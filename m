From: akpm@osdl.org
Subject: - freezerh-uses-task_struct-fields.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:59 -0800
Message-ID: <200612130651.kBD6pxIN030389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57313 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964974AbWLMGw0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:52:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, shaggy@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     freezer.h uses task_struct fields
has been removed from the -mm tree.  Its filename was
     freezerh-uses-task_struct-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freezer.h uses task_struct fields
From: Randy Dunlap <randy.dunlap@oracle.com>

freezer.h uses task_struct fields so it should include sched.h.

  CC [M]  fs/jfs/jfs_txnmgr.o
In file included from fs/jfs/jfs_txnmgr.c:49:
include/linux/freezer.h: In function 'frozen':
include/linux/freezer.h:9: error: dereferencing pointer to incomplete type
include/linux/freezer.h:9: error: 'PF_FROZEN' undeclared (first use in this function)
include/linux/freezer.h:9: error: (Each undeclared identifier is reported only once
include/linux/freezer.h:9: error: for each function it appears in.)
include/linux/freezer.h: In function 'freezing':
include/linux/freezer.h:17: error: dereferencing pointer to incomplete type
include/linux/freezer.h:17: error: 'PF_FREEZE' undeclared (first use in this function)
include/linux/freezer.h: In function 'freeze':
include/linux/freezer.h:26: error: dereferencing pointer to incomplete type
include/linux/freezer.h:26: error: 'PF_FREEZE' undeclared (first use in this function)
include/linux/freezer.h: In function 'do_not_freeze':
include/linux/freezer.h:34: error: dereferencing pointer to incomplete type
include/linux/freezer.h:34: error: 'PF_FREEZE' undeclared (first use in this function)
include/linux/freezer.h: In function 'thaw_process':
include/linux/freezer.h:43: error: dereferencing pointer to incomplete type
include/linux/freezer.h:43: error: 'PF_FROZEN' undeclared (first use in this function)
include/linux/freezer.h:44: warning: implicit declaration of function 'wake_up_process'
include/linux/freezer.h: In function 'frozen_process':
include/linux/freezer.h:55: error: dereferencing pointer to incomplete type
include/linux/freezer.h:55: error: dereferencing pointer to incomplete type
include/linux/freezer.h:55: error: 'PF_FREEZE' undeclared (first use in this function)
include/linux/freezer.h:55: error: 'PF_FROZEN' undeclared (first use in this function)
fs/jfs/jfs_txnmgr.c: In function 'freezing':
include/linux/freezer.h:18: warning: control reaches end of non-void function
make[2]: *** [fs/jfs/jfs_txnmgr.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/freezer.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/freezer.h~freezerh-uses-task_struct-fields include/linux/freezer.h
--- a/include/linux/freezer.h~freezerh-uses-task_struct-fields
+++ a/include/linux/freezer.h
@@ -1,5 +1,7 @@
 /* Freezer declarations */
 
+#include <linux/sched.h>
+
 #ifdef CONFIG_PM
 /*
  * Check if a process has been frozen
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
fix-section-mismatch-in-parainstructions.patch
kconfig-new-function-bool-conf_get_changedvoid.patch
kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch
kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch
kconfig-set-gconfs-save-widgets-sensitivity-according-to-configs-changed-state.patch
isicom-fix-build-with-pci-disabled.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

