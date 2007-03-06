From: akpm@linux-foundation.org
Subject: - slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:10:48 -0800
Message-ID: <200703060210.l262AmaT009031@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47246 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855AbXCFCPi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:15:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, kjhall@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security/slim/slm_main.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch

This patch was dropped because it was folded into slim-main-patch.patch

------------------------------------------------------
Subject: security/slim/slm_main.c: make 2 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN security/slim/slm_main.c~slim-main-patch-security-slim-slm_mainc-make-2-functions-static security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-main-patch-security-slim-slm_mainc-make-2-functions-static
+++ a/security/slim/slm_main.c
@@ -819,8 +819,8 @@ static int slm_inode_rename(struct inode
  * of the current process. This is especially important for objects
  * being promoted.
 */
-int slm_inode_setxattr(struct dentry *dentry, char *name, void *value,
-		       size_t size, int flags)
+static int slm_inode_setxattr(struct dentry *dentry, char *name, void *value,
+			      size_t size, int flags)
 {
 	struct slm_tsec_data *cur_tsec = current->security;
 	char *data = value;
@@ -923,7 +923,7 @@ static int slm_inode_alloc_security(stru
 /*
  * Opening a socket demotes the integrity of a process to untrusted.
  */
-int slm_socket_create(int family, int type, int protocol, int kern)
+static int slm_socket_create(int family, int type, int protocol, int kern)
 {
 	struct task_struct *parent_tsk;
 	struct slm_tsec_data *cur_tsec = current->security, *parent_tsec;
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
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
