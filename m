Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C36253B71
	for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2025 23:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752536900; cv=none; b=Z/sGVlVhqRSVCdBrULWbnPJAJkbKra3WRpmnZMoidgS27aPyduQddfB3esD99bHH8DGaWh5s7mERlm+FQhpzHoZG3vt93dk2hlt2BMkDvHXF/FEYhYxZ7yuEVYTwqyQILtcHcOyWntLmRFa0DhRB4GhR5/qoo6Trz1pNv88QWhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752536900; c=relaxed/simple;
	bh=J+WOk24jinhBNGwgRqLCQSUeljzcXu8PmdJtmA+j8tI=;
	h=Date:To:From:Subject:Message-Id; b=rOlkRx8XA/i8NzzQcMlF7k19jS82jbGNlYLbZQh6UKSHfKGK85m2+KdCBUKOHDIqfOBKcGXT7xBMoIvyBTArLIIcHvAipw62tYpJYS43/oEwUEn/+o+1CGNo3BwFHkPZlmBhoNsOymT7VR85tsm2DpTDcAppC0bFbqTrAZWBSbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1FNcelZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1FNcelZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5C4C4CEF0;
	Mon, 14 Jul 2025 23:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752536899;
	bh=J+WOk24jinhBNGwgRqLCQSUeljzcXu8PmdJtmA+j8tI=;
	h=Date:To:From:Subject:From;
	b=1FNcelZ7Oi2CTWFPMNai8Mp71eEQvhJEIBrD1HpdZ2V6b1bLCk1DTrN62Hbp938k4
	 mfFwyDEpUH1RvsYjhK8yQY28mEg3BRLxhN8QFiHR8zRD+DTFDS1dv2tvObFJI1HzSu
	 tKdEuY34DYfLDFy0aL6Ic9rNDEHmH4tAAh75tG5I=
Date: Mon, 14 Jul 2025 16:48:18 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch added to mm-new branch
Message-Id: <20250714234819.9A5C4C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: correct comment
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch

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
Subject: mm/madvise: correct comment
Date: Mon, 14 Jul 2025 15:29:59 +0100

We only either update vm_flags or anon vma name, not a combination of the
two.  Per David.

Link: https://lkml.kernel.org/r/77f45b2e-a748-4635-9381-a5051091087f@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix
+++ a/mm/madvise.c
@@ -145,8 +145,8 @@ static int replace_anon_vma_name(struct
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 /*
- * Update the vm_flags and/or anon_name on region of a vma, splitting it or
- * merging it as necessary. Must be called with mmap_lock held for writing.
+ * Update the vm_flags or anon_name on region of a vma, splitting it or merging
+ * it as necessary. Must be called with mmap_lock held for writing.
  */
 static int madvise_update_vma(vm_flags_t new_flags,
 		struct madvise_behavior *madv_behavior)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch

