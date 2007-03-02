From: akpm@linux-foundation.org
Subject: - fix-the-sysctl=n-compilation.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:24 -0800
Message-ID: <200703020506.l2256OQW000793@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42520 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422782AbXCBFJh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:09:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     fix the SYSCTL=n compilation
has been removed from the -mm tree.  Its filename was
     fix-the-sysctl=n-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix the SYSCTL=n compilation
From: Adrian Bunk <bunk@stusta.de>

/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/kernel/sysctl.c:1411: error: conflicting types for 'register_sysctl_table'
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/include/linux/sysctl.h:1042: error: previous declaration of 'register_sysctl_table' was here
make[2]: *** [kernel/sysctl.o] Error 1

Caused by commit 0b4d414714f0d2f922d39424b0c5c82ad900a381.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/sysctl.c~fix-the-sysctl=n-compilation kernel/sysctl.c
--- a/kernel/sysctl.c~fix-the-sysctl=n-compilation
+++ a/kernel/sysctl.c
@@ -1359,8 +1359,7 @@ void unregister_sysctl_table(struct ctl_
 }
 
 #else /* !CONFIG_SYSCTL */
-struct ctl_table_header * register_sysctl_table(ctl_table * table,
-						int insert_at_head)
+struct ctl_table_header *register_sysctl_table(ctl_table * table)
 {
 	return NULL;
 }
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
lumpy-reclaim-cleanup.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-fix.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
