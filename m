Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795559248;
	b=YbRAQ/eZ6lX7fiPNNqjE8+l4KIPNuodJjDDcsX4G4CWVCSge8lf4vLWz0fdOSxzU6TEk
	 nLXjn15v50IPcTLu119COR1wgaQswn7LK3aeyp4tRFhqPyIPlRxMNUa2klGb/5oJYaR3B
	 PiA/dwHnynW6kE/7bp/K4oElVRnVRaa0+LOTB4dLhEq0e6Wj4J/t3q657s/x5xsncCDx4
	 1S0ZLizaUbwfOyy8Ed8Zj9CSimH2f5QI0URVwI6OY/24WYzUMGd4rhodDuXDGdUL7epUQ
	 +HZoo+Ss86DvszXDCmS/MDAHBsD7v28XpDhzHJoAjRmUs1B7krsnhWUSB0gjlSkokIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795559248;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=PnDn6MXywSFQcmmUQEGx/g+btSDB8dbMSpRvgJfbF/I=;
	b=cV7tPJb66COk1/ufY1thFmH+g4CPsrcDeVVLC8bPjsHUiuVR5RMmWV4Tj/hfmXuLl4Wi
	 I+2JaLp0NiShH6Lv/Feg5eZYoMf7bsAUhVWYV6AQYa9J3R7Fx46UXlj8j23BfZJFXSR1V
	 bItJhyjaE+aIbQ5ZXSkwvWKiYJnlBxMYySZWffkc1WLTIRA+lmFo3qXqgjDt6tX0aedny
	 rN+ekZOEsYtYW1AdeXixxIpz2ZhwEZ1JmLafimDzfwNaKP8HOuF3RuXIu0AXbY92v8NEU
	 ukIOOXA0auv43CdEzf+TLTTSfZrkeJssNzMXF8xO3eNzJpTqyCLomB80HCwi1soVGWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=W1roVZUj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5858E606A321;
	Tue, 24 Nov 2026 22:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=W1roVZUj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B7E1F000C6;
	Tue, 24 Nov 2026 22:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795559248;
	bh=PnDn6MXywSFQcmmUQEGx/g+btSDB8dbMSpRvgJfbF/I=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=W1roVZUjLGCsoYxH23Gj8CDgp5eoebcMo6dlABseUDjweTmHoYb+tpY9jaNO0n+3G
	 wOL6x7Zi15iJTntL59NU3Nbr1xyX4YhxoECeCpa/zB6BDJ27Ei7pJFBvs11TKK4l/m
	 uVnP8i41eXO+MgtC1GBmVts1gIdPFUda11el7IL0=
Date: Tue, 24 Nov 2026 14:27:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,
	stable@vger.kernel.org,sfr@canb.auug.org.au,ryan.roberts@arm.com,
	rppt@kernel.org,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,
	nico.pache@linux.dev,muchun.song@linux.dev,mirq-linux@rere.qmqm.pl,
	miko.lenczewski@arm.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,leitao@debian.org,lance.yang@linux.dev,
	kas@kernel.org,jthoughton@google.com,joshua.hahnjy@gmail.com,
	jannh@google.com,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,
	byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	balbirs@nvidia.com,avagin@gmail.com,arnd@arndb.de,apopple@nvidia.com,
	aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-uffd-state-fixes-v3-2-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-2-b617009d1a4a@columbia.edu>
Subject: + userfaultfd-refuse-uffdio_move-into-a-non-present-huge-destination-pmd.patch added to mm-new branch
Message-Id: <20261124222727.E9B7E1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-refuse-uffdio_move-into-a-non-present-huge-destination-pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-refuse-uffdio_move-into-a-non-present-huge-destination-pmd.patch

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
Subject: userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD
Date: Tue, 17 Nov 2026 23:28:42 -0500

move_pages() refuses to move into a destination PMD that already maps a
THP, but checks for that with pmd_trans_huge(), which is only true for a
present THP. A device-private THP or a THP under migration is a PMD
softleaf entry and is not refused.

The destination PMD is then treated as if it pointed to a PTE table. It
is not empty, so pte_alloc() leaves it alone, and move_pages_ptes()
fails to map a PTE table from it and returns -EAGAIN. move_pages()
retries on -EAGAIN, with both VMA read locks held. If the source is a
THP, it is split first for nothing.

For a THP under migration, the loop ends once the migration finishes.
A device-private THP can remain in device memory indefinitely, so the
caller of UFFDIO_MOVE hangs until it receives a fatal signal, and
anything in the mm that needs to write-lock one of the VMAs blocks along
with it. This requires a driver that migrates THPs to device memory.

To fix it, check the destination with pmd_is_huge(), which is true for
a present THP and for a PMD softleaf entry. UFFDIO_MOVE now fails with
-EEXIST in these cases, as it already does for a present THP.

Link: https://patch.msgid.link/20261117-uffd-state-fixes-v3-2-b617009d1a4a@columbia.edu
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
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
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mikołaj Lenczewski <miko.lenczewski@arm.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: <stable@vger.kernel.org>

 mm/userfaultfd.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-refuse-uffdio_move-into-a-non-present-huge-destination-pmd
+++ a/mm/userfaultfd.c
@@ -2036,12 +2036,13 @@ static ssize_t move_pages(struct userfau
 
 		dst_pmdval = pmdp_get_lockless(dst_pmd);
 		/*
-		 * If the dst_pmd is mapped as THP don't override it and just
-		 * be strict. If dst_pmd changes into TPH after this check, the
-		 * move_pages_huge_pmd() will detect the change and retry
-		 * while move_pages_pte() will detect the change and fail.
+		 * If the dst_pmd is a huge leaf, present or not, don't
+		 * override it and just be strict. If dst_pmd changes into a
+		 * leaf after this check, move_pages_huge_pmd() will detect the
+		 * change and retry while move_pages_ptes() will fail to map
+		 * the PTE table and the next iteration will see the leaf.
 		 */
-		if (unlikely(pmd_trans_huge(dst_pmdval))) {
+		if (unlikely(pmd_is_huge(dst_pmdval))) {
 			err = -EEXIST;
 			break;
 		}
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

