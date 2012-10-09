From: akpm@linux-foundation.org
Subject: + memstick-ms_block-fix-complile-issue.patch added to -mm tree
Date: Tue, 09 Oct 2012 13:59:52 -0700
Message-ID: <20121009205953.6439F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51412 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2JIU7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 16:59:54 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so692155ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 13:59:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, axboe@kernel.dk, geert@linux-m68k.org, oakad@yahoo.com


The patch titled
     Subject: memstick: ms_block: fix complile issue
has been added to the -mm tree.  Its filename is
     memstick-ms_block-fix-complile-issue.patch

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
Subject: memstick: ms_block: fix complile issue

As suggested by Geert Uytterhoeven:

: http://kisskb.ellerman.id.au/kisskb/buildresult/7280352/
: arch/m68k/include/asm/hardirq.h:23:20: error: expected ')' before 'DRIVER_NAME'
: make[4]: *** [drivers/memstick/core/ms_block.o] Error 1
: 
: The reason for this is that pr_fmt() references DRIVER_NAME and is defined
: before the first include, while DRIVER_NAME is only defined in ms_block.h,
: which is the last included file.  If any subsequent include file uses
: pr_fmt() (e.g.  the call to pr_crit() in arch/m68k/include/asm/hardirq.h),
: this causes a build failure.
: 
: I suggest moving the DRIVER_NAME define to ms_block.c.  Cfr.  memstick.c
: and mspro_block.c, who already have their own definition.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |    2 +-
 drivers/memstick/core/ms_block.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/memstick/core/ms_block.c~memstick-ms_block-fix-complile-issue drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~memstick-ms_block-fix-complile-issue
+++ a/drivers/memstick/core/ms_block.c
@@ -11,7 +11,7 @@
  * Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
  *
  */
-
+#define DRIVER_NAME "ms_block"
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
 
 #include <linux/module.h>
diff -puN drivers/memstick/core/ms_block.h~memstick-ms_block-fix-complile-issue drivers/memstick/core/ms_block.h
--- a/drivers/memstick/core/ms_block.h~memstick-ms_block-fix-complile-issue
+++ a/drivers/memstick/core/ms_block.h
@@ -277,8 +277,6 @@ static int msb_reset(struct msb_data *ms
 static int h_msb_default_bad(struct memstick_dev *card,
 						struct memstick_request **mrq);
 
-#define DRIVER_NAME "ms_block"
