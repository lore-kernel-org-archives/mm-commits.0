From: akpm@linux-foundation.org
Subject: + arch-i386-kernel-vmic-must-include-asm-kmap_typesh.patch added to -mm tree
Date: Sun, 04 Mar 2007 22:57:46 -0800
Message-ID: <200703050657.l256vkZZ012099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbXCEHBA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 02:01:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, zach@vmware.com


The patch titled
     arch/i386/kernel/vmi.c must #include <asm/kmap_types.h>
has been added to the -mm tree.  Its filename is
     arch-i386-kernel-vmic-must-include-asm-kmap_typesh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/i386/kernel/vmi.c must #include <asm/kmap_types.h>
From: Adrian Bunk <bunk@stusta.de>

  CC      arch/i386/kernel/vmi.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c: In function 'vmi_map_pt_hook':
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c:387: error: 'KM_PTE0' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c:387: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c:387: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c:387: error: 'KM_PTE1' undeclared (first use in this function)
make[2]: *** [arch/i386/kernel/vmi.o] Error 1

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/kernel/vmi.c~arch-i386-kernel-vmic-must-include-asm-kmap_typesh arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~arch-i386-kernel-vmic-must-include-asm-kmap_typesh
+++ a/arch/i386/kernel/vmi.c
@@ -35,6 +35,7 @@
 #include <asm/processor.h>
 #include <asm/timer.h>
 #include <asm/vmi_time.h>
+#include <asm/kmap_types.h>
 
 /* Convenient for calling VMI functions indirectly in the ROM */
 typedef u32 __attribute__((regparm(1))) (VROMFUNC)(void);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
arch-i386-kernel-vmic-must-include-asm-kmap_typesh.patch
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
