From: akpm@linux-foundation.org
Subject: + paride-fix-and-typo-in-drivers-block-paride-ptc.patch added to -mm tree
Date: Thu, 01 Nov 2007 15:34:34 -0700
Message-ID: <200711012234.lA1MYYBP018922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbXKAWfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 18:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl


The patch titled
     paride: fix 'and' typo in drivers/block/paride/pt.c
has been added to the -mm tree.  Its filename is
     paride-fix-and-typo-in-drivers-block-paride-ptc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: paride: fix 'and' typo in drivers/block/paride/pt.c
From: Roel Kluin <12o3l@tiscali.nl>

Fix 'and' typo (PT_WRITE_OK is defined 2)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/paride/pt.c~paride-fix-and-typo-in-drivers-block-paride-ptc drivers/block/paride/pt.c
--- a/drivers/block/paride/pt.c~paride-fix-and-typo-in-drivers-block-paride-ptc
+++ a/drivers/block/paride/pt.c
@@ -664,7 +664,7 @@ static int pt_open(struct inode *inode, 
 		goto out;
 
 	err = -EROFS;
-	if ((!tape->flags & PT_WRITE_OK) && (file->f_mode & 2))
+	if ((!(tape->flags & PT_WRITE_OK)) && (file->f_mode & 2))
 		goto out;
 
 	if (!(iminor(inode) & 128))
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
i4l-errors-with-assignments-in-if.patch
paride-fix-and-typo-in-drivers-block-paride-ptc.patch
unlock-when-ssp-tries-to-close-an-invalid-port.patch
dvb-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-ocfs2.patch
git-s390.patch
git-watchdog.patch
cris-gpio-undo-locks-before-returning.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
