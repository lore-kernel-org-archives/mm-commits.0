From: akpm@linux-foundation.org
Subject: [merged] arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch removed from -mm tree
Date: Tue, 03 Apr 2012 13:10:57 -0700
Message-ID: <20120403201057.5F07FA0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60002 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab2DCULA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Apr 2012 16:11:00 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so15088vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Apr 2012 13:10:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, grant.likely@secretlab.ca, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/platforms/pseries/eeh_event.c: slightly fix set_current_state() wart
has been removed from the -mm tree.  Its filename was
     arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/powerpc/platforms/pseries/eeh_event.c: slightly fix set_current_state() wart

That set_current_state() won't work very well: the subsequent mutex_lock()
might flip the task back into TASK_RUNNING.

Attempt to put it somewhere where it might have been meant to be, and
attempt to describe why it might have been added.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/eeh_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/pseries/eeh_event.c~arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart arch/powerpc/platforms/pseries/eeh_event.c
--- a/arch/powerpc/platforms/pseries/eeh_event.c~arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart
+++ a/arch/powerpc/platforms/pseries/eeh_event.c
@@ -60,7 +60,6 @@ static int eeh_event_handler(void * dumm
 	struct eeh_dev *edev;
 
 	set_task_comm(current, "eehd");
-	set_current_state(TASK_INTERRUPTIBLE);
 
 	spin_lock_irqsave(&eeh_eventlist_lock, flags);
 	event = NULL;
@@ -83,6 +82,7 @@ static int eeh_event_handler(void * dumm
 	printk(KERN_INFO "EEH: Detected PCI bus error on device %s\n",
 	       eeh_pci_name(edev->pdev));
 
+	set_current_state(TASK_INTERRUPTIBLE);	/* Don't add to load average */
 	edev = handle_eeh_events(event);
 
 	eeh_clear_slot(eeh_dev_to_of_node(edev), EEH_MODE_RECOVERING);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-2.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

