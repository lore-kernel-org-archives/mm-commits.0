Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB687C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D8D221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633229;
	bh=Epx5luYbLHPQ2yUalLOq0nTGtTpBlT4vJ1va5yZUPoI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ru+Mjv0et0TDtnmrjdpe7nC7AdkMYxLit4fj+sKQAsgi8mFhdeosDuJeRk8DCQvUN
	 NinlbLJ+K1eFeV1mH8TJjzktQghIIDoynagECup2f41Zum9z/HtdWSS10o1SKv11Qu
	 Y4nHaoM2FsZJOixJJUEs6xWZJIFd24IaM91jGXjI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388073AbgJMXxt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387743AbgJMXxt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E421206D5;
        Tue, 13 Oct 2020 23:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633228;
        bh=Epx5luYbLHPQ2yUalLOq0nTGtTpBlT4vJ1va5yZUPoI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=r95X3/IWwu67UK2kKf4D8tWzISW0WBuaXEPgCRo28eGIZNNY8r4yarESJyshovLG0
         IFdssC64Ay0VSC1vSzbjxUJ494MfLJ/FnyG2xRJSILmISteB5gEVmzzFuDzqjzk30b
         GQ/yIqZYTOAqu9IjoEfumOkzV8KoR7I+8WzHrqK0=
Date:   Tue, 13 Oct 2020 16:53:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        chinwen.chang@mediatek.com, daniel.kiss@arm.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, jgg@ziepe.ca,
        jimmyassarsson@gmail.com, ldufour@linux.ibm.com,
        linux-mm@kvack.org, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        steven.price@arm.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, walken@google.com, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 099/181] mm: proc: smaps_rollup: do not stall
 write attempts on mmap_lock
Message-ID: <20201013235347.GQyJGHB9Z%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
