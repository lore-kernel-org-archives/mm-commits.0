Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A2B11182
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560199; cv=none; b=Gp7CvdSZJnQBCLq/iTfG1mI2Md2bokA9ODsR5KWBr0FV8XzfW3Mfq81F678UP4RiSlVxhM9Wn+gIM0qQxKmBnB6FASE5hQyogc5jQVd6/sQh73j6SAk57I7emz7Xm4bEVxqa7mv1iKen1ZxxyEPavUVOrQB+kRL6YK4gPK90Pjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560199; c=relaxed/simple;
	bh=SOuq0EWfYY3ve8c67k7NszRwCXBfHP8hEkmdKhVPqok=;
	h=Date:To:From:Subject:Message-Id; b=LFKzxzxyhsVD55SddnwVyHDW4yu2Ej3DphzfeJ0L8Vg4GaXsrI6+8xxguCJnW/XxwB3uSmFda+EUQ0DRANVAzLOzmW5VnZYZtmDRKt07iDoKlEAUNcnJaWsmLlFnb/mwTKgn3NVIxos9bsWSN/bHLELcHdvwsSK2cAEWi0xdVGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0g+K/Axj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0g+K/Axj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAC1C433F1;
	Thu, 22 Feb 2024 00:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560199;
	bh=SOuq0EWfYY3ve8c67k7NszRwCXBfHP8hEkmdKhVPqok=;
	h=Date:To:From:Subject:From;
	b=0g+K/AxjKDa87D84sX9l8GOEoLFRj/KX66VIjm8H5b6NsE/HykKKrD5LbUooBJ8S5
	 tYllD1kqBQNe0u+RRR31KV08xO1jX2aLIDJgVI6JbYTSafH8saYQUvmoyFZYRZXhkb
	 9/HyncrrWmVcjCWx7h3xNWhxmXKq1E8UAU7JxWAM=
Date: Wed, 21 Feb 2024 16:03:18 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,emmir@google.com,avagin@gmail.com,pgofman@codeweavers.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-preserve-exact-soft-dirty-state.patch removed from -mm tree
Message-Id: <20240222000319.5DAC1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: preserve exact soft-dirty state
has been removed from the -mm tree.  Its filename was
     mm-migrate-preserve-exact-soft-dirty-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Andrei Vagin <avagin@gmail.com>
Cc: Michał Mirosław <emmir@google.com>
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


