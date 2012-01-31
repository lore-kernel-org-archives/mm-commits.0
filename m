From: akpm@linux-foundation.org
Subject: + drivers-cpufreq-gx-suspmodc-fix-build.patch added to -mm tree
Date: Tue, 31 Jan 2012 14:39:46 -0800
Message-ID: <20120131232229.4A89D200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57702 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2AaXWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 18:22:32 -0500
Received: by eekb15 with SMTP id b15so21543eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2012 15:22:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com, davej@redhat.com, gregkh@suse.de, hpa@zytor.com, kay.sievers@vrfy.org, trenn@suse.de


The patch titled
     Subject: drivers/cpufreq/gx-suspmod.c: fix build
has been added to the -mm tree.  Its filename is
     drivers-cpufreq-gx-suspmodc-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/cpufreq/gx-suspmod.c: fix build

i386 allmodconfig:

drivers/cpufreq/gx-suspmod.c:175:35: error: macro "MODULE_DEVICE_TABLE" requires 2 arguments, but only 1 given
drivers/cpufreq/gx-suspmod.c:175: warning: data definition has no type or storage class
drivers/cpufreq/gx-suspmod.c:175: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE'

How did this get through??

The patch is a guess.

Cc: Dave Jones <davej@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/gx-suspmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/gx-suspmod.c~drivers-cpufreq-gx-suspmodc-fix-build drivers/cpufreq/gx-suspmod.c
--- a/drivers/cpufreq/gx-suspmod.c~drivers-cpufreq-gx-suspmodc-fix-build
+++ a/drivers/cpufreq/gx-suspmod.c
@@ -172,7 +172,7 @@ static struct pci_device_id gx_chipset_t
 	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5510), },
 	{ 0, },
 };
-MODULE_DEVICE_TABLE(gx_chipset_tbl);
+MODULE_DEVICE_TABLE(x86cpu, gx_chipset_tbl);
 
 static void gx_write_byte(int reg, int value)
 {
_
Subject: Subject: drivers/cpufreq/gx-suspmod.c: fix build

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-cpufreq-gx-suspmodc-fix-build.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-filemap_xipc-fix-race-condition-in-xip_file_fault-fix.patch
kprobes-fix-a-memory-leak-in-function-pre_handler_kretprobe-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

