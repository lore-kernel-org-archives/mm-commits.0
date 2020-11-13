Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1507C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC2E21D79
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:56:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rN8v8nB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgKMA4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKMA4L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:56:11 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5784C221E9;
        Fri, 13 Nov 2020 00:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605228971;
        bh=FG44UAGF7EPXybh3bYt4ViFY3MpY1ehd+KE6idLO7uA=;
        h=Date:From:To:Subject:From;
        b=rN8v8nB5nH3vSDXkuVlNsdnhdHE+f5zc6LaLU+3/1CTvbOcv6EHzI3HQ47z4K7EYO
         cFs8MNGKX2voLkDJbvOqP/VPmyw9MALcwjQ5DMj6PK9OZOrLV629LE6taJPFGyjDUk
         +p3ZDd/Qp/jQFkc4ANYQ3Q3Eoatz69RNNznsstwA=
Date:   Thu, 12 Nov 2020 16:56:09 -0800
From:   akpm@linux-foundation.org
To:     a.darwish@linutronix.de, aarcange@redhat.com,
        aneesh.kumar@linux.ibm.com, hch@lst.de, hughd@google.com,
        jack@suse.cz, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kirill@shutemov.name, ktkhai@virtuozzo.com,
        leonro@nvidia.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, peterx@redhat.com, torvalds@linux-foundation.org
Subject:  +
 mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch added to -mm
 tree
Message-ID: <20201113005609.xmsqnsCkH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: prevent gup_fast from racing with COW during fork
has been added to the -mm tree.  Its filename is
     mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: prevent gup_fast from racing with COW during fork

Since commit 70e806e4e645 ("mm: Do early cow for pinned pages during
fork() for ptes") pages under a FOLL_PIN will not be write protected
during COW for fork.  This means that pages returned from
pin_user_pages(FOLL_WRITE) should not become write protected while the pin
is active.

However, there is a small race where get_user_pages_fast(FOLL_PIN) can
establish a FOLL_PIN at the same time copy_present_page() is write
protecting it:

        CPU 0                             CPU 1
   get_user_pages_fast()
    internal_get_user_pages_fast()
                                       copy_page_range()
                                         pte_alloc_map_lock()
                                           copy_present_page()
                                             atomic_read(has_pinned) == 0
					     page_maybe_dma_pinned() == false
     atomic_set(has_pinned, 1);
     gup_pgd_range()
      gup_pte_range()
       pte_t pte = gup_get_pte(ptep)
       pte_access_permitted(pte)
       try_grab_compound_head()
                                             pte = pte_wrprotect(pte)
	                                     set_pte_at();
                                         pte_unmap_unlock()
      // GUP now returns with a write protected page

The first attempt to resolve this by using the write protect caused
problems (and was missing a barrrier), see commit f3c64eda3e50 ("mm: avoid
early COW write protect games during fork()")

Instead wrap copy_p4d_range() with the write side of a seqcount and check
the read side around gup_pgd_range().  If there is a collision then
get_user_pages_fast() fails and falls back to slow GUP.

Slow GUP is safe against this race because copy_page_range() is only
called while holding the exclusive side of the mmap_lock on the src
mm_struct.

Link: https://lkml.kernel.org/r/2-v4-908497cf359a+4782-gup_fork_jgg@nvidia.com
Fixes: f3c64eda3e50 ("mm: avoid early COW write protect games during fork()")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
  Link: https://lore.kernel.org/r/CAHk-=wi=iCnYCARbPGjkVJu9eyYeZ13N64tZYLdOB8CP5Q_PLw@mail.gmail.com
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: "Ahmed S. Darwish" <a.darwish@linutronix.de>	[seqcount_t parts]
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/tboot.c    |    1 +
 drivers/firmware/efi/efi.c |    1 +
 include/linux/mm_types.h   |    8 ++++++++
 kernel/fork.c              |    1 +
 mm/gup.c                   |   18 ++++++++++++++++++
 mm/init-mm.c               |    1 +
 mm/memory.c                |   13 ++++++++++++-
 7 files changed, 42 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/tboot.c~mm-prevent-gup_fast-from-racing-with-cow-during-fork
+++ a/arch/x86/kernel/tboot.c
@@ -93,6 +93,7 @@ static struct mm_struct tboot_mm = {
 	.pgd            = swapper_pg_dir,
 	.mm_users       = ATOMIC_INIT(2),
 	.mm_count       = ATOMIC_INIT(1),
+	.write_protect_seq = SEQCNT_ZERO(tboot_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(init_mm)
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.mmlist         = LIST_HEAD_INIT(init_mm.mmlist),
--- a/drivers/firmware/efi/efi.c~mm-prevent-gup_fast-from-racing-with-cow-during-fork
+++ a/drivers/firmware/efi/efi.c
@@ -57,6 +57,7 @@ struct mm_struct efi_mm = {
 	.mm_rb			= RB_ROOT,
 	.mm_users		= ATOMIC_INIT(2),
 	.mm_count		= ATOMIC_INIT(1),
+	.write_protect_seq      = SEQCNT_ZERO(efi_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(efi_mm)
 	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
--- a/include/linux/mm_types.h~mm-prevent-gup_fast-from-racing-with-cow-during-fork
+++ a/include/linux/mm_types.h
@@ -14,6 +14,7 @@
 #include <linux/uprobes.h>
 #include <linux/page-flags-layout.h>
 #include <linux/workqueue.h>
+#include <linux/seqlock.h>
 
 #include <asm/mmu.h>
 
@@ -446,6 +447,13 @@ struct mm_struct {
 		 */
 		atomic_t has_pinned;
 
+		/**
+		 * @write_protect_seq: Locked when any thread is write
+		 * protecting pages mapped by this mm to enforce a later COW,
+		 * for instance during page table copying for fork().
+		 */
+		seqcount_t write_protect_seq;
+
 #ifdef CONFIG_MMU
 		atomic_long_t pgtables_bytes;	/* PTE page table pages */
 #endif
--- a/kernel/fork.c~mm-prevent-gup_fast-from-racing-with-cow-during-fork
+++ a/kernel/fork.c
@@ -1007,6 +1007,7 @@ static struct mm_struct *mm_init(struct
 	mm->vmacache_seqnum = 0;
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
+	seqcount_init(&mm->write_protect_seq);
 	mmap_init_lock(mm);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->core_state = NULL;
--- a/mm/gup.c~mm-prevent-gup_fast-from-racing-with-cow-during-fork
+++ a/mm/gup.c
@@ -2684,11 +2684,18 @@ static unsigned long lockless_pages_from
 {
 	unsigned long flags;
 	int nr_pinned = 0;
+	unsigned seq;
 
 	if (!IS_ENABLED(CONFIG_HAVE_FAST_GUP) ||
 	    !gup_fast_permitted(start, end))
 		return 0;
 
+	if (gup_flags & FOLL_PIN) {
+		seq = raw_read_seqcount(&current->mm->write_protect_seq);
+		if (seq & 1)
+			return 0;
+	}
+
 	/*
 	 * Disable interrupts. The nested form is used, in order to allow full,
 	 * general purpose use of this routine.
@@ -2703,6 +2710,17 @@ static unsigned long lockless_pages_from
 	local_irq_save(flags);
 	gup_pgd_range(start, end, gup_flags, pages, &nr_pinned);
 	local_irq_restore(flags);
+
+	/*
+	 * When pinning pages for DMA there could be a concurrent write protect
+	 * from fork() via copy_page_range(), in this case always fail fast GUP.
+	 */
+	if (gup_flags & FOLL_PIN) {
+		if (read_seqcount_retry(&current->mm->write_protect_seq, seq)) {
+			unpin_user_pages(pages, nr_pinned);
+			return 0;
+		}
+	}
 	return nr_pinned;
 }
 
--- a/mm/init-mm.c~mm-prevent-gup_fast-from-racing-with-cow-during-fork
+++ a/mm/init-mm.c
@@ -31,6 +31,7 @@ struct mm_struct init_mm = {
 	.pgd		= swapper_pg_dir,
 	.mm_users	= ATOMIC_INIT(2),
 	.mm_count	= ATOMIC_INIT(1),
+	.write_protect_seq = SEQCNT_ZERO(init_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(init_mm)
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.arg_lock	=  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
--- a/mm/memory.c~mm-prevent-gup_fast-from-racing-with-cow-during-fork
+++ a/mm/memory.c
@@ -1171,6 +1171,15 @@ copy_page_range(struct vm_area_struct *d
 		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
 					0, src_vma, src_mm, addr, end);
 		mmu_notifier_invalidate_range_start(&range);
+		/*
+		 * Disabling preemption is not needed for the write side, as
+		 * the read side doesn't spin, but goes to the mmap_lock.
+		 *
+		 * Use the raw variant of the seqcount_t write API to avoid
+		 * lockdep complaining about preemptibility.
+		*/
+		mmap_assert_write_locked(src_mm);
+		raw_write_seqcount_begin(&src_mm->write_protect_seq);
 	}
 
 	ret = 0;
@@ -1187,8 +1196,10 @@ copy_page_range(struct vm_area_struct *d
 		}
 	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
 
-	if (is_cow)
+	if (is_cow) {
+		raw_write_seqcount_end(&src_mm->write_protect_seq);
 		mmu_notifier_invalidate_range_end(&range);
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch
mm-reorganize-internal_get_user_pages_fast.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch

