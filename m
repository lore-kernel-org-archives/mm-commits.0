From: akpm@linux-foundation.org
Subject: [folded] fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup-cleanup.patch removed from -mm tree
Date: Wed, 10 Feb 2010 13:54:50 -0800
Message-ID: <201002102154.o1ALsocG001144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507Ab0BJV43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Feb 2010 16:56:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anton@samba.org, benh@kernel.crashing.org, jmorris@namei.org, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, oleg@redhat.com, serue@us.ibm.com, stable@kerne


The patch titled
     fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup-cleanup
has been removed from the -mm tree.  Its filename was
     fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup-cleanup.patch

This patch was dropped because it was folded into fs-execc-restrict-initial-stack-space-expansion-to-rlimit.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <stable@kernel.org>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/exec.c~fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup-cleanup fs/exec.c
--- a/fs/exec.c~fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup-cleanup
+++ a/fs/exec.c
@@ -637,20 +637,17 @@ int setup_arg_pages(struct linux_binprm 
 	 * will align it up.
 	 */
 	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
-	if (rlim_stack < stack_size)
-		rlim_stack = stack_size;
+	rlim_stack = min(rlim_stack, stack_size);
 #ifdef CONFIG_STACK_GROWSUP
-	if (stack_size + stack_expand > rlim_stack) {
+	if (stack_size + stack_expand > rlim_stack)
 		stack_base = vma->vm_start + rlim_stack;
-	} else {
+	else
 		stack_base = vma->vm_end + stack_expand;
-	}
 #else
-	if (stack_size + stack_expand > rlim_stack) {
+	if (stack_size + stack_expand > rlim_stack)
 		stack_base = vma->vm_end - rlim_stack;
-	} else {
+	else
 		stack_base = vma->vm_start - stack_expand;
-	}
 #endif
 	ret = expand_stack(vma, stack_base);
 	if (ret)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-execc-restrict-initial-stack-space-expansion-to-rlimit.patch
fs-execc-restrict-initial-stack-space-expansion-to-rlimit-cleanup-cleanup.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

