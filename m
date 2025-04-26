Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B7213B284;
	Sat, 26 Apr 2025 01:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745632785; cv=none; b=kC1D96fZeaCNCtayhlDPFuHkYa/gnjw977o8MO0pvO0qwQsvcXf+hRbI3wVyDwJWW37LhVQenivkkllriHrSdWcPI5/Y9d16xv7RS4CUBV8QWVolygVk/4ILHeyVF4WVi20vwcEiuHUO4MZfMRYpZIo5HD28GySNclJmWFxEkxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745632785; c=relaxed/simple;
	bh=8Or1dD90mFtgUKp0lVsuOKbDOlgiixo5kCZ7CLMijnA=;
	h=Date:To:From:Subject:Message-Id; b=WnNwruq/uiCBaQp3p0DYcMzqdJT/UIDeULtMPejuRCVBXWPsnyv5w5D1R4rEmetCWA7KWoZPEl/JdglB2/J3LixLI6vlPrF2AaJv//UJKsSBWg3NsQA3YiDVnI3/K86ems7iaHkncaGzLFg5ROsCDa0JTb9NNCTPPhpMYH1qjSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qmTJiR3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qmTJiR3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8415C4CEE4;
	Sat, 26 Apr 2025 01:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745632784;
	bh=8Or1dD90mFtgUKp0lVsuOKbDOlgiixo5kCZ7CLMijnA=;
	h=Date:To:From:Subject:From;
	b=qmTJiR3HRpa21WGwDchuxe2tfnMtDQz4ShSTSVQf6DANN+hP1qeqqfv4P3OF2nqZQ
	 fTR8qyAEyqkx+GColr9uiDnaiYRoFy/9ZUYXI4iLXDp68B3BPAUUuFkh+yu9b6TeeK
	 r4czI2wcnRtzXaNqfwzeB6wnOdMpqIRWYApQExoY=
Date: Fri, 25 Apr 2025 18:59:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,stable@vger.kernel.org,mhocko@suse.com,erhard_f@mailbox.org,dakr@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-support-more-granular-vrealloc-sizing.patch added to mm-hotfixes-unstable branch
Message-Id: <20250426015944.B8415C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: support more granular vrealloc() sizing
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-support-more-granular-vrealloc-sizing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-support-more-granular-vrealloc-sizing.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kees Cook <kees@kernel.org>
Subject: mm: vmalloc: support more granular vrealloc() sizing
Date: Fri, 25 Apr 2025 17:11:07 -0700

Introduce struct vm_struct::requested_size so that the requested
(re)allocation size is retained separately from the allocated area size. 
This means that KASAN will correctly poison the correct spans of requested
bytes.  This also means we can support growing the usable portion of an
allocation that can already be supported by the existing area's existing
allocation.

Link: https://lkml.kernel.org/r/20250426001105.it.679-kees@kernel.org
Fixes: 3ddc2fefe6f3 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Kees Cook <kees@kernel.org>
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/20250408192503.6149a816@outsider.home/
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |   31 ++++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-support-more-granular-vrealloc-sizing
+++ a/include/linux/vmalloc.h
@@ -61,6 +61,7 @@ struct vm_struct {
 	unsigned int		nr_pages;
 	phys_addr_t		phys_addr;
 	const void		*caller;
+	unsigned long		requested_size;
 };
 
 struct vmap_area {
--- a/mm/vmalloc.c~mm-vmalloc-support-more-granular-vrealloc-sizing
+++ a/mm/vmalloc.c
@@ -1940,7 +1940,7 @@ static inline void setup_vmalloc_vm(stru
 {
 	vm->flags = flags;
 	vm->addr = (void *)va->va_start;
-	vm->size = va_size(va);
+	vm->size = vm->requested_size = va_size(va);
 	vm->caller = caller;
 	va->vm = vm;
 }
@@ -3133,6 +3133,7 @@ struct vm_struct *__get_vm_area_node(uns
 
 	area->flags = flags;
 	area->caller = caller;
+	area->requested_size = requested_size;
 
 	va = alloc_vmap_area(size, align, start, end, node, gfp_mask, 0, area);
 	if (IS_ERR(va)) {
@@ -4063,6 +4064,8 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  */
 void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
 {
+	struct vm_struct *vm = NULL;
+	size_t alloced_size = 0;
 	size_t old_size = 0;
 	void *n;
 
@@ -4072,15 +4075,17 @@ void *vrealloc_noprof(const void *p, siz
 	}
 
 	if (p) {
-		struct vm_struct *vm;
-
 		vm = find_vm_area(p);
 		if (unlikely(!vm)) {
 			WARN(1, "Trying to vrealloc() nonexistent vm area (%p)\n", p);
 			return NULL;
 		}
 
-		old_size = get_vm_area_size(vm);
+		alloced_size = get_vm_area_size(vm);
+		old_size = vm->requested_size;
+		if (WARN(alloced_size < old_size,
+			 "vrealloc() has mismatched area vs requested sizes (%p)\n", p))
+			return NULL;
 	}
 
 	/*
@@ -4088,14 +4093,26 @@ void *vrealloc_noprof(const void *p, siz
 	 * would be a good heuristic for when to shrink the vm_area?
 	 */
 	if (size <= old_size) {
-		/* Zero out spare memory. */
-		if (want_init_on_alloc(flags))
+		/* Zero out "freed" memory. */
+		if (want_init_on_free())
 			memset((void *)p + size, 0, old_size - size);
+		vm->requested_size = size;
 		kasan_poison_vmalloc(p + size, old_size - size);
-		kasan_unpoison_vmalloc(p, size, KASAN_VMALLOC_PROT_NORMAL);
 		return (void *)p;
 	}
 
+	/*
+	 * We already have the bytes available in the allocation; use them.
+	 */
+	if (size <= alloced_size) {
+		kasan_unpoison_vmalloc(p + old_size, size - old_size,
+				       KASAN_VMALLOC_PROT_NORMAL);
+		/* Zero out "alloced" memory. */
+		if (want_init_on_alloc(flags))
+			memset((void *)p + old_size, 0, size - old_size);
+		vm->requested_size = size;
+	}
+
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
 	n = __vmalloc_noprof(size, flags);
 	if (!n)
_

Patches currently in -mm which might be from kees@kernel.org are

mm-vmalloc-support-more-granular-vrealloc-sizing.patch

