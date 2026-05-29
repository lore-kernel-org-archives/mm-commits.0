Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5168E29D26B;
	Fri, 29 May 2026 23:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780097401; cv=none; b=KadbDimZDClNkRDTrj1+mkIrk8OgQKjcVZSn2ucLy8p3viiz8RJ46NqPGh8w1mm+2wHbbVao7lKOUx4aHHCts1ebUAIhXUMyE0YGggO1xtMq7kPHG7Dexm0G8ksPQM5h8224UG7u1kDq2ikLasdxWGNr1bKlQvS8o2RjmboY+XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780097401; c=relaxed/simple;
	bh=wqlX10ptD6G0Sy0U+H7rTMauxwC04zA4qIN47cKNDss=;
	h=Date:To:From:Subject:Message-Id; b=f1DNNmvbSjnlCZznJU/ggLedOO50IHz09bELROCnoMSSsm+q7aRVEPe5Cz4ZCtGX2xW5inER9/ExSQqoGoO5LdTrzIR4SVhT6yrUkFZuaU5HSwEidbovQdzjJSAnc1DEnR2U97lED93I2ttTRKKFJwbqnyGlbJ3z4nwJ4QHr2PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rUjpnrBc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rUjpnrBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62D81F00893;
	Fri, 29 May 2026 23:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780097399;
	bh=2Dq5XqllVrENOUnMWr6d8a8D4lIBdT6qXMoz0uHAD00=;
	h=Date:To:From:Subject;
	b=rUjpnrBcSrPwWKaCePbKAjq4o8DmFIngtVlo7yWKqTRZkmclK3ZFiY21akrOzLg2h
	 bauh9chGG8y5Ms+SmcAXHgNUlp3gBccPYwg7N3fjH6Ql4awT56nZUovvy1uhY2Cz43
	 h+1ZoRFGxf+EzlUvM/H7x9T3jq3dCyyrZYefocJ0=
Date: Fri, 29 May 2026 16:29:59 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-preserve-pmd_swp_uffd_wp-on-device-private-pmd-downgrade.patch added to mm-new branch
Message-Id: <20260529232959.C62D81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: preserve pmd_swp_uffd_wp on device-private PMD downgrade
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-preserve-pmd_swp_uffd_wp-on-device-private-pmd-downgrade.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-preserve-pmd_swp_uffd_wp-on-device-private-pmd-downgrade.patch

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/huge_memory: preserve pmd_swp_uffd_wp on device-private PMD downgrade
Date: Fri, 29 May 2026 18:23:28 +0100

change_non_present_huge_pmd() rewrites a writable device-private PMD swap
entry into a readable one without carrying pmd_swp_uffd_wp() across.  The
PTE-level change_softleaf_pte() does this correctly; mirror that here,
matching what copy_huge_pmd() does for the fork path.  Without the carry,
a plain mprotect() over a UFFD_WP-marked device-private THP strips the bit
and the trap is bypassed on swap-in.

Link: https://lore.kernel.org/20260529172331.356655-5-kas@kernel.org
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-preserve-pmd_swp_uffd_wp-on-device-private-pmd-downgrade
+++ a/mm/huge_memory.c
@@ -2577,6 +2577,8 @@ static void change_non_present_huge_pmd(
 	} else if (softleaf_is_device_private_write(entry)) {
 		entry = make_readable_device_private_entry(swp_offset(entry));
 		newpmd = swp_entry_to_pmd(entry);
+		if (pmd_swp_uffd_wp(*pmd))
+			newpmd = pmd_swp_mkuffd_wp(newpmd);
 	} else {
 		newpmd = *pmd;
 	}
_

Patches currently in -mm which might be from kas@kernel.org are

fs-proc-task_mmu-fix-make_uffd_wp_huge_pte-prot-update-race.patch
fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry.patch
fs-proc-task_mmu-fix-hugetlb-self-deadlock-in-pagemap_scan_pte_hole.patch
mm-huge_memory-preserve-pmd_swp_uffd_wp-on-device-private-pmd-downgrade.patch
userfaultfd-gate-must_wait-writability-check-on-pte_present.patch
userfaultfd-build-__vma_uffd_flags-from-config-gated-masks.patch

