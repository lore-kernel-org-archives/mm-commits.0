From: akpm@osdl.org
Subject: + freezerh-uses-task_struct-fields.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:17:16 -0800
Message-ID: <200612090017.kB90HHlN010663@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947557AbWLIARd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, shaggy@linux.vnet.ibm.com


The patch titled
     freezer.h uses task_struct fields
has been added to the -mm tree.  Its filename is
     freezerh-uses-task_struct-fields.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+)

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
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
codingstyle-updates.patch
freezerh-uses-task_struct-fields.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

