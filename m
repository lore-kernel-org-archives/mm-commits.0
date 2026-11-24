Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795559258;
	b=inKYhYsGya+YMEt6ReYW0McYKiWpuMptwHgpH/EPXFMrzB35OLG6OvQBXRg8b7PC0r26
	 oLEYGA5khUaBkj2OMkOvn4RM7+UHj56/Im6gVeaITvPfUq8obdVH9bQf4JD9AbkJK5K/K
	 j9PbLtjg5RbEcPVSfxqB9Ucp7DCBrE2Fldd6e6WjsEoiOJdyxRAE6W0Lz/O660+JK01gt
	 2Q77JZnmfp6n+dx8gcqQ6DqpKTa7DL7gB8rQgDhC/KU93+6QZmgKpEweUqB9kMx9hAhrv
	 IQVQdHAuFlqfsGZ4KlhF8lq7w18zC/NtJiyIN7UG4AVnDOIEDJEbNazXauhgYSwvJyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795559258;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=iSpXgOY/BIhvtTEIjqhLCM37YAdDqV/wb3xXa6ugtJg=;
	b=Np7ucRnPeHlDQp2J6loNWvfEnKPwoPfkmTOtXJXNXWmXwRKdTNwczvhfISlnwkA5CLz0
	 Gi2Pg78bNi4Yr1KubOj9GD/3t38gV9Os0RsX8JRdaID/WVJ+LnaJPtSeO1r3mrK2zWBpg
	 FZrnqsIoydDUOuM49JQ8aCIWiOfDkDrWK7XjRi1dGYI7sHOeqGGXU4wMmshl4R47GriXl
	 C91K24TsyF3dUulz9B1OUE8yriegqfTeV47n+grlHdn5nYhs0hljJtnCSw6w08Fg4zI+D
	 WztO2NFEnWCmKVCK3ArABW6BoXiqOyUasBCulfru3RHv1qoAYgWx2NUZ2r1Yn6uqgpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SAnCHx52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7DB606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 22:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SAnCHx52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3437C1F000C0;
	Tue, 24 Nov 2026 22:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795559257;
	bh=iSpXgOY/BIhvtTEIjqhLCM37YAdDqV/wb3xXa6ugtJg=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=SAnCHx52j8CN9MHutGAfHN2ZifLn4DAg9NfOgz2J65cO1PeDGrUerRbPPbRZzT3Sf
	 NFuOCAQTyJqX33R6YWQ4Rs8IQwEo/mAjR/16hTVK/Umnz2lqcO8p/1CytxPGDy20O2
	 QswSNpgS8A4Dhj1NlRAIYFk8MF1BeYsykRiDW6C8=
Date: Tue, 24 Nov 2026 14:27:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,
	sfr@canb.auug.org.au,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,
	peterx@redhat.com,osalvador@suse.de,nico.pache@linux.dev,
	muchun.song@linux.dev,mirq-linux@rere.qmqm.pl,miko.lenczewski@arm.com,
	mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,
	leitao@debian.org,lance.yang@linux.dev,kas@kernel.org,jthoughton@google.com,
	joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,dev.jain@arm.com,
	david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,balbirs@nvidia.com,avagin@gmail.com,arnd@arndb.de,
	apopple@nvidia.com,aarcange@redhat.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-uffd-state-fixes-v3-6-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-6-b617009d1a4a@columbia.edu>
Subject: + mm-huge_memory-build-the-moved-huge-zero-pmd-from-the-destination-vma.patch added to mm-new branch
Message-Id: <20261124222737.3437C1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/huge_memory: build the moved huge zero PMD from the destination VMA
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-build-the-moved-huge-zero-pmd-from-the-destination-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-build-the-moved-huge-zero-pmd-from-the-destination-vma.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/huge_memory: build the moved huge zero PMD from the destination VMA
Date: Tue, 17 Nov 2026 23:28:46 -0500

move_pages_huge_pmd() builds the destination PMD for the huge zero page
by copying the source PMD and clearing its uffd bit, so the destination
keeps the protection of the source.

A source VMA registered for RWP can map the huge zero page with a
PAGE_NONE PMD, and UFFDIO_MOVE does not check how the source is
registered. The destination then gets a PAGE_NONE PMD without the uffd
bit, although nothing asked for that in the destination VMA.

The next access fixes it up through the NUMA hinting fault path. Until
then, the first access to the destination takes a spurious fault and GUP
has to take the fault path. The impact on userspace is small.

The moved entry must have the protection of the destination VMA. To fix
it, build the entry from the vm_page_prot of the destination VMA, as
move_zeropage_pte() does for the small zero page, and keep marking it
soft-dirty. A destination VMA registered for RWP still gets its PMD
re-armed afterwards.

Link: https://patch.msgid.link/20261117-uffd-state-fixes-v3-6-b617009d1a4a@columbia.edu
Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mikołaj Lenczewski <miko.lenczewski@arm.com>
Cc: Breno Leitao <leitao@debian.org>

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-build-the-moved-huge-zero-pmd-from-the-destination-vma
+++ a/mm/huge_memory.c
@@ -2999,9 +2999,9 @@ int move_pages_huge_pmd(struct mm_struct
 		/* Follow mremap() behavior and treat the entry dirty after the move */
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
-		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
-		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
+		pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
+		_dst_pmd = folio_mk_pmd(huge_zero_folio, dst_vma->vm_page_prot);
+		_dst_pmd = move_soft_dirty_pmd(pmd_mkspecial(_dst_pmd));
 	}
 
 	/* Re-arm RWP on the moved PMD if dst_vma is RWP-registered. */
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
userfaultfd-use-anonymous-memory-for-uffdio_zeropage-on-private-file-mappings.patch
userfaultfd-refuse-uffdio_move-into-a-non-present-huge-destination-pmd.patch
fs-proc-task_mmu-downgrade-writable-migration-entries-in-pagemap_scan-write-protect.patch
fs-proc-task_mmu-write-protect-device-private-thps-in-pagemap_scan.patch
mm-huge_memory-build-the-moved-huge-zero-pmd-from-the-destination-vma.patch
mm-mremap-resolve-uffd-state-when-the-context-is-dropped-not-during-the-move.patch
mm-userfaultfd-check-the-hugetlb-alignment-of-every-vma-in-the-pre-scan.patch

