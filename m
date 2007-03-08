From: akpm@linux-foundation.org
Subject: + x86_p4_clockmod-must-select-cpu_freq_table.patch added to -mm tree
Date: Thu, 08 Mar 2007 01:08:07 -0800
Message-ID: <200703080908.l28987GE023808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59841 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030394AbXCHJLf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Mar 2007 04:11:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, davej@redhat.com, rientjes@google.com


The patch titled
     X86_P4_CLOCKMOD must select CPU_FREQ_TABLE
has been added to the -mm tree.  Its filename is
     x86_p4_clockmod-must-select-cpu_freq_table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: X86_P4_CLOCKMOD must select CPU_FREQ_TABLE
From: Adrian Bunk <bunk@stusta.de>

CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_X86_P4_CLOCKMOD=y

arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_verify':p4-clockmod.c:(.text.cpufreq_p4_verify+0x8): undefined reference to `cpufreq_frequency_table_verify'
arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_cpu_exit':p4-clockmod.c:(.text.cpufreq_p4_cpu_exit+0x8): undefined reference to `cpufreq_frequency_table_put_attr'
arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_cpu_init':p4-clockmod.c:(.text.cpufreq_p4_cpu_init+0x13b): undefined reference to `cpufreq_frequency_table_get_attr'

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Dave Jones <davej@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/cpufreq/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/cpufreq/Kconfig~x86_p4_clockmod-must-select-cpu_freq_table arch/x86_64/kernel/cpufreq/Kconfig
--- a/arch/x86_64/kernel/cpufreq/Kconfig~x86_p4_clockmod-must-select-cpu_freq_table
+++ a/arch/x86_64/kernel/cpufreq/Kconfig
@@ -75,6 +75,7 @@ config X86_ACPI_CPUFREQ_PROC_INTF
 config X86_P4_CLOCKMOD
 	tristate "Intel Pentium 4 clock modulation"
 	depends on EMBEDDED
+	select CPU_FREQ_TABLE
 	help
 	  This adds the clock modulation driver for Intel Pentium 4 / XEON
 	  processors.  When enabled it will lower CPU temperature by skipping
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
x86_p4_clockmod-must-select-cpu_freq_table.patch
git-acpi.patch
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
git-netdev-all.patch
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
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
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
