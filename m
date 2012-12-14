From: akpm@linux-foundation.org
Subject: [merged] fs-bufferc-do-not-inline-exported-function.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:42 -0800
Message-ID: <20121214232942.AD11F82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41133 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab2LNX3n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:43 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so145712qaq.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clouds.yan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: do not inline exported function
has been removed from the -mm tree.  Its filename was
     fs-bufferc-do-not-inline-exported-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yan Hong <clouds.yan@gmail.com>
Subject: fs/buffer.c: do not inline exported function

It makes no sense to inline an exported function.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/buffer.c~fs-bufferc-do-not-inline-exported-function fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-do-not-inline-exported-function
+++ a/fs/buffer.c
@@ -46,8 +46,7 @@ static int fsync_buffers_list(spinlock_t
 
 #define BH_ENTRY(list) list_entry((list), struct buffer_head, b_assoc_buffers)
 
-inline void
-init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
+void init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
 {
 	bh->b_end_io = handler;
 	bh->b_private = private;
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

origin.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch

