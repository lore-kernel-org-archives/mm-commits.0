From: akpm@osdl.org
Subject: - ciss-require-same-scsi-module-support.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:34 -0800
Message-ID: <200612072306.kB7N6Yna030274@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52693 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163923AbWLGXGw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:06:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     CISS: require same SCSI module support
has been removed from the -mm tree.  Its filename was
     ciss-require-same-scsi-module-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CISS: require same SCSI module support
From: Randy Dunlap <randy.dunlap@oracle.com>

Building CCISS SCSI tape support in-kernel when SCSI=m causes build errors,
so require SCSI support to be =y or same as CCISS SCSI tape support.

drivers/built-in.o: In function `cciss_remove_one':
cciss.c:(.text+0x79d4c): undefined reference to `scsi_remove_host'
cciss.c:(.text+0x79d55): undefined reference to `scsi_host_put'
drivers/built-in.o: In function `cciss_update_non_disk_devices':
cciss.c:(.text+0x7bb54): undefined reference to `scsi_device_type'
cciss.c:(.text+0x7bcc8): undefined reference to `scsi_device_type'
cciss.c:(.text+0x7be81): undefined reference to `scsi_device_type'
cciss.c:(.text+0x7bf81): undefined reference to `scsi_device_type'
drivers/built-in.o: In function `cciss_proc_write':
cciss.c:(.text+0x7c175): undefined reference to `scsi_host_alloc'
cciss.c:(.text+0x7c1ed): undefined reference to `scsi_add_host'
cciss.c:(.text+0x7c1f9): undefined reference to `scsi_scan_host'
cciss.c:(.text+0x7c206): undefined reference to `scsi_host_put'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/Kconfig~ciss-require-same-scsi-module-support drivers/block/Kconfig
--- a/drivers/block/Kconfig~ciss-require-same-scsi-module-support
+++ a/drivers/block/Kconfig
@@ -168,7 +168,8 @@ config BLK_CPQ_CISS_DA
 
 config CISS_SCSI_TAPE
 	bool "SCSI tape drive support for Smart Array 5xxx"
-	depends on BLK_CPQ_CISS_DA && SCSI && PROC_FS
+	depends on BLK_CPQ_CISS_DA && PROC_FS
+	depends on SCSI=y || SCSI=BLK_CPQ_CISS_DA
 	help
 	  When enabled (Y), this option allows SCSI tape drives and SCSI medium
 	  changers (tape robots) to be accessed via a Compaq 5xxx array 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

