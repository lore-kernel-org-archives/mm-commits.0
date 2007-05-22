From: akpm@linux-foundation.org
Subject: + off-by-one-in-floppyc.patch added to -mm tree
Date: Mon, 21 May 2007 21:05:38 -0700
Message-ID: <200705220405.l4M45bdg026956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755027AbXEVEGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 00:06:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snakebyte@gmx.de


The patch titled
     Off by one in floppy.c
has been added to the -mm tree.  Its filename is
     off-by-one-in-floppyc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Off by one in floppy.c
From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>

Another coverity patch i forgot to resend, original thread here
http://marc.info/?l=linux-kernel&m=115144559823592&w=2

In case drive == N_DRIVE, we get one past the drive_params array.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/floppy.c~off-by-one-in-floppyc drivers/block/floppy.c
--- a/drivers/block/floppy.c~off-by-one-in-floppyc
+++ a/drivers/block/floppy.c
@@ -670,7 +670,7 @@ static void __reschedule_timeout(int dri
 	if (drive == current_reqD)
 		drive = current_drive;
 	del_timer(&fd_timeout);
-	if (drive < 0 || drive > N_DRIVE) {
+	if (drive < 0 || drive >= N_DRIVE) {
 		fd_timeout.expires = jiffies + 20UL * HZ;
 		drive = 0;
 	} else
_

Patches currently in -mm which might be from snakebyte@gmx.de are

git-kvm.patch
git-ubi.patch
remove-unnecessary-check-in-drivers-scsi-sgc.patch
off-by-one-in-floppyc.patch
