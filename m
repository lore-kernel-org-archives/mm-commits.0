Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9909D51C4A
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 01:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738029367; cv=none; b=rA40VvsH2v3XFPnKOgj8jRyIWqlP2PGTSvzJMu9ykhPRGFc/eEqe09yu3X9J3omk5huXajtEY/H9TTUf/IKqbZY+aeCbsDGp7cbPqtr4u8EeMBsLP6B2IME75R6avAQ1rmjvRcd+8fEe7DNufVAVuxpWKoZzjwjPKJfE3Uw3WoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738029367; c=relaxed/simple;
	bh=PelgPCH0zM8f2ijqnzQpk9C6IloQheJSS83FyYStDbk=;
	h=Date:To:From:Subject:Message-Id; b=U5scYm6Uqc5YwPkEWd4mU4K3HndXW5aE+5cs34dnZBaYXG7M0zZnlf30Rayrlss1a7XLYAcIwM4Gg17J/tSkmqnQxsummj8wkw39UjZlhLoiEpL52xmWGdCfyrW9PhSP6lpgbQKNgt29dGsRuenh7mCV8lMxNtVhMUhRJ29T9yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R1fECkr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R1fECkr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B2EC4CEE0;
	Tue, 28 Jan 2025 01:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738029367;
	bh=PelgPCH0zM8f2ijqnzQpk9C6IloQheJSS83FyYStDbk=;
	h=Date:To:From:Subject:From;
	b=R1fECkr9WujXvON+nfZd8M7kA3zoifqCr2XlsJz3swdBHFTkWa1N6Msxcb0Snv5qf
	 AU09yIOKFt+99CYcreVNaRp7j17hGmihSUpJuUu0IwDnaMX45h/lNAQxVtyusD5Y0T
	 Ngzqyy4oYZYDwUyXuO/2yUvNXJTcyPkC1jeaffdY=
Date: Mon, 27 Jan 2025 17:56:06 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch added to mm-unstable branch
Message-Id: <20250128015607.46B2EC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: allow split shmem large folio to any lower order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: allow split shmem large folio to any lower order
Date: Wed, 22 Jan 2025 11:19:27 -0500

Commit 4d684b5f92ba ("mm: shmem: add large folio support for tmpfs") has
added large folio support to shmem.  Remove the restriction in
split_huge_page*().

Link: https://lkml.kernel.org/r/20250122161928.1240637-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order
+++ a/mm/huge_memory.c
@@ -3299,7 +3299,7 @@ static void __split_huge_page(struct pag
 		/* Some pages can be beyond EOF: drop them from page cache */
 		if (tail->index >= end) {
 			if (shmem_mapping(folio->mapping))
-				nr_dropped++;
+				nr_dropped += new_nr;
 			else if (folio_test_clear_dirty(tail))
 				folio_account_cleaned(tail,
 					inode_to_wb(folio->mapping->host));
@@ -3465,12 +3465,6 @@ int split_huge_page_to_list_to_order(str
 			return -EINVAL;
 		}
 	} else if (new_order) {
-		/* Split shmem folio to non-zero order not supported */
-		if (shmem_mapping(folio->mapping)) {
-			VM_WARN_ONCE(1,
-				"Cannot split shmem folio to non-0 order");
-			return -EINVAL;
-		}
 		/*
 		 * No split if the file system does not support large folio.
 		 * Note that we might still have THPs in such mappings due to
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch

