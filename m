Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F32287268
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675123; cv=none; b=D27au+VmGfHXmTyoTPns130Cb3VGe+bbv6kwQ+p7l1EhPJsXKvelSHd49BLSKgiGtbZEERDbR+1/EF1nuDn93h2viiwVAKIOLhXydjMDHEDWxY2TvH9zgSNB8/iCLaA+oXyWYH0axtHVz5ilMxOPYWvWlEBzSDba+5mnfBWJByA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675123; c=relaxed/simple;
	bh=bPlnLAL5nmVPSnriFazqXuH1ajml+I1LyYRChpr8N8k=;
	h=Date:To:From:Subject:Message-Id; b=A8zIaptVXR0UkXbl+mgooj0XMxd/mbxss5kwkZ6ZTwazAbPsFWfl5mmq8UBa5ISojgPX94Oo2bSUmtx8I3rom8LriGavMUzucfZRgsRS7SxrZmpDCYDKRYkzcR0RCmiTyGuoDqcCGrifz9anvz0MBCgMhkOBS0qpfQv7GKxcJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pZJbKxbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pZJbKxbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB8BC4CEF1;
	Thu, 20 Nov 2025 21:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675122;
	bh=bPlnLAL5nmVPSnriFazqXuH1ajml+I1LyYRChpr8N8k=;
	h=Date:To:From:Subject:From;
	b=pZJbKxbQK5j6sWf8ifG/l228XFRDLVMZNZxUuUfoC8XpRkBWw1RIOo/N56cDcqhHa
	 S8fadiUEkAS1ebNYdoyifQyA9q+35cPSwOlk1xJWDBj13kp4K9oY0ZUJoStAfMfN/J
	 CQSwwXpKdo1vQyzPFmiHOaLfSJWQ0yjRFsYbjXS4=
Date: Thu, 20 Nov 2025 13:45:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch removed from -mm tree
Message-Id: <20251120214522.7EB8BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: use vm_normal_folio{,_pmd}() instead of damon_get_folio()
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: use vm_normal_folio{,_pmd}() instead of damon_get_folio()
Date: Wed, 12 Nov 2025 07:41:07 -0800

A few page table walk entry callback functions in vaddr.c uses
damon_get_folio() with p{te,md}_pfn() to get the folio, and then
put_folio().  Simplify and drop unnecessary folio get/put by using
vm_normal_folio() and its friends instead.

Note that this cleanup was suggested by David Hildenbrand during a review
of another patch series [1] and the patch was updated following the
suggestion.  This patch further applies the cleanup to DAMON code that
merged before the patch.

Link: https://lkml.kernel.org/r/20251112154114.66053-5-sj@kernel.org
Link: https://lore.kernel.org/0cb3d5a5-683b-4dba-90a8-b45ab83eec53@redhat.com [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio
+++ a/mm/damon/vaddr.c
@@ -444,7 +444,7 @@ static int damon_young_pmd_entry(pmd_t *
 
 		if (!pmd_present(pmde))
 			goto huge_out;
-		folio = damon_get_folio(pmd_pfn(pmde));
+		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
 		if (!folio)
 			goto huge_out;
 		if (pmd_young(pmde) || !folio_test_idle(folio) ||
@@ -452,7 +452,6 @@ static int damon_young_pmd_entry(pmd_t *
 						addr))
 			priv->young = true;
 		*priv->folio_sz = HPAGE_PMD_SIZE;
-		folio_put(folio);
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -465,14 +464,13 @@ huge_out:
 	ptent = ptep_get(pte);
 	if (!pte_present(ptent))
 		goto out;
-	folio = damon_get_folio(pte_pfn(ptent));
+	folio = vm_normal_folio(walk->vma, addr, ptent);
 	if (!folio)
 		goto out;
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
 	*priv->folio_sz = folio_size(folio);
-	folio_put(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
 	return 0;
@@ -720,18 +718,16 @@ static int damos_va_migrate_pmd_entry(pm
 	/* Tell page walk code to not split the PMD */
 	walk->action = ACTION_CONTINUE;
 
-	folio = damon_get_folio(pmd_pfn(pmde));
+	folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
 	if (!folio)
 		goto unlock;
 
 	if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
-		goto put_folio;
+		goto unlock;
 
 	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 		migration_lists);
 
-put_folio:
-	folio_put(folio);
 unlock:
 	spin_unlock(ptl);
 	return 0;
@@ -754,18 +750,15 @@ static int damos_va_migrate_pte_entry(pt
 	if (pte_none(ptent) || !pte_present(ptent))
 		return 0;
 
-	folio = damon_get_folio(pte_pfn(ptent));
+	folio = vm_normal_folio(walk->vma, addr, ptent);
 	if (!folio)
 		return 0;
 
 	if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
-		goto put_folio;
+		return 0;
 
 	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 		migration_lists);
-
-put_folio:
-	folio_put(folio);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


