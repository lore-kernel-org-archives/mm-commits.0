Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066B039A061
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439136; cv=none; b=YXe9aPZszNZTAENVzlfP2w/gsmOStMCFDoeSsRnk7ue6/neAfAfbxnJl3Qd8lZLISJ+CeGWzWavdOGHlXANH/1DAvwCxuHlsxFm34eDjZXg3CtB89rHWWXVoAMQMSaqMxR9pdtOXs/5piZLhzUl/+8ga9Q2zXPjUQ4c/u7/Xl/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439136; c=relaxed/simple;
	bh=USPyX1xEPosPPLqfQ1FaWtQ2myUpH0h3irEtBpR20PM=;
	h=Date:To:From:Subject:Message-Id; b=FFEAjavGHdYDPwZGF+zarSPDYaTQXQ3V85P6UMqBTtXtoCE8NFK2iXq9HsSDeTjiq+SPjV508CX3mlYL2uSf9ohM8YCbmOATNDySFN1IrFFz36w67h2RJoDUnlZ7UbienRMC3YfKbcWmO1AdB+YyEFfXzifd8buH7KBuksVe44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fdj7kAbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fdj7kAbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3011F00893;
	Tue,  2 Jun 2026 22:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439134;
	bh=7pU6qeyijNTomse2KWhHNtrEe/3cljhc6tJTzijpF6I=;
	h=Date:To:From:Subject;
	b=Fdj7kAbfsDbgPyhirchUnpMYewDoRxcPJXeTJrRps2IbpFfD0xfYtIhcgHfmIiDKo
	 dfIWbKd3I0yjQUGVylM4Y3tj4GfFj66e779i1g+eWxzdEWbX9wnXHoB8KkTf5GHAb7
	 ArXZ/NtwEnKyGXBxG+5wEHTkXYd/O9Rv3OpGGfuc=
Date: Tue, 02 Jun 2026 15:25:34 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch removed from -mm tree
Message-Id: <20260602222534.CF3011F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: check alloc_page_vma() return value and handle OOM
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qiang Liu <liuqiang@kylinos.cn>
Subject: lib/test_hmm: check alloc_page_vma() return value and handle OOM
Date: Thu, 21 May 2026 10:18:58 +0800

Check alloc_page_vma() return status for page allocation failures, free
allocated pages and return VM_FAULT_OOM on error.

Handle return codes of dmirror_devmem_fault_alloc_and_copy(), call
migrate_vma_finalize() to remove migration entries from
migrate_vma_setup().

Link: https://lore.kernel.org/20260521021858.21511-1-liuqiangneo@163.com
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom
+++ a/lib/test_hmm.c
@@ -1063,6 +1063,25 @@ static vm_fault_t dmirror_devmem_fault_a
 			/* Try with smaller pages if large allocation fails */
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+				if (!dpage) {
+					/* Unlock and free pages already allocated. */
+					while (i > 0) {
+						struct page *fpage;
+
+						fpage = migrate_pfn_to_page(dst[--i]);
+						unlock_page(fpage);
+						__free_page(fpage);
+					}
+					/* Clear remaining dst entries to avoid
+					 * migrate_vma_pages/finalize() using
+					 * uninitialized values.
+					 */
+					while (i < (1 << order)) {
+						dst[i] = 0;
+						i++;
+					}
+					return VM_FAULT_OOM;
+				}
 				lock_page(dpage);
 				dst[i] = migrate_pfn(page_to_pfn(dpage));
 				dst_page = pfn_to_page(page_to_pfn(dpage));
@@ -1148,7 +1167,11 @@ static int dmirror_migrate_to_system(str
 			goto out;
 
 		pr_debug("Migrating from device mem to sys mem\n");
-		dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
+		ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
+		if (ret) {
+			migrate_vma_finalize(&args);
+			goto out;
+		}
 
 		migrate_vma_pages(&args);
 		cmd->cpages += dmirror_successful_migrated_pages(&args);
@@ -1689,8 +1712,10 @@ static vm_fault_t dmirror_devmem_fault(s
 	}
 
 	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
-	if (ret)
+	if (ret) {
+		migrate_vma_finalize(&args);
 		goto err;
+	}
 	migrate_vma_pages(&args);
 	/*
 	 * No device finalize step is needed since
_

Patches currently in -mm which might be from liuqiang@kylinos.cn are


