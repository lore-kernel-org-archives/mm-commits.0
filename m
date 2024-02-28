Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A9479B61
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709144206; cv=none; b=fsoWsPZMacgsvcq3+RBFoufeGzy61uSQ7Epswy4TTnUeuemwShfAXsMyiLivS4/Z96NVpysEyu9H6/hxrX/UK6BmrbehYGUE34GDFqgW+XOK432XsnTJPQIhOjMfUXsaloSF6h+S/9WYBtQrsSVlr18zYCGAdDrW7sco7S1cmKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709144206; c=relaxed/simple;
	bh=rV1gnAIHygyj226eelzMVHtRKCeE9OjeEPT9NPGEcYU=;
	h=Date:To:From:Subject:Message-Id; b=vAtgVNpvTLly9+M57mkfg+Tj3D+ciD7jgHm/fPfT1z5/5lk+ZMG9XkNj668DBhUJT27i5Jrb5kVXdUrdcU5F+E1w1Be7SEGc7lgZEpv9NseZB4hUwUa+8MV1wvOLDKpzk2esOV/7QdjcnKWYcnCFr0AXS+tDx5dOBSSIEOZPTv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k0Er7hh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k0Er7hh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFACCC433C7;
	Wed, 28 Feb 2024 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709144206;
	bh=rV1gnAIHygyj226eelzMVHtRKCeE9OjeEPT9NPGEcYU=;
	h=Date:To:From:Subject:From;
	b=k0Er7hh9gaz5zzki5db/sETvuPiHcwX0XN0zRWRyS34smk6appEYb9cw5lZOT7R3r
	 Qp9cI6NzgtnDmG7ad2ic3RloiVA6krQDAh/CO3uod2bfADgfc+Tb8Ww66WknY/g8VE
	 O6QZW3FmYcDlykvMx6oTLsq4TWj82PKwa/9fTPOk=
Date: Wed, 28 Feb 2024 10:16:44 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-split-huge-page-to-any-lower-order-pages-fix.patch added to mm-unstable branch
Message-Id: <20240228181645.DFACCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-thp-split-huge-page-to-any-lower-order-pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-split-huge-page-to-any-lower-order-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-split-huge-page-to-any-lower-order-pages-fix.patch

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
Subject: mm-thp-split-huge-page-to-any-lower-order-pages-fix
Date: Wed, 28 Feb 2024 10:52:23 -0500

fixup per discussion with Ryan at https://lore.kernel.org/linux-mm/408df79a-130e-43cd-a21a-9b3a2ddef617

Link: https://lkml.kernel.org/r/494F48CD-1F0F-4CAD-884E-6D48F40AF990@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-thp-split-huge-page-to-any-lower-order-pages-fix
+++ a/mm/huge_memory.c
@@ -3059,11 +3059,8 @@ int split_huge_page_to_list_to_order(str
 
 	if (new_order) {
 		/* Only swapping a whole PMD-mapped folio is supported */
-		if (folio_test_swapcache(folio)) {
-			VM_WARN_ONCE(1,
-				"Cannot split swap-cached folio to non-0 order");
+		if (folio_test_swapcache(folio))
 			return -EINVAL;
-		}
 		/* Split shmem folio to non-zero order not supported */
 		if (shmem_mapping(folio->mapping)) {
 			VM_WARN_ONCE(1,
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-only-split-pmd-mapping-when-necessary-in-unmap_folio.patch
mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch
mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch
mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch
mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch
mm-thp-split-huge-page-to-any-lower-order-pages.patch
mm-thp-split-huge-page-to-any-lower-order-pages-fix.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch

