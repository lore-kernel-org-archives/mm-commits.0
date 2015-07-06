From: akpm@linux-foundation.org
Subject: +
 ntfs-deletion-of-unnecessary-checks-before-the-function-call-iput.patch
 added to -mm tree
Date: Mon, 06 Jul 2015 14:50:41 -0700
Message-ID: <559af831.gs5jUDh5rHabVfUX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886AbbGFVul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 17:50:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, anton@tuxera.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: delete unnecessary checks before calling iput()
has been added to the -mm tree.  Its filename is
     ntfs-deletion-of-unnecessary-checks-before-the-function-call-iput.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ntfs-deletion-of-unnecessary-checks-before-the-function-call-iput.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ntfs-deletion-of-unnecessary-checks-before-the-function-call-iput.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ntfs-deletion-of-unnecessary-checks-before-the-function-call-iput.patch
linux-next.patch

