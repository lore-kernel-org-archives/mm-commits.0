From: akpm@linux-foundation.org
Subject: - drivers-edac-new-pasemi-driver-fix.patch removed from -mm tree
Date: Thu, 19 Jul 2007 01:40:09 -0700
Message-ID: <200707190840.l6J8e9F7022509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45518 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936521AbXGSIkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 04:40:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dougthompson@xmission.com, egor@pasemi.com, greg@kroah.com, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     drivers-edac-new-pasemi-driver-fix
has been removed from the -mm tree.  Its filename was
     drivers-edac-new-pasemi-driver-fix.patch

This patch was dropped because it was folded into drivers-edac-new-pasemi-driver.patch

------------------------------------------------------
Subject: drivers-edac-new-pasemi-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alan Cox alan@lxorguk.ukuu.org.uk
Cc: Doug Thompson <dougthompson@xmission.com
Cc: Egor Martovetsky <egor@pasemi.com>
Cc: Greg KH <greg@kroah.com>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/pasemi_edac.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/edac/pasemi_edac.c~drivers-edac-new-pasemi-driver-fix drivers/edac/pasemi_edac.c
--- a/drivers/edac/pasemi_edac.c~drivers-edac-new-pasemi-driver-fix
+++ a/drivers/edac/pasemi_edac.c
@@ -168,7 +168,8 @@ static int pasemi_edac_init_csrows(struc
 			break;
 		default:
 			edac_mc_printk(mci, KERN_ERR,
-				       "Unrecognized Rank Config\n");
+				"Unrecognized Rank Config. rankcfg=%u\n",
+				rankcfg);
 			return -EINVAL;
 		}
 
@@ -244,9 +245,8 @@ static int __devinit pasemi_edac_probe(s
 	 */
 	pasemi_edac_get_error_info(mci);
 
-	if (edac_mc_add_mc(mci, system_mmc_id++)) {
+	if (edac_mc_add_mc(mci, system_mmc_id++))
 		goto fail;
-	}
 
 	/* get this far and it's successful */
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
kernel-sysctlc-finish-off-the-warning-comments.patch
afs-build-fix.patch
