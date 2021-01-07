Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41252C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 172E823719
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 22:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbhAGWdW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 17:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbhAGWdV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 17:33:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E61823600;
        Thu,  7 Jan 2021 22:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610058760;
        bh=dxTQ5gdBPUfkVmctoXywsFi21q4wTQwBfwl3by81sK0=;
        h=Date:From:To:Subject:From;
        b=Guu9VCn/dnL7sVVU6VRmcz6crq42lSu7TSGv9RpxXVjSv6jfKGmpWfhTc4WR0v+su
         Q2JVdzdPXmXYWm9xt14jhbAZCNbTpfThSkghuNVGT8peVJorwbLBG98RdnvvhSuB3B
         w7B0F0EhTA+NzvDC+WFkKdJJ/hU7lObXmBd9CXCU=
Date:   Thu, 07 Jan 2021 14:32:40 -0800
From:   akpm@linux-foundation.org
To:     andrii@kernel.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged] mm-make-mem_dump_obj-handle-vmalloc-memory.patch
 removed from -mm tree
Message-ID: <20210107223240.3j-PuD10_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mem_dump_obj() handle vmalloc() memory
has been removed from the -mm tree.  Its filename was
     mm-make-mem_dump_obj-handle-vmalloc-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Paul E. McKenney" <paulmck@kernel.org>
Subject: mm: make mem_dump_obj() handle vmalloc() memory

This commit adds vmalloc() support to mem_dump_obj().  Note that the
vmalloc_dump_obj() function combines the checking and dumping, in contrast
with the split between kmem_valid_obj() and kmem_dump_obj().  The reason
for the difference is that the checking in the vmalloc() case involves
acquiring a global lock, and redundant acquisitions of global locks should
be avoided, even on not-so-fast paths.

Note that this change causes on-stack variables to be reported as
vmalloc() storage from kernel_clone() or similar, depending on the degree
of inlining that your compiler does.  This is likely more helpful than the
earlier "non-paged (local) memory".

Link: https://lkml.kernel.org/r/20210106011750.13709-3-paulmck@kernel.org
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    6 ++++++
 mm/util.c               |   14 ++++++++------
 mm/vmalloc.c            |   12 ++++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

--- a/include/linux/vmalloc.h~mm-make-mem_dump_obj-handle-vmalloc-memory
+++ a/include/linux/vmalloc.h
@@ -246,4 +246,10 @@ pcpu_free_vm_areas(struct vm_struct **vm
 int register_vmap_purge_notifier(struct notifier_block *nb);
 int unregister_vmap_purge_notifier(struct notifier_block *nb);
 
+#ifdef CONFIG_MMU
+bool vmalloc_dump_obj(void *object);
+#else
+static inline bool vmalloc_dump_obj(void *object) { return false; }
+#endif
+
 #endif /* _LINUX_VMALLOC_H */
--- a/mm/util.c~mm-make-mem_dump_obj-handle-vmalloc-memory
+++ a/mm/util.c
@@ -996,18 +996,20 @@ int __weak memcmp_pages(struct page *pag
  */
 void mem_dump_obj(void *object)
 {
+	if (kmem_valid_obj(object)) {
+		kmem_dump_obj(object);
+		return;
+	}
+	if (vmalloc_dump_obj(object))
+		return;
 	if (!virt_addr_valid(object)) {
 		if (object == NULL)
 			pr_cont(" NULL pointer.\n");
 		else if (object == ZERO_SIZE_PTR)
 			pr_cont(" zero-size pointer.\n");
 		else
-			pr_cont(" non-paged (local) memory.\n");
-		return;
-	}
-	if (kmem_valid_obj(object)) {
-		kmem_dump_obj(object);
+			pr_cont(" non-paged memory.\n");
 		return;
 	}
-	pr_cont(" non-slab memory.\n");
+	pr_cont(" non-slab/vmalloc memory.\n");
 }
--- a/mm/vmalloc.c~mm-make-mem_dump_obj-handle-vmalloc-memory
+++ a/mm/vmalloc.c
@@ -3448,6 +3448,18 @@ void pcpu_free_vm_areas(struct vm_struct
 }
 #endif	/* CONFIG_SMP */
 
+bool vmalloc_dump_obj(void *object)
+{
+	struct vm_struct *vm;
+	void *objp = (void *)PAGE_ALIGN((unsigned long)object);
+
+	vm = find_vm_area(objp);
+	if (!vm)
+		return false;
+	pr_cont(" vmalloc allocated at %pS\n", vm->caller);
+	return true;
+}
+
 #ifdef CONFIG_PROC_FS
 static void *s_start(struct seq_file *m, loff_t *pos)
 	__acquires(&vmap_purge_lock)
_

Patches currently in -mm which might be from paulmck@kernel.org are


