Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D938C143C60;
	Mon,  8 Apr 2024 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712598520; cv=none; b=Azmq1VrHtlJVq/yB6Iai0b+abk9REtuay0XroMq0ZLpAgP/QDImUNuPIZ5ruyBfBPiNodW86NMpFMKg7KDGd7hU++28EtS6a7S5fnB5CexoVxA9shC/njLHZ3Z3wPLfat3GHlVozPOMGCoRntrlYWgrOq60Y7U4I6cbU8QN6nqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712598520; c=relaxed/simple;
	bh=fqz54rmuIE6mCMQlkOy2gdyljnN6Nro14MmFVNfiuB8=;
	h=Date:To:From:Subject:Message-Id; b=Zx8+oHeUBuD6xjWp0VgZdy5yDCspEUuNKpuKaZ+ZI5tRgTCItURNVMIJjvArnkpowZi/oA3xL6lHqjRb6B/hjHWr6/80clVPBspE9tsTLSByqH2SyF67O+NWR6A6JVBEXVywlSWCiodNq4SS3J5HeMqzU9IDBzGB7CaWUlaKSdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nnf79NCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nnf79NCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4906FC433C7;
	Mon,  8 Apr 2024 17:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712598519;
	bh=fqz54rmuIE6mCMQlkOy2gdyljnN6Nro14MmFVNfiuB8=;
	h=Date:To:From:Subject:From;
	b=nnf79NCkEltSYRsqASHQmIpptUaM9B5POZTJQhsaRej9b6ijD+N0VmbDaINd4GWnn
	 BSiRwBMe4fUXmZwbISdKKTaZXKmtP0G2HM5CGiil6gnsfGS1P9moLzSNCsz8oDSjX6
	 tuXMeNdYqniDVvpfkYF8sVZj4GZiIB4MD4zVJd/o=
Date: Mon, 08 Apr 2024 10:48:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,david@redhat.com,axelrasmussen@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-allow-hugetlb-change-protection-upon-poison-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20240408174839.4906FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: Allow hugetlb change protection upon poison entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-allow-hugetlb-change-protection-upon-poison-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-allow-hugetlb-change-protection-upon-poison-entry.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/userfaultfd: Allow hugetlb change protection upon poison entry
Date: Fri, 5 Apr 2024 19:19:20 -0400

After UFFDIO_POISON, there can be two kinds of hugetlb pte markers, either
the POISON one or UFFD_WP one.

Allow change protection to run on a poisoned marker just like !hugetlb
cases, ignoring the marker irrelevant of the permission.

Here the two bits are mutual exclusive.  For example, when install a
poisoned entry it must not be UFFD_WP already (by checking pte_none()
before such install).  And it also means if UFFD_WP is set there must have
no POISON bit set.  It makes sense because UFFD_WP is a bit to reflect
permission, and permissions do not apply if the pte is poisoned and
destined to sigbus.

So here we simply check uffd_wp bit set first, do nothing otherwise.

Attach the Fixes to UFFDIO_POISON work, as before that it should not be
possible to have poison entry for hugetlb (e.g., hugetlb doesn't do swap,
so no chance of swapin errors).

Link: https://lkml.kernel.org/r/20240405231920.1772199-1-peterx@redhat.com
Link: https://lore.kernel.org/r/000000000000920d5e0615602dd1@google.com
Reported-by: syzbot+b07c8ac8eee3d4d8440f@syzkaller.appspotmail.com
Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-userfaultfd-allow-hugetlb-change-protection-upon-poison-entry
+++ a/mm/hugetlb.c
@@ -7044,9 +7044,13 @@ long hugetlb_change_protection(struct vm
 			if (!pte_same(pte, newpte))
 				set_huge_pte_at(mm, address, ptep, newpte, psize);
 		} else if (unlikely(is_pte_marker(pte))) {
-			/* No other markers apply for now. */
-			WARN_ON_ONCE(!pte_marker_uffd_wp(pte));
-			if (uffd_wp_resolve)
+			/*
+			 * Do nothing on a poison marker; page is
+			 * corrupted, permissons do not apply.  Here
+			 * pte_marker_uffd_wp()==true implies !poison
+			 * because they're mutual exclusive.
+			 */
+			if (pte_marker_uffd_wp(pte) && uffd_wp_resolve)
 				/* Safe to modify directly (non-present->none). */
 				huge_pte_clear(mm, address, ptep, psize);
 		} else if (!huge_pte_none(pte)) {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-allow-hugetlb-change-protection-upon-poison-entry.patch
mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch
selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation-fix.patch
mm-kconfig-config_pgtable_has_huge_leaves.patch
mm-hugetlb-declare-hugetlbfs_pagecache_present-non-static.patch
mm-make-hpage_pxd_-macros-even-if-thp.patch
mm-introduce-vma_pgtable_walk_beginend.patch
mm-arch-provide-pud_pfn-fallback.patch
mm-arch-provide-pud_pfn-fallback-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-gup-refactor-record_subpages-to-find-1st-small-page.patch
mm-gup-handle-hugetlb-for-no_page_table.patch
mm-gup-cache-pudp-in-follow_pud_mask.patch
mm-gup-handle-huge-pud-for-follow_pud_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask.patch
mm-gup-handle-huge-pmd-for-follow_pmd_mask-fix.patch
mm-gup-handle-hugepd-for-follow_page.patch
mm-gup-handle-hugetlb-in-the-generic-follow_page_mask-code.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

