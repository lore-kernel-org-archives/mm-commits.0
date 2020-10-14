Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F44C43467
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF83A221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709274;
	bh=E2ZMr6cw/z9jDbcfRqrMU0VywELwMA+QPgg3Chl04vo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SpBgIy7NqS3g/u0eAU9Rx5aGXyvj2njyxyLiKx/qbb9z8rsojU4pWtv6lfZTbqSly
	 4906g+1fE3p6BDA5jFNDA0YM4Vp8oLd3dpzY4CmGlRho002WXekzaw3viuv1xDMKBP
	 w/4AY/8v6L9CV0RrThWrXCHYgleWaT9zsrDcHCTg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgJNVBK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729952AbgJNVBK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 953E722248;
        Wed, 14 Oct 2020 21:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709266;
        bh=E2ZMr6cw/z9jDbcfRqrMU0VywELwMA+QPgg3Chl04vo=;
        h=Date:From:To:Subject:From;
        b=j/yXPHVZtXYHGONSG6/CNgD2OZ+NcAMl0ZDIvak7LGUvQ6V81WdxuVIQrxj+UTS6J
         WkrBJ2IlsA/45/pyS99fzyFXe4mJLtEitB7xABfXbKHT76vpE/EdGDap8+W7j3hej1
         SnpJHnBEuRzeG2w8snmQEsZALj2smA9rLrFxUhK0=
Date:   Wed, 14 Oct 2020 14:01:05 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chinwen.chang@mediatek.com,
        daniel.kiss@arm.com, daniel.m.jordan@oracle.com, dbueso@suse.de,
        jgg@ziepe.ca, jimmyassarsson@gmail.com, ldufour@linux.ibm.com,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        songliubraving@fb.com, steven.price@arm.com, vbabka@suse.cz,
        walken@google.com, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-proc-smaps_rollup-do-not-stall-write-attempts-on-mmap_lock.patch removed
 from -mm tree
Message-ID: <20201014210105.jPv5iv5ZL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: proc: smaps_rollup: do not stall write attempts on mmap_lock
has been removed from the -mm tree.  Its filename was
     mm-proc-smaps_rollup-do-not-stall-write-attempts-on-mmap_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chinwen Chang <chinwen.chang@mediatek.com>
Subject: mm: proc: smaps_rollup: do not stall write attempts on mmap_lock

smaps_rollup will try to grab mmap_lock and go through the whole vma list
until it finishes the iterating.  When encountering large processes, the
mmap_lock will be held for a longer time, which may block other write
requests like mmap and munmap from progressing smoothly.

There are upcoming mmap_lock optimizations like range-based locks, but the
lock applied to smaps_rollup would be the coarse type, which doesn't avoid
the occurrence of unpleasant contention.

To solve aforementioned issue, we add a check which detects whether anyone
wants to grab mmap_lock for write attempts.

Link: http://lkml.kernel.org/r/1597715898-3854-4-git-send-email-chinwen.chang@mediatek.com
Signed-off-by: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Song Liu <songliubraving@fb.com>
Cc: Jimmy Assarsson <jimmyassarsson@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Daniel Kiss <daniel.kiss@arm.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   66 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~mm-proc-smaps_rollup-do-not-stall-write-attempts-on-mmap_lock
+++ a/fs/proc/task_mmu.c
@@ -865,9 +865,73 @@ static int show_smaps_rollup(struct seq_
 
 	hold_task_mempolicy(priv);
 
-	for (vma = priv->mm->mmap; vma; vma = vma->vm_next) {
+	for (vma = priv->mm->mmap; vma;) {
 		smap_gather_stats(vma, &mss, 0);
 		last_vma_end = vma->vm_end;
+
+		/*
+		 * Release mmap_lock temporarily if someone wants to
+		 * access it for write request.
+		 */
+		if (mmap_lock_is_contended(mm)) {
+			mmap_read_unlock(mm);
+			ret = mmap_read_lock_killable(mm);
+			if (ret) {
+				release_task_mempolicy(priv);
+				goto out_put_mm;
+			}
+
+			/*
+			 * After dropping the lock, there are four cases to
+			 * consider. See the following example for explanation.
+			 *
+			 *   +------+------+-----------+
+			 *   | VMA1 | VMA2 | VMA3      |
+			 *   +------+------+-----------+
+			 *   |      |      |           |
+			 *  4k     8k     16k         400k
+			 *
+			 * Suppose we drop the lock after reading VMA2 due to
+			 * contention, then we get:
+			 *
+			 *	last_vma_end = 16k
+			 *
+			 * 1) VMA2 is freed, but VMA3 exists:
+			 *
+			 *    find_vma(mm, 16k - 1) will return VMA3.
+			 *    In this case, just continue from VMA3.
+			 *
+			 * 2) VMA2 still exists:
+			 *
+			 *    find_vma(mm, 16k - 1) will return VMA2.
+			 *    Iterate the loop like the original one.
+			 *
+			 * 3) No more VMAs can be found:
+			 *
+			 *    find_vma(mm, 16k - 1) will return NULL.
+			 *    No more things to do, just break.
+			 *
+			 * 4) (last_vma_end - 1) is the middle of a vma (VMA'):
+			 *
+			 *    find_vma(mm, 16k - 1) will return VMA' whose range
+			 *    contains last_vma_end.
+			 *    Iterate VMA' from last_vma_end.
+			 */
+			vma = find_vma(mm, last_vma_end - 1);
+			/* Case 3 above */
+			if (!vma)
+				break;
+
+			/* Case 1 above */
+			if (vma->vm_start >= last_vma_end)
+				continue;
+
+			/* Case 4 above */
+			if (vma->vm_end > last_vma_end)
+				smap_gather_stats(vma, &mss, last_vma_end);
+		}
+		/* Case 2 above */
+		vma = vma->vm_next;
 	}
 
 	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
_

Patches currently in -mm which might be from chinwen.chang@mediatek.com are


