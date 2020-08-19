Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6FEC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C87A6204EC
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597802131;
	bh=LL9lrEhhVZjQJQJgZwLpE3Ly8SxHF118GHrpIcOiCJ8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hYVjnaBXQemfV4Nz7a/rBGCq43OeE+91/Ya58RiJddJo73p6GrBhU6gtRiT3kGkFz
	 tIMcjAlvi5cy1BhipUpAiMSHffoG86DVPGb5I/7I3V85TMFo+XFJlBnGAMAbEp6Gq6
	 u7D/c/vHkdBL00oNLaVhtevcWxpbKa7rT+CfCI84=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgHSBza (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgHSBza (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 21:55:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DF29205CB;
        Wed, 19 Aug 2020 01:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597802129;
        bh=LL9lrEhhVZjQJQJgZwLpE3Ly8SxHF118GHrpIcOiCJ8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cMKgXK0OrcWFu6NuRjj7pyvE6wr0ynEp07XSGt0ntaidUvq2T3R/QPTYsR17w33am
         relU04yUDAtyZDdov++Zc1sOWdp07gXO6zoJ9MqjJ6t3Nr28+qtDlL46g/oRxG4OwN
         pclIWbrSs2nomtvyIYmcOKlGCcl+QnAOc6pWcbhw=
Date:   Tue, 18 Aug 2020 18:55:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, chinwen.chang@mediatek.com,
        daniel.kiss@arm.com, daniel.m.jordan@oracle.com, dbueso@suse.de,
        jgg@ziepe.ca, jimmyassarsson@gmail.com, ldufour@linux.ibm.com,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        songliubraving@fb.com, steven.price@arm.com, vbabka@suse.cz,
        walken@google.com, willy@infradead.org, ying.huang@intel.com
Subject:  +
 mm-proc-smaps_rollup-do-not-stall-write-attempts-on-mmap_lock.patch added
 to -mm tree
Message-ID: <20200819015528.LR0vGABge%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: proc: smaps_rollup: do not stall write attempts on mmap_lock
has been added to the -mm tree.  Its filename is
     mm-proc-smaps_rollup-do-not-stall-write-attempts-on-mmap_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proc-smaps_rollup-do-not-stall-write-attempts-on-mmap_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-smaps_rollup-do-not-stall-write-attempts-on-mmap_lock.patch

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
@@ -867,9 +867,73 @@ static int show_smaps_rollup(struct seq_
 
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

mmap-locking-api-add-mmap_lock_is_contended.patch
mm-smaps-extend-smap_gather_stats-to-support-specified-beginning.patch
mm-proc-smaps_rollup-do-not-stall-write-attempts-on-mmap_lock.patch

