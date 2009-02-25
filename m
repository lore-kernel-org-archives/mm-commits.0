From: akpm@linux-foundation.org
Subject: + alpha-convert-u64-to-unsigned-long-long-fix-2.patch added to -mm tree
Date: Tue, 24 Feb 2009 16:50:23 -0800
Message-ID: <200902250107.n1P17pxR026489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbZBYBI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 20:08:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ink@jurassic.park.msu.ru, randy.dunlap@oracle.com, rth@twiddle.net


The patch titled
     alpha-convert-u64-to-unsigned-long-long-fix-2
has been added to the -mm tree.  Its filename is
     alpha-convert-u64-to-unsigned-long-long-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha-convert-u64-to-unsigned-long-long-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

arch/alpha/kernel/core_mcpcia.c:574: error: conflicting types for 'mcpcia_machine_check'
arch/alpha/kernel/proto.h:67: error: previous declaration of 'mcpcia_machine_check' was here

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/proto.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/kernel/proto.h~alpha-convert-u64-to-unsigned-long-long-fix-2 arch/alpha/kernel/proto.h
--- a/arch/alpha/kernel/proto.h~alpha-convert-u64-to-unsigned-long-long-fix-2
+++ a/arch/alpha/kernel/proto.h
@@ -64,7 +64,7 @@ void io7_clear_errors(struct io7 *io7);
 extern struct pci_ops mcpcia_pci_ops;
 extern void mcpcia_init_arch(void);
 extern void mcpcia_init_hoses(void);
-extern void mcpcia_machine_check(u64, u64);
+extern void mcpcia_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void mcpcia_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_polaris.c */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
oprofile-dont-set-counter-width-from-cpuid-on-core2-checkpatch-fixes.patch
kernel-auditscc-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
mmc-add-extended-csd-register-to-debugfs-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
pci-enable-pcie-aer-only-after-checking-firmware-support-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

