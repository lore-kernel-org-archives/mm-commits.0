From: akpm@linux-foundation.org
Subject: + fs-bufferc-do-not-inline-exported-function.patch added to -mm tree
Date: Tue, 27 Nov 2012 15:08:38 -0800
Message-ID: <20121127230839.379BA82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53284 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2K0XIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 18:08:40 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so1534942qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 15:08:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clouds.yan@gmail.com


The patch titled
     Subject: fs/buffer.c: do not inline exported function
has been added to the -mm tree.  Its filename is
     fs-bufferc-do-not-inline-exported-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch
writeback-fix-a-typo-in-comment.patch
fs-bufferc-do-not-inline-exported-function.patch
fs-bufferc-remove-redundant-initialization-in-alloc_page_buffers.patch

