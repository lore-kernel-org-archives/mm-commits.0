From: akpm@linux-foundation.org
Subject: [folded] page_fault-retry-with-nopage_retry-fix.patch removed from -mm tree
Date: Tue, 31 Mar 2009 14:51:05 -0700
Message-ID: <200903312151.n2VLp5PW013087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301AbZCaV7l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 17:59:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, edwintorok@gmail.com, hpa@zytor.com, hugh@veritas.com, lee.schermerhorn@hp.com, mikew@google.com, mingo@el


The patch titled
     page_fault-retry-with-nopage_retry-fix
has been removed from the -mm tree.  Its filename was
     page_fault-retry-with-nopage_retry-fix.patch

This patch was dropped because it was folded into page_fault-retry-with=
-nopage_retry.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: page_fault-retry-with-nopage_retry-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

Untangle the `write' boolean from the FAULT_FLAG_foo non-boolean field.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: T=F6r=F6k Edwin <edwintorok@gmail.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix ar=
ch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix
+++ a/arch/x86/mm/fault.c
@@ -808,7 +808,7 @@ void __kprobes do_page_fault(struct pt_r
 	struct vm_area_struct *vma;
 	int write;
 	int fault;
-	unsigned int retry_flag =3D FAULT_FLAG_RETRY;
+	int retry_flag =3D 1;
=20
 	tsk =3D current;
 	mm =3D tsk->mm;
@@ -965,6 +965,7 @@ good_area:
 	}
=20
 	write |=3D retry_flag;
+
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -983,8 +984,8 @@ good_area:
 	 * be removed or changed after the retry.
 	 */
 	if (fault & VM_FAULT_RETRY) {
-		if (write & FAULT_FLAG_RETRY) {
-			retry_flag &=3D ~FAULT_FLAG_RETRY;
+		if (retry_flag) {
+			retry_flag =3D 0;
 			goto retry;
 		}
 		BUG();
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-=
in-follow_page-fix.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage-checkpatch-fixes.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
ubd-stop-defintining-major_nr-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-k=
ey-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
cirrusfb-fix-clock-doubling-fix.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-=
checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-=
simplification.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-int=
erface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-c=
heckpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch=
-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-wor=
k.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
simplify-copy_thread-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-namei=
c-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-namei=
c-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
hpet-fix-the-possibility-of-insane-return-value-of-hpet_calibrate-again=
st-smi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-f=
ix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.=
patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.pa=
tch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkp=
atch-fixes-cleanup.patch
kernel-auditscc-fix-warning.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkp=
atch-fixes.patch
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
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patc=
h

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
