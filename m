Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E97A1F9EC0
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 01:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751939913; cv=none; b=pZ8eLNalmNTd4SAvcTO4LIDgw0t09ZuBmbBjyHgdBfi+vXgW0lV5D705dfDhKXmMAelife/r8Z1OQrjXcQx1z8WzfJkljMdRmZ+Uvtx6n3PYxNXm1ut/qaSIoc92c/O+trXGuv8ueqpL0abnfMCYdXyAZUpGeL0dDug0iKKuHLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751939913; c=relaxed/simple;
	bh=p4/icbxYsf9GLYsaslhIwT+zAb6rCNno8G95Pp2KDPQ=;
	h=Date:To:From:Subject:Message-Id; b=SHt+LbEGYGfwCMrb2h3eA10XAUZ/MY+DZDHEvMM7D2DaZIUU/BO5oI+pGhJClzojLcalsBTTbDdl1AXNnSSxByZD7q+2RkctiVasGU7rFMlvClSXtOBvncA47myeL4PS2rFy0IS2qVKlibTwyl8/aCsNjcZOLmHFafeRiERp0FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d9JUdfoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d9JUdfoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89A8C4CEE3;
	Tue,  8 Jul 2025 01:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751939912;
	bh=p4/icbxYsf9GLYsaslhIwT+zAb6rCNno8G95Pp2KDPQ=;
	h=Date:To:From:Subject:From;
	b=d9JUdfoEWSyfl/z8r6vtwUnMckFTuzm06veyRTzPQGc329JMcDNm1mF6I4jbtZldY
	 lb52WLbGHW+W2ak2CeX31ocnFuO6wbW8/T/IOrQoQB2iPFcWNpWcIyeh5fUIUl5lPb
	 6yJq49gqava7fEvUUs4WHaVqYfb6b9rwpcNJZ3EM=
Date: Mon, 07 Jul 2025 18:58:32 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,lkp@intel.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch added to mm-new branch
Message-Id: <20250708015832.C89A8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: add missing mremap_userfaultfd_fail() stub
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: add missing mremap_userfaultfd_fail() stub
Date: Mon, 7 Jul 2025 11:13:12 +0100

This covers the !CONFIG_USERFAULTFD case.

Link: https://lkml.kernel.org/r/3dadd329-484e-40c8-b04c-4c4ffab24957@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507071505.e2HFMCH2-lkp@intel.com/

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/userfaultfd_k.h~mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix
+++ a/include/linux/userfaultfd_k.h
@@ -372,6 +372,10 @@ static inline void mremap_userfaultfd_co
 {
 }
 
+static inline void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *ctx)
+{
+}
+
 static inline bool userfaultfd_remove(struct vm_area_struct *vma,
 				      unsigned long start,
 				      unsigned long end)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

