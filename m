From: akpm@osdl.org
Subject: + slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch added to -mm tree
Date: Wed, 13 Dec 2006 15:55:10 -0800
Message-ID: <200612132355.kBDNtADn025125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbWLNADm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:03:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, chrisw@sous-sol.org, jmorris@namei.org, kjhall@us.ibm.com, safford@us.ibm.com, sds@tycho.nsa.gov, sergeh@us.ibm.com, zohar@us.ibm.com


The patch titled
     slm_set_taskperm(): remove horrible error handling code
has been added to the -mm tree.  Its filename is
     slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slm_set_taskperm(): remove horrible error handling code
From: Adrian Bunk <bunk@stusta.de>

Error handling:
Pass something you memset'ed to 0 to functions that never change it but
dereference it in dprintk()'s.

This patch removes this broken code - plain Oops'es aren't worse.

As a bonus, this function no longer wastes more than 2 kB stack space.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Dave Safford <safford@us.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge Hallyn <sergeh@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_main.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff -puN security/slim/slm_main.c~slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code
+++ a/security/slim/slm_main.c
@@ -610,24 +610,11 @@ static int do_task_may_write(struct slm_
 static int slm_set_taskperm(int mask, struct slm_file_xattr *level,
 			    const unsigned char *name)
 {
-	struct task_struct *parent_tsk = current->parent, new_tsk;
-	struct slm_tsec_data *parent_tsec = NULL, new_tsec;
+	struct task_struct *parent_tsk = current->parent;
+	struct slm_tsec_data *parent_tsec;
 	int rc = 0;
 
-	if (parent_tsk)
-		parent_tsec = parent_tsk->security;
-	else {
-		printk(KERN_INFO
-		       "%s: current pid %d: parent_tsk is null\n",
-		       __FUNCTION__, current->pid);
-		memset(&new_tsk, 0, sizeof(struct task_struct));
-		parent_tsk = &new_tsk;
-	}
-
-	if (!parent_tsec) {
-		memset(&new_tsec, 0, sizeof(struct slm_tsec_data));
-		parent_tsec = &new_tsec;
-	}
+	parent_tsec = parent_tsk->security;
 
 	if (mask & MAY_READ)
 		rc = do_task_may_read(level, name, parent_tsk, parent_tsec);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
debug-add-sysrq_always_enabled-boot-option.patch
one-more-export_unused_symbol-removal.patch
remove-the-broken-blk_dev_swim_iop-driver.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
acpi-make-code-static.patch
git-alsa.patch
proper-prototype-for-drivers-base-initcdriver_init.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-the-broken-skmc-driver.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
remove-include-linux-byteorder-pdp_endianh.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

