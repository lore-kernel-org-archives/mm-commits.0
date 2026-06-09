Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBF43002D8
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968178; cv=none; b=MABDMNmCD7EUE0C0N2lErl2LUu9Whd0lMkUziunNS1lksTWz1d/lOYt3eqwyq/B+z6Ons2KOtV7sdozF09vIhVez+5ef7z2wgU00/5+6paJA1CfNJL+lKdX17xHLkc1os9XVvqcATSBC9qa3BOfIN/WrwvfKIilph4bJR65pek4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968178; c=relaxed/simple;
	bh=j2Io0sfRKn9D9LLluuV3ZzqD0KazUd4W8SUQG4qOcng=;
	h=Date:To:From:Subject:Message-Id; b=t+F+vXBHbnrmsT/uHx/6G57aNmJBlIC2RnZBudlq8mYugd6iia9JlC9WxWBwMJ1D99NwI0YVcBrnoyEN3jMGtcILWINSemrsusuld6MIvw7R+L9ApthsfOWR5dNJh0TNdPbzlXOsB1Eu9676kBSuwjUG4isYgDFbPuQEXcI+hH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZOe1jytK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZOe1jytK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8851F00898;
	Tue,  9 Jun 2026 01:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968176;
	bh=DMPJExpVKtqa6jJ/WZXlU6/nXwwx2gPEMh8hKrQegRA=;
	h=Date:To:From:Subject;
	b=ZOe1jytK1zN79P/Z7jn+HlsCVhcEQ50t1wpSLG7mw9OeWT46i5oBBMrNdPobDLwn2
	 4Jg+aqsTPHCriafFEcPgyTogF1akAmuEifqirnqI+g/uAzBKttBgB6lkgM6OZx+EA1
	 nH1OmZRaXbq1fXX4mtgUCVct7rph576B82ImXixM=
Date: Mon, 08 Jun 2026 18:22:56 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch removed from -mm tree
Message-Id: <20260609012256.BD8851F00898@smtp.kernel.org>
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
[akpm@linux-foundation.org: fix dmirror_devmem_fault_alloc_and_copy() retval handling]
  Link: https://lore.kernel.org/oe-kbuild-all/202606011329.zWs2BKy4-lkp@intel.com/
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
+		if (dmirror_devmem_fault_alloc_and_copy(&args, dmirror)) {
+			migrate_vma_finalize(&args);
+			ret = -ENOMEM;
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


