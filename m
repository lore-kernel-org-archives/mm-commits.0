From: akpm@linux-foundation.org
Subject: + lib-string_helpers-introduce-string_escape_mem-fix.patch added
 to -mm tree
Date: Wed, 03 Sep 2014 15:26:27 -0700
Message-ID: <54079593./X09KKNSKWsXQpzw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018AbaICW02 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 18:26:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-string_helpers-introduce-string_escape_mem-fix
has been added to the -mm tree.  Its filename is
     lib-string_helpers-introduce-string_escape_mem-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpers-introduce-string_escape_mem-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpers-introduce-string_escape_mem-fix.patch

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
Subject: lib-string_helpers-introduce-string_escape_mem-fix

avoid 1k stack consumption

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-string_helpers.c |   37 +++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff -puN lib/test-string_helpers.c~lib-string_helpers-introduce-string_escape_mem-fix lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-string_helpers-introduce-string_escape_mem-fix
+++ a/lib/test-string_helpers.c
@@ -5,6 +5,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/string.h>
@@ -62,10 +63,14 @@ static const struct test_string strings[
 static void __init test_string_unescape(const char *name, unsigned int flags,
 					bool inplace)
 {
-	char in[256];
-	char out_test[256];
-	char out_real[256];
-	int i, p = 0, q_test = 0, q_real = sizeof(out_real);
+	int q_real = 256;
+	char *in = kmalloc(q_real, GFP_KERNEL);
+	char *out_test = kmalloc(q_real, GFP_KERNEL);
+	char *out_real = kmalloc(q_real, GFP_KERNEL);
+	int i, p = 0, q_test = 0;
+
+	if (!in || !out_test || !out_real)
+		goto out;
 
 	for (i = 0; i < ARRAY_SIZE(strings); i++) {
 		const char *s = strings[i].in;
@@ -100,6 +105,10 @@ static void __init test_string_unescape(
 
 	test_string_check_buf(name, flags, in, p - 1, out_real, q_real,
 			      out_test, q_test);
+out:
+	kfree(out_real);
+	kfree(out_test);
+	kfree(in);
 }
 
 struct test_string_1 {
@@ -255,10 +264,15 @@ static __init void test_string_escape(co
 				      const struct test_string_2 *s2,
 				      unsigned int flags, const char *esc)
 {
-	char in[256];
-	char out_test[512];
-	char out_real[512], *buf = out_real;
-	int p = 0, q_test = 0, q_real = sizeof(out_real);
+	int q_real = 512;
+	char *out_test = kmalloc(q_real, GFP_KERNEL);
+	char *out_real = kmalloc(q_real, GFP_KERNEL);
+	char *in = kmalloc(256, GFP_KERNEL);
+	char *buf = out_real;
+	int p = 0, q_test = 0;
+
+	if (!out_test || !out_real || !in)
+		goto out;
 
 	for (; s2->in; s2++) {
 		const char *out;
@@ -289,7 +303,12 @@ static __init void test_string_escape(co
 
 	q_real = string_escape_mem(in, p, &buf, q_real, flags, esc);
 
-	test_string_check_buf(name, flags, in, p, out_real, q_real, out_test, q_test);
+	test_string_check_buf(name, flags, in, p, out_real, q_real, out_test,
+			      q_test);
+out:
+	kfree(in);
+	kfree(out_real);
+	kfree(out_test);
 }
 
 static __init void test_string_escape_nomem(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range-fix.patch
mm-slab_commonc-suppress-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-fix.patch
mm-introduce-common-page-state-for-ballooned-memory-fix.patch
mm-balloon_compaction-use-common-page-ballooning-fix.patch
mm-balloon_compaction-general-cleanup-fix.patch
mm-balloon_compaction-general-cleanup-checkpatch-fixes.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

