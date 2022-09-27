Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD061C6FA86
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiI0Cvz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiI0Ctl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0094DB2765
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50DE26157C
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC39EC433D6;
        Tue, 27 Sep 2022 02:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246931;
        bh=Gmi8T5veTw9F/nYuVJw08jjOk/8zAcozgj5Iix0KmRk=;
        h=Date:To:From:Subject:From;
        b=fWiRA079PjwO96a8/GHYOHFD1S4fjQngpf53TIHepFgWl7arFo8o9I6hWeUvsfoC2
         TpC1KWPS7Ufmnso6/TKx3S84hJ2eKT+nN/dCz3BgjmtCLG9AyDSFPd4Zuj3QMCuf+e
         XvLz3WoOZHGi4jUMVruOfRsi0uMSHzqmALfMNTsI=
Date:   Mon, 26 Sep 2022 19:48:51 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] damon-convert-__damon_va_three_regions-to-use-the-vma-iterator.patch removed from -mm tree
Message-Id: <20220927024851.AC39EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: damon: convert __damon_va_three_regions to use the VMA iterator
has been removed from the -mm tree.  Its filename was
     damon-convert-__damon_va_three_regions-to-use-the-vma-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: damon: convert __damon_va_three_regions to use the VMA iterator
Date: Tue, 6 Sep 2022 19:48:48 +0000

This rather specialised walk can use the VMA iterator.  If this proves to
be too slow, we can write a custom routine to find the two largest gaps,
but it will be somewhat complicated, so let's see if we need it first.

Update the kunit test case to use the maple tree.  This also fixes an
issue with the kunit testcase not adding the last VMA to the list.

Link: https://lkml.kernel.org/r/20220906194824.2110408-16-Liam.Howlett@oracle.com
Fixes: 17ccae8bb5c9 (mm/damon: add kunit tests)
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |   36 +++++++++-------------------
 mm/damon/vaddr.c      |   51 ++++++++++++++++++++--------------------
 2 files changed, 38 insertions(+), 49 deletions(-)

--- a/mm/damon/vaddr.c~damon-convert-__damon_va_three_regions-to-use-the-vma-iterator
+++ a/mm/damon/vaddr.c
@@ -113,37 +113,38 @@ static unsigned long sz_range(struct dam
  *
  * Returns 0 if success, or negative error code otherwise.
  */
-static int __damon_va_three_regions(struct vm_area_struct *vma,
+static int __damon_va_three_regions(struct mm_struct *mm,
 				       struct damon_addr_range regions[3])
 {
-	struct damon_addr_range gap = {0}, first_gap = {0}, second_gap = {0};
-	struct vm_area_struct *last_vma = NULL;
-	unsigned long start = 0;
-	struct rb_root rbroot;
-
-	/* Find two biggest gaps so that first_gap > second_gap > others */
-	for (; vma; vma = vma->vm_next) {
-		if (!last_vma) {
-			start = vma->vm_start;
-			goto next;
-		}
+	struct damon_addr_range first_gap = {0}, second_gap = {0};
+	VMA_ITERATOR(vmi, mm, 0);
+	struct vm_area_struct *vma, *prev = NULL;
+	unsigned long start;
+
+	/*
+	 * Find the two biggest gaps so that first_gap > second_gap > others.
+	 * If this is too slow, it can be optimised to examine the maple
+	 * tree gaps.
+	 */
+	for_each_vma(vmi, vma) {
+		unsigned long gap;
 
-		if (vma->rb_subtree_gap <= sz_range(&second_gap)) {
-			rbroot.rb_node = &vma->vm_rb;
-			vma = rb_entry(rb_last(&rbroot),
-					struct vm_area_struct, vm_rb);
+		if (!prev) {
+			start = vma->vm_start;
 			goto next;
 		}
+		gap = vma->vm_start - prev->vm_end;
 
-		gap.start = last_vma->vm_end;
-		gap.end = vma->vm_start;
-		if (sz_range(&gap) > sz_range(&second_gap)) {
-			swap(gap, second_gap);
-			if (sz_range(&second_gap) > sz_range(&first_gap))
-				swap(second_gap, first_gap);
+		if (gap > sz_range(&first_gap)) {
+			second_gap = first_gap;
+			first_gap.start = prev->vm_end;
+			first_gap.end = vma->vm_start;
+		} else if (gap > sz_range(&second_gap)) {
+			second_gap.start = prev->vm_end;
+			second_gap.end = vma->vm_start;
 		}
 next:
-		last_vma = vma;
+		prev = vma;
 	}
 
 	if (!sz_range(&second_gap) || !sz_range(&first_gap))
@@ -159,7 +160,7 @@ next:
 	regions[1].start = ALIGN(first_gap.end, DAMON_MIN_REGION);
 	regions[1].end = ALIGN(second_gap.start, DAMON_MIN_REGION);
 	regions[2].start = ALIGN(second_gap.end, DAMON_MIN_REGION);
-	regions[2].end = ALIGN(last_vma->vm_end, DAMON_MIN_REGION);
+	regions[2].end = ALIGN(prev->vm_end, DAMON_MIN_REGION);
 
 	return 0;
 }
@@ -180,7 +181,7 @@ static int damon_va_three_regions(struct
 		return -EINVAL;
 
 	mmap_read_lock(mm);
-	rc = __damon_va_three_regions(mm->mmap, regions);
+	rc = __damon_va_three_regions(mm, regions);
 	mmap_read_unlock(mm);
 
 	mmput(mm);
--- a/mm/damon/vaddr-test.h~damon-convert-__damon_va_three_regions-to-use-the-vma-iterator
+++ a/mm/damon/vaddr-test.h
@@ -14,33 +14,19 @@
 
 #include <kunit/test.h>
 
-static void __link_vmas(struct vm_area_struct *vmas, ssize_t nr_vmas)
+static void __link_vmas(struct maple_tree *mt, struct vm_area_struct *vmas,
+			ssize_t nr_vmas)
 {
-	int i, j;
-	unsigned long largest_gap, gap;
+	int i;
+	MA_STATE(mas, mt, 0, 0);
 
 	if (!nr_vmas)
 		return;
 
-	for (i = 0; i < nr_vmas - 1; i++) {
-		vmas[i].vm_next = &vmas[i + 1];
-
-		vmas[i].vm_rb.rb_left = NULL;
-		vmas[i].vm_rb.rb_right = &vmas[i + 1].vm_rb;
-
-		largest_gap = 0;
-		for (j = i; j < nr_vmas; j++) {
-			if (j == 0)
-				continue;
-			gap = vmas[j].vm_start - vmas[j - 1].vm_end;
-			if (gap > largest_gap)
-				largest_gap = gap;
-		}
-		vmas[i].rb_subtree_gap = largest_gap;
-	}
-	vmas[i].vm_next = NULL;
-	vmas[i].vm_rb.rb_right = NULL;
-	vmas[i].rb_subtree_gap = 0;
+	mas_lock(&mas);
+	for (i = 0; i < nr_vmas; i++)
+		vma_mas_store(&vmas[i], &mas);
+	mas_unlock(&mas);
 }
 
 /*
@@ -72,6 +58,7 @@ static void __link_vmas(struct vm_area_s
  */
 static void damon_test_three_regions_in_vmas(struct kunit *test)
 {
+	static struct mm_struct mm;
 	struct damon_addr_range regions[3] = {0,};
 	/* 10-20-25, 200-210-220, 300-305, 307-330 */
 	struct vm_area_struct vmas[] = {
@@ -83,9 +70,10 @@ static void damon_test_three_regions_in_
 		(struct vm_area_struct) {.vm_start = 307, .vm_end = 330},
 	};
 
-	__link_vmas(vmas, 6);
+	mt_init_flags(&mm.mm_mt, MM_MT_FLAGS);
+	__link_vmas(&mm.mm_mt, vmas, ARRAY_SIZE(vmas));
 
-	__damon_va_three_regions(&vmas[0], regions);
+	__damon_va_three_regions(&mm, regions);
 
 	KUNIT_EXPECT_EQ(test, 10ul, regions[0].start);
 	KUNIT_EXPECT_EQ(test, 25ul, regions[0].end);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


