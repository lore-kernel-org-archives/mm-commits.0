Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496D8C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiI0Cvn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiI0Ctk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F279CAFAE8
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5082661580
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90DAC433D7;
        Tue, 27 Sep 2022 02:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246927;
        bh=FsHmVLRm+oWwo7rNJiRtOKqx+QTksTk3s4fic7BjsaM=;
        h=Date:To:From:Subject:From;
        b=tqAYq235d507DpC46V2nWhj46dP8HCogcWXz0t5ZE4l70ak4wqT0EVWUoc4bb4DtL
         bDegQHjYdEYyTXnPlJbJn1fzpa7ZCNj+pkdBo5mXNnqhOK36HppT0uc6DT+DEGSNAg
         x6OqRbdSHnuNbGEC2PjLUd5P0mLUjNZS+0oNzhDk=
Date:   Mon, 26 Sep 2022 19:48:47 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-use-the-maple-tree-for-find_vma_prev-instead-of-the-rbtree.patch removed from -mm tree
Message-Id: <20220927024847.A90DAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: use the maple tree for find_vma_prev() instead of the rbtree
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-the-maple-tree-for-find_vma_prev-instead-of-the-rbtree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: use the maple tree for find_vma_prev() instead of the rbtree
Date: Tue, 6 Sep 2022 19:48:47 +0000

Use the maple tree's advanced API and a maple state to walk the tree for
the entry at the address of the next vma, then use the maple state to walk
back one entry to find the previous entry.

Add kernel documentation comments for this API.

Link: https://lkml.kernel.org/r/20220906194824.2110408-13-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-the-maple-tree-for-find_vma_prev-instead-of-the-rbtree
+++ a/mm/mmap.c
@@ -2475,23 +2475,30 @@ struct vm_area_struct *find_vma(struct m
 }
 EXPORT_SYMBOL(find_vma);
 
-/*
- * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
+/**
+ * find_vma_prev() - Find the VMA for a given address, or the next vma and
+ * set %pprev to the previous VMA, if any.
+ * @mm: The mm_struct to check
+ * @addr: The address
+ * @pprev: The pointer to set to the previous VMA
+ *
+ * Note that RCU lock is missing here since the external mmap_lock() is used
+ * instead.
+ *
+ * Returns: The VMA associated with @addr, or the next vma.
+ * May return %NULL in the case of no vma at addr or above.
  */
 struct vm_area_struct *
 find_vma_prev(struct mm_struct *mm, unsigned long addr,
 			struct vm_area_struct **pprev)
 {
 	struct vm_area_struct *vma;
+	MA_STATE(mas, &mm->mm_mt, addr, addr);
 
-	vma = find_vma(mm, addr);
-	if (vma) {
-		*pprev = vma->vm_prev;
-	} else {
-		struct rb_node *rb_node = rb_last(&mm->mm_rb);
-
-		*pprev = rb_node ? rb_entry(rb_node, struct vm_area_struct, vm_rb) : NULL;
-	}
+	vma = mas_walk(&mas);
+	*pprev = mas_prev(&mas, 0);
+	if (!vma)
+		vma = mas_next(&mas, ULONG_MAX);
 	return vma;
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


