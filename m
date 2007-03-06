From: akpm@linux-foundation.org
Subject: - lguest-kconfig-and-headers-fix.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:53:40 -0800
Message-ID: <200703061053.l26Are3O020344@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35547 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888AbXCFK5G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:57:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ak@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     LGUEST must depend on NET
has been removed from the -mm tree.  Its filename was
     lguest-kconfig-and-headers-fix.patch

This patch was dropped because it was folded into lguest-kconfig-and-headers.patch

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

origin.patch
remove-arch-i386-kernel-tscccustom_sched_clock.patch
drivers-cpuidle-make-code-static.patch
git-drm.patch
make-drivers-char-drm-drm_vmcdrm_io_prot-static.patch
git-dvb.patch
saa7134-fix-modules=n-compilation.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-fs-jffs2-ioctlc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
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
lguest-kconfig-and-headers.patch
lguest-kconfig-and-headers-fix.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
