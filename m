Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC44819
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716163925; cv=none; b=qDkgWA35nfSeKZdUNOMWG15CnLyUqVF8D19nkFBMLUOV+F+O5zqRTIuvZ5fw27sGbFdEmskdkIrx2q9KLLfJsdz2zxvIEOLb8ULivUk7EaSZvemuLFmd/gl/RWC+J62GfKPsXFNppbvOt9WNORJGMtWH7Z/ROqwzZzFFIRUBnp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716163925; c=relaxed/simple;
	bh=C/i90GSYGSQ55YeIhd4MkZWx1uZPLalVtWzYpOuzDiE=;
	h=Date:To:From:Subject:Message-Id; b=gxTkHSqY5dn/ApbB3Fv8vxpkcNg29PDz3fnu5DOSg12ng5AdLAPWwTJmiw9eBl6WzE98A6oGMKXagZ4YYvsHWzKEmKUuyui/uR9VUD5Hkb72V+Pl2FiUKMBLMyd1uMsbE5sgo1/hN5fsDtGxvWFXZdqGKTRrf/148qDWXggyWLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cx4vKhTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cx4vKhTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B046C32781;
	Mon, 20 May 2024 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716163925;
	bh=C/i90GSYGSQ55YeIhd4MkZWx1uZPLalVtWzYpOuzDiE=;
	h=Date:To:From:Subject:From;
	b=Cx4vKhTUdPNuytEuDVy/S8OUxVDEdTumtiiE8K4m7RNaSfUHB6JDdDSuKTerjamVe
	 H4eNIAyjnzm+QEvqr1f7UvoFyfXPRkOUmSkW/InaObruZCEd8OkuPMc6XhKLHsgdME
	 YVlfEr8En4DffosbctHaCkH8SvsTHltH7L83x3N0=
Date: Sun, 19 May 2024 17:12:04 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch added to mm-unstable branch
Message-Id: <20240520001205.0B046C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mempolicy: use folio_alloc_mpol() in alloc_migration_target_by_mpol()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch

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
Subject: mm: mempolicy: use folio_alloc_mpol() in alloc_migration_target_by_mpol()
Date: Wed, 15 May 2024 15:07:08 +0800

Convert to use folio_alloc_mpol() to make vma_alloc_folio_noprof() to use
folio throughout.

Link: https://lkml.kernel.org/r/20240515070709.78529-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol
+++ a/mm/mempolicy.c
@@ -1211,7 +1211,6 @@ static struct folio *alloc_migration_tar
 	struct migration_mpol *mmpol = (struct migration_mpol *)private;
 	struct mempolicy *pol = mmpol->pol;
 	pgoff_t ilx = mmpol->ilx;
-	struct page *page;
 	unsigned int order;
 	int nid = numa_node_id();
 	gfp_t gfp;
@@ -1235,8 +1234,7 @@ static struct folio *alloc_migration_tar
 	else
 		gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL | __GFP_COMP;
 
-	page = alloc_pages_mpol(gfp, order, pol, ilx, nid);
-	return page_rmappable_folio(page);
+	return folio_alloc_mpol(gfp, order, pol, ilx, nid);
 }
 #else
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch

