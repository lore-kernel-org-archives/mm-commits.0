Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293131;
	b=alC0+jNgmWF+V0BswVvcqnoIVn00CPHaW/AbxWf7jSBffhEYiURr6wEFA4x3mTTbaGQE
	 9XHHu+mx5B8kK/dIdbE8FqWN/IzHL/zSjFZTKlaCGvnWVzcpV8dy0Z+Ny9PNXrrlW0ccC
	 CB0Z/JDYW88CmICDyrAaJUowFc6pmQC8axERfbO7KMGg9ZED2JWJXOI/J2BRBaiReZz3V
	 6AmyUQ3md8tl84TyoO5jMsLcUAMmLj1HXh6xgmhF3L8C3/7k3TcTvaqEFn0HtDrsScD2k
	 pRgXTVmpyYBixzFEzya5okCRMj1+g8YM7LZZTnC2b1ZrfPjsXPJUywpu3k55mVJVA4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293131;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=atKKCDUPvmRNBnqZo/JGr1sKPs4dlxQ1gPDFpmJarr4=;
	b=08sMWi6p6GJIqTXnMupBWPjIfLbwUOm34T00UA+EATtYsdY2FOm7eV4mz2XBUQY/VBul
	 gllHZg/Ft14Ju3eO0zI/AC43hcWgS0N+t2NoU4C2EhAdud/f4aKpY/7CLUCIFqWCaZQ3q
	 uXu51gdLU8OeQYjNXkm55C2o0/b6Mu/ccsXKQVS97weaQURAUfdkT0E0c+VHa1Uruxi0R
	 QNJbQXrQ2anY77O+0+s+NYkvriCHCAsgAH51AsJ5qvxvpKODYR5hfnHYGgLzdjUX1xoIh
	 TeDMBDvIujANGM4P11+eAulhbgt/GpGCZ13VRyNk8lSvv/X/Q4eC4JMHR5luiUhuDew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JhpyT3OO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A966E606CB24;
	Tue, 10 Nov 2026 06:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JhpyT3OO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C39F1F008A4;
	Tue, 10 Nov 2026 06:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293130;
	bh=atKKCDUPvmRNBnqZo/JGr1sKPs4dlxQ1gPDFpmJarr4=;
	h=Date:To:From:Subject;
	b=JhpyT3OOx1J7v5pqOA9HdtZyMp39ZXHL8+cDJT4Ii+PCkWBsBjQZ+S8SGOe+UnnV3
	 tTEiG2oHoZng1mVfuxd9z3AAsMAo8KxKhsgcjmIwNq5i1v7s7m6NDsaZOz+wdagWyT
	 K3YJaJOTtAdVTpPLx9Y4DtQRzOHnts7/qGNIsTcE=
Date: Mon, 09 Nov 2026 22:45:30 -0800
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,stable@vger.kernel.org,
	peterx@redhat.com,azpijr@gmail.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-clear-uffd-state-in-child-ptes-if-uffd-is-released-during-fork.patch removed from -mm tree
Message-Id: <20261110064530.6C39F1F008A4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: userfaultfd: clear uffd state in child PTEs if uffd is released during fork
has been removed from the -mm tree.  Its filename was
     userfaultfd-clear-uffd-state-in-child-ptes-if-uffd-is-released-during-fork.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: userfaultfd: clear uffd state in child PTEs if uffd is released during fork
Date: Sat, 31 Oct 2026 20:14:03 +0200

With UFFD_FEATURE_EVENT_FORK the userfaultfd context is duplicated for the
child process, the child VMAs are registered with the new context, and
uffd protection state from the parent PTEs is copied into the child.

If the parent's userfaultfd is released before the fork event is read,
userfaultfd_release_new() resets the VMA flags but keeps uffd state in the
child PTEs.

This leaves the child's VMAs in an inconsistent state: they are not
registered with userfaultfd but their mappings carry uffd protection
state.

If the child registers the range with userfaultfd again, the stale state
turns into protection the child never asked for.

When a write fault makes such a PTE writable without copying the page, the
uffd bit remains set and page_table_check_pte_flags() warns about it.

Split resolving of the uffd PTE state out of userfaultfd_clear_vma() and
call it from userfaultfd_release_new() before resetting the VMA.

Link: https://lore.kernel.org/20261031-uffd-prot-bits-fork-event-v2-1-c448e57df417@kernel.org
Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Tested-by: Tal Zussman <tz2294@columbia.edu>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
---

 mm/userfaultfd.c |   47 ++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-clear-uffd-state-in-child-ptes-if-uffd-is-released-during-fork
+++ a/mm/userfaultfd.c
@@ -2192,6 +2192,32 @@ static void userfaultfd_reset_ctx(struct
 	userfaultfd_set_ctx(vma, NULL, 0);
 }
 
+/*
+ * Clear uffd state from a WP or RWP range: the uffd bit, WP markers and
+ * RWP PAGE_NONE entries. Call this before dropping the registration, as it
+ * needs the VMA flags to know what to resolve.
+ */
+static void userfaultfd_clear_ptes(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end)
+{
+	unsigned int mm_cp_flags = 0;
+	struct mmu_gather tlb;
+
+	if (!userfaultfd_protected(vma))
+		return;
+
+	if (userfaultfd_wp(vma))
+		mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
+	if (userfaultfd_rwp(vma))
+		mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
+	if (vma_wants_manual_pte_write_upgrade(vma))
+		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	change_protection(&tlb, vma, start, end, mm_cp_flags);
+	tlb_finish_mmu(&tlb);
+}
+
 static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 					     struct vm_area_struct *prev,
 					     struct vm_area_struct *vma,
@@ -2211,22 +2237,7 @@ static struct vm_area_struct *userfaultf
 	if (start == vma->vm_start && end == vma->vm_end)
 		give_up_on_oom = true;
 
-	/* Clear the uffd bit and/or restore protnone PTEs */
-	if (userfaultfd_protected(vma)) {
-		unsigned int mm_cp_flags = 0;
-		struct mmu_gather tlb;
-
-		if (userfaultfd_wp(vma))
-			mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
-		if (userfaultfd_rwp(vma))
-			mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
-		if (vma_wants_manual_pte_write_upgrade(vma))
-			mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
-
-		tlb_gather_mmu(&tlb, vma->vm_mm);
-		change_protection(&tlb, vma, start, end, mm_cp_flags);
-		tlb_finish_mmu(&tlb);
-	}
+	userfaultfd_clear_ptes(vma, start, end);
 
 	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
 				    &new_vma_flags, NULL_VM_UFFD_CTX,
@@ -2335,8 +2346,10 @@ static void userfaultfd_release_new(stru
 	/* the various vma->vm_userfaultfd_ctx still points to it */
 	mmap_write_lock(mm);
 	for_each_vma(vmi, vma) {
-		if (vma->vm_userfaultfd_ctx.ctx == ctx)
+		if (vma->vm_userfaultfd_ctx.ctx == ctx) {
+			userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
 			userfaultfd_reset_ctx(vma);
+		}
 	}
 	mmap_write_unlock(mm);
 }
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-vma-undo-userfaultfd-unmap-preparation-when-unmapping-fails.patch
hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

