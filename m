From: akpm@linux-foundation.org
Subject: + lguest-kconfig-and-headers-fix.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:52:34 -0800
Message-ID: <200702272052.l1RKqcME028166@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51625 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbXB0U4A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:56:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, ak@suse.de, rusty@rustcorp.com.au


The patch titled
     LGUEST must depend on NET
has been added to the -mm tree.  Its filename is
     lguest-kconfig-and-headers-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: LGUEST must depend on NET
From: Adrian Bunk <bunk@stusta.de>

CONFIG_LGUEST=y, CONFIG_NET=n results in the following compile error:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `lguestnet_close':
lguest_net.c:(.text+0x3b8de): undefined reference to `kfree_skb'
drivers/built-in.o: In function `fill_slot':
lguest_net.c:(.text+0x3ba08): undefined reference to `__alloc_skb'
drivers/built-in.o: In function `lguestnet_open':
lguest_net.c:(.text+0x3bada): undefined reference to `kfree_skb'
drivers/built-in.o: In function `lguestnet_start_xmit':
lguest_net.c:(.text+0x3bc03): undefined reference to `kfree_skb'
drivers/built-in.o: In function `lguestnet_rcv':
lguest_net.c:(.text+0x3bc61): undefined reference to `kfree_skb'
lguest_net.c:(.text+0x3bc6c): undefined reference to `skb_put'
lguest_net.c:(.text+0x3bc76): undefined reference to `eth_type_trans'
lguest_net.c:(.text+0x3bc94): undefined reference to `netif_rx'
drivers/built-in.o: In function `lguestnet_probe':
lguest_net.c:(.text+0x3bcdb): undefined reference to `alloc_etherdev'
lguest_net.c:(.text+0x3bcea): undefined reference to `ether_setup'
lguest_net.c:(.text+0x3bdc1): undefined reference to `register_netdev'
lguest_net.c:(.text+0x3be10): undefined reference to `unregister_netdev'
lguest_net.c:(.text+0x3be17): undefined reference to `free_netdev'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/Kconfig~lguest-kconfig-and-headers-fix arch/i386/Kconfig
--- a/arch/i386/Kconfig~lguest-kconfig-and-headers-fix
+++ a/arch/i386/Kconfig
@@ -257,7 +257,7 @@ source "arch/i386/Kconfig.cpu"
 
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE
+	depends on X86 && PARAVIRT && NET && EXPERIMENTAL && !X86_PAE
 	select LGUEST_GUEST
 	select HVC_DRIVER
 	---help---
_

Patches currently in -mm which might be from bunk@stusta.de are

arch-arm26-kernel-entrys-remove-dead-code.patch
make-ipc-shmcshm_nopage-static.patch
mm-tiny-shmemc-cleanups.patch
drivers-video-sm501fbc-make-4-functions-static.patch
fix-the-sysctl=n-compilation.patch
remove-the-jffs-maintainers-entry.patch
drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix.patch
git-cpufreq.patch
make-kernel-kmodckmod_mk-static.patch
git-drm.patch
git-dvb.patch
make-dvb_usb_gl861_debug-static.patch
make-pvr2_encoder_prep_config-static.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
mips-remove-smp_tune_scheduling.patch
drivers-mmc-kconfig-source-drivers-mmc-card-kconfig.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
mtd_ubi_debug-must-depend-on-sysfs.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
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
make-drivers-usb-misc-iowarriorciowarrior_ids-static.patch
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
