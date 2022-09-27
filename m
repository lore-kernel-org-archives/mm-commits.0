Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26467C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiI0Cvo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiI0Ctk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27BFAE850
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A24C8B81906
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59114C433D6;
        Tue, 27 Sep 2022 02:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246926;
        bh=9XE5BdJFfpi+J0bgLj63jK5aDBJU79n5BWN5yq3/AJs=;
        h=Date:To:From:Subject:From;
        b=zOlIXhInWpsbWTG51ZXqLov66zmup/hrxv6NaakVO4YHJVTQzgQV8N9shAJwHHEo2
         23Co3LuSHbvD1hi27KChPzsiOms8Pmo+nyPcLwH9fyH/+GoKlhdSERyGBz0uEz+1A0
         wTpI5CGqwtMaDWI7X76FN5vIu8ZdkefBfvnx4r6c=
Date:   Mon, 26 Sep 2022 19:48:45 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-use-the-maple-tree-in-find_vma-instead-of-the-rbtree.patch removed from -mm tree
Message-Id: <20220927024846.59114C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: use the maple tree in find_vma() instead of the rbtree.
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-the-maple-tree-in-find_vma-instead-of-the-rbtree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: use the maple tree in find_vma() instead of the rbtree.
Date: Tue, 6 Sep 2022 19:48:46 +0000

Using the maple tree interface mt_find() will handle the RCU locking and
will start searching at the address up to the limit, ULONG_MAX in this
case.

Add kernel documentation to this API.

Link: https://lkml.kernel.org/r/20220906194824.2110408-12-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-the-maple-tree-in-find_vma-instead-of-the-rbtree
+++ a/mm/mmap.c
@@ -2449,11 +2449,18 @@ get_unmapped_area(struct file *file, uns
 
 EXPORT_SYMBOL(get_unmapped_area);
 
-/* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
+/**
+ * find_vma() - Find the VMA for a given address, or the next VMA.
+ * @mm: The mm_struct to check
+ * @addr: The address
+ *
+ * Returns: The VMA associated with addr, or the next VMA.
+ * May return %NULL in the case of no VMA at addr or above.
+ */
 struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
-	struct rb_node *rb_node;
 	struct vm_area_struct *vma;
+	unsigned long index = addr;
 
 	mmap_assert_locked(mm);
 	/* Check the cache first. */
@@ -2461,22 +2468,7 @@ struct vm_area_struct *find_vma(struct m
 	if (likely(vma))
 		return vma;
 
-	rb_node = mm->mm_rb.rb_node;
-
-	while (rb_node) {
-		struct vm_area_struct *tmp;
-
-		tmp = rb_entry(rb_node, struct vm_area_struct, vm_rb);
-
-		if (tmp->vm_end > addr) {
-			vma = tmp;
-			if (tmp->vm_start <= addr)
-				break;
-			rb_node = rb_node->rb_left;
-		} else
-			rb_node = rb_node->rb_right;
-	}
-
+	vma = mt_find(&mm->mm_mt, &index, ULONG_MAX);
 	if (vma)
 		vmacache_update(addr, vma);
 	return vma;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


