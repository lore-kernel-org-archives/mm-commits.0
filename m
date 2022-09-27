Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D54C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiI0C4D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiI0CzI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D54262E3
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F4C0B81989
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E39FC433C1;
        Tue, 27 Sep 2022 02:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247003;
        bh=bmhSq+MglTGEdCz823W/ddis4rNWOmV+k/EVIYrDdlk=;
        h=Date:To:From:Subject:From;
        b=meeiMvvoJH3JQl5gst5Ou9WLe6O1+iq+L49W2yJ0DeXqScc7fFqzUzxNwPXbDUhcs
         CtiB8vMpYSvua4MeF7nABe/3NuRBE7kcUQ7SZ+RXpFEtHU7Qe3vV46tVUr0tlQooWr
         F3sQMD1cR7F8SefxeV0NCWaPrO3R+/7XhH/aBjSg=
Date:   Mon, 26 Sep 2022 19:50:02 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-drop-range_has_overlap-function.patch removed from -mm tree
Message-Id: <20220927025003.1E39FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: drop range_has_overlap() function
has been removed from the -mm tree.  Its filename was
     mm-mmap-drop-range_has_overlap-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: drop range_has_overlap() function
Date: Tue, 6 Sep 2022 19:49:06 +0000

Since there is no longer a linked list, the range_has_overlap() function
is identical to the find_vma_intersection() function.

Link: https://lkml.kernel.org/r/20220906194824.2110408-70-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

--- a/mm/mmap.c~mm-mmap-drop-range_has_overlap-function
+++ a/mm/mmap.c
@@ -390,30 +390,6 @@ anon_vma_interval_tree_post_update_vma(s
 		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
 }
 
-/*
- * range_has_overlap() - Check the @start - @end range for overlapping VMAs and
- * sets up a pointer to the previous VMA
- * @mm: the mm struct
- * @start: the start address of the range
- * @end: the end address of the range
- * @pprev: the pointer to the pointer of the previous VMA
- *
- * Returns: True if there is an overlapping VMA, false otherwise
- */
-static inline
-bool range_has_overlap(struct mm_struct *mm, unsigned long start,
-		       unsigned long end, struct vm_area_struct **pprev)
-{
-	struct vm_area_struct *existing;
-
-	MA_STATE(mas, &mm->mm_mt, start, start);
-	rcu_read_lock();
-	existing = mas_find(&mas, end - 1);
-	*pprev = mas_prev(&mas, 0);
-	rcu_read_unlock();
-	return existing ? true : false;
-}
-
 static unsigned long count_vma_pages_range(struct mm_struct *mm,
 		unsigned long addr, unsigned long end)
 {
@@ -3178,11 +3154,10 @@ void exit_mmap(struct mm_struct *mm)
  */
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_area_struct *prev;
 	unsigned long charged = vma_pages(vma);
 
 
-	if (range_has_overlap(mm, vma->vm_start, vma->vm_end, &prev))
+	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
 	if ((vma->vm_flags & VM_ACCOUNT) &&
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


