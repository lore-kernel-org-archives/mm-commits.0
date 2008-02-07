From: akpm@linux-foundation.org
Subject: - make-srcu_readers_active-static.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:52 -0800
Message-ID: <200802070021.m170LXHT006347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765036AbYBGAvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:51:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     make srcu_readers_active() static
has been removed from the -mm tree.  Its filename was
     make-srcu_readers_active-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make srcu_readers_active() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global srcu_readers_active() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/srcu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/srcu.c~make-srcu_readers_active-static kernel/srcu.c
--- a/kernel/srcu.c~make-srcu_readers_active-static
+++ a/kernel/srcu.c
@@ -74,7 +74,7 @@ static int srcu_readers_active_idx(struc
  * severe errors when invoked on an active srcu_struct.  That said, it
  * can be useful as an error check at cleanup time.
  */
-int srcu_readers_active(struct srcu_struct *sp)
+static int srcu_readers_active(struct srcu_struct *sp)
 {
 	return srcu_readers_active_idx(sp, 0) + srcu_readers_active_idx(sp, 1);
 }
@@ -255,4 +255,3 @@ EXPORT_SYMBOL_GPL(srcu_read_lock);
 EXPORT_SYMBOL_GPL(srcu_read_unlock);
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 EXPORT_SYMBOL_GPL(srcu_batches_completed);
-EXPORT_SYMBOL_GPL(srcu_readers_active);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
