From: akpm@linux-foundation.org
Subject: [alternative-merged] floppy-revert-floppy-disable-halt-warning.patch removed from -mm tree
Date: Wed, 28 Mar 2012 16:26:18 -0700
Message-ID: <20120328232618.D907DA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:50235 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758517Ab2C1X0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2012 19:26:21 -0400
Received: by laai8 with SMTP id i8so76330laa.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 16:26:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lenb@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: floppy: revert floppy disable halt warning
has been removed from the -mm tree.  Its filename was
     floppy-revert-floppy-disable-halt-warning.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from shemminger@vyatta.com are

origin.patch

