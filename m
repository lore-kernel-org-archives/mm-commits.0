Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204132586EC
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753820514; cv=none; b=lbvWVXEE/U/q3Dy534r6/+SeTv1vZIDnb998LXDFxAoiIwWdPQrURITUswZ1ldQyeCXmDSYIKhnlChC3UzZsuDOmbbXxJTd+kkN7jGQPwJJBcFsISDJ7SvWZ9XOLgiIW7xeKn432QZf0BWSlgltH4mZYtudH9L/IZyvRS9nL5Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753820514; c=relaxed/simple;
	bh=KVplUZELIzy91PpCHe7DVObSF2wk6m1Sv2ld6iStSHw=;
	h=Date:To:From:Subject:Message-Id; b=JGf7yw7dPs7phXC2U3dBb5fqszbnQm23Jt/jh2Mo/3gUy6kYW4iv377fho7yHOrtMbCQkagm4ZtLEbiGcVpofxIlR7IaUIG0X2Cs58fFLV3DozNjMRjmswEpEc95b41NLc5Aict24yjU1HjRKqvxxKVv74AUOd8209EXnXSaMbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KziQORML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KziQORML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0ECC4CEF6;
	Tue, 29 Jul 2025 20:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753820513;
	bh=KVplUZELIzy91PpCHe7DVObSF2wk6m1Sv2ld6iStSHw=;
	h=Date:To:From:Subject:From;
	b=KziQORML8QTxwMmuUQ5gTbv/HA2nI6mUJG2tS5jV2YLaEwkooRT+szvnBCH+/yEQb
	 Z3ySdXj7oEgXt9zONYtUEZK0RWLJuL7lc0eKFE3fNLbx3/tCaeVkDL7iJgSYoyBfFC
	 rwy0RvaP/m4Owz3ifyJzax70DPZPjXuDkPxQj9dw=
Date: Tue, 29 Jul 2025 13:21:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-type-for-vmalloc-vm_flags-fields.patch added to mm-unstable branch
Message-Id: <20250729202153.9D0ECC4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: correct type for vmalloc vm_flags fields
has been added to the -mm mm-unstable branch.  Its filename is
     mm-correct-type-for-vmalloc-vm_flags-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-type-for-vmalloc-vm_flags-fields.patch

This patch will later appear in the mm-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: correct type for vmalloc vm_flags fields
Date: Tue, 29 Jul 2025 12:49:06 +0100

Several functions refer to the unfortunately named 'vm_flags' field when
referencing vmalloc flags, which happens to be the precise same name used
for VMA flags.

As a result these were erroneously changed to use the vm_flags_t type
(which currently is a typedef equivalent to unsigned long).

Currently this has no impact, but in future when vm_flags_t changes this
will result in issues, so change the type to unsigned long to account for
this.

Link: https://lkml.kernel.org/r/20250729114906.55347-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Harry Yoo <harry.yoo@oracle.com>
Closes: https://lore.kernel.org/all/aIgSpAnU8EaIcqd9@hyeyoo/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c  |    8 ++++----
 mm/internal.h |    2 +-
 mm/nommu.c    |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/execmem.c~mm-correct-type-for-vmalloc-vm_flags-fields
+++ a/mm/execmem.c
@@ -26,7 +26,7 @@ static struct execmem_info default_execm
 
 #ifdef CONFIG_MMU
 static void *execmem_vmalloc(struct execmem_range *range, size_t size,
-			     pgprot_t pgprot, vm_flags_t vm_flags)
+			     pgprot_t pgprot, unsigned long vm_flags)
 {
 	bool kasan = range->flags & EXECMEM_KASAN_SHADOW;
 	gfp_t gfp_flags = GFP_KERNEL | __GFP_NOWARN;
@@ -82,7 +82,7 @@ struct vm_struct *execmem_vmap(size_t si
 }
 #else
 static void *execmem_vmalloc(struct execmem_range *range, size_t size,
-			     pgprot_t pgprot, vm_flags_t vm_flags)
+			     pgprot_t pgprot, unsigned long vm_flags)
 {
 	return vmalloc(size);
 }
@@ -283,7 +283,7 @@ out_unlock:
 
 static int execmem_cache_populate(struct execmem_range *range, size_t size)
 {
-	vm_flags_t vm_flags = VM_ALLOW_HUGE_VMAP;
+	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
 	struct vm_struct *vm;
 	size_t alloc_size;
 	int err = -ENOMEM;
@@ -465,7 +465,7 @@ void *execmem_alloc(enum execmem_type ty
 {
 	struct execmem_range *range = &execmem_info->ranges[type];
 	bool use_cache = range->flags & EXECMEM_ROX_CACHE;
-	vm_flags_t vm_flags = VM_FLUSH_RESET_PERMS;
+	unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
 	pgprot_t pgprot = range->pgprot;
 	void *p = NULL;
 
--- a/mm/internal.h~mm-correct-type-for-vmalloc-vm_flags-fields
+++ a/mm/internal.h
@@ -1391,7 +1391,7 @@ int migrate_device_coherent_folio(struct
 
 struct vm_struct *__get_vm_area_node(unsigned long size,
 				     unsigned long align, unsigned long shift,
-				     vm_flags_t vm_flags, unsigned long start,
+				     unsigned long vm_flags, unsigned long start,
 				     unsigned long end, int node, gfp_t gfp_mask,
 				     const void *caller);
 
--- a/mm/nommu.c~mm-correct-type-for-vmalloc-vm_flags-fields
+++ a/mm/nommu.c
@@ -126,7 +126,7 @@ void *vrealloc_noprof(const void *p, siz
 
 void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		unsigned long start, unsigned long end, gfp_t gfp_mask,
-		pgprot_t prot, vm_flags_t vm_flags, int node,
+		pgprot_t prot, unsigned long vm_flags, int node,
 		const void *caller)
 {
 	return __vmalloc_noprof(size, gfp_mask);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch
mm-correct-type-for-vmalloc-vm_flags-fields.patch
mm-correct-type-for-vmalloc-vm_flags-fields-fix.patch

