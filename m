Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE4F7FBB2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104049; cv=none; b=EVqBWhn2bk378kox6t9vgNX5RSxut1HtyOMJXxBMhYnEMPMHllc9sOLEPfO/l5QUnAjjGuvxhyJ3XckQtErfMLftF9aEWsacEhy0myMLVWW2silzAU8FTMq95zaBT0PvKNrhC6kYTCn5hcg9VPnYAOeB9ByQZEdSCfmcz/rlMaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104049; c=relaxed/simple;
	bh=Z5RznQDlREknmwNp/kUxXNjoOfZqaeyrG0QR6LJ886E=;
	h=Date:To:From:Subject:Message-Id; b=l6edfJvZe50TJRT1cS3TQ392RLK5/+ExNOBEYpisNILgE3D4LGfgCdWrHKUB+axWwgpuSHMU+tVKmhw0fHOE2vbrS0mrztKljdy+Wpi0N304/K/hI2KLLnDws1lt1EnW3qreMIP57GUNjlL9eth+rusOOadfN+apjNnaEk2kHbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pjPDM3S0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pjPDM3S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEBEC113CD;
	Fri, 26 Apr 2024 04:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104049;
	bh=Z5RznQDlREknmwNp/kUxXNjoOfZqaeyrG0QR6LJ886E=;
	h=Date:To:From:Subject:From;
	b=pjPDM3S0cuDOdaDJQ4F/Qmd5HqfU7AbG3jpq29bB40KGrSuINUEbfFSEB1vbrH7/O
	 fJJx9kXdi1IGsPCQG+jE4eM41/IZtlfeJ022L+Wb5Bcc+BN64NriuV2HiK9d4rm3d0
	 IhcmCkCKJwCUT12Z1Do9oPgOXcjUa7R0aROJdtis=
Date: Thu, 25 Apr 2024 21:00:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,muchun.song@linux.dev,mpe@ellerman.id.au,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-config_pgtable_has_huge_leaves.patch removed from -mm tree
Message-Id: <20240426040049.4AEBEC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/Kconfig: CONFIG_PGTABLE_HAS_HUGE_LEAVES
has been removed from the -mm tree.  Its filename was
     mm-kconfig-config_pgtable_has_huge_leaves.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/Kconfig: CONFIG_PGTABLE_HAS_HUGE_LEAVES
Date: Wed, 27 Mar 2024 11:23:20 -0400

Patch series "mm/gup: Unify hugetlb, part 2", v4.

The series removes the hugetlb slow gup path after a previous refactor
work [1], so that slow gup now uses the exact same path to process all
kinds of memory including hugetlb.

For the long term, we may want to remove most, if not all, call sites of
huge_pte_offset().  It'll be ideal if that API can be completely dropped
from arch hugetlb API.  This series is one small step towards merging
hugetlb specific codes into generic mm paths.  From that POV, this series
removes one reference to huge_pte_offset() out of many others.

One goal of such a route is that we can reconsider merging hugetlb
features like High Granularity Mapping (HGM).  It was not accepted in the
past because it may add lots of hugetlb specific codes and make the mm
code even harder to maintain.  With a merged codeset, features like HGM
can hopefully share some code with THP, legacy (PMD+) or modern
(continuous PTEs).

To make it work, the generic slow gup code will need to at least
understand hugepd, which is already done like so in fast-gup.  Due to the
specialty of hugepd to be software-only solution (no hardware recognizes
the hugepd format, so it's purely artificial structures), there's chance
we can merge some or all hugepd formats with cont_pte in the future.  That
question is yet unsettled from Power side to have an acknowledgement.  As
of now for this series, I kept the hugepd handling because we may still
need to do so before getting a clearer picture of the future of hugepd. 
The other reason is simply that we did it already for fast-gup and most
codes are still around to be reused.  It'll make more sense to keep
slow/fast gup behave the same before a decision is made to remove hugepd.

There's one major difference for slow-gup on cont_pte / cont_pmd handling,
currently supported on three architectures (aarch64, riscv, ppc).  Before
the series, slow gup will be able to recognize e.g.  cont_pte entries with
the help of huge_pte_offset() when hstate is around.  Now it's gone but
still working, by looking up pgtable entries one by one.

It's not ideal, but hopefully this change should not affect yet on major
workloads.  There's some more information in the commit message of the
last patch.  If this would be a concern, we can consider teaching slow gup
to recognize cont pte/pmd entries, and that should recover the lost
performance.  But I doubt its necessity for now, so I kept it as simple as
it can be.

Patch layout
=============

Patch 1-8:    Preparation works, or cleanups in relevant code paths
Patch 9-11:   Teach slow gup with all kinds of huge entries (pXd, hugepd)
Patch 12:     Drop hugetlb_follow_page_mask()

More information can be found in the commit messages of each patch.

[1] https://lore.kernel.org/all/20230628215310.73782-1-peterx@redhat.com
[2] https://lore.kernel.org/r/20240321215047.678172-1-peterx@redhat.com




Introduce a config option that will be selected as long as huge leaves are
involved in pgtable (thp or hugetlbfs).  It would be useful to mark any
code with this new config that can process either hugetlb or thp pages in
any level that is higher than pte level.

Link: https://lkml.kernel.org/r/20240327152332.950956-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240327152332.950956-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/Kconfig~mm-kconfig-config_pgtable_has_huge_leaves
+++ a/mm/Kconfig
@@ -850,6 +850,12 @@ config READ_ONLY_THP_FOR_FS
 endif # TRANSPARENT_HUGEPAGE
 
 #
+# The architecture supports pgtable leaves that is larger than PAGE_SIZE
+#
+config PGTABLE_HAS_HUGE_LEAVES
+	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
+
+#
 # UP and nommu archs use km based percpu allocator
 #
 config NEED_PER_CPU_KM
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

