Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEE32EEE89
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609604; cv=none; b=uDGmeMNr+dz35ZfzHlzv8CC7kxoi5PGZPSRxzo9j6FA86Cx+yubuyq0xags75KW8sOjB1cE5X4nlgFP+eFBTvqZNmSFlNno/mG5bu977WXI2JHKdVl+EYhV7qkCkUctKI8IaDje8V2sj07Cuvl+ip5opZGYi/zdvKmmL5q4Z1DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609604; c=relaxed/simple;
	bh=IdVQhh4PmaVf3bp5EW9B44ECAXGqyUoTD7kG0pZTTnk=;
	h=Date:To:From:Subject:Message-Id; b=ic0DC6Ag0slL2uhl+hAgkJvrjff1r3PmE+qH+T5RDfQS1gUycpjKb1ClIZ0ZlCNTpymUMqODivJorJs6uPTctSPCI9B0AszSLCDeurZUS7tB3ly561aGPZpYFlHzO1TiE/8DDg7i/YGfARYgSqswUqLT/0fU7g35Q9iDjqKxH6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZswVfDR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZswVfDR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B121F00893;
	Thu,  4 Jun 2026 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609602;
	bh=erFyJs0ZTrdJC7kBqaSI4gilzZjWfs2nGKQllFUubfQ=;
	h=Date:To:From:Subject;
	b=ZswVfDR+WO/51jGarS3O5giNW1vD9vuarsa2xDil0vsQx/t9wc1nCI59q7xwpWzmw
	 1r950vjJbhilyWG3wij9rzu0mog6cElw8rAcHRgVoS4+ojSUQRwPupEhrqVaJZ7KwJ
	 JZv+By4iH9OjlpJK1wFazltMsvKbDmn0aJdWdJfw=
Date: Thu, 04 Jun 2026 14:46:42 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch added to mm-unstable branch
Message-Id: <20260604214642.C8B121F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: check alloc_page_vma() return value and handle OOM
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch

