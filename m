Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54FD339381
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465809; cv=none; b=JgVMj2CFxvPtvKwgGEoHccGXCsn3abT2cJMEwnEW6k1l65DPeNYN6nTn9wa8QdhGkNZNK8CJY906FnE5Y2Ntsu5NMEHDldGUII4MNV8enERFUAtYT+jM5Xjs6QWHIPDZygTM9l9CFZ2QVzjF48RgR73F7deWZZ/RsX84WsWR88E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465809; c=relaxed/simple;
	bh=Pm5PK/7UxkkbkTabC1N2h+PzRkMh9THLFPRJw3XxE4Y=;
	h=Date:To:From:Subject:Message-Id; b=XzJ+ghHHcEITLrZGpK9geOwzW2wjcAQX3R/JXl9hH7+FSDKmJDpNvBdFdyugUgAqhqt9V2rV/ztY1mkcVubRuM/MCmtHJ5rCu2Pp2GYNf8N6YP+sCQBhnWWC2KO/TcnKaB7e9vLaP3wDXThF19PqOVQudhY83gOkTlHyDg2ZIaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMmR6yH1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMmR6yH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF011F00A3A;
	Fri, 31 Jul 2026 02:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465806;
	bh=UW+nOLhIY5YVwQlbB+oHj/HxqDGmaEY6Fx8wa7aF3tk=;
	h=Date:To:From:Subject;
	b=HMmR6yH1rOxWfjjIjDCoVod28MlVmWfBPSf6qpIyB0oHxKC+rP3yC9Sn1w3odyWBR
	 isZIXVGHY8jnlaGK7pmh5nnOc7eVOmU+i7R7P3OAopNNbkexxMk6nqCDP+Zmy2CgRU
	 icbwIQDX6g8q/1FIAe/hifd1mCLVOX+ZrCzPjscs=
Date: Thu, 30 Jul 2026 19:43:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tglx@kernel.org,surenb@google.com,mingo@redhat.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-virt-use-higher-level-allocator-api.patch removed from -mm tree
Message-Id: <20260731024326.6AF011F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/virt: use higher-level allocator API
has been removed from the -mm tree.  Its filename was
     x86-virt-use-higher-level-allocator-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

