From: akpm@linux-foundation.org
Subject: [merged] include-linux-credh-fix-build.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:53 -0700
Message-ID: <200909241937.n8OJbrqm005472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbZIXTlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:41:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, jmorris@namei.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/cred.h: fix build
has been removed from the -mm tree.  Its filename was
     include-linux-credh-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[randy.dunlap@oracle.com: export creds_are_invalid]
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |   18 +-----------------
 kernel/cred.c        |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 17 deletions(-)

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
@@ -782,6 +782,25 @@ EXPORT_SYMBOL(set_create_files_as);
 
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
+EXPORT_SYMBOL(creds_are_invalid);
+
 /*
  * dump invalid credentials
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
procfs-disable-per-task-stack-usage-on-nommu.patch
hugetlb_file_setup-use-c-not-cpp.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
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

