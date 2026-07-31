Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677C033937A
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465806; cv=none; b=DenrXlmVB8y+qpPgYCBsj5Ea+YMb7GLEVMrepl5jKW6oEBNNLVOgJWLTCHN5o3CiqvtDG5kqv4f6WvXlax70hbAhYEuqEQg8TzL+JzOp8tnlusSxelMEx7p8uZR0dq72F8HKuFg+Uv7FMhKA9QLJBQtyd9x7NDCWWemQJfeFYQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465806; c=relaxed/simple;
	bh=XC0Namh2K7wVzXNYbKrCYbnm4VYkDuomRYofQ9rLYnc=;
	h=Date:To:From:Subject:Message-Id; b=bWIxF+dR8/zSOnDPbnJjhxlyR5aWIWyL7B8yVRMwiXEkYbdZehupDF3KvkMZ2r+v9Ivf655bzv5QPj2jtO/3ZILZZleYBQ5YtPTbih2H58lY9gUEF3HCIlogiRYO/a3dVzuxkB04X9sr5cVZ8uUJoNK7wbNpwsTH+Q4/oh48UQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6loo8c9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6loo8c9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8311F000E9;
	Fri, 31 Jul 2026 02:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465805;
	bh=hjN36Ijep2ABflqgykw2Uoq7D72yXqaq2JPZDPY6Slg=;
	h=Date:To:From:Subject;
	b=f6loo8c9gTXBmLXZVNEmrEFaKlu55J8dmTnftin9EOpiA5KigfGnNey5BzLti/SzS
	 KnKtkbL1vaYT5z7aBjtVEI301AmNJhn6V3IbRO0wmaHCmXGVZcsXrnbY1KCDmd+AYH
	 gWusX1hLvnkXEa4MpoMOsE2arzDIxtd3QI8ZC5r0=
Date: Thu, 30 Jul 2026 19:43:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,seanjc@google.com,pbonzini@redhat.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kvm-vmx-use-higher-level-allocator-api.patch removed from -mm tree
Message-Id: <20260731024325.3C8311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: VMX: use higher-level allocator API
has been removed from the -mm tree.  Its filename was
     kvm-vmx-use-higher-level-allocator-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3027,7 +3027,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow,
 	struct page *pages;
 	struct vmcs *vmcs;
 
-	pages = __alloc_pages_node(node, flags, 0);
+	pages = alloc_pages_node(node, flags, 0);
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

