Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF3B2580C7
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 21:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750800866; cv=none; b=ZQkwoAc0MrSxyOFQGFHpDhmn3vOWRwujSKsWEimPgVyie85BSWsMVT3id4Fviq6lNU8kC6/aNA0N+pjwl0/q6RzQKd0p/APqVF3NoKCioiySdvG45H92DKWh7s7T13xUJ8V0fMQ6aAJteJlZHUuaz0uhMssXxtrFzRpOUhbXSuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750800866; c=relaxed/simple;
	bh=cRin8p1M5ETfp3obs51yRxUQHB2zS0T4UnrA0vE+L+g=;
	h=Date:To:From:Subject:Message-Id; b=CbQLdhkhqwPWItU8jm7WxdlGGSZ8CNH7ZNpSg/XMZe+0R7Wusmt93MG/i3EOZmq36Q6EoBKLOwqAjH+P1IbsqwVUnkcthZ1HgMQ5b3A+EpqHr1LXzReFn6shWRx9woT/zMIlQkLgu6AnRZOeOxNtJ9QKTo5zdmhVvQtySO4oBKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qpKkaHbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qpKkaHbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0CBC4CEEF;
	Tue, 24 Jun 2025 21:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750800866;
	bh=cRin8p1M5ETfp3obs51yRxUQHB2zS0T4UnrA0vE+L+g=;
	h=Date:To:From:Subject:From;
	b=qpKkaHbZqVZKV0KfU43RDfClZinrXb9CNnJL20myuJRYt5FubGY1KR7/q/Eg6YdJ2
	 w/tNN7VoQVmpDlAY7UNSmxaBgorDLlVSetySikmlK6QymHy5rLR7OEsS5KYidTrfj4
	 p6KUqHGG8OCcxxpypxKYF/ycMXyJtxmNnHZ8S6FI=
Date: Tue, 24 Jun 2025 14:34:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch added to mm-new branch
Message-Id: <20250624213426.5E0CBC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: fix very subtle bug
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch

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
Subject: mm/madvise: fix very subtle bug
Date: Tue, 24 Jun 2025 14:14:19 +0100

With thanks to stress-ng --madvise :)

vma may have been updated (in the modify call in madvise_update_vma()), so
we can't assign prev = vma, we must first reassign vma to
madv_behavior->vma to account for this, before setting prev = vma.

Link: https://lkml.kernel.org/r/dca94cde-8afb-4eab-8e57-3f508624d670@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix
+++ a/mm/madvise.c
@@ -1665,8 +1665,8 @@ int madvise_walk_vmas(struct madvise_beh
 			vma = NULL;
 			madv_behavior->lock_dropped = false;
 		} else {
-			prev = vma;
 			vma = madv_behavior->vma;
+			prev = vma;
 		}
 
 		if (vma && range->end < vma->vm_end)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-files-to-mm-page-alloc-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
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

