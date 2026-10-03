Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D213B7B7D
	for <mm-commits@vger.kernel.org>; Sat,  3 Oct 2026 23:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791071949; cv=none; b=OF/JiFqytLJzTnwizOeWNeli/dexXiEGdxs7IqLWpbDiesN3zOsA+HI78m9PoFQhLYJqX7VcRbpuf3aw3eq/mlq+KSNS7x+z5jitoPVFVwj44Qd3t1kux9JEb7hYS8k1cjncs6fablhYq42lT0JZ4sxv01523OwoJwY1NQWlQsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791071949; c=relaxed/simple;
	bh=xSfxOox12NnWxw9XK9m1joIJhVUSwbG39tiC3E/OZYw=;
	h=Date:To:From:Subject:Message-Id; b=HkpXFzbyCWRoph3TKqR7yyhXujIqMROH9jt/OiQxq2mowxz1ryV0gaR2rDULPHsvCaOff2u4C+KZRSdYm/Cos7PPNxh9CyVjfsnNSPwmB5sZ2jM71+Gczv8b9DFDuUoJEcvkxQpVKPiRohFAyZPLqlGCmAIw5tGn5b3umj2dqyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TpFUG+Wo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TpFUG+Wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC8F1F0089C;
	Sat,  3 Oct 2026 23:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791071947;
	bh=o4S4v0nFJnGtZ4g7Z0s46UaaTviqfbrjkyM9HqBetXM=;
	h=Date:To:From:Subject;
	b=TpFUG+WoDp8u8yL4myWNF9WTsWMdXs1DByjnMABOzCGO5A8YxM0sxYJ0WHMUTFjnt
	 loy8QRJCPhGrpMR2j8KvOhX9thTvueLf8yb9gtg9kHo8vUR+V6d7p3fuGYboPGrka+
	 7g9mk9+VY3ROi+YI/B9hFMq7FtK0WhbzS2nosazk=
Date: Sat, 03 Oct 2026 16:59:06 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch added to mm-unstable branch
Message-Id: <20261003235907.4CC8F1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/usb/mon: update to use mmap_prepare + map kernel pages
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch

This patch will later appear in the mm-unstable branch at
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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: drivers/usb/mon: update to use mmap_prepare + map kernel pages
Date: Sat, 03 Oct 2026 17:32:40 +0100

Replace the deprecated .mmap hook with its replacement .mmap_prepare. As
part of this change, additionally take the approach of mapping pages upon
mmap rather than providing a fault handler.

The page span cannot be mutated when an mmap mapping is in place, so this
is safe to do in advance (the MON_IOCT_RING_SIZE ioctl operation exits
-EBUSY if it's attempted, gated by the rp->mmap_active reference count).

Utilise the newly introduced mmap_action_map_discontig_kernel_pages() to do
this, which allows for iteration over pages in mon_bin_discontig_get().

mon_bin_discontig_init() increments the rp->mmap_active reference count to
stabilise page spans. Should an error arise the core unmaps the VMA and
mon_bin_vma_close() drops the reference again.

The vm_ops->close hook implemented in mon_bin_vma_close() will ensure
correct reference count arithmetic upon unmap (with mon_bin_vma_open()
accounting for splitting).

The existing semantics are all retained, including not mapping past the
range of available pages, with a SIGBUS being raised in a userland process
that attempts to access past this point.

Ultimately insert_page() is invoked to insert each page, which increments
the reference count on each mapped page. This mimics what was being done
previously, only we pre-map the entire range rather than doing so on
demand.

The existing fault handler did nothing that required demand paging, and was
presumably implemented this way for historical reasons.

One behavioural difference: pages are no longer faulted in on demand, so a
page discarded with MADV_DONTNEED is not repopulated and a subsequent
access raises SIGBUS, as with other pre-populated kernel mappings.

Link: https://lore.kernel.org/20261003-b4-mmap-prepare-vma-flag-sanify-v4-9-a1f052500fd7@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Martin K. Petersen <mkp@kernel.org>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Xin <xu.xin@linux.dev>
---

 drivers/usb/mon/mon_bin.c |   82 +++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 29 deletions(-)

--- a/drivers/usb/mon/mon_bin.c~drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages
+++ a/drivers/usb/mon/mon_bin.c
@@ -1219,6 +1219,15 @@ mon_bin_poll(struct file *file, struct p
 	return mask;
 }
 
+static void __mon_bin_vma_open(struct mon_reader_bin *rp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rp->b_lock, flags);
+	rp->mmap_active++;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
+}
+
 /*
  * open and close: just keep track of how many times the device is
  * mapped, to use the proper memory allocation function.
@@ -1226,64 +1235,79 @@ mon_bin_poll(struct file *file, struct p
 static void mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&rp->b_lock, flags);
-	rp->mmap_active++;
-	spin_unlock_irqrestore(&rp->b_lock, flags);
+	__mon_bin_vma_open(rp);
 }
 
-static void mon_bin_vma_close(struct vm_area_struct *vma)
+static void __mon_bin_vma_close(struct mon_reader_bin *rp)
 {
 	unsigned long flags;
 
-	struct mon_reader_bin *rp = vma->vm_private_data;
 	spin_lock_irqsave(&rp->b_lock, flags);
 	rp->mmap_active--;
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 }
 
-/*
- * Map ring pages to user space.
- */
-static vm_fault_t mon_bin_vma_fault(struct vm_fault *vmf)
+static void mon_bin_vma_close(struct vm_area_struct *vma)
+{
+	struct mon_reader_bin *rp = vma->vm_private_data;
+
+	__mon_bin_vma_close(rp);
+}
+
+static const struct vm_operations_struct mon_bin_vm_ops = {
+	.open =     mon_bin_vma_open,
+	.close =    mon_bin_vma_close,
+};
+
+static int mon_bin_discontig_init(void *vm_private_data, void **private)
 {
-	struct mon_reader_bin *rp = vmf->vma->vm_private_data;
+	struct mon_reader_bin *rp = vm_private_data;
+
+	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
+	__mon_bin_vma_open(rp);
+	return 0;
+}
+
+static int mon_bin_discontig_get(struct discontig_kernel_page_state *state)
+{
+	struct mon_reader_bin *rp = state->vm_private_data;
 	unsigned long offset, chunk_idx;
-	struct page *pageptr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rp->b_lock, flags);
-	offset = vmf->pgoff << PAGE_SHIFT;
+
+	offset = state->pgoff << PAGE_SHIFT;
 	if (offset >= rp->b_size) {
 		spin_unlock_irqrestore(&rp->b_lock, flags);
-		return VM_FAULT_SIGBUS;
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 	chunk_idx = offset / CHUNK_SIZE;
-	pageptr = rp->b_vec[chunk_idx].pg;
-	get_page(pageptr);
-	vmf->page = pageptr;
+	discontig_kernel_map_page(state, rp->b_vec[chunk_idx].pg);
+
 	spin_unlock_irqrestore(&rp->b_lock, flags);
 	return 0;
 }
 
-static const struct vm_operations_struct mon_bin_vm_ops = {
-	.open =     mon_bin_vma_open,
-	.close =    mon_bin_vma_close,
-	.fault =    mon_bin_vma_fault,
+static const struct discontig_kernel_page_ops mon_discontig_ops = {
+	.init = mon_bin_discontig_init,
+	.get = mon_bin_discontig_get,
 };
 
-static int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mon_bin_mmap_prepare(struct vm_area_desc *desc)
 {
-	/* don't do anything here: "fault" will set up page table entries */
-	vma->vm_ops = &mon_bin_vm_ops;
+	const struct file *filp = desc->file;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_desc_test(desc, VMA_WRITE_BIT))
 		return -EPERM;
 
-	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_MAYWRITE);
-	vma->vm_private_data = filp->private_data;
-	mon_bin_vma_open(vma);
+	desc->vm_ops = &mon_bin_vm_ops;
+	vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = filp->private_data;
+
+	mmap_action_map_discontig_kernel_pages(desc, NULL, &mon_discontig_ops);
 	return 0;
 }
 
@@ -1298,7 +1322,7 @@ static const struct file_operations mon_
 	.compat_ioctl =	mon_bin_compat_ioctl,
 #endif
 	.release =	mon_bin_release,
-	.mmap =		mon_bin_mmap,
+	.mmap_prepare = mon_bin_mmap_prepare,
 };
 
 static int mon_bin_wait_event(struct file *file, struct mon_reader_bin *rp)
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch
mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch
drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-khugepaged-deposit-a-newly-allocated-page-table-on-collapse.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-userland-pgtable-freeing-is-rcu-safe-now-remove-leftover-bits.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_mm_managed-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-not-mm-managed.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-mm-managed-mappings-may-not-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_mm_managed.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_mm_backed.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

