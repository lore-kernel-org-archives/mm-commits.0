Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB608C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 20:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiDFU7k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Apr 2022 16:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbiDFU6e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2022 16:58:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6394B21046D
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 12:23:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF52C61CBB
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 19:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E115C385A5;
        Wed,  6 Apr 2022 19:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649273031;
        bh=yJpz0nKOxLCpCVY37Qhl7MEMSWaBAHcx68fijaCry/U=;
        h=Date:To:From:Subject:From;
        b=RtkgwsqkJioyWcvCf3kFlWqc867GS87iJ8/JyLtvV38te/3hyqT8slDWKaBM2nIGT
         kVuFArDQ2YCG1KBipVMTQVsYJEm5iHsDAQ84OE6tfJbKex1opTBLoE8Uh3ys4H8nKR
         pVCALKquLmlAwkd8HQieZfLgplcLEGPSPUUn/doI=
Date:   Wed, 06 Apr 2022 12:23:50 -0700
To:     mm-commits@vger.kernel.org, oliver.sang@intel.com,
        42.hyeyoo@gmail.com, elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-support-kmem_dump_obj-for-kfence-objects.patch added to -mm tree
Message-Id: <20220406192351.2E115C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kfence: support kmem_dump_obj() for KFENCE objects
has been added to the -mm tree.  Its filename is
     mm-kfence-support-kmem_dump_obj-for-kfence-objects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kfence-support-kmem_dump_obj-for-kfence-objects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kfence-support-kmem_dump_obj-for-kfence-objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: mm, kfence: support kmem_dump_obj() for KFENCE objects

Calling kmem_obj_info() via kmem_dump_obj() on KFENCE objects has been
producing garbage data due to the object not actually being maintained by
SLAB or SLUB.

Fix this by implementing __kfence_obj_info() that copies relevant
information to struct kmem_obj_info when the object was allocated by
KFENCE; this is called by a common kmem_obj_info(), which also calls the
slab/slub/slob specific variant now called __kmem_obj_info().

For completeness, kmem_dump_obj() now displays if the object was allocated
by KFENCE.

Link: https://lore.kernel.org/all/20220323090520.GG16885@xsang-OptiPlex-9020/
Link: https://lkml.kernel.org/r/20220406131558.3558585-1-elver@google.com
Fixes: b89fb5ef0ce6 ("mm, kfence: insert KFENCE hooks for SLUB")
Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h |   24 +++++++++++++++++++
 mm/kfence/core.c       |   21 -----------------
 mm/kfence/kfence.h     |   21 +++++++++++++++++
 mm/kfence/report.c     |   47 +++++++++++++++++++++++++++++++++++++++
 mm/slab.c              |    2 -
 mm/slab.h              |    2 -
 mm/slab_common.c       |    9 +++++++
 mm/slob.c              |    2 -
 mm/slub.c              |    2 -
 9 files changed, 105 insertions(+), 25 deletions(-)

--- a/include/linux/kfence.h~mm-kfence-support-kmem_dump_obj-for-kfence-objects
+++ a/include/linux/kfence.h
@@ -204,6 +204,22 @@ static __always_inline __must_check bool
  */
 bool __must_check kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs *regs);
 
+#ifdef CONFIG_PRINTK
+struct kmem_obj_info;
+/**
+ * __kfence_obj_info() - fill kmem_obj_info struct
+ * @kpp: kmem_obj_info to be filled
+ * @object: the object
+ *
+ * Return:
+ * * false - not a KFENCE object
+ * * true - a KFENCE object, filled @kpp
+ *
+ * Copies information to @kpp for KFENCE objects.
+ */
+bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
+#endif
+
 #else /* CONFIG_KFENCE */
 
 static inline bool is_kfence_address(const void *addr) { return false; }
@@ -221,6 +237,14 @@ static inline bool __must_check kfence_h
 	return false;
 }
 
+#ifdef CONFIG_PRINTK
+struct kmem_obj_info;
+static inline bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
+{
+	return false;
+}
+#endif
+
 #endif
 
 #endif /* _LINUX_KFENCE_H */
--- a/mm/kfence/core.c~mm-kfence-support-kmem_dump_obj-for-kfence-objects
+++ a/mm/kfence/core.c
@@ -231,27 +231,6 @@ static bool kfence_unprotect(unsigned lo
 	return !KFENCE_WARN_ON(!kfence_protect_page(ALIGN_DOWN(addr, PAGE_SIZE), false));
 }
 
-static inline struct kfence_metadata *addr_to_metadata(unsigned long addr)
-{
-	long index;
-
-	/* The checks do not affect performance; only called from slow-paths. */
-
-	if (!is_kfence_address((void *)addr))
-		return NULL;
-
-	/*
-	 * May be an invalid index if called with an address at the edge of
-	 * __kfence_pool, in which case we would report an "invalid access"
-	 * error.
-	 */
-	index = (addr - (unsigned long)__kfence_pool) / (PAGE_SIZE * 2) - 1;
-	if (index < 0 || index >= CONFIG_KFENCE_NUM_OBJECTS)
-		return NULL;
-
-	return &kfence_metadata[index];
-}
-
 static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *meta)
 {
 	unsigned long offset = (meta - kfence_metadata + 1) * PAGE_SIZE * 2;
--- a/mm/kfence/kfence.h~mm-kfence-support-kmem_dump_obj-for-kfence-objects
+++ a/mm/kfence/kfence.h
@@ -96,6 +96,27 @@ struct kfence_metadata {
 
 extern struct kfence_metadata kfence_metadata[CONFIG_KFENCE_NUM_OBJECTS];
 
+static inline struct kfence_metadata *addr_to_metadata(unsigned long addr)
+{
+	long index;
+
+	/* The checks do not affect performance; only called from slow-paths. */
+
+	if (!is_kfence_address((void *)addr))
+		return NULL;
+
+	/*
+	 * May be an invalid index if called with an address at the edge of
+	 * __kfence_pool, in which case we would report an "invalid access"
+	 * error.
+	 */
+	index = (addr - (unsigned long)__kfence_pool) / (PAGE_SIZE * 2) - 1;
+	if (index < 0 || index >= CONFIG_KFENCE_NUM_OBJECTS)
+		return NULL;
+
+	return &kfence_metadata[index];
+}
+
 /* KFENCE error types for report generation. */
 enum kfence_error_type {
 	KFENCE_ERROR_OOB,		/* Detected a out-of-bounds access. */
--- a/mm/kfence/report.c~mm-kfence-support-kmem_dump_obj-for-kfence-objects
+++ a/mm/kfence/report.c
@@ -273,3 +273,50 @@ void kfence_report_error(unsigned long a
 	/* We encountered a memory safety error, taint the kernel! */
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_STILL_OK);
 }
+
+#ifdef CONFIG_PRINTK
+static void kfence_to_kp_stack(const struct kfence_track *track, void **kp_stack)
+{
+	int i, j;
+
+	i = get_stack_skipnr(track->stack_entries, track->num_stack_entries, NULL);
+	for (j = 0; i < track->num_stack_entries && j < KS_ADDRS_COUNT; ++i, ++j)
+		kp_stack[j] = (void *)track->stack_entries[i];
+	if (j < KS_ADDRS_COUNT)
+		kp_stack[j] = NULL;
+}
+
+bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
+{
+	struct kfence_metadata *meta = addr_to_metadata((unsigned long)object);
+	unsigned long flags;
+
+	if (!meta)
+		return false;
+
+	/*
+	 * If state is UNUSED at least show the pointer requested; the rest
+	 * would be garbage data.
+	 */
+	kpp->kp_ptr = object;
+
+	/* Requesting info an a never-used object is almost certainly a bug. */
+	if (WARN_ON(meta->state == KFENCE_OBJECT_UNUSED))
+		return true;
+
+	raw_spin_lock_irqsave(&meta->lock, flags);
+
+	kpp->kp_slab = slab;
+	kpp->kp_slab_cache = meta->cache;
+	kpp->kp_objp = (void *)meta->addr;
+	kfence_to_kp_stack(&meta->alloc_track, kpp->kp_stack);
+	if (meta->state == KFENCE_OBJECT_FREED)
+		kfence_to_kp_stack(&meta->free_track, kpp->kp_free_stack);
+	/* get_stack_skipnr() ensures the first entry is outside allocator. */
+	kpp->kp_ret = kpp->kp_stack[0];
+
+	raw_spin_unlock_irqrestore(&meta->lock, flags);
+
+	return true;
+}
+#endif
--- a/mm/slab.c~mm-kfence-support-kmem_dump_obj-for-kfence-objects
+++ a/mm/slab.c
@@ -3665,7 +3665,7 @@ EXPORT_SYMBOL(__kmalloc_node_track_calle
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 {
 	struct kmem_cache *cachep;
 	unsigned int objnr;
--- a/mm/slab_common.c~mm-kfence-support-kmem_dump_obj-for-kfence-objects
+++ a/mm/slab_common.c
@@ -555,6 +555,13 @@ bool kmem_valid_obj(void *object)
 }
 EXPORT_SYMBOL_GPL(kmem_valid_obj);
 
+static void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
+{
+	if (__kfence_obj_info(kpp, object, slab))
+		return;
+	__kmem_obj_info(kpp, object, slab);
+}
+
 /**
  * kmem_dump_obj - Print available slab provenance information
  * @object: slab object for which to find provenance information.
@@ -590,6 +597,8 @@ void kmem_dump_obj(void *object)
 		pr_cont(" slab%s %s", cp, kp.kp_slab_cache->name);
 	else
 		pr_cont(" slab%s", cp);
+	if (is_kfence_address(object))
+		pr_cont(" (kfence)");
 	if (kp.kp_objp)
 		pr_cont(" start %px", kp.kp_objp);
 	if (kp.kp_data_offset)
--- a/mm/slab.h~mm-kfence-support-kmem_dump_obj-for-kfence-objects
+++ a/mm/slab.h
@@ -868,7 +868,7 @@ struct kmem_obj_info {
 	void *kp_stack[KS_ADDRS_COUNT];
 	void *kp_free_stack[KS_ADDRS_COUNT];
 };
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
 #endif
 
 #ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
--- a/mm/slob.c~mm-kfence-support-kmem_dump_obj-for-kfence-objects
+++ a/mm/slob.c
@@ -463,7 +463,7 @@ out:
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 {
 	kpp->kp_ptr = object;
 	kpp->kp_slab = slab;
--- a/mm/slub.c~mm-kfence-support-kmem_dump_obj-for-kfence-objects
+++ a/mm/slub.c
@@ -4312,7 +4312,7 @@ int __kmem_cache_shutdown(struct kmem_ca
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
+void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 {
 	void *base;
 	int __maybe_unused i;
_

Patches currently in -mm which might be from elver@google.com are

mm-kfence-support-kmem_dump_obj-for-kfence-objects.patch

