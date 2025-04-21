Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9416718DF86;
	Mon, 21 Apr 2025 18:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745261253; cv=none; b=C/2789qSSmDomMlbLihNt/mCUkKJaN29Y+Qo+MO4YV0OTrxusA+tXHJ5rP0XEM6oBrOISkTA2bXAeQfAgMYjDt+j7fUZNRQYvRD1zlN1CVmehv6bCxaUYGPoN2hx/DByzqSHNXBPugxrgQBUVg0LczxQFSbfupQ1TGk2vs2zraA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745261253; c=relaxed/simple;
	bh=OlJnnN3YRwuWvQxYA7fg4HQKN+3nL1lTR2meGICNBvM=;
	h=Date:To:From:Subject:Message-Id; b=Muy7PLOm9nVPgX4ADurSJcuNyBvxJFeUfz0IqnNXsSS9Ve5YjxVoA+t40pieSlwEgX0o7TJKJscPXMmuHv1NvBr9dHVnF9ViYKtWjwErZbX6CRYIMCWIjMnnutgz+4CQ9vHUDzJnuE7IzqAt+A+eGPPjWl/K3IzPNOeyfEuH3Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wY5zeXHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wY5zeXHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EDAC4CEE4;
	Mon, 21 Apr 2025 18:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745261253;
	bh=OlJnnN3YRwuWvQxYA7fg4HQKN+3nL1lTR2meGICNBvM=;
	h=Date:To:From:Subject:From;
	b=wY5zeXHe+Hsriz1Gj/XfB+8yr+MApskuCDjL/95MVhta8rnN9mYdJXnJbA9LuOnyg
	 wPN85lEMzCPGZ77ZXTwix9pLkNxZfm7b3hfq7RLPOoyJ9qpXp76Jkl8JHlKjITRe9f
	 +2KkwZ2ErpWXI63Nu0mTuJPSV0l9ovD2fk6o2BxI=
Date: Mon, 21 Apr 2025 11:47:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,revest@google.com,linmiaohe@huawei.com,hughd@google.com,gshan@redhat.com,david@redhat.com,gavinguo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-dereferencing-invalid-pmd-migration-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20250421184733.07EDAC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix dereferencing invalid pmd migration entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-dereferencing-invalid-pmd-migration-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-dereferencing-invalid-pmd-migration-entry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Gavin Guo <gavinguo@igalia.com>
Subject: mm/huge_memory: fix dereferencing invalid pmd migration entry
Date: Mon, 21 Apr 2025 19:35:36 +0800

When migrating a THP, concurrent access to the PMD migration entry during
a deferred split scan can lead to an invalid address access, as
illustrated below.  To prevent this invalid access, it is necessary to
check the PMD migration entry and return early.  In this context, there is
no need to use pmd_to_swp_entry and pfn_swap_entry_to_page to verify the
equality of the target folio.  Since the PMD migration entry is locked, it
cannot be served as the target.

Mailing list discussion and explanation from Hugh Dickins: "An anon_vma
lookup points to a location which may contain the folio of interest, but
might instead contain another folio: and weeding out those other folios is
precisely what the "folio != pmd_folio((*pmd)" check (and the "risk of
replacing the wrong folio" comment a few lines above it) is for."

BUG: unable to handle page fault for address: ffffea60001db008
CPU: 0 UID: 0 PID: 2199114 Comm: tee Not tainted 6.14.0+ #4 NONE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:split_huge_pmd_locked+0x3b5/0x2b60
Call Trace:
<TASK>
try_to_migrate_one+0x28c/0x3730
rmap_walk_anon+0x4f6/0x770
unmap_folio+0x196/0x1f0
split_huge_page_to_list_to_order+0x9f6/0x1560
deferred_split_scan+0xac5/0x12a0
shrinker_debugfs_scan_write+0x376/0x470
full_proxy_write+0x15c/0x220
vfs_write+0x2fc/0xcb0
ksys_write+0x146/0x250
do_syscall_64+0x6a/0x120
entry_SYSCALL_64_after_hwframe+0x76/0x7e

The bug is found by syzkaller on an internal kernel, then confirmed on
upstream.

Link: https://lkml.kernel.org/r/20250421113536.3682201-1-gavinguo@igalia.com
Link: https://lore.kernel.org/all/20250414072737.1698513-1-gavinguo@igalia.com/
Link: https://lore.kernel.org/all/20250418085802.2973519-1-gavinguo@igalia.com/
Fixes: 84c3fc4e9c56 ("mm: thp: check pmd migration entry in common path")
Signed-off-by: Gavin Guo <gavinguo@igalia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Cc: Florent Revest <revest@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-dereferencing-invalid-pmd-migration-entry
+++ a/mm/huge_memory.c
@@ -3075,6 +3075,8 @@ static void __split_huge_pmd_locked(stru
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze, struct folio *folio)
 {
+	bool pmd_migration = is_pmd_migration_entry(*pmd);
+
 	VM_WARN_ON_ONCE(folio && !folio_test_pmd_mappable(folio));
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
 	VM_WARN_ON_ONCE(folio && !folio_test_locked(folio));
@@ -3085,9 +3087,12 @@ void split_huge_pmd_locked(struct vm_are
 	 * require a folio to check the PMD against. Otherwise, there
 	 * is a risk of replacing the wrong folio.
 	 */
-	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
-	    is_pmd_migration_entry(*pmd)) {
-		if (folio && folio != pmd_folio(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) || pmd_migration) {
+		/*
+		 * Do not apply pmd_folio() to a migration entry; and folio lock
+		 * guarantees that it must be of the wrong folio anyway.
+		 */
+		if (folio && (pmd_migration || folio != pmd_folio(*pmd)))
 			return;
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 	}
_

Patches currently in -mm which might be from gavinguo@igalia.com are

mm-huge_memory-fix-dereferencing-invalid-pmd-migration-entry.patch

