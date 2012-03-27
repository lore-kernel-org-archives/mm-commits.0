From: akpm@linux-foundation.org
Subject: + floppy-revert-floppy-disable-halt-warning.patch added to -mm tree
Date: Tue, 27 Mar 2012 16:27:07 -0700
Message-ID: <20120327232707.B9C5CA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62134 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2C0X1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Mar 2012 19:27:10 -0400
Received: by wejx9 with SMTP id x9so17648wej.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Mar 2012 16:27:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lenb@kernel.org, mingo@elte.hu


The patch titled
     Subject: floppy: revert floppy disable halt warning
has been added to the -mm tree.  Its filename is
     floppy-revert-floppy-disable-halt-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Hemminger <shemminger@vyatta.com>
Subject: floppy: revert floppy disable halt warning

Remove the stupid floppy disable halt warning.  It is meaningless since
the API is local to floppy driver.  Our boot scripts check for the floppy
drive, and this causes the warning to trigger every time.  This confuses
support, breaks automated tests that look for backtraces on boot, and adds
no value.

The message is being displayed to the wrong audience, it looks like it was
intended as a compromise of a long discussion on LKML about supporting
older x86 hardware; but users don't know or understand what it is saying.

If you want to change halt handling then just fix the floppy driver, don't
whine about it.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/floppy.c~floppy-revert-floppy-disable-halt-warning drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-revert-floppy-disable-halt-warning
+++ a/drivers/block/floppy.c
@@ -1037,7 +1037,6 @@ static void floppy_disable_hlt(void)
 {
 	unsigned long flags;
 
-	WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2012");
 	spin_lock_irqsave(&floppy_hlt_lock, flags);
 	if (!hlt_disabled) {
 		hlt_disabled = 1;
_
Subject: Subject: floppy: revert floppy disable halt warning

Patches currently in -mm which might be from shemminger@vyatta.com are

origin.patch
floppy-revert-floppy-disable-halt-warning.patch

