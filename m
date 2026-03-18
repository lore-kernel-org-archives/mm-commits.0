Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EA03DFC8F
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773858807; cv=none; b=YJXAaDBG2zrBS9FPS4SIrc5xMo49RLX6su5lNmAOsYrauPOxeDAFP79i7oCYIK8dBoctTjL8Eu4k7vb7XeAVPdS3vvpymxBGURIFW1HhTBNO6VoCSyXGNtHImSqbR8duvUBlUyp9WfsS2/rFGiZ/YEVLdpqlWVPY5FiPEoJiITw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773858807; c=relaxed/simple;
	bh=28ropGPBc9Fy5zZVTp+XJBxMA6hvgXXc0xztM/pDRaY=;
	h=Date:To:From:Subject:Message-Id; b=Yn8VgiMdfJl6lTizYJM2LSOPi3vqEuY3INMHLVEVwP+fTP9a+bkJ/uzR1U+RGRo5qgYvPl0a912oTYFhZGRoMRP4jNYtGoN9yGhiVkLIdfSpLtToayFjeuRynd5VHSzm8fY96GomjD0b7mQjRy9kQnXplnqkN0Zs5/I7qfx9hdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s+QZZgwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s+QZZgwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A684C19421;
	Wed, 18 Mar 2026 18:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773858807;
	bh=28ropGPBc9Fy5zZVTp+XJBxMA6hvgXXc0xztM/pDRaY=;
	h=Date:To:From:Subject:From;
	b=s+QZZgwSZXJs/4GsNVFe9QAXItwAkWlhGngxZusuoZLoSD/mKRJ4bhI18iZGX+ZhY
	 x7moLk8bYTVF2B5INP727AnASwJ9dKDdVoJqqKMtoyMInIFmkiZGtfobnxUHukAfid
	 KZp8vlnfirWyYtYCiCycW7suIqhm/9KCbESiYLAk=
Date: Wed, 18 Mar 2026 11:33:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sashal@kernel.org,riel@surriel.com,liam.howlett@oracle.com,jiakaipeanut@gmail.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-clear-vma-anon_vma-on-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20260318183327.2A684C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: clear vma->anon_vma on error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-rmap-clear-vma-anon_vma-on-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-clear-vma-anon_vma-on-error.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/rmap: clear vma->anon_vma on error
Date: Wed, 18 Mar 2026 12:26:32 +0000

Commit 542eda1a8329 ("mm/rmap: improve anon_vma_clone(),
unlink_anon_vmas() comments, add asserts") alters the way errors are
handled, but overlooked one important aspect of clean up.

When a VMA encounters an error state in anon_vma_clone() (that is, on
attempted allocation of anon_vma_chain objects), it cleans up partially
established state in cleanup_partial_anon_vmas(), before returning an
error.

However, this occurs prior to anon_vma->num_active_vmas being incremented,
and it also fails to clear the VMA's vma->anon_vma field, which remains in
place.

This is immediately an inconsistent state, because
anon_vma->num_active_vmas is supposed to track the number of VMAs whose
vma->anon_vma field references that anon_vma, and now that count is
off-by-negative-1 for each VMA for which this error state has occurred.

When VMAs are unlinked from this anon_vma, unlink_anon_vmas() will
eventually underflow anon_vma->num_active_vmas, which will trigger a
warning.

This will always eventually happen, as we unlink anon_vma's at process
teardown.

It could also cause maybe_reuse_anon_vma() to incorrectly permit the reuse
of an anon_vma which has active VMAs attached, which will lead to a
persistently invalid state.

The solution is to clear the VMA's anon_vma field when we clean up partial
state, as the fact we are doing so indicates clearly that the VMA is not
correctly integrated into the anon_vma tree and thus this field is
invalid.

Link: https://lkml.kernel.org/r/20260318122632.63404-1-ljs@kernel.org
Fixes: 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reported-by: Sasha Levin <sashal@kernel.org>
Closes: https://lore.kernel.org/linux-mm/20260302151547.2389070-1-sashal@kernel.org/
Reported-by: Jiakai Xu <jiakaipeanut@gmail.com>
Closes: https://lore.kernel.org/linux-mm/CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com/
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sasha Levin (Microsoft) <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/rmap.c~mm-rmap-clear-vma-anon_vma-on-error
+++ a/mm/rmap.c
@@ -457,6 +457,13 @@ static void cleanup_partial_anon_vmas(st
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
+
+	/*
+	 * The anon_vma assigned to this VMA is no longer valid, as we were not
+	 * able to correctly clone AVC state. Avoid inconsistent anon_vma tree
+	 * state by resetting.
+	 */
+	vma->anon_vma = NULL;
 }
 
 /**
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-zswap-add-missing-kunmap_local.patch
mm-zswap-add-missing-kunmap_local-fix.patch
mm-rmap-clear-vma-anon_vma-on-error.patch
mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch
mm-mremap-correct-invalid-map-count-check.patch
mm-abstract-reading-sysctl_max_map_count-and-read_once.patch
mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch
mm-vma-add-vma_flags_empty-vma_flags_and-vma_flags_diff_pair.patch
tools-testing-vma-add-unit-tests-flag-empty-diff_pair-and.patch
mm-vma-add-further-vma_flags_t-unions.patch
tools-testing-vma-convert-bulk-of-test-code-to-vma_flags_t.patch
mm-vma-use-new-vma-flags-for-sticky-flags-logic.patch
tools-testing-vma-fix-vma-flag-tests.patch
mm-vma-add-append_vma_flags-helper.patch
tools-testing-vma-add-simple-test-for-append_vma_flags.patch
mm-unexport-vm_brk_flags-and-eliminate-vm_flags-parameter.patch
mm-vma-introduce-vma_flags_same.patch
mm-vma-introduce-_to_-helpers.patch
tools-testing-vma-test-that-legacy-flag-helpers-work-correctly.patch
mm-vma-introduce-vma_test-and-make-inlining-consistent.patch
tools-testing-vma-update-vma-flag-tests-to-test-vma_test.patch
mm-introduce-vma_flags_count-and-vma_test_single_mask.patch
tools-testing-vma-test-vma_flags_countvma_test_single_mask.patch
mm-convert-do_brk_flags-to-use-vma_flags_t.patch
mm-update-vma_supports_mlock-to-use-new-vma-flags.patch
mm-vma-introduce-vma_clear_flags.patch
tools-testing-vma-update-vma-tests-to-test-vma_clear_flags.patch
mm-vma-convert-as-much-as-we-can-in-mm-vmac-to-vma_flags_t.patch
mm-vma-convert-vma_modify_flags-to-use-vma_flags_t.patch
mm-vma-convert-__mmap_region-to-use-vma_flags_t.patch
mm-various-small-mmap_prepare-cleanups.patch
mm-add-documentation-for-the-mmap_prepare-file-operation-callback.patch
mm-document-vm_operations_struct-open-the-same-as-close.patch
mm-add-vm_ops-mapped-hook.patch
fs-afs-correctly-drop-reference-count-on-mapping-failure.patch
mm-add-mmap_action_simple_ioremap.patch
misc-open-dice-replace-deprecated-mmap-hook-with-mmap_prepare.patch
hpet-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch
stm-replace-deprecated-mmap-hook-with-mmap_prepare.patch
staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch
mm-allow-handling-of-stacked-mmap_prepare-hooks-in-more-drivers.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare.patch
uio-replace-deprecated-mmap-hook-with-mmap_prepare-in-uio_info.patch
mm-add-mmap_action_map_kernel_pages.patch
mm-on-remap-assert-that-input-range-within-the-proposed-vma.patch

