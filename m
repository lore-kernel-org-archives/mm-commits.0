From: akpm@linux-foundation.org
Subject: + kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch added to -mm tree
Date: Tue, 27 Jan 2009 00:12:35 -0800
Message-ID: <200901270812.n0R8CZX4014969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037AbZA0IM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 03:12:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, horms@verge.net.au, nhorman@tuxdriver.com, vgoyal@redhat.com


The patch titled
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix
has been added to the -mm tree.  Its filename is
     kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch

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
Subject: kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix
From: Andrew Morton <akpm@linux-foundation.org>

- switch didnt-need-to-be-a-macro to inline

- Remove unneeded ifdefs (we already did that in the header)

- repair bouncy enter key

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 ++++-
 kernel/kexec.c         |    2 --
 kernel/printk.c        |    1 -
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/kernel.h~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix include/linux/kernel.h
--- a/include/linux/kernel.h~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix
+++ a/include/linux/kernel.h
@@ -254,7 +254,10 @@ static inline int printk_ratelimit(void)
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
-#define log_buf_kexec_setup() do {} while(0)
+
+static inline void log_buf_kexec_setup(void)
+{
+}
 #endif
 
 extern int printk_needs_cpu(int cpu);
diff -puN kernel/kexec.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix kernel/kexec.c
--- a/kernel/kexec.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix
+++ a/kernel/kexec.c
@@ -1409,9 +1409,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(list_head, prev);
 	VMCOREINFO_OFFSET(vm_struct, addr);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
-#ifdef CONFIG_PRINTK
 	log_buf_kexec_setup();
-#endif
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
diff -puN kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix kernel/printk.c
--- a/kernel/printk.c~kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix
+++ a/kernel/printk.c
@@ -143,7 +143,6 @@ void log_buf_kexec_setup(void)
 	VMCOREINFO_SYMBOL(log_end);
 }
 
-
 static int __init log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
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
w1-build-fix.patch

