Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7983C2BBA
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439123; cv=none; b=Tr4+/XD68S/ZReSRbXzVivm2KfFW6gInJ+LArai9ajB2TWl0WFhZzGtPELy1z5xbzwmpcEVwhYiCl7IuCcOA1/rKkvj6ksfarFznTVzv8DQgafY4NTYQYYHpLw/OVVYHgtvCq8gBp0py9gFRqConQv+ws81ulTk+ruf6C8anKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439123; c=relaxed/simple;
	bh=6WlabDZFOjwopWnVGDPVQUgYTg45cM3hwhcKnHKPJi4=;
	h=Date:To:From:Subject:Message-Id; b=ijWxUJ/OvZ+bPy41IcIJZ6C0x4zg7axHcuJ4f7+G5+HtBDcj7F+eFm3neOH4nCvOQwG5STGZJcWl60dpCjA1eKbJL2uf5yNP3NQbN6+UhYyo4HGYldfe4XABjUKqACno7l11pr/NTpeZKGkHWgAcloMx+x92Vk9pdxynjJZpd9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DGtPLA74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DGtPLA74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632841F00893;
	Tue,  2 Jun 2026 22:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439122;
	bh=IKzjPke1g4eIhfD5Wmhb036eywJapFifrLJaP8kR3pA=;
	h=Date:To:From:Subject;
	b=DGtPLA74XcmL0cnSwg7XCxsdrVa/UBQyk4jztSdz6b6m4LFNHZz11/R2m4SZL7aDh
	 gvaV5Pw/MIOZ+1vUF8GY0AhP2JkBpTSBiRytwpmR6AEN8J7NK2GjkVsDNTgVE218Kf
	 8kcPL6xcAVVViCX57cqHcwOH+fsErGvgLG8w8ARE=
Date: Tue, 02 Jun 2026 15:25:21 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch removed from -mm tree
Message-Id: <20260602222522.632841F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivam Kalra <shivamkalra98@zohomail.in>
Subject: mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas
Date: Tue, 19 May 2026 17:42:16 +0530

For VM_ALLOC areas in vread_iter(), derive the vm area size from
vm->nr_pages rather than get_vm_area_size().

Only VM_ALLOC areas are subject to vrealloc() shrinking, which frees pages
without reducing the virtual reservation size.  Switch to using
vm->nr_pages for VM_ALLOC areas so the reader remains correct once shrink
support is added.  Other mapping types (vmap, ioremap) do not initialize
nr_pages and will continue using get_vm_area_size().

[shivamkalra98@zohomail.in: add an nr_pages check]
  Link: https://lore.kernel.org/aff47da5-4fd5-481d-be18-e1eb99639490@zohomail.in
Link: https://lore.kernel.org/20260519-vmalloc-shrink-v14-3-70b96ee3e9c9@zohomail.in
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas
+++ a/mm/vmalloc.c
@@ -4666,7 +4666,18 @@ long vread_iter(struct iov_iter *iter, c
 		smp_rmb();
 
 		vaddr = (char *) va->va_start;
-		size = vm ? get_vm_area_size(vm) : va_size(va);
+		if (vm)
+			/*
+			 * For VM_ALLOC areas, use nr_pages rather than
+			 * get_vm_area_size() because vrealloc() may shrink
+			 * the mapping without updating area->size. Other
+			 * mapping types (vmap, ioremap) don't set nr_pages.
+			 */
+			size = (vm->flags & VM_ALLOC && vm->nr_pages) ?
+				       (vm->nr_pages << PAGE_SHIFT) :
+				       get_vm_area_size(vm);
+		else
+			size = va_size(va);
 
 		if (addr >= vaddr + size)
 			goto next_va;
_

Patches currently in -mm which might be from shivamkalra98@zohomail.in are


