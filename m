Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EFA35C19F
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 04:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785990919; cv=none; b=a4EzoMHZ5FvNSyY8ETckoneEUFx10qgciqKMpDTvQtt0kzrzhaTsUbeOfJwSO7CajIGhfg6Pn3g6lWOYUoO3Vrn0FfWNI9l8j+5xfdlRzmY7sIMOa3j2GdqvlpMzsOpGR1/VY5Je1qLcg1os2K1j+UpUVKqyHIiylZgKGoQQSKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785990919; c=relaxed/simple;
	bh=H5G/Ol1sh98hfQh5joR5bJsumHFnew919WYu3geHZFo=;
	h=Date:To:From:Subject:Message-Id; b=EoBtwvSyCZpbWL9J7VRMjosl8qbjGiiDzy207pDL17HFUBdANN92EtqovDR2jbs5F2KpFQEz4dmqdztcOG6SweHF7vtp7bDDc/DV6fTtVaJjO4dliWK3hDwJUrTSrT5Zh051fVsdrWov0tBw+7WRPf4Rx2AtkSHlVzG9oB82gYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EPBh7OHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPBh7OHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE27D1F000E9;
	Thu,  6 Aug 2026 04:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785990917;
	bh=6ZRlLLF1AW+UPONJld8ssfpXo8hY9eT2ySNElrb09Ig=;
	h=Date:To:From:Subject;
	b=EPBh7OHcO14AX8hYPYVwLREXRC4twOO8/GeW3GD1ywMs2VYyvHXVyO0pk7cvgv5X7
	 WtewdJFXg39H4xXtqmjQkco412EAT9TY8apDLmhCIsG3YI/hcPjSkVy2rfYisndhDs
	 UsJ5+1iCYm6MHBvHLi6Ka/4IWP1hx7LVSYyxbE5c=
Date: Wed, 05 Aug 2026 21:35:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch added to mm-new branch
Message-Id: <20260806043517.BE27D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: drop duplicate test_seal_mprotect_two_vma_with_gap() call
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: drop duplicate test_seal_mprotect_two_vma_with_gap() call
Date: Thu, 6 Aug 2026 11:08:50 +0800

mseal_test main() invokes test_seal_mprotect_two_vma_with_gap() twice. 
The second run repeats all assertions with no benefit.  Drop the duplicate
call.

Link: https://lore.kernel.org/20260806030850.76077-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -1876,7 +1876,7 @@ int main(void)
 	if (!pkey_supported())
 		ksft_print_msg("PKEY not supported\n");
 
-	ksft_set_plan(88);
+	ksft_set_plan(87);
 
 	test_seal_addseal();
 	test_seal_unmapped_start();
@@ -1914,7 +1914,6 @@ int main(void)
 	test_seal_mprotect_partial_mprotect(true);
 
 	test_seal_mprotect_two_vma_with_gap();
-	test_seal_mprotect_two_vma_with_gap();
 
 	test_seal_mprotect_merge(false);
 	test_seal_mprotect_merge(true);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-factor-out-hmm_buffer_alloc-to-consolidate-buffer-setup.patch
selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
ksm-update-comments-and-docs-to-reference-folio-mapping.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch
selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

