From: akpm@linux-foundation.org
Subject: + include-linux-credh-fix-build.patch added to -mm tree
Date: Thu, 17 Sep 2009 17:47:12 -0700
Message-ID: <200909180109.n8I19UR7026733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbZIRBK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Sep 2009 21:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com, jmorris@namei.org, serue@us.ibm.com


The patch titled
     include/linux/cred.h: fix build
has been added to the -mm tree.  Its filename is
     include-linux-credh-fix-build.patch

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
Subject: include/linux/cred.h: fix build
From: Andrew Morton <akpm@linux-foundation.org>

mips allmodconfig:

include/linux/cred.h: In function `creds_are_invalid':
include/linux/cred.h:187: error: `PAGE_SIZE' undeclared (first use in this function)
include/linux/cred.h:187: error: (Each undeclared identifier is reported only once
include/linux/cred.h:187: error: for each function it appears in.)

Fixes

commit b6dff3ec5e116e3af6f537d4caedcad6b9e5082a
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Fri Nov 14 10:39:16 2008 +1100
Commit:     James Morris <jmorris@namei.org>
CommitDate: Fri Nov 14 10:39:16 2008 +1100

    CRED: Separate task security context from task_struct


I think.


It's way too large to be inlined anyway.

Dunno if this needs an EXPORT_SYMBOL() yet.

Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |   18 +-----------------
 kernel/cred.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 17 deletions(-)

diff -puN include/linux/cred.h~include-linux-credh-fix-build include/linux/cred.h
--- a/include/linux/cred.h~include-linux-credh-fix-build
+++ a/include/linux/cred.h
@@ -176,23 +176,7 @@ extern void __invalid_creds(const struct
 extern void __validate_process_creds(struct task_struct *,
 				     const char *, unsigned);
 
-static inline bool creds_are_invalid(const struct cred *cred)
-{
-	if (cred->magic != CRED_MAGIC)
-		return true;
-	if (atomic_read(&cred->usage) < atomic_read(&cred->subscribers))
-		return true;
-#ifdef CONFIG_SECURITY_SELINUX
-	if (selinux_is_enabled()) {
-		if ((unsigned long) cred->security < PAGE_SIZE)
-			return true;
-		if ((*(u32 *)cred->security & 0xffffff00) ==
-		    (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8))
-			return true;
-	}
-#endif
-	return false;
-}
+extern bool creds_are_invalid(const struct cred *cred);
 
 static inline void __validate_creds(const struct cred *cred,
 				    const char *file, unsigned line)
diff -puN kernel/cred.c~include-linux-credh-fix-build kernel/cred.c
--- a/kernel/cred.c~include-linux-credh-fix-build
+++ a/kernel/cred.c
@@ -782,6 +782,24 @@ EXPORT_SYMBOL(set_create_files_as);
 
 #ifdef CONFIG_DEBUG_CREDENTIALS
 
+bool creds_are_invalid(const struct cred *cred)
+{
+	if (cred->magic != CRED_MAGIC)
+		return true;
+	if (atomic_read(&cred->usage) < atomic_read(&cred->subscribers))
+		return true;
+#ifdef CONFIG_SECURITY_SELINUX
+	if (selinux_is_enabled()) {
+		if ((unsigned long) cred->security < PAGE_SIZE)
+			return true;
+		if ((*(u32 *)cred->security & 0xffffff00) ==
+		    (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8))
+			return true;
+	}
+#endif
+	return false;
+}
+
 /*
  * dump invalid credentials
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
hwmon-driver-for-acpi-40-power-meters-fix.patch
hwmon-driver-for-acpi-40-power-meters-fix-2.patch
cpuidle-fix-the-menu-governor-to-boost-io-performance.patch
video-initial-support-for-adv7180-update-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
drivers-mfd-ab3100-corec-make-powerpc-shut-up.patch
net-fix-config_net=n-build-on-sparc64.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatch-fixes.patch
st-fix-test-of-value-range-in-st_set_options-fix.patch
drivers-usb-serial-sierrac-fix-config_pm=n-build.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimize-touch_time-too.patch
fs-improve-remountro-vs-buffercache-coherency-fix.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
revert-proc-kcore-work-around-a-bug.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers-checkpatch-fixes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
include-linux-credh-fix-build.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-convert-to-use-arch_gettimeoffset-fix.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

