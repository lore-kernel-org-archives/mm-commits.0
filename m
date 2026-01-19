Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECECF2638BA
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 22:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768861302; cv=none; b=NyW57yUdi7pobW9IKqIDLNkDrJXGhGywQB5t0J9wO3LfDeYNjZqSlG/BemVGdlbDlUu0fi/pniqeFj9sHo79QnplwTGgsPc7wkB8rkkrG6aUSqEmR7lmyEfjIgKPIuD/DhbNWPI7XHxUAl9MV7Kh6vGNmDzipgsd8Lrl3DVQeqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768861302; c=relaxed/simple;
	bh=lXGjWE8jkO2HQq0NfKkX3N3/S68GU14j5b3QQT5XnmA=;
	h=Date:To:From:Subject:Message-Id; b=kC4ITkgFFEEEQInHD4c/ennK7y/d5oYwkRPzicxmv49WolquTJSHgG1oH8VTsjcqFk//Emay5Ye8dwkpLuDRnJXRA2wLPDDIh6mB1pk3AxJNs2v564N2hVo8IwOasrWIY8kcAFh+XmZ/sxFvi5jKqmscqXdCgxgOu6iJLjA4Tpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xRzFEu+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xRzFEu+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16D2C116C6;
	Mon, 19 Jan 2026 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768861301;
	bh=lXGjWE8jkO2HQq0NfKkX3N3/S68GU14j5b3QQT5XnmA=;
	h=Date:To:From:Subject:From;
	b=xRzFEu+3pQ92+d7VgB6kc8raGJQ9F53BkNP00GoG4f1T+XUdFREc1zsLM+jVFvGFR
	 IVsUtaI8f4ug49ZkqnS4YFKTjptZUyB5q7v4EjySVlENoMQVVS4qaBCuv9jbD8jz0G
	 iCjbhFe9VQI5Lca4WmiC4a3IJ8lQHFVo85pUTyZE=
Date: Mon, 19 Jan 2026 14:21:41 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch added to mm-unstable branch
Message-Id: <20260119222141.A16D2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: handle non-split locks correctly in zap_empty_pte_table()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/memory: handle non-split locks correctly in zap_empty_pte_table()
Date: Mon, 19 Jan 2026 23:07:08 +0100

While we handle pte_lockptr() == pmd_lockptr() correctly in
zap_pte_table_if_empty(), we don't handle it in zap_empty_pte_table(),
making the spin_trylock() always fail and forcing us onto the slow path.

So let's handle the scenario where pte_lockptr() == pmd_lockptr() better,
which can only happen if CONFIG_SPLIT_PTE_PTLOCKS is not set.

This is only relevant once we unlock CONFIG_PT_RECLAIM on architectures
that are not x86-64.

Link: https://lkml.kernel.org/r/20260119220708.3438514-3-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table
+++ a/mm/memory.c
@@ -1830,16 +1830,18 @@ static bool pte_table_reclaim_possible(u
 	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
 }
 
-static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
+static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd,
+		spinlock_t *ptl, pmd_t *pmdval)
 {
 	spinlock_t *pml = pmd_lockptr(mm, pmd);
 
-	if (!spin_trylock(pml))
+	if (ptl != pml && !spin_trylock(pml))
 		return false;
 
 	*pmdval = pmdp_get(pmd);
 	pmd_clear(pmd);
-	spin_unlock(pml);
+	if (ptl != pml)
+		spin_unlock(pml);
 	return true;
 }
 
@@ -1931,7 +1933,7 @@ retry:
 	 * from being repopulated by another thread.
 	 */
 	if (can_reclaim_pt && direct_reclaim && addr == end)
-		direct_reclaim = zap_empty_pte_table(mm, pmd, &pmdval);
+		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
 
 	add_mm_rss_vec(mm, rss);
 	lazy_mmu_mode_disable();
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch
vmw_balloon-adjust-balloon_deflate-when-deflating-while-migrating.patch
vmw_balloon-remove-vmballoon_compaction_init.patch
powerpc-pseries-cmm-remove-cmm_balloon_compaction_init.patch
mm-balloon_compaction-centralize-basic-page-migration-handling.patch
mm-balloon_compaction-centralize-adjust_managed_page_count-handling.patch
vmw_balloon-stop-using-the-balloon_dev_info-lock.patch
mm-balloon_compaction-use-a-device-independent-balloon-list-lock.patch
mm-balloon_compaction-remove-dependency-on-page-lock.patch
mm-balloon_compaction-make-balloon_mops-static.patch
mm-balloon_compaction-drop-fsh-include-from-balloon_compactionh.patch
drivers-virtio-virtio_balloon-stop-using-balloon_page_push-pop.patch
mm-balloon_compaction-remove-balloon_page_push-pop.patch
mm-balloon_compaction-fold-balloon_mapping_gfp_mask-into-balloon_page_alloc.patch
mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc.patch
mm-balloon_compaction-assert-that-the-balloon_pages_lock-is-held.patch
mm-balloon_compaction-mark-remaining-functions-for-having-proper-kerneldoc.patch
mm-balloon_compaction-remove-extern-from-functions.patch
mm-vmscan-drop-inclusion-of-balloon_compactionh.patch
mm-rename-balloon_compactionch-to-balloonch.patch
mm-kconfig-make-balloon_compaction-depend-on-migration.patch
mm-rename-config_balloon_compaction-to-config_balloon_migration.patch
mm-rename-config_memory_balloon-config_balloon.patch
maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon.patch
maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon-fix.patch

