From: akpm@linux-foundation.org
Subject: [patch 073/126] pipe: account to kmemcg
Date: Tue, 26 Jul 2016 15:24:33 -0700
Message-ID: <5797e321.OTnXCVU2oX2QnT2m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372AbcGZWYe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov@virtuozzo.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org, viro@zeniv.linux.org.uk

From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: pipe: account to kmemcg

Pipes can consume a significant amount of system memory, hence they
should be accounted to kmemcg.

This patch marks pipe_inode_info and anonymous pipe buffer page
allocations as __GFP_ACCOUNT so that they would be charged to kmemcg.
Note, since a pipe buffer page can be "stolen" and get reused for other
purposes, including mapping to userspace, we clear PageKmemcg thus
resetting page->_mapcount and uncharge it in anon_pipe_buf_steal, which
is introduced by this patch.

A note regarding anon_pipe_buf_steal implementation. We allow to steal
the page if its ref count equals 1. It looks racy, but it is correct for
anonymous pipe buffer pages, because:

 - We lock out all other pipe users, because ->steal is called with
   pipe_lock held, so the page can't be spliced to another pipe from
   under us.

 - The page is not on LRU and it never was.

 - Thus a parallel thread can access it only by PFN. Although this is
   quite possible (e.g. see page_idle_get_page and balloon_page_isolate)
   this is not dangerous, because all such functions do is increase page
   ref count, check if the page is the one they are looking for, and
   decrease ref count if it isn't. Since our page is clean except for
   PageKmemcg mark, which doesn't conflict with other _mapcount users,
   the worst that can happen is we see page_count > 2 due to a transient
   ref, in which case we false-positively abort ->steal, which is still
   fine, because ->steal is not guaranteed to succeed.

Link: http://lkml.kernel.org/r/20160527150313.GD26059@esperanza
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff -puN fs/pipe.c~pipe-account-to-kmemcg fs/pipe.c
--- a/fs/pipe.c~pipe-account-to-kmemcg
+++ a/fs/pipe.c
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
+#include <linux/memcontrol.h>
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
@@ -137,6 +138,22 @@ static void anon_pipe_buf_release(struct
 		put_page(page);
 }
 
+static int anon_pipe_buf_steal(struct pipe_inode_info *pipe,
+			       struct pipe_buffer *buf)
+{
+	struct page *page = buf->page;
+
+	if (page_count(page) == 1) {
+		if (memcg_kmem_enabled()) {
+			memcg_kmem_uncharge(page, 0);
+			__ClearPageKmemcg(page);
+		}
+		__SetPageLocked(page);
+		return 0;
+	}
+	return 1;
+}
+
 /**
  * generic_pipe_buf_steal - attempt to take ownership of a &pipe_buffer
  * @pipe:	the pipe that the buffer belongs to
@@ -219,7 +236,7 @@ static const struct pipe_buf_operations
 	.can_merge = 1,
 	.confirm = generic_pipe_buf_confirm,
 	.release = anon_pipe_buf_release,
-	.steal = generic_pipe_buf_steal,
+	.steal = anon_pipe_buf_steal,
 	.get = generic_pipe_buf_get,
 };
 
@@ -227,7 +244,7 @@ static const struct pipe_buf_operations
 	.can_merge = 0,
 	.confirm = generic_pipe_buf_confirm,
 	.release = anon_pipe_buf_release,
-	.steal = generic_pipe_buf_steal,
+	.steal = anon_pipe_buf_steal,
 	.get = generic_pipe_buf_get,
 };
 
@@ -405,7 +422,7 @@ pipe_write(struct kiocb *iocb, struct io
 			int copied;
 
 			if (!page) {
-				page = alloc_page(GFP_HIGHUSER);
+				page = alloc_page(GFP_HIGHUSER | __GFP_ACCOUNT);
 				if (unlikely(!page)) {
 					ret = ret ? : -ENOMEM;
 					break;
@@ -611,7 +628,7 @@ struct pipe_inode_info *alloc_pipe_info(
 {
 	struct pipe_inode_info *pipe;
 
-	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL);
+	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
 	if (pipe) {
 		unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
 		struct user_struct *user = get_current_user();
@@ -619,7 +636,9 @@ struct pipe_inode_info *alloc_pipe_info(
 		if (!too_many_pipe_buffers_hard(user)) {
 			if (too_many_pipe_buffers_soft(user))
 				pipe_bufs = 1;
-			pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * pipe_bufs, GFP_KERNEL);
+			pipe->bufs = kcalloc(pipe_bufs,
+					     sizeof(struct pipe_buffer),
+					     GFP_KERNEL_ACCOUNT);
 		}
 
 		if (pipe->bufs) {
@@ -1010,7 +1029,8 @@ static long pipe_set_size(struct pipe_in
 	if (nr_pages < pipe->nrbufs)
 		return -EBUSY;
 
-	bufs = kcalloc(nr_pages, sizeof(*bufs), GFP_KERNEL | __GFP_NOWARN);
+	bufs = kcalloc(nr_pages, sizeof(*bufs),
+		       GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (unlikely(!bufs))
 		return -ENOMEM;
 
_
