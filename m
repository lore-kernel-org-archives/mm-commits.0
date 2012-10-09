From: akpm@linux-foundation.org
Subject: + memstick-remove-unused-field-from-state-struct.patch added to -mm tree
Date: Tue, 09 Oct 2012 13:59:48 -0700
Message-ID: <20121009205949.3320A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:49122 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2JIU7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 16:59:50 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so605151yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 13:59:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, axboe@kernel.dk, geert@linux-m68k.org, oakad@yahoo.com


The patch titled
     Subject: memstick: remove unused field from state struct
has been added to the -mm tree.  Its filename is
     memstick-remove-unused-field-from-state-struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: memstick: remove unused field from state struct

Oops, I forgot that I have thet field there already.  Just save memory by
not allocating it.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/memstick/core/ms_block.h~memstick-remove-unused-field-from-state-struct drivers/memstick/core/ms_block.h
--- a/drivers/memstick/core/ms_block.h~memstick-remove-unused-field-from-state-struct
+++ a/drivers/memstick/core/ms_block.h
@@ -162,7 +162,6 @@ struct msb_data {
 	struct workqueue_struct		*io_queue;
 	bool				io_queue_stopped;
 	struct work_struct		io_work;
-	struct scatterlist		prealloc_sg[MS_BLOCK_MAX_SEGS+1];
 	bool				card_dead;
 
 	/* Media properties */
@@ -194,7 +193,7 @@ struct msb_data {
 
 	/* Preallocated buffers */
 	unsigned char			*block_buffer;
-	struct scatterlist		sg[MS_BLOCK_MAX_SEGS+1];
+	struct scatterlist		prealloc_sg[MS_BLOCK_MAX_SEGS+1];
 
 
 	/* handler's local data */
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

origin.patch
linux-next.patch
memstick-remove-unused-field-from-state-struct.patch
memstick-ms_block-fix-complile-issue.patch

