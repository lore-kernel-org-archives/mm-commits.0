From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-propertyh-fix-build-issues-with-gcc-444.patch removed from
 -mm tree
Date: Mon, 04 Jan 2016 11:06:22 -0800
Message-ID: <568ac2ae.i3+DtTNz3BwTJl4q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcADTGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 14:06:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, heikki.krogerus@linux.intel.com, kevin@scrye.com, mika.westerberg@linux.intel.com, rafael.j.wysocki@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/property.h: fix build issues with gcc-4.4.4
has been removed from the -mm tree.  Its filename was
     include-linux-propertyh-fix-build-issues-with-gcc-444.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/property.h: fix build issues with gcc-4.4.4

gcc-4.4.4 has problems with initialization of anonymous unions:

drivers/mfd/intel-lpss-acpi.c:30: error: unknown field 'value' specified in initializer

work around this by crafting the initializers in a manner which the
compiler can handle.

Cc: Kevin Fenzi <kevin@scrye.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/property.h |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN include/linux/property.h~include-linux-propertyh-fix-build-issues-with-gcc-444 include/linux/property.h
--- a/include/linux/property.h~include-linux-propertyh-fix-build-issues-with-gcc-444
+++ a/include/linux/property.h
@@ -175,12 +175,19 @@ struct property_entry {
 	};
 };
 
+/*
+ * Note: the below four initializers for the anonymous union are carefully
+ * crafted to avoid gcc-4.4.4's problems with initialization of anon unions
+ * and structs.
+ */
+
 #define PROPERTY_ENTRY_INTEGER_ARRAY(_name_, _type_, _val_)	\
 {								\
 	.name = _name_,						\
 	.length = ARRAY_SIZE(_val_) * sizeof(_type_),		\
 	.is_array = true,					\
-	.pointer._type_##_data = _val_,				\
+	.is_string = false,					\
+	{ .pointer = { _type_##_data = _val_ } },		\
 }
 
 #define PROPERTY_ENTRY_U8_ARRAY(_name_, _val_)			\
@@ -198,14 +205,15 @@ struct property_entry {
 	.length = ARRAY_SIZE(_val_) * sizeof(const char *),	\
 	.is_array = true,					\
 	.is_string = true,					\
-	.pointer.str = _val_,					\
+	{ .pointer = { .str = _val_ } },			\
 }
 
 #define PROPERTY_ENTRY_INTEGER(_name_, _type_, _val_)	\
 {							\
 	.name = _name_,					\
 	.length = sizeof(_type_),			\
-	.value._type_##_data = _val_,			\
+	.is_string = false,				\
+	{ .value = { ._type_##_data = _val_ } },	\
 }
 
 #define PROPERTY_ENTRY_U8(_name_, _val_)		\
@@ -222,7 +230,7 @@ struct property_entry {
 	.name = _name_,					\
 	.length = sizeof(_val_),			\
 	.is_string = true,				\
-	.value.str = _val_,				\
+	{ .value = {.str = _val_} },			\
 }
 
 #define PROPERTY_ENTRY_BOOL(_name_)		\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-introduce-kernelcore=mirror-option-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-printk-introduce-new-format-string-for-flags-fix-2.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-oom-introduce-oom-reaper-fix-fix.patch
mm-oom-introduce-oom-reaper-fix-fix-2.patch
mm-oom-introduce-oom-reaper-checkpatch-fixes.patch
mm-oom-introduce-oom-reaper-fix-3.patch
mm-oom-introduce-oom-reaper-fix-4-fix.patch
mm-oom-introduce-oom-reaper-fix-5-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

