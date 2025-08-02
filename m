Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539781A8412
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160888; cv=none; b=ijt+85Ev2P+HwcYI9wzxPngcG9JiG9lea4Uqk9bcCXqnVQkyNALHaUQO2L3fT9jK22hhWAClkfXCd5MHYtXXxXgbQsuyVRX+MhwvZPl6tixwg3PdMAa39I+/7geLvxu5kSctm+0Z22DjVuBLXafdxHW6+jBFTpDM1qXMm59GWgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160888; c=relaxed/simple;
	bh=MuzsBKFikNgAGh+EZeqvOylInV8I2s5hCmAKUqyyDws=;
	h=Date:To:From:Subject:Message-Id; b=O9jlwtKp4a6ILJdQC3oZT6wZ+LUDqBrf2cYo0nyVcby5dofvl6k32AtT7PUEW+BYRLNk7CTlZBQwdy6PsisyB5GSTHu2qWSUPT6WzME0l85G6WtIkXEK1e8elsLjTCXT6sujKxpLl208eee4pPfWmejLW6gaERd5fXgMzfwJBgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xZYLzibk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xZYLzibk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28512C4CEEF;
	Sat,  2 Aug 2025 18:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160888;
	bh=MuzsBKFikNgAGh+EZeqvOylInV8I2s5hCmAKUqyyDws=;
	h=Date:To:From:Subject:From;
	b=xZYLzibkRr0hbNh1ZqTAdyxe0/DawZ7ELbV7QbXUkRx0Y2w6QTFrw+qB3FfBsgz7z
	 kpxNgg044LUJ0JbjDCu+dx1TYpy7n1OueO6AM1PxKFGe6Dt4Dc0JsqorMBA6MfAJVH
	 kNKS3YZxcegGq0+jUbSb0wJrkljOO/qQLjS+SOEM=
Date: Sat, 02 Aug 2025 11:54:47 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-correct-type-for-vmalloc-vm_flags-fields.patch removed from -mm tree
Message-Id: <20250802185448.28512C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: correct type for vmalloc vm_flags fields
has been removed from the -mm tree.  Its filename was
     mm-correct-type-for-vmalloc-vm_flags-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[lorenzo.stoakes@oracle.com: fixup very disguised vmalloc flags parameter]
  Link: https://lkml.kernel.org/r/e74dd8de-7e60-47ab-8a45-2c851f3c5d26@lucifer.local
Link: https://lkml.kernel.org/r/20250729114906.55347-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Harry Yoo <harry.yoo@oracle.com>
Closes: https://lore.kernel.org/all/aIgSpAnU8EaIcqd9@hyeyoo/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |    2 +-
 mm/execmem.c        |    8 ++++----
 mm/internal.h       |    2 +-
 mm/nommu.c          |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-correct-type-for-vmalloc-vm_flags-fields
+++ a/arch/arm64/mm/mmu.c
@@ -721,7 +721,7 @@ void mark_rodata_ro(void)
 
 static void __init declare_vma(struct vm_struct *vma,
 			       void *va_start, void *va_end,
-			       vm_flags_t vm_flags)
+			       unsigned long vm_flags)
 {
 	phys_addr_t pa_start = __pa_symbol(va_start);
 	unsigned long size = va_end - va_start;
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


