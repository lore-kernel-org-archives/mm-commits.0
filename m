Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B3A8493
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716581732; cv=none; b=K45nv6MPU9/qFbnGb6LJtPgMKYzr9KFIy42LDKjgftKtuzQjegs3EdtSyRcht2F34gkrkoOdZIE2qaB2MDbpi6RZ1SvqjiNeeTQAonmBDJ3diUEf+KcrfXeTdVBPWII2jM533RUyutUZMS7GLpDOVptrc7xN9WbSi+UljZNfDpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716581732; c=relaxed/simple;
	bh=mNXOAxJk/IZT0BXoxoVrn+67TBtPjsWIh97ajWyRl20=;
	h=Date:To:From:Subject:Message-Id; b=eT2UUK2JXSBfNVMTPZLpdKjSZ+ZK/BdJwqhrtKhgwPA0S6lsf/7/16a1i1eC+J6/5VRTRU3voy7AeigKyxYGk4flKvwfBdlvZYnbBFfmLELaB+CpZ6R1vEgT6AWVwLReYzwqaL2ANOZ3u+J3SbklT21ZevDprE6XHpYAvvjMsMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zXpD+1QP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zXpD+1QP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3CCC2BBFC;
	Fri, 24 May 2024 20:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716581731;
	bh=mNXOAxJk/IZT0BXoxoVrn+67TBtPjsWIh97ajWyRl20=;
	h=Date:To:From:Subject:From;
	b=zXpD+1QPkJPsS6dtA4ijWHdRSy5wsp+V2lUtZMeGKuNd18ImaaCO5MOmIEBFfxpTe
	 nSJ8AiPy4RVTlbTPD2MM/O1HnzU8mkzvF+FKIfyY+z6XCZVCe5mSIDTwEW81Uin51d
	 TcRTAqA/ZgckEGzOaKQNNBvFOOiwOLcJWZ32QtR8=
Date: Fri, 24 May 2024 13:15:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,alexs@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rmap-remove-define_page_vma_walk.patch added to mm-unstable branch
Message-Id: <20240524201531.9B3CCC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rmap: remove DEFINE_PAGE_VMA_WALK()
has been added to the -mm mm-unstable branch.  Its filename is
     rmap-remove-define_page_vma_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rmap-remove-define_page_vma_walk.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: rmap: remove DEFINE_PAGE_VMA_WALK()
Date: Fri, 24 May 2024 13:36:18 +0800

This are no users since commit 40d707f33db5 ("mm/ksm: use folio in
write_protect_page"), so remove DEFINE_PAGE_VMA_WALK().

Link: https://lkml.kernel.org/r/20240524053618.208895-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/linux/rmap.h~rmap-remove-define_page_vma_walk
+++ a/include/linux/rmap.h
@@ -684,16 +684,6 @@ struct page_vma_mapped_walk {
 	unsigned int flags;
 };
 
-#define DEFINE_PAGE_VMA_WALK(name, _page, _vma, _address, _flags)	\
-	struct page_vma_mapped_walk name = {				\
-		.pfn = page_to_pfn(_page),				\
-		.nr_pages = compound_nr(_page),				\
-		.pgoff = page_to_pgoff(_page),				\
-		.vma = _vma,						\
-		.address = _address,					\
-		.flags = _flags,					\
-	}
-
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
 	struct page_vma_mapped_walk name = {				\
 		.pfn = folio_pfn(_folio),				\
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch

