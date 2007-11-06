From: akpm@linux-foundation.org
Subject: - paride-fix-and-typo-in-drivers-block-paride-ptc.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:13 -0800
Message-ID: <200711060552.lA65qDB4007265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbXKFFwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:52:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     paride: fix 'and' typo in drivers/block/paride/pt.c
has been removed from the -mm tree.  Its filename was
     paride-fix-and-typo-in-drivers-block-paride-ptc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
unlock-when-ssp-tries-to-close-an-invalid-port.patch
git-dvb.patch
dvb-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-ocfs2.patch
cris-gpio-undo-locks-before-returning.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
