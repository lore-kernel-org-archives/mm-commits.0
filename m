Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D281552E4;
	Mon, 22 Apr 2024 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713815643; cv=none; b=qcNGryXBbpgDGsfgavWTb/f5W92zp6gH53QW8yf9XUJVLtvJdWBCo0Ao0MUMTaezxnY82fQEXNYfOfqW+4VMU24vFAMpBMFOUTW9gIKYaquULukRwHjpv2YMuqz7ShDtCxmwDHyJXhbkp6HFsCId1mPwsZszheJh07LFHWP6fpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713815643; c=relaxed/simple;
	bh=CKovM99CpAea3dMheTJmg8+vR1Kanfw2KSJtSVkjRRc=;
	h=Date:To:From:Subject:Message-Id; b=GAIPmawdQgx/Lj600T8g12tXRrIfr7xvf/8Ke5jmuBgLLU99RX2AAtgaVGmAAAtJ0q945hGlUVMPthHLIMkY//dgFeMf98iht5wwbdGRsL+3Xh9InW8gqzbwg/FvZrQCs523QRVw+gfputWJAl5i73M8xuBTnyEFh4sMRH5gxC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B5b7UUYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B5b7UUYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A49EC116B1;
	Mon, 22 Apr 2024 19:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713815643;
	bh=CKovM99CpAea3dMheTJmg8+vR1Kanfw2KSJtSVkjRRc=;
	h=Date:To:From:Subject:From;
	b=B5b7UUYkrkBYUy5OnfGU7K0Y7PA9b0ucykEbzDCWzHfL38IS+hQTUHgtjZklgQf9x
	 jkhAf+6eW74zr4GJmyROE+NjnKzz7LGLnuARDMw9OpKJESfQ57WmlPt6B2GvFmkIEJ
	 eazpy/1LlVMKQ00WeSWG032ocnKS0bAJA7sfe8fU=
Date: Mon, 22 Apr 2024 12:54:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nadav.amit@gmail.com,david@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch added to mm-hotfixes-unstable branch
Message-Id: <20240422195403.4A49EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: reset ptes when close() for wr-protected ones
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch

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
Subject: mm/userfaultfd: reset ptes when close() for wr-protected ones
Date: Mon, 22 Apr 2024 09:33:11 -0400

Userfaultfd unregister includes a step to remove wr-protect bits from all
the relevant pgtable entries, but that only covered an explicit
UFFDIO_UNREGISTER ioctl, not a close() on the userfaultfd itself.  Cover
that too.  This fixes a WARN trace.

Link: https://lore.kernel.org/all/000000000000ca4df20616a0fe16@google.com/
Analyzed-by: David Hildenbrand <david@redhat.com>
Link: https://lkml.kernel.org/r/20240422133311.2987675-1-peterx@redhat.com
Reported-by: syzbot+d8426b591c36b21c750e@syzkaller.appspotmail.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/userfaultfd.c~mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones
+++ a/fs/userfaultfd.c
@@ -895,6 +895,10 @@ static int userfaultfd_release(struct in
 			prev = vma;
 			continue;
 		}
+		/* Reset ptes for the whole vma range if wr-protected */
+		if (userfaultfd_wp(vma))
+			uffd_wp_range(vma, vma->vm_start,
+				      vma->vm_end - vma->vm_start, false);
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
 		vma = vma_modify_flags_uffd(&vmi, prev, vma, vma->vm_start,
 					    vma->vm_end, new_flags,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-missing-hugetlb_lock-for-resv-uncharge.patch
mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
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
mm-always-initialise-folio-_deferred_list-fix.patch
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
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

