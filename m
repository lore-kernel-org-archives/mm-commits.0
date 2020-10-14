Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA825C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DCF022248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709270;
	bh=mV/d47a6DgDYIhLMeEItXKPWTVf3vtnBZklyCymf/30=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EsXh3uci6uv5kwwpdjEOETjI7JqVR9MWWnb4+4p3dJ4iuNIHCu1zc8KtgNmf4Gr1m
	 gwF0N8180sSuJdQ65QUZbegE23Z081AeaiJ5abbUvUrnlb0lVTf/Xkt+Qd5e3rfcgq
	 DxtmjT+vVBLboBMViozZcd63qZWhfs+7R3Rqaojc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgJNVBH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729906AbgJNVBG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDA1C221FF;
        Wed, 14 Oct 2020 21:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709263;
        bh=mV/d47a6DgDYIhLMeEItXKPWTVf3vtnBZklyCymf/30=;
        h=Date:From:To:Subject:From;
        b=FmJeD0KzybSvuUiBb0JvLYK+Gd7AoXaCOyZvACZfco9QeGHCBbyWec9OBB521i8SB
         5GDN+lzUDzznh37wuzQeK5r9rqfF4f94LoUHdax3DqhG3J/wxNUybQTFLikDl2Gduz
         dQ/5cFIepvumLmoTNjOVnIvJjDMJYt6TRM7Ce/Aw=
Date:   Wed, 14 Oct 2020 14:01:02 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chinwen.chang@mediatek.com,
        daniel.kiss@arm.com, daniel.m.jordan@oracle.com, dbueso@suse.de,
        jgg@ziepe.ca, jimmyassarsson@gmail.com, ldufour@linux.ibm.com,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        songliubraving@fb.com, steven.price@arm.com, vbabka@suse.cz,
        walken@google.com, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-smaps-extend-smap_gather_stats-to-support-specified-beginning.patch
 removed from -mm tree
Message-ID: <20201014210102.wbI8pi4bs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: smaps*: extend smap_gather_stats to support specified beginning
has been removed from the -mm tree.  Its filename was
     mm-smaps-extend-smap_gather_stats-to-support-specified-beginning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chinwen Chang <chinwen.chang@mediatek.com>
Subject: mm: smaps*: extend smap_gather_stats to support specified beginning

Extend smap_gather_stats to support indicated beginning address at which
it should start gathering.  To achieve the goal, we add a new parameter
@start assigned by the caller and try to refactor it for simplicity.

If @start is 0, it will use the range of @vma for gathering.

Link: http://lkml.kernel.org/r/1597715898-3854-3-git-send-email-chinwen.chang@mediatek.com
Signed-off-by: Chinwen Chang <chinwen.chang@mediatek.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Daniel Kiss <daniel.kiss@arm.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jimmy Assarsson <jimmyassarsson@gmail.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/fs/proc/task_mmu.c~mm-smaps-extend-smap_gather_stats-to-support-specified-beginning
+++ a/fs/proc/task_mmu.c
@@ -721,9 +721,21 @@ static const struct mm_walk_ops smaps_sh
 	.pte_hole		= smaps_pte_hole,
 };
 
+/*
+ * Gather mem stats from @vma with the indicated beginning
+ * address @start, and keep them in @mss.
+ *
+ * Use vm_start of @vma as the beginning address if @start is 0.
+ */
 static void smap_gather_stats(struct vm_area_struct *vma,
-			     struct mem_size_stats *mss)
+		struct mem_size_stats *mss, unsigned long start)
 {
+	const struct mm_walk_ops *ops = &smaps_walk_ops;
+
+	/* Invalid start */
+	if (start >= vma->vm_end)
+		return;
+
 #ifdef CONFIG_SHMEM
 	/* In case of smaps_rollup, reset the value from previous vma */
 	mss->check_shmem_swap = false;
@@ -740,18 +752,20 @@ static void smap_gather_stats(struct vm_
 		 */
 		unsigned long shmem_swapped = shmem_swap_usage(vma);
 
-		if (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
-					!(vma->vm_flags & VM_WRITE)) {
+		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
+					!(vma->vm_flags & VM_WRITE))) {
 			mss->swap += shmem_swapped;
 		} else {
 			mss->check_shmem_swap = true;
-			walk_page_vma(vma, &smaps_shmem_walk_ops, mss);
-			return;
+			ops = &smaps_shmem_walk_ops;
 		}
 	}
 #endif
 	/* mmap_lock is held in m_start */
-	walk_page_vma(vma, &smaps_walk_ops, mss);
+	if (!start)
+		walk_page_vma(vma, ops, mss);
+	else
+		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
 }
 
 #define SEQ_PUT_DEC(str, val) \
@@ -803,7 +817,7 @@ static int show_smap(struct seq_file *m,
 
 	memset(&mss, 0, sizeof(mss));
 
-	smap_gather_stats(vma, &mss);
+	smap_gather_stats(vma, &mss, 0);
 
 	show_map_vma(m, vma);
 
@@ -852,7 +866,7 @@ static int show_smaps_rollup(struct seq_
 	hold_task_mempolicy(priv);
 
 	for (vma = priv->mm->mmap; vma; vma = vma->vm_next) {
-		smap_gather_stats(vma, &mss);
+		smap_gather_stats(vma, &mss, 0);
 		last_vma_end = vma->vm_end;
 	}
 
_

Patches currently in -mm which might be from chinwen.chang@mediatek.com are


