Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A067BDDD9
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707240692; cv=none; b=mlF+mp2g/oip3muwK+EgJIiAm0cuKaZuwV+ThPcqlWMd+IhKpf8+JiS2vqMZTR92cxMoYGP2glV///a5nnzhaq1moKU/v+Tr6EUSipRVL2K1aVijw6t+ixuFnruI1nEIJRWQSScjGFUP8cLJ6jyPjxUgwj+k6fnWZYP1VGcgyZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707240692; c=relaxed/simple;
	bh=9RUjpdsTk9vXNkAezqvcdwyi3T2WmbHHMaSK/8FB8yM=;
	h=Date:To:From:Subject:Message-Id; b=gP2cTlOP6TDm2PGUSp8BOWURWPIMpfxp6ZTXDMSk7cJmpAzPxqFL5QJwp1nr6TFlZUFay8pIxI0o47VAIOkjHbUMwxHHE4VGfG3OdkOkxZyQC/RB8vzDMDvD0cuwp2L5FKhXriK7oO784Coi7C0+EYVeryO4kmnWx0cACJmg/eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ly/6tvAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ly/6tvAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16712C433C7;
	Tue,  6 Feb 2024 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707240692;
	bh=9RUjpdsTk9vXNkAezqvcdwyi3T2WmbHHMaSK/8FB8yM=;
	h=Date:To:From:Subject:From;
	b=Ly/6tvAxbKOKTGiBNTFqKtK/IvlEqvz/qcjwZx9t7Z+rdnJTMu928d4tLbNTchttD
	 GSt9GGvDXNOZoOEDPmEUICOckd+hgfOMlpJSZTjgq8u1qpa1uJb6QLiHdXiOsxSJYI
	 uUktCi7yD+QOfvW/4VeVsOkLsrJncy2S8ESa3y8E=
Date: Tue, 06 Feb 2024 09:31:31 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,emmir@google.com,avagin@gmail.com,pgofman@codeweavers.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-preserve-exact-soft-dirty-state.patch added to mm-unstable branch
Message-Id: <20240206173132.16712C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: preserve exact soft-dirty state
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-preserve-exact-soft-dirty-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-preserve-exact-soft-dirty-state.patch

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
From: Paul Gofman <pgofman@codeweavers.com>
Subject: mm/migrate: preserve exact soft-dirty state
Date: Tue, 6 Feb 2024 13:48:01 +0500

pte_mkdirty() sets both _PAGE_DIRTY and _PAGE_SOFT_DIRTY bits.  The
_PAGE_SOFT_DIRTY can get set even if it wasn't set on original page before
migration.  This makes non-soft-dirty pages soft-dirty just because of
migration/compaction.  Clear the _PAGE_SOFT_DIRTY flag if it wasn't set on
original page.

By definition of soft-dirty feature, there can be spurious soft-dirty
pages because of kernel's internal activity such as VMA merging or
migration/compaction.  This patch is eliminating the spurious soft-dirty
pages because of migration/compaction.

Link: https://lkml.kernel.org/r/20240206084838.34560-1-usama.anjum@collabora.com
Signed-off-by: Paul Gofman <pgofman@codeweavers.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Michał Mirosław <emmir@google.com>
Cc: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-preserve-exact-soft-dirty-state
+++ a/mm/migrate.c
@@ -211,14 +211,17 @@ static bool remove_migration_pte(struct
 		folio_get(folio);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
 		old_pte = ptep_get(pvmw.pte);
-		if (pte_swp_soft_dirty(old_pte))
-			pte = pte_mksoft_dirty(pte);
 
 		entry = pte_to_swp_entry(old_pte);
 		if (!is_migration_entry_young(entry))
 			pte = pte_mkold(pte);
 		if (folio_test_dirty(folio) && is_migration_entry_dirty(entry))
 			pte = pte_mkdirty(pte);
+		if (pte_swp_soft_dirty(old_pte))
+			pte = pte_mksoft_dirty(pte);
+		else
+			pte = pte_clear_soft_dirty(pte);
+
 		if (is_writable_migration_entry(entry))
 			pte = pte_mkwrite(pte, vma);
 		else if (pte_swp_uffd_wp(old_pte))
_

Patches currently in -mm which might be from pgofman@codeweavers.com are

mm-migrate-preserve-exact-soft-dirty-state.patch

