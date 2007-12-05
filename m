From: akpm@linux-foundation.org
Subject: + drivers-cpufreq-cpufreq_statsc-section-fix.patch added to -mm tree
Date: Wed, 05 Dec 2007 15:52:40 -0800
Message-ID: <200712052352.lB5Nqe47031302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbXLEXxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 18:53:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, chris2553@googlemail.com, davej@codemonkey.org.uk


The patch titled
     drivers/cpufreq/cpufreq_stats.c section fix
has been added to the -mm tree.  Its filename is
     drivers-cpufreq-cpufreq_statsc-section-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/cpufreq/cpufreq_stats.c section fix
From: Adrian Bunk <bunk@kernel.org>

cpufreq_stats_free_table() mustn't be __cpuexit since it's called by the
__cpuinit cpufreq_stat_cpu_callback().

This patch fixes the following section mismatch reported by
Chris Clayton:

WARNING: vmlinux.o(.init.text+0x143dd): Section mismatch: reference to .exit.text:cpufreq_stats_free_table (between 'cpufreq_stat_cpu_callback' and 'cpufreq_stats_init')

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Chris Clayton <chris2553@googlemail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq_stats.c~drivers-cpufreq-cpufreq_statsc-section-fix drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~drivers-cpufreq-cpufreq_statsc-section-fix
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -164,7 +164,7 @@ freq_table_get_index(struct cpufreq_stat
 	return -1;
 }
 
-static void __cpuexit cpufreq_stats_free_table(unsigned int cpu)
+static void cpufreq_stats_free_table(unsigned int cpu)
 {
 	struct cpufreq_stats *stat = cpufreq_stats_table[cpu];
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-dvb.patch
remove-saa7134-oss.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
git-netdev-all.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
scsi-qla2xxx-qla_osc-section-fix.patch
git-x86.patch
git-xtensa.patch
xtensa-kernel-setupc-remove-dead-code.patch
drivers-cpufreq-cpufreq_statsc-section-fix.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
