Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A80C48BE0
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B9BE613C8
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhFJWSb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230453AbhFJWS0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 18:18:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B68A76141D;
        Thu, 10 Jun 2021 22:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363384;
        bh=FKk6nkwff5SRHrnaM62wKl00o9exKIR/4gu+6whAGPw=;
        h=Date:From:To:Subject:From;
        b=auKapPRE/nyNXlqbfcY/MeZq8NPGtKroEnWOxV00ZvTQfRchGm7Wh/gQ7cqNYUDIe
         Jyn0XXb72UX1z2k1CLUqDaCq2sG0K5LEc9ujYlCuZjjnFcWCQiYPg6uRXee4GTqxi5
         HP4dPK/lFKDtsVDjsP4FA99yL4tm02B3Mq3EbA14=
Date:   Thu, 10 Jun 2021 15:16:23 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, bsingharora@gmail.com, bskeggs@redhat.com,
        hch@lst.de, hughd@google.com, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, willy@infradead.org
Subject:  [to-be-updated]
 nouveau-svm-refactor-nouveau_range_fault.patch removed from -mm tree
Message-ID: <20210610221623.DjZMR7fpu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nouveau/svm: refactor nouveau_range_fault
has been removed from the -mm tree.  Its filename was
     nouveau-svm-refactor-nouveau_range_fault.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: nouveau/svm: refactor nouveau_range_fault

Call mmu_interval_notifier_insert() as part of nouveau_range_fault(). 
This doesn't introduce any functional change but makes it easier for a
subsequent patch to alter the behaviour of nouveau_range_fault() to
support GPU atomic operations.

Link: https://lkml.kernel.org/r/20210524132725.12697-10-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
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

nouveau-svm-implement-atomic-svm-access.patch

