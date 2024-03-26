Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD58452F8A
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476487; cv=none; b=hcmEhGoq/SM99vWml30/b6hD4gyU3zHTN9oHhgiN9GZIY1WQxTez++8fjQbFW2j4GQlgWcwQp+whYdXS0pGCSU4TFPMx/+qKDkxeKBjUOOs0buXrWrkdi5oG2Ly5qwmkMG9yOfzNqULvjNAv/9bAk2hWyFOJCL17hlpq1HYinVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476487; c=relaxed/simple;
	bh=j41/wFbBdluQ9yntPhtA/hOh9Y75hBwd9uxZtNo+fz8=;
	h=Date:To:From:Subject:Message-Id; b=NaB0N+7cd5MFq1vySz7F3nTZRhk666HtsWMQtLfv64Kwx7URmfXimILrDYdW11Uya/OuD6rh1dt6yq0QiFw0zlHxCSfe1HDYzhGcMQbonmR+/R8f0geA8k4OjpFSg/pxBU0+JEe+9edWAEAhu18uQUrTmZ+RAtS2z6uw/b1cQpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GI4vyXXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GI4vyXXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D7FC433C7;
	Tue, 26 Mar 2024 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476487;
	bh=j41/wFbBdluQ9yntPhtA/hOh9Y75hBwd9uxZtNo+fz8=;
	h=Date:To:From:Subject:From;
	b=GI4vyXXfXTz9qLfdN5PhrZVIpBxMXFNdLv6nnUx4RrSY2sbyUb3GrsmeUMbCqAhEe
	 aVKDKPFQgd+kQhqScqyDt2Nhtn0Kv/SyQ/EDz2P46EMX4kxp4KlF+jKqg9a1bEqsql
	 7vLfQr9EfNwa5RKt9S2ijUs6bWMH7Ocu6Eeiw8Ys=
Date: Tue, 26 Mar 2024 11:08:06 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,david@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch removed from -mm tree
Message-Id: <20240326180807.47D7FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: fix missing pte marker for !page on pte zaps
has been removed from the -mm tree.  Its filename was
     mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/memory: fix missing pte marker for !page on pte zaps
Date: Wed, 13 Mar 2024 17:31:07 -0400

Commit 0cf18e839f64 of large folio zap work broke uffd-wp.  Now mm's uffd
unit test "wp-unpopulated" will trigger this WARN_ON_ONCE().

The WARN_ON_ONCE() asserts that an VMA cannot be registered with
userfaultfd-wp if it contains a !normal page, but it's actually possible. 
One example is an anonymous vma, register with uffd-wp, read anything will
install a zero page.  Then when zap on it, this should trigger.

What's more, removing that WARN_ON_ONCE may not be enough either, because
we should also not rely on "whether it's a normal page" to decide whether
pte marker is needed.  For example, one can register wr-protect over some
DAX regions to track writes when UFFD_FEATURE_WP_ASYNC enabled, in which
case it can have page==NULL for a devmap but we may want to keep the
marker around.

Link: https://lkml.kernel.org/r/20240313213107.235067-1-peterx@redhat.com
Fixes: 0cf18e839f64 ("mm/memory: handle !page case in zap_present_pte() separately")
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps
+++ a/mm/memory.c
@@ -1536,7 +1536,9 @@ static inline int zap_present_ptes(struc
 		ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
 		arch_check_zapped_pte(vma, ptent);
 		tlb_remove_tlb_entry(tlb, pte, addr);
-		VM_WARN_ON_ONCE(userfaultfd_wp(vma));
+		if (userfaultfd_pte_wp(vma, ptent))
+			zap_install_uffd_wp_if_needed(vma, addr, pte, 1,
+						      details, ptent);
 		ksm_might_unmap_zero_page(mm, ptent);
 		return 1;
 	}
_

Patches currently in -mm which might be from peterx@redhat.com are

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

