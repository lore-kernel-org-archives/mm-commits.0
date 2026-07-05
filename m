Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B623603DD
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236702; cv=none; b=oWF/rYB9SXmdGe2YycMD4IurZ9Fv+jHdkgcVrGCCPT5UhMZkdUABd/pBxdD+CWZhow6Ki5tTKM+RNz9riQaz8Ww5bsm5UNnvFkGhCUqzEPq1zTHeJbbVsJc3/SjQQjeGUVMDjYTemNErgHSh1Ub5VIZ6bDmeAHIfhq+WpiGdL3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236702; c=relaxed/simple;
	bh=p3/Xow0tMlngIKtdRvXOF3nt2obEvH8wVoGoon9o4Ow=;
	h=Date:To:From:Subject:Message-Id; b=B6hbhqjFAqtSAX6Gx06nu/G42nDy0qi0saFDVXuUb+apTg1jTAzNLuxAuT3eofoWbxO2Q6b3vR56/LSHmhEEOG7Gwq7ccu+OCyyjPaCtInSvRgPMbtxJpCQZiioAWta603/62JFSBK+w+NQFn6uqs0pYdQ+OdlPqAqCV7mLROmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DgErG+DW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DgErG+DW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A128F1F000E9;
	Sun,  5 Jul 2026 07:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236700;
	bh=8yXy9EF4QAmEdqZjGY2J07bxWMaKajratHkkPjJzVQ0=;
	h=Date:To:From:Subject;
	b=DgErG+DWkNAxsqykxu5881yeIT73okiDG0oAPM0mDUfohJCC0m21XL1y7/zDHxEXw
	 t2IfubMLvgEfmI1btzSq2Zp1WRXi8363Z/AnMc8B0uOmyJwbTea7VEq4496TrUkLBJ
	 Ohpm+DHDdIG0lEtrDtSMTe6cmcChFpbAUw/pf0Zk=
Date: Sun, 05 Jul 2026 00:31:40 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-virt-use-higher-level-allocator-api.patch added to mm-new branch
Message-Id: <20260705073140.A128F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/virt: use higher-level allocator API
has been added to the -mm mm-new branch.  Its filename is
     x86-virt-use-higher-level-allocator-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-virt-use-higher-level-allocator-api.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: x86/virt: use higher-level allocator API
Date: Fri, 03 Jul 2026 12:31:50 +0000

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-10-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Assisted-by: Gemini:unknown-version
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/virt/hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/virt/hw.c~x86-virt-use-higher-level-allocator-api
+++ a/arch/x86/virt/hw.c
@@ -196,7 +196,7 @@ static __init int __x86_vmx_init(void)
 		struct page *page;
 		struct vmcs *vmcs;
 
-		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+		page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
 		if (WARN_ON_ONCE(!page)) {
 			x86_vmx_exit();
 			return -ENOMEM;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-secretmem-disable-under-highmem.patch
mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch
mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch
mm-name-some-args-in-a-function-declaration.patch
mm-split-out-internal-page_alloch.patch
mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch
mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch
mm-move-some-stuff-to-mm-page_alloch.patch
perf-x86-intel-use-higher-level-allocator-api.patch
kvm-vmx-use-higher-level-allocator-api.patch
x86-virt-use-higher-level-allocator-api.patch
sgi-xp-use-higher-level-allocator-api.patch
net-funeth-switch-to-higher-level-allocator-api.patch
mm-remove-__alloc_pages_node.patch
mm-move-__alloc_pages-to-mm-page_alloch.patch
mm-replace-__gfp_no_codetag-with-alloc_no_codetag.patch
mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch
mm-factor-out-can_spin_trylock.patch

