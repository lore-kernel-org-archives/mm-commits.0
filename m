Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85624347DD
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 19:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753817303; cv=none; b=NuggIamB+hAvW5qfH9qTz0Ah66E0y+f2dIDeRAu05b13ictAKuJGhd3nEwCpbnvVR7PUhV8rs7CwTYi8edoVV4c7DxBw4v6+qifhZWklBvl9HKY1d3cTibljLPWE3Q2bN57Bq6P5FT8JT+zHy7nBU0SLxh4UhPxtO6aX0nMd8nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753817303; c=relaxed/simple;
	bh=KONCInvwYvsrfPTxkPZF2vKNeK23wyhN2fLRniieEzI=;
	h=Date:To:From:Subject:Message-Id; b=DRGkQF+3SbuPPqv468ZTRR21wAo/Yw/E3ooFaHDUNBM4xDx9ckfDW6rqYvRh11J4D9KGEm/R0Tb9batghDnja9535VeTudixN6u4AVRkoablbHWikg9/CT6L8O2N3yglOVsSPpcutMjRIW3rCeUEz8lvwJtRORlYlnBsK0UlUoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dob2+gJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dob2+gJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3255AC4CEEF;
	Tue, 29 Jul 2025 19:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753817303;
	bh=KONCInvwYvsrfPTxkPZF2vKNeK23wyhN2fLRniieEzI=;
	h=Date:To:From:Subject:From;
	b=Dob2+gJ+Qptrelet7JPcV24D22JLXE9+dJA51+aqwqDh+d53TDqq2w1B6mSWeMJsj
	 aDFkkyOXO5Cl5gpgBK8VymyD3Bgx3MxC9/2CWIy8t4tYh1NSrMNlCMpZkPvuYQvug0
	 s7h16h+Ng/x9wdY9LHImTszOTw6Q3+0fYKTssjf4=
Date: Tue, 29 Jul 2025 12:28:22 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-add-test-for-kexec-handover-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250729192823.3255AC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-add-test-for-kexec-handover-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-add-test-for-kexec-handover-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-add-test-for-kexec-handover-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Mike Rapoport <rppt@kernel.org>
Subject: kho-add-test-for-kexec-handover-fix
Date: Tue, 29 Jul 2025 12:14:51 +0300

fix section mismatch

Link: https://lkml.kernel.org/r/aIiRC8fXiOXKbPM_@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kho.c~kho-add-test-for-kexec-handover-fix
+++ a/lib/test_kho.c
@@ -194,7 +194,7 @@ static int kho_test_save(void)
 	return register_kho_notifier(&kho_test_nb);
 }
 
-static int __init kho_test_restore_data(const void *fdt, int node)
+static int kho_test_restore_data(const void *fdt, int node)
 {
 	const unsigned int *nr_folios;
 	const phys_addr_t *folios_info;
_

Patches currently in -mm which might be from rppt@kernel.org are

execmem-drop-unused-execmem_update_copy.patch
execmem-introduce-execmem_alloc_rw.patch
execmem-rework-execmem_cache_free.patch
execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch
execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch
execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch
x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch
x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch
kho-add-test-for-kexec-handover.patch
kho-add-test-for-kexec-handover-fix.patch

