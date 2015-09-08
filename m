From: akpm@linux-foundation.org
Subject: [merged]
 ntfs-deletion-of-unnecessary-checks-before-the-function-call-iput.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:01:54 -0700
Message-ID: <55ef2292.nUwVwGMpy2c91e4E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbbIHSBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, anton@tuxera.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: delete unnecessary checks before calling iput()
has been removed from the -mm tree.  Its filename was
     ntfs-deletion-of-unnecessary-checks-before-the-function-call-iput.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: ntfs: delete unnecessary checks before calling iput()

iput() tests whether its argument is NULL and then returns immediately. 
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/super.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN fs/ntfs/super.c~ntfs-deletion-of-unnecessary-checks-before-the-function-call-iput fs/ntfs/super.c
--- a/fs/ntfs/super.c~ntfs-deletion-of-unnecessary-checks-before-the-function-call-iput
+++ a/fs/ntfs/super.c
@@ -2204,17 +2204,12 @@ get_ctx_vol_failed:
 	return true;
 #ifdef NTFS_RW
 iput_usnjrnl_err_out:
-	if (vol->usnjrnl_j_ino)
-		iput(vol->usnjrnl_j_ino);
-	if (vol->usnjrnl_max_ino)
-		iput(vol->usnjrnl_max_ino);
-	if (vol->usnjrnl_ino)
-		iput(vol->usnjrnl_ino);
+	iput(vol->usnjrnl_j_ino);
+	iput(vol->usnjrnl_max_ino);
+	iput(vol->usnjrnl_ino);
 iput_quota_err_out:
-	if (vol->quota_q_ino)
-		iput(vol->quota_q_ino);
-	if (vol->quota_ino)
-		iput(vol->quota_ino);
+	iput(vol->quota_q_ino);
+	iput(vol->quota_ino);
 	iput(vol->extend_ino);
 #endif /* NTFS_RW */
 iput_sec_err_out:
@@ -2223,8 +2218,7 @@ iput_root_err_out:
 	iput(vol->root_ino);
 iput_logfile_err_out:
 #ifdef NTFS_RW
-	if (vol->logfile_ino)
-		iput(vol->logfile_ino);
+	iput(vol->logfile_ino);
 iput_vol_err_out:
 #endif /* NTFS_RW */
 	iput(vol->vol_ino);
@@ -2254,8 +2248,7 @@ iput_mftbmp_err_out:
 	iput(vol->mftbmp_ino);
 iput_mirr_err_out:
 #ifdef NTFS_RW
-	if (vol->mftmirr_ino)
-		iput(vol->mftmirr_ino);
+	iput(vol->mftmirr_ino);
 #endif /* NTFS_RW */
 	return false;
 }
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are


