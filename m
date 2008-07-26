From: akpm@linux-foundation.org
Subject: - mm-allocpercpuc-make-4-functions-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:14 -0700
Message-ID: <200807262118.m6QLIE5b020073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758038AbYGZVSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mm/allocpercpu.c: make 4 functions static
has been removed from the -mm tree.  Its filename was
     mm-allocpercpuc-make-4-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/allocpercpu.c: make 4 functions static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global functions static:
- percpu_depopulate()
- __percpu_depopulate_mask()
- percpu_populate()
- __percpu_populate_mask()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |   29 -----------------------------
 mm/allocpercpu.c       |   20 +++++++++++---------
 2 files changed, 11 insertions(+), 38 deletions(-)

diff -puN include/linux/percpu.h~mm-allocpercpuc-make-4-functions-static include/linux/percpu.h
--- a/include/linux/percpu.h~mm-allocpercpuc-make-4-functions-static
+++ a/include/linux/percpu.h
@@ -74,11 +74,6 @@ struct percpu_data {
         (__typeof__(ptr))__p->ptrs[(cpu)];	          \
 })
 
-extern void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu);
-extern void percpu_depopulate(void *__pdata, int cpu);
-extern int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-				  cpumask_t *mask);
-extern void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask);
 extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
 extern void percpu_free(void *__pdata);
 
@@ -86,26 +81,6 @@ extern void percpu_free(void *__pdata);
 
 #define percpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static inline void percpu_depopulate(void *__pdata, int cpu)
-{
-}
-
-static inline void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
-{
-}
-
-static inline void *percpu_populate(void *__pdata, size_t size, gfp_t gfp,
-				    int cpu)
-{
-	return percpu_ptr(__pdata, cpu);
-}
-
-static inline int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-					 cpumask_t *mask)
-{
-	return 0;
-}
-
 static __always_inline void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
 {
 	return kzalloc(size, gfp);
@@ -118,10 +93,6 @@ static inline void percpu_free(void *__p
 
 #endif /* CONFIG_SMP */
 
-#define percpu_populate_mask(__pdata, size, gfp, mask) \
-	__percpu_populate_mask((__pdata), (size), (gfp), &(mask))
-#define percpu_depopulate_mask(__pdata, mask) \
-	__percpu_depopulate_mask((__pdata), &(mask))
 #define percpu_alloc_mask(size, gfp, mask) \
 	__percpu_alloc_mask((size), (gfp), &(mask))
 
diff -puN mm/allocpercpu.c~mm-allocpercpuc-make-4-functions-static mm/allocpercpu.c
--- a/mm/allocpercpu.c~mm-allocpercpuc-make-4-functions-static
+++ a/mm/allocpercpu.c
@@ -18,27 +18,28 @@
  * Depopulating per-cpu data for a cpu going offline would be a typical
  * use case. You need to register a cpu hotplug handler for that purpose.
  */
-void percpu_depopulate(void *__pdata, int cpu)
+static void percpu_depopulate(void *__pdata, int cpu)
 {
 	struct percpu_data *pdata = __percpu_disguise(__pdata);
 
 	kfree(pdata->ptrs[cpu]);
 	pdata->ptrs[cpu] = NULL;
 }
-EXPORT_SYMBOL_GPL(percpu_depopulate);
 
 /**
  * percpu_depopulate_mask - depopulate per-cpu data for some cpu's
  * @__pdata: per-cpu data to depopulate
  * @mask: depopulate per-cpu data for cpu's selected through mask bits
  */
-void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
+static void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
 {
 	int cpu;
 	for_each_cpu_mask_nr(cpu, *mask)
 		percpu_depopulate(__pdata, cpu);
 }
-EXPORT_SYMBOL_GPL(__percpu_depopulate_mask);
+
+#define percpu_depopulate_mask(__pdata, mask) \
+	__percpu_depopulate_mask((__pdata), &(mask))
 
 /**
  * percpu_populate - populate per-cpu data for given cpu
@@ -51,7 +52,7 @@ EXPORT_SYMBOL_GPL(__percpu_depopulate_ma
  * use case. You need to register a cpu hotplug handler for that purpose.
  * Per-cpu object is populated with zeroed buffer.
  */
-void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu)
+static void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu)
 {
 	struct percpu_data *pdata = __percpu_disguise(__pdata);
 	int node = cpu_to_node(cpu);
@@ -68,7 +69,6 @@ void *percpu_populate(void *__pdata, siz
 		pdata->ptrs[cpu] = kzalloc(size, gfp);
 	return pdata->ptrs[cpu];
 }
-EXPORT_SYMBOL_GPL(percpu_populate);
 
 /**
  * percpu_populate_mask - populate per-cpu data for more cpu's
@@ -79,8 +79,8 @@ EXPORT_SYMBOL_GPL(percpu_populate);
  *
  * Per-cpu objects are populated with zeroed buffers.
  */
-int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-			   cpumask_t *mask)
+static int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
+				  cpumask_t *mask)
 {
 	cpumask_t populated;
 	int cpu;
@@ -94,7 +94,9 @@ int __percpu_populate_mask(void *__pdata
 			cpu_set(cpu, populated);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__percpu_populate_mask);
+
+#define percpu_populate_mask(__pdata, size, gfp, mask) \
+	__percpu_populate_mask((__pdata), (size), (gfp), &(mask))
 
 /**
  * percpu_alloc_mask - initial setup of per-cpu data
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

