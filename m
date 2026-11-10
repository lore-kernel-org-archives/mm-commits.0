Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293132;
	b=uLKtx+C1qMVBTqBO1aQnNgVG+s/aupNcxhhovKLs4+kt7RQfn4vkplFq7sUgCPItU53y
	 TPI8KUp40k+l16i+v6yBal5LzVR+5BMndIhzV6dJ02C+CyM94g6ZkloDm/gu8GCVNIzyj
	 HAu2+LOssrXaWkuJTtQLcm7B/c3fCSsgE8wgbLkgQwlpAc8z4FALfaTSP/Qr9z+yMGd6D
	 xl9QMwkYaL5as+D7cfLMo6UMcDXUgXk+XtM2NFT1Nd30xv4Z28IS4H+rdXhSrRqxi0f8i
	 jPlB76ymbRbEc5hGV1Qgzgau3+CzOjptBaT4db+kkIwvb3ng9EEdlJ2wClKtPdS4GTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293132;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4dfQxJ2Sg0rC0lkBG4Q8FZblxf35pXwGMZqU45WQWPI=;
	b=Uatw2tvZOgVL13fCGyWRnr2j/CvTyzWRYOKjYPv15+ebwy/OG/MfHvI7WNC7Z/SGUHBI
	 /Pjj6zqCbzuxXixf9IplfTe9uSC+A0/VlU/PQ71Hdn6sOGNQ0MCvjboOqfg6yrwp7jz/h
	 unDCPdaM2dRc9gFiZpHVYmcof06hhDjJ2AUBZX5MYbUWNB+I2m5gB6pI3NcHM2acLT59O
	 b22AZekvoW/cKfgwm8tkhaLRRDGzGMOnRhh/IY3CfwOt5BtVA8e/cadYv4bK0ZLcfLSi0
	 YahUggOK+p8VItze6xSBF7su8Gxk9KXCMo8ibjoC1sSHWbo+FasuDxGf/w4lX1V4Wjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wm3a2fq7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7952606CB29;
	Tue, 10 Nov 2026 06:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wm3a2fq7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815F51F008A2;
	Tue, 10 Nov 2026 06:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293131;
	bh=4dfQxJ2Sg0rC0lkBG4Q8FZblxf35pXwGMZqU45WQWPI=;
	h=Date:To:From:Subject;
	b=wm3a2fq7AhUUbpp7XL3FlOjxVdMFsBAot6n80lRMA4hGE0XwLnFLV6IqOKCbfvtG7
	 +tPxNj8WQZ5g8EhAM95pYS5g89S57LY6eu5W07prHPcSCdWYaeapIcItZwkfJabrSU
	 UywCb2Cf1kAOYt9ODD6Lr16mnac9yx+xEgIDb7fM=
Date: Mon, 09 Nov 2026 22:45:31 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tz2294@columbia.edu,
	stable@vger.kernel.org,pfalcato@suse.de,peterx@redhat.com,
	NoahWeinberger2003@proton.me,ljs@kernel.org,liam@infradead.org,
	jannh@google.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-undo-userfaultfd-unmap-preparation-when-unmapping-fails.patch removed from -mm tree
Message-Id: <20261110064531.815F51F008A2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: undo userfaultfd unmap preparation when unmapping fails
has been removed from the -mm tree.  Its filename was
     mm-vma-undo-userfaultfd-unmap-preparation-when-unmapping-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/vma: undo userfaultfd unmap preparation when unmapping fails
Date: Sun, 01 Nov 2026 10:24:02 +0200

vms_gather_munmap_vmas() collects VMAs to unmap and calls
userfaultfd_unmap_prep() for each of these VMAs. This takes a reference
to the userfaultfd context, raises ctx->mmap_changing and queues an
UFFD_EVENT_UNMAP on the caller's list.

If gathering fails half way, e.g. because one of the VMAs is sealed, or
the operation fails after the VMAs were gathered, the original mappings
stay intact but the queued events remain on the list.

Depending on the caller they are either delivered although nothing was
unmapped (munmap(), mremap(), mmap(MAP_FIXED)), or silently dropped
(brk()). In the latter case the userfaultfd context and the mm_struct it
pins are leaked and mmap_changing is never lowered, so UFFDIO_COPY,
UFFDIO_ZEROPAGE and all other ioctls that check mmap_changing fail with
-EAGAIN forever.

With mseal() this is trivially triggered by an unprivileged process.

Collect the events in do_vmi_align_munmap() on a local list and splice
it to the caller's list only when the unmap completes, because mremap()
may already have events for earlier unmaps on that list.

Drop the pending events with a new userfaultfd_unmap_abort() helper when
do_vmi_align_munmap() or __mmap_setup() fail.

Link: https://lore.kernel.org/20261101-uffd-unmap-abort-v1-1-1588d7a7c61a@kernel.org
Fixes: 65ac132027a8 ("userfaultfd: fix regression in userfaultfd_unmap_prep()")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Noah Weinberger <NoahWeinberger2003@proton.me>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Tested-by: Tal Zussman <tz2294@columbia.edu>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 include/linux/userfaultfd_k.h     |    5 +++++
 mm/userfaultfd.c                  |   19 +++++++++++++++++++
 mm/vma.c                          |   28 +++++++++++++++++++++++-----
 tools/testing/vma/include/stubs.h |    4 ++++
 4 files changed, 51 insertions(+), 5 deletions(-)

--- a/include/linux/userfaultfd_k.h~mm-vma-undo-userfaultfd-unmap-preparation-when-unmapping-fails
+++ a/include/linux/userfaultfd_k.h
@@ -277,6 +277,7 @@ extern int userfaultfd_unmap_prep(struct
 		unsigned long start, unsigned long end, struct list_head *uf);
 extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
+void userfaultfd_unmap_abort(struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
 extern bool userfaultfd_rwp_async(struct vm_area_struct *vma);
@@ -443,6 +444,10 @@ static inline void userfaultfd_unmap_com
 {
 }
 
+static inline void userfaultfd_unmap_abort(struct list_head *uf)
+{
+}
+
 static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
 {
 	return false;
--- a/mm/userfaultfd.c~mm-vma-undo-userfaultfd-unmap-preparation-when-unmapping-fails
+++ a/mm/userfaultfd.c
@@ -3290,6 +3290,25 @@ void userfaultfd_unmap_complete(struct m
 	}
 }
 
+void userfaultfd_unmap_abort(struct list_head *uf)
+{
+	struct userfaultfd_unmap_ctx *unmap_ctx, *n;
+
+	if (!uf)
+		return;
+
+	list_for_each_entry_safe(unmap_ctx, n, uf, list) {
+		struct userfaultfd_ctx *ctx = unmap_ctx->ctx;
+
+		atomic_dec(&ctx->mmap_changing);
+		VM_WARN_ON_ONCE(atomic_read(&ctx->mmap_changing) < 0);
+		userfaultfd_ctx_put(ctx);
+
+		list_del(&unmap_ctx->list);
+		kfree(unmap_ctx);
+	}
+}
+
 static int userfaultfd_release(struct inode *inode, struct file *file)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
--- a/mm/vma.c~mm-vma-undo-userfaultfd-unmap-preparation-when-unmapping-fails
+++ a/mm/vma.c
@@ -1686,9 +1686,18 @@ int do_vmi_align_munmap(struct vma_itera
 	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_on_stack(mt_detach);
 	struct vma_munmap_struct vms;
+	struct list_head *uf_unmaps;
+	LIST_HEAD(uf_new_unmaps);
 	int error;
 
-	init_vma_munmap(&vms, vmi, vma, start, end, uf, unlock);
+	/*
+	 * @uf may already hold events of earlier successful unmaps, e.g. in
+	 * mremap().
+	 * Collect new events on a separate list so they can be dropped if this
+	 * unmap fails, and splice them into @uf on success.
+	 */
+	uf_unmaps = uf ? &uf_new_unmaps : NULL;
+	init_vma_munmap(&vms, vmi, vma, start, end, uf_unmaps, unlock);
 	error = vms_gather_munmap_vmas(&vms, &mas_detach);
 	if (error)
 		goto gather_failed;
@@ -1698,12 +1707,15 @@ int do_vmi_align_munmap(struct vma_itera
 		goto clear_tree_failed;
 
 	/* Point of no return */
+	if (uf)
+		list_splice_tail(&uf_new_unmaps, uf);
 	vms_complete_munmap_vmas(&vms, &mas_detach);
 	return 0;
 
 clear_tree_failed:
 	reattach_vmas(&mas_detach);
 gather_failed:
+	userfaultfd_unmap_abort(&uf_new_unmaps);
 	validate_mm(mm);
 	return error;
 }
@@ -2592,7 +2604,7 @@ static int __mmap_setup(struct mmap_stat
 		if (error) {
 			/* On error VMAs will already have been reattached. */
 			vms->nr_pages = 0;
-			return error;
+			goto abort_unmaps;
 		}
 
 		map->next = vms->next;
@@ -2602,8 +2614,10 @@ static int __mmap_setup(struct mmap_stat
 	}
 
 	/* Check against address space limit. */
-	if (!may_expand_vm(map->mm, &map->vma_flags, map->pglen - vms->nr_pages))
-		return -ENOMEM;
+	if (!may_expand_vm(map->mm, &map->vma_flags, map->pglen - vms->nr_pages)) {
+		error = -ENOMEM;
+		goto abort_unmaps;
+	}
 
 	/* Private writable mapping: check memory availability. */
 	if (accountable_mapping(map)) {
@@ -2613,7 +2627,7 @@ static int __mmap_setup(struct mmap_stat
 		if (uncharged) {
 			error = security_vm_enough_memory_mm(map->mm, uncharged);
 			if (error)
-				return error;
+				goto abort_unmaps;
 		}
 
 		/* Our new mapping owns the entire charge now. */
@@ -2632,6 +2646,10 @@ static int __mmap_setup(struct mmap_stat
 
 	set_desc_from_map(desc, map);
 	return 0;
+
+abort_unmaps:
+	userfaultfd_unmap_abort(uf);
+	return error;
 }
 
 static bool map_same_file(struct mmap_state *map)
--- a/tools/testing/vma/include/stubs.h~mm-vma-undo-userfaultfd-unmap-preparation-when-unmapping-fails
+++ a/tools/testing/vma/include/stubs.h
@@ -148,6 +148,10 @@ static inline int userfaultfd_unmap_prep
 	return 0;
 }
 
+static inline void userfaultfd_unmap_abort(struct list_head *uf)
+{
+}
+
 static inline void mmap_write_downgrade(struct mm_struct *mm)
 {
 }
_

Patches currently in -mm which might be from rppt@kernel.org are

hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

