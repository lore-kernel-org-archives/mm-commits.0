From: akpm@linux-foundation.org
Subject: - cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:59:11 -0700
Message-ID: <200704301959.l3UJxCwJ013566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423560AbXD3T7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     cache pipe buf page address for non-highmem arch (fix)
has been removed from the -mm tree.  Its filename was
     cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch

This patch was dropped because it was folded into cache-pipe-buf-page-address-for-non-highmem-arch.patch

------------------------------------------------------
Subject: cache pipe buf page address for non-highmem arch (fix)
From: "Ken Chen" <kenchen@google.com>

On 3/26/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> LTP's vmsplice01 triggers the below:
>
> Unable to handle kernel NULL pointer dereference at 0000000000000130 RIP:
>  [<ffffffff8029e1b6>] pipe_to_file+0x1f3/0x2a6

Ouch, generic_pipe_buf_map() and unmap is used by both pipe and
splice, I better constrain all changes within fs/pipe.c because from
splice path, the page->private is not initialized.

Double ouch for missing test that code path.  Here is an updated
patch, tested with LTP and FIO.  I will write more test cases to make
sure all code path are covered.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff -puN fs/pipe.c~cache-pipe-buf-page-address-for-non-highmem-arch-fix fs/pipe.c
--- a/fs/pipe.c~cache-pipe-buf-page-address-for-non-highmem-arch-fix
+++ a/fs/pipe.c
@@ -184,13 +184,34 @@ void *generic_pipe_buf_map(struct pipe_i
 {
 	if (atomic) {
 		buf->flags |= PIPE_BUF_FLAG_ATOMIC;
+		return kmap_atomic(buf->page, KM_USER0);
+	}
+
+	return kmap(buf->page);
+}
+
+void generic_pipe_buf_unmap(struct pipe_inode_info *pipe,
+			    struct pipe_buffer *buf, void *map_data)
+{
+	if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
+		buf->flags &= ~PIPE_BUF_FLAG_ATOMIC;
+		kunmap_atomic(map_data, KM_USER0);
+	} else
+		kunmap(buf->page);
+}
+
+static void *pipe_buf_map(struct pipe_inode_info *pipe,
+			   struct pipe_buffer *buf, int atomic)
+{
+	if (atomic) {
+		buf->flags |= PIPE_BUF_FLAG_ATOMIC;
 		return pipe_kmap_atomic(buf->page, KM_USER0);
 	}
 
 	return pipe_kmap(buf->page);
 }
 
-void generic_pipe_buf_unmap(struct pipe_inode_info *pipe,
+static void pipe_buf_unmap(struct pipe_inode_info *pipe,
 			    struct pipe_buffer *buf, void *map_data)
 {
 	if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
@@ -225,8 +246,8 @@ int generic_pipe_buf_pin(struct pipe_ino
 
 static const struct pipe_buf_operations anon_pipe_buf_ops = {
 	.can_merge = 1,
-	.map = generic_pipe_buf_map,
-	.unmap = generic_pipe_buf_unmap,
+	.map = pipe_buf_map,
+	.unmap = pipe_buf_unmap,
 	.pin = generic_pipe_buf_pin,
 	.release = anon_pipe_buf_release,
 	.steal = generic_pipe_buf_steal,
_

Patches currently in -mm which might be from kenchen@google.com are

cache-pipe-buf-page-address-for-non-highmem-arch.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
remove-artificial-software-max_loop-limit.patch
