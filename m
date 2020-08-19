Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAD3C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ED9A205CB
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597802128;
	bh=OQc2qwvxBkUHs2JCDzTBUVxT0JR8zeWBYbv0hsIqYWk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KNP3+paAcfGA7K7RrOc+/uL/lalsFsqhaJsxyiVpHnb3ET5PEocfzY8dqsB+zXcSO
	 7sSv7xlnOKEpsL0YMNiJVz/SD/CIWjYKs2IYRaqQCakF5c7/89iz6p0hTeY9eWichV
	 4/OjI3H2MqA86PzFY/SKv8I9Vtbkat1Pu/0BQQpo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHSBz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgHSBz1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 21:55:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B095204EC;
        Wed, 19 Aug 2020 01:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597802126;
        bh=OQc2qwvxBkUHs2JCDzTBUVxT0JR8zeWBYbv0hsIqYWk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yYqUb1GUn6Jkz5iT/utDsxfZccgUrxhxM1p0Eu8qOsa2Ivybdcdlo3I9WVcD2doDs
         +qU6JKOsiSIghy+nqxTXmD4ap9HnhXh0gndcONrxdQ5z+wNkRsj+amsL1O37iMBfhI
         20Fh4sYkzJvCkx/IGWamvDsrTmg9PT507YzA3nlQ=
Date:   Tue, 18 Aug 2020 18:55:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, chinwen.chang@mediatek.com,
        daniel.kiss@arm.com, daniel.m.jordan@oracle.com, dbueso@suse.de,
        jgg@ziepe.ca, jimmyassarsson@gmail.com, ldufour@linux.ibm.com,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        songliubraving@fb.com, steven.price@arm.com, vbabka@suse.cz,
        walken@google.com, willy@infradead.org, ying.huang@intel.com
Subject:  +
 mm-smaps-extend-smap_gather_stats-to-support-specified-beginning.patch
 added to -mm tree
Message-ID: <20200819015525.99itAHyEK%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: smaps*: extend smap_gather_stats to support specified beginning
has been added to the -mm tree.  Its filename is
     mm-smaps-extend-smap_gather_stats-to-support-specified-beginning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-smaps-extend-smap_gather_stats-to-support-specified-beginning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-smaps-extend-smap_gather_stats-to-support-specified-beginning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -723,9 +723,21 @@ static const struct mm_walk_ops smaps_sh
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
@@ -742,18 +754,20 @@ static void smap_gather_stats(struct vm_
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
@@ -805,7 +819,7 @@ static int show_smap(struct seq_file *m,
 
 	memset(&mss, 0, sizeof(mss));
 
-	smap_gather_stats(vma, &mss);
+	smap_gather_stats(vma, &mss, 0);
 
 	show_map_vma(m, vma);
 
@@ -854,7 +868,7 @@ static int show_smaps_rollup(struct seq_
 	hold_task_mempolicy(priv);
 
 	for (vma = priv->mm->mmap; vma; vma = vma->vm_next) {
-		smap_gather_stats(vma, &mss);
+		smap_gather_stats(vma, &mss, 0);
 		last_vma_end = vma->vm_end;
 	}
 
_

Patches currently in -mm which might be from chinwen.chang@mediatek.com are

mmap-locking-api-add-mmap_lock_is_contended.patch
mm-smaps-extend-smap_gather_stats-to-support-specified-beginning.patch
mm-proc-smaps_rollup-do-not-stall-write-attempts-on-mmap_lock.patch

