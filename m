Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC3835F161
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236700; cv=none; b=KPR8Ba7MRf5RjJhLmE89aFrRsbvQ7LXal5iKiCgzQhc/ywe/s59bY3GT7EepjEk93HcI18pGGawD7yefqFpaZwBg8WGvCOVc0q8CTegyW1I9cGKc4ZkTT3la2jik3V1J5r4qCqjKOdV4mP7btCL8qugh3kY7rNDVmXtcQTaBe+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236700; c=relaxed/simple;
	bh=fdyxDhj7GwPhtL27r1HIArzH7nhKeUO6NPyns/UMhZg=;
	h=Date:To:From:Subject:Message-Id; b=ietO00AYgJEmr943MYe9G2L4pS6gX3lmOkMThr59Jpw/jweu/Tu2646k4a9mPZlx1fzRlJ3o2EQU6+CSwKa2T/W33rHStqqgpAgn07jTYkD/0Lc9jCznqTik3ciEWhM0JR2ClXMo8nvkqyZH7flI/vH4wW33NDMhyrKAsmWrjLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jfWwpKI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jfWwpKI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2631F000E9;
	Sun,  5 Jul 2026 07:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236698;
	bh=DRYdFnt5jEnrvWXYoggpx+eunf+7HtfZdN+Fz9UDLMY=;
	h=Date:To:From:Subject;
	b=jfWwpKI39GCLWOr4+6E8b6HTHdfwJiZoo5ex9yWvGGZATkhRUERr3luSUjs5nIt+7
	 CGiD+RC2xzqO06zVvZocxAayGiFy/WUbeXKU61+UiGt6iYDWi0OV2lYOtkXa+PvL3a
	 9WKAmKGuN7p/IklTFxZP5aoJn6ytbsEUXUCyq78s=
Date: Sun, 05 Jul 2026 00:31:38 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-vmx-use-higher-level-allocator-api.patch added to mm-new branch
Message-Id: <20260705073138.9D2631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KVM: VMX: use higher-level allocator API
has been added to the -mm mm-new branch.  Its filename is
     kvm-vmx-use-higher-level-allocator-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-vmx-use-higher-level-allocator-api.patch

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
Subject: KVM: VMX: use higher-level allocator API
Date: Fri, 03 Jul 2026 12:31:49 +0000

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-9-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Assisted-by: Gemini:unknown-version
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/vmx/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c~kvm-vmx-use-higher-level-allocator-api
+++ a/arch/x86/kvm/vmx/vmx.c
@@ -3028,7 +3028,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow,
 	struct page *pages;
 	struct vmcs *vmcs;
 
-	pages = __alloc_pages_node(node, flags, 0);
+	pages = alloc_pages_node(node, flags, 0);
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
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

