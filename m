Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256381F5F6
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 01:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976549; cv=none; b=eIeNMKEWMjdatsaFmFCyHtXg8mdXCMieVh9WSmaJ2W8UxrCcYrpHXvp95ob4uzdNbg7CffR1HEybQGtjHH42iq63+6fySMlpmFCsx3tPV2+NKUtPrY2MU7uSmOil9RRlAQzcD4YKpbLFiARWWvPRJMBt+GhY8Fr6yjxpEwJeIIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976549; c=relaxed/simple;
	bh=JH0B7PiaarLBMWwrUdAmPi9+gAiXvZVlyDyslzwc51k=;
	h=Date:To:From:Subject:Message-Id; b=tL7dbZkTwb28ojguH12Vit6kQrmU13gycMV/wZTXcOhaygjUXwLR6WNtb8xDwpCxEXgORjCwycJLwqdLsK50P35yy+qsf9WkbscmZ80ytQ1zXMXr9dEOIF2KzETaxmKOKbWCG/bBYWESkp4oGbGvAiJNX98A59IyQFnNSmr7JSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xJEQp/ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xJEQp/ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F30C4CEE3;
	Sun, 20 Jul 2025 01:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976548;
	bh=JH0B7PiaarLBMWwrUdAmPi9+gAiXvZVlyDyslzwc51k=;
	h=Date:To:From:Subject:From;
	b=xJEQp/gewklOZJaR/ZSEbggiea/JZfwjY+xg7tP9/BOFh6oNE7jplJmCCwra/wxO1
	 5Lp9cvJ/4sExshEUIM91QCb3ERaTXqnBOSAlh3yo6ttEd/wixeOw3thEYGqYoyej/V
	 SMdaB7CLtNx35yQIb5TCSx/FFiQr5NXNUtMxTeeA=
Date: Sat, 19 Jul 2025 18:55:47 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch removed from -mm tree
Message-Id: <20250720015548.85F30C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: correct comment
has been removed from the -mm tree.  Its filename was
     mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch

This patch was dropped because it was folded into mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch

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
@@ -144,8 +144,8 @@ static int replace_anon_vma_name(struct
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

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

