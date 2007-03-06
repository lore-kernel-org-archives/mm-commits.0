From: akpm@linux-foundation.org
Subject: - slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:12:29 -0800
Message-ID: <200703060212.l262CTpQ009058@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965752AbXCFCRT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, chrisw@sous-sol.org, jmorris@namei.org, kjhall@us.ibm.com, safford@us.ibm.com, sds@tycho.nsa.gov, sergeh@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slm_set_taskperm(): remove horrible error handling code
has been removed from the -mm tree.  Its filename was
     slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch

This patch was dropped because it was folded into slim-debug-output.patch

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
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
