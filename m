From: akpm@linux-foundation.org
Subject: [obsolete] mm-slab_commonc-fix-warning.patch removed from -mm tree
Date: Wed, 15 Aug 2012 16:53:46 -0700
Message-ID: <20120815235347.8F0B920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:56061 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383Ab2HOXxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2012 19:53:50 -0400
Received: by lagw12 with SMTP id w12so100165lag.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:53:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: cleanup
has been removed from the -mm tree.  Its filename was
     mm-slab_commonc-fix-warning.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/slab_common.c: cleanup

Eliminate an ifdef and a label by moving all the CONFIG_DEBUG_VM checking
inside the locked region.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN mm/slab_common.c~mm-slab_commonc-fix-warning mm/slab_common.c
--- a/mm/slab_common.c~mm-slab_commonc-fix-warning
+++ a/mm/slab_common.c
@@ -53,19 +53,17 @@ struct kmem_cache *kmem_cache_create(con
 {
 	struct kmem_cache *s = NULL;
 
+	get_online_cpus();
+	mutex_lock(&slab_mutex);
+
 #ifdef CONFIG_DEBUG_VM
 	if (!name || in_interrupt() || size < sizeof(void *) ||
 		size > KMALLOC_MAX_SIZE) {
 		printk(KERN_ERR "kmem_cache_create(%s) integrity check"
-			" failed\n", name);
-		goto out;
+				" failed\n", name);
+		goto oops;
 	}
-#endif
-
-	get_online_cpus();
-	mutex_lock(&slab_mutex);
 
-#ifdef CONFIG_DEBUG_VM
 	list_for_each_entry(s, &slab_caches, list) {
 		char tmp;
 		int res;
@@ -104,9 +102,6 @@ oops:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-#ifdef CONFIG_DEBUG_VM
-out:
-#endif
 	if (!s && (flags & SLAB_PANIC))
 		panic("kmem_cache_create: Failed to create slab '%s'\n", name);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function-fix.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

