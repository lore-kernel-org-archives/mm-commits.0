Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F5837D10C
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 23:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774568355; cv=none; b=J579o4z5WMmcv1zJ3WraNtTKQGcgS5UW8vNP0upSzz5qRIEbKC7W1pEe2dAxdGhgrEoLcZzrSIPw9gTajdPJ/3N2D0tOgwVQvC18H6g31p1uLTBVakgmPIRICoyMnxrRmm+FEB+3rsyJX3c1mn8hQ9Nw0Mq689JUGL8RqaKWo1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774568355; c=relaxed/simple;
	bh=w7o2OvbYziyXWXBPPP0ViG9GKdYzBa1BsqffQs/DGiA=;
	h=Date:To:From:Subject:Message-Id; b=u2QBUxMCvfdJJVFEf1ArW8cIjYtg1fXc5mqIUpA0Wrf7dsglksXtJsSeSmzMfIZIADxoKuEnkXCXxvIL62AHiQNscilIx1fpXgdw/emgSpMahp76DQocDjGMbeMHLKJrnHK0E/TC4Y+H4svUxSY2/aQl44S/Ii8TRNunHFXghME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RbzuATyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RbzuATyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55182C116C6;
	Thu, 26 Mar 2026 23:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774568355;
	bh=w7o2OvbYziyXWXBPPP0ViG9GKdYzBa1BsqffQs/DGiA=;
	h=Date:To:From:Subject:From;
	b=RbzuATygcHQ+fEO+rHRjfHNRBtDI7lItITjLxf28V2hL6hjuDu63jlJ5HxeM38hq/
	 eKcD5c/I9ZtgFATDA7UieV7E43STz1SfuBeapRMHsv53ggyszvQD/3UcCNu4oZ2YlP
	 Ht1oRxMACUWIuY5xb2X0txxXWFfv3YNr/QlQQ3qY=
Date: Thu, 26 Mar 2026 16:39:13 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch added to mm-new branch
Message-Id: <20260326233915.55182C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd_luo: remove unnecessary memset in zero-size memfd path
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: remove unnecessary memset in zero-size memfd path
Date: Thu, 26 Mar 2026 16:47:23 +0800

The memset(kho_vmalloc, 0, sizeof(*kho_vmalloc)) call in the zero-size
file handling path is unnecessary because the allocation of the ser
structure already uses the __GFP_ZERO flag, ensuring the memory is already
zero-initialized.

Link: https://lkml.kernel.org/r/20260326084727.118437-4-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path
+++ a/mm/memfd_luo.c
@@ -105,7 +105,6 @@ static int memfd_luo_preserve_folios(str
 	if (!size) {
 		*nr_foliosp = 0;
 		*out_folios_ser = NULL;
-		memset(kho_vmalloc, 0, sizeof(*kho_vmalloc));
 		return 0;
 	}
 
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch
mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch
mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch
mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch

