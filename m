From: akpm@linux-foundation.org
Subject: + mm-allocpercpuc-make-4-functions-static.patch added to -mm tree
Date: Tue, 06 May 2008 11:36:44 -0700
Message-ID: <200805061836.m46Iaiel021236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbYEFSg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:36:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, clameter@sgi.com


The patch titled
     mm/allocpercpu.c: make 4 functions static
has been added to the -mm tree.  Its filename is
     mm-allocpercpuc-make-4-functions-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |   29 -----------------------------
 mm/allocpercpu.c       |   20 +++++++++++---------
 2 files changed, 11 insertions(+), 38 deletions(-)

diff -puN include/linux/percpu.h~mm-allocpercpuc-make-4-functions-static include/linux/percpu.h
--- a/include/linux/percpu.h~mm-allocpercpuc-make-4-functions-static
+++ a/include/linux/percpu.h
@@ -75,11 +75,6 @@ struct percpu_data {
         (__typeof__(ptr))__p->ptrs[(cpu)];	          \
 })
 
-extern void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu);
-extern void percpu_depopulate(void *__pdata, int cpu);
-extern int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-				  cpumask_t *mask);
-extern void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask);
 extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
 extern void percpu_free(void *__pdata);
 
@@ -87,26 +82,6 @@ extern void percpu_free(void *__pdata);
 
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
@@ -119,10 +94,6 @@ static inline void percpu_free(void *__p
 
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
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

