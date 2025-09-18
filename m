Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C908226C3A7
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 21:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758229778; cv=none; b=auxd1O5dYdzDihww/wiqNMHB0GUQhsvTOjiRXPgc8giZWx5G5jk8Og5wXAdrf4hxqFmcN6LapL+g783vhgv+ubk9Ym6G9JIWAHguPs32U3+kVgLta5lqQb7A6PpIkorzf+OwPDzvRMN1wp7YYv7KaE//wlVqnHvY6iikBtKE3LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758229778; c=relaxed/simple;
	bh=jXyDAD7vn0rltXp4MlwIkFqBXvRDZ3OMRFFfPN4UDH8=;
	h=Date:To:From:Subject:Message-Id; b=sF9E9nRkrzpQwxGAl1P5ondkKCC7jbe4DKufMMcHc8sNI6P4KAmf2VG+/KED0B2Kfw7B4rX4ssv+AXwJZYZrgRuq6UktMfjKjyQrpIfoxQ7sXLU71IHrFRUwnoVJw14kY+RYQyHFY651hAjKNN9mkKh2Gr9efQxmypMe5H7qc14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B7yBIJQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B7yBIJQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E33C4CEF0;
	Thu, 18 Sep 2025 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758229778;
	bh=jXyDAD7vn0rltXp4MlwIkFqBXvRDZ3OMRFFfPN4UDH8=;
	h=Date:To:From:Subject:From;
	b=B7yBIJQ2szK2b7do9d+VL8zdKUePZhtz3WIqsAxP1ZPYIQEvpiUA2FC6xNG5KaeQA
	 m7lQ8wfzP7xyo4sETaAYGnFixuPmkfrxU5VN+AmwyoeqLD/0FRTEIbuB0zeQ1yMbMV
	 HC5ooplZJQAF5eSYLM1t8oNaSM1HNMN1zCzPyRWU=
Date: Thu, 18 Sep 2025 14:09:37 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-io_remap_pfn_range_-fix.patch added to mm-unstable branch
Message-Id: <20250918210938.37E33C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup io_remap_pfn_range_[prepare, complete]
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-io_remap_pfn_range_-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-io_remap_pfn_range_-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fixup io_remap_pfn_range_[prepare, complete]
Date: Thu, 18 Sep 2025 07:43:21 +0100

propagate the fact that we don't need io_remap_pfn_range_prot()

Link: https://lkml.kernel.org/r/2cf129c4-627b-4a78-9ec3-cf43c95cf17d@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-introduce-io_remap_pfn_range_-fix
+++ a/mm/internal.h
@@ -1670,7 +1670,7 @@ static inline int io_remap_pfn_range_com
 		pgprot_t orig_prot)
 {
 	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
-	const pgprot_t prot = io_remap_pfn_range_prot(orig_prot);
+	const pgprot_t prot = pgprot_decrypted(orig_prot);
 
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-abstract-io_remap_pfn_range-based-on-pfn-fix.patch
mm-introduce-io_remap_pfn_range_.patch
mm-introduce-io_remap_pfn_range_-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-oom_killc-fix-inverted-check.patch

