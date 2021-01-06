Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25827C433E0
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 21:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDA4C2333C
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 21:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbhAFVtw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 16:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726624AbhAFVtv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 16:49:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F49A23159;
        Wed,  6 Jan 2021 21:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609969750;
        bh=GvFrc7fm5Rw8qQBqDXwl4ADggq+P/MsZSuVQjZRqOJU=;
        h=Date:From:To:Subject:From;
        b=f8cuVKGOhPG98cGH+S/U8k93TODOHYWOBHWvlrh54hrcA90oUWhMSvOo0N2p1KC2Q
         5MZVqFTIMCj0gU+XPNFjRb7HdZmB5Qh7pDXpNC0WUQqSZYoATOdTWfavLjXOp2z5XG
         tsCHZAF8cngP/m9U+s/3xvXANVtDQY5/LtXQYlwY=
Date:   Wed, 06 Jan 2021 13:49:09 -0800
From:   akpm@linux-foundation.org
To:     andrii@kernel.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  + mm-make-mem_dump_obj-handle-vmalloc-memory.patch added
 to -mm tree
Message-ID: <20210106214909.6Agk2o4jZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mem_dump_obj() handle vmalloc() memory
has been added to the -mm tree.  Its filename is
     mm-make-mem_dump_obj-handle-vmalloc-memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-mem_dump_obj-handle-vmalloc-memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-mem_dump_obj-handle-vmalloc-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-add-mem_dump_obj-to-print-source-of-memory-block.patch
mm-make-mem_dump_obj-handle-null-and-zero-sized-pointers.patch
mm-make-mem_dump_obj-handle-vmalloc-memory.patch
mm-make-mem_obj_dump-vmalloc-dumps-include-start-and-length.patch
rcu-make-call_rcu-print-mem_dump_obj-info-for-double-freed-callback.patch
percpu_ref-dump-mem_dump_obj-info-upon-reference-count-underflow.patch

