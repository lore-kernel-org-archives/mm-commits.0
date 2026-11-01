Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793500985;
	b=xkj0jwgdzFvUbsLeDSoKthotMpixCR1EAs79lHtGz1S0RF0PjxCwR8ilAzrjcqQZ20dE
	 wGFM58eynuOmu7aBJ8zAmgfQ/KOhj0jxc3Ygf83ulrpynKsFZmpxkCGarC7OgayZEx1RX
	 S6wOOBGMogkM7xyE1O6oQraGPsSReGHZwpAmsGL2xli59fMRcD2G9sNtpDFFOwup9KiDX
	 Tma/ExiK0q876+I6XiFHiAqrrweaDMcd/c7W8f7+paORl1za8LB2UsOu5kD8Lr4NOD7TW
	 wyj6AwDXVjKq/L9W2B8sTpvQoeBH1YcxTvGgNshCLF5QRjw0uQCDWe0cobkE6621yrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793500985;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=td/iMtOuYstq/gC3+MS2yZ7PQiaQQwgkuy5p24lBfvA=;
	b=Oxfdq+3GPPP30AcuYzbZGBNgTdy10q/3pTa2e/6NdkI2xTnMhhdwamfYOGfN7LisXKJJ
	 BTq8d9p02YOyPoQL0SL65nWl97zhM8/t94TSm7G1FpaKrIjM3s5U5yzZRMLFTyHcS28wz
	 bJ9ScvUdMS7BvSDTIFzi7WDBrSaBOtDg3aHLtLS+xKchn8YVFc46pUZaSTYWywNxLEhnQ
	 mCOET2Q8eJOVRpWxrHbqgGeSTcjP+vgJqDuh3n/q4HAcnqezv2iU0inNZw7gmwQBTptfB
	 mytE8x2v3q0HjZwKbGxUfclMOldC65HzvqYefXAn2cZl2Awej10k0M3yh00LZMGWBEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vGG+FTf0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D73606A324;
	Sun,  1 Nov 2026 02:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vGG+FTf0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B8F1F000C1;
	Sun,  1 Nov 2026 02:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793500984;
	bh=td/iMtOuYstq/gC3+MS2yZ7PQiaQQwgkuy5p24lBfvA=;
	h=Date:To:From:Subject;
	b=vGG+FTf0gYXA18QOsaTkzYndpxyn//5Rd1MGS8hNHBLvm7jgHvuf45oZym91LAe0/
	 4LUKmWAgbKHcYJ9ZfWr5JDEURxbN/2SIENY0nFzqKe7ohGGklJIDkyQrCl4bN1IC6i
	 ydH+hxt2i3SAW7REl2WZ16g8favYAt6AGOi7FFxg=
Date: Sat, 31 Oct 2026 19:43:03 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,stable@vger.kernel.org,
	peterx@redhat.com,azpijr@gmail.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-clear-uffd-state-in-child-ptes-if-uffd-is-released-during-fork.patch added to mm-hotfixes-unstable branch
Message-Id: <20261101024304.32B8F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: userfaultfd: clear uffd state in child PTEs if uffd is released during fork
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-clear-uffd-state-in-child-ptes-if-uffd-is-released-during-fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-clear-uffd-state-in-child-ptes-if-uffd-is-released-during-fork.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2219,6 +2219,32 @@ static void userfaultfd_reset_ctx(struct
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
@@ -2238,22 +2264,7 @@ static struct vm_area_struct *userfaultf
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
@@ -2352,8 +2363,10 @@ static void userfaultfd_release_new(stru
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

mm-cma-accept-memory-of-multi-range-cma-areas.patch
mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch
userfaultfd-clear-uffd-state-in-child-ptes-if-uffd-is-released-during-fork.patch
hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

