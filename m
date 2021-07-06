Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B93BC11F68
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8652C61C9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhGFTYV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhGFTYT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD6061C9A;
        Tue,  6 Jul 2021 19:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599300;
        bh=oFUxSy7mMidzG2MXZSCGrEGrTfTIx76dkH6rbpQn60c=;
        h=Date:From:To:Subject:From;
        b=MNafQ7ypvce4Q/bwbRJU2jhy0uyIWB9uOcJTIt+LV/XOS7R1lXazbdsFyjF+RiOKv
         3RNu7IXQ6AV8xtTRlhm5eve5F7f7rcZGZXMSpnAEu7ojkqVq9kksabrWwYPWWxvPru
         dDvh/M/8O97GvO0j5GhEBZljjGDZok0qG/xYjz7M=
Date:   Tue, 06 Jul 2021 12:21:39 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bskeggs@redhat.com, hch@lst.de,
        hughd@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shakeelb@google.com, willy@infradead.org
Subject:  [merged] nouveau-svm-refactor-nouveau_range_fault.patch
 removed from -mm tree
Message-ID: <20210706192139.0zl-8Ve-W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nouveau/svm: refactor nouveau_range_fault
has been removed from the -mm tree.  Its filename was
     nouveau-svm-refactor-nouveau_range_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: nouveau/svm: refactor nouveau_range_fault

Call mmu_interval_notifier_insert() as part of nouveau_range_fault(). 
This doesn't introduce any functional change but makes it easier for a
subsequent patch to alter the behaviour of nouveau_range_fault() to
support GPU atomic operations.

Link: https://lkml.kernel.org/r/20210616105937.23201-10-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_svm.c |   34 ++++++++++++++----------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~nouveau-svm-refactor-nouveau_range_fault
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -567,18 +567,27 @@ static int nouveau_range_fault(struct no
 	unsigned long hmm_pfns[1];
 	struct hmm_range range = {
 		.notifier = &notifier->notifier,
-		.start = notifier->notifier.interval_tree.start,
-		.end = notifier->notifier.interval_tree.last + 1,
 		.default_flags = hmm_flags,
 		.hmm_pfns = hmm_pfns,
 		.dev_private_owner = drm->dev,
 	};
-	struct mm_struct *mm = notifier->notifier.mm;
+	struct mm_struct *mm = svmm->notifier.mm;
 	int ret;
 
+	ret = mmu_interval_notifier_insert(&notifier->notifier, mm,
+					args->p.addr, args->p.size,
+					&nouveau_svm_mni_ops);
+	if (ret)
+		return ret;
+
+	range.start = notifier->notifier.interval_tree.start;
+	range.end = notifier->notifier.interval_tree.last + 1;
+
 	while (true) {
-		if (time_after(jiffies, timeout))
-			return -EBUSY;
+		if (time_after(jiffies, timeout)) {
+			ret = -EBUSY;
+			goto out;
+		}
 
 		range.notifier_seq = mmu_interval_read_begin(range.notifier);
 		mmap_read_lock(mm);
@@ -587,7 +596,7 @@ static int nouveau_range_fault(struct no
 		if (ret) {
 			if (ret == -EBUSY)
 				continue;
-			return ret;
+			goto out;
 		}
 
 		mutex_lock(&svmm->mutex);
@@ -606,6 +615,9 @@ static int nouveau_range_fault(struct no
 	svmm->vmm->vmm.object.client->super = false;
 	mutex_unlock(&svmm->mutex);
 
+out:
+	mmu_interval_notifier_remove(&notifier->notifier);
+
 	return ret;
 }
 
@@ -727,14 +739,8 @@ nouveau_svm_fault(struct nvif_notify *no
 		}
 
 		notifier.svmm = svmm;
-		ret = mmu_interval_notifier_insert(&notifier.notifier, mm,
-						   args.i.p.addr, args.i.p.size,
-						   &nouveau_svm_mni_ops);
-		if (!ret) {
-			ret = nouveau_range_fault(svmm, svm->drm, &args.i,
-				sizeof(args), hmm_flags, &notifier);
-			mmu_interval_notifier_remove(&notifier.notifier);
-		}
+		ret = nouveau_range_fault(svmm, svm->drm, &args.i,
+					sizeof(args), hmm_flags, &notifier);
 		mmput(mm);
 
 		limit = args.i.p.addr + args.i.p.size;
_

Patches currently in -mm which might be from apopple@nvidia.com are


