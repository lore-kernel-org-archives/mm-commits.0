Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C07BC43334
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 22:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiFAWWg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiFAWWf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 18:22:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E65F7B
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 15:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 662A6B81CEC
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 22:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC422C385B8;
        Wed,  1 Jun 2022 22:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654122149;
        bh=lDwCk0GEHccj1OP/3q5h9bxK9kVfzgbzn9UUnlad6r8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rz4NzmLaQAxnGBqzt0bVaNfxFAahbtnSDue8LK64Il7wm/J22+ym1xO5DZTCTm5sN
         cz1S+IHlspiKCJQITFEfwDIc6TksX2WjJHczDR0MFWSRErlaJs7wVi/lvmMnIGTTVa
         Z/AV52cZyPOSgsQCXMElrLe+OWmnxqIOSH2//+So=
Date:   Wed, 1 Jun 2022 15:22:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     mm-commits@vger.kernel.org, Liam Howlett <liam.howlett@oracle.com>
Subject: Re: + mm-drop-oom-code-from-exit_mmap-fix.patch added to
 mm-unstable branch
Message-Id: <20220601152228.9f3186da0b507f5bab859f24@linux-foundation.org>
In-Reply-To: <CAJuCfpFvH0EnyNnc8bdFnMVE3tHWQX2zwN7L29Yz+PT_xsZq5A@mail.gmail.com>
References: <20220601220859.B1F0EC385A5@smtp.kernel.org>
        <CAJuCfpFvH0EnyNnc8bdFnMVE3tHWQX2zwN7L29Yz+PT_xsZq5A@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 1 Jun 2022 15:13:54 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> On Wed, Jun 1, 2022 at 3:09 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: mm-drop-oom-code-from-exit_mmap-fix
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-drop-oom-code-from-exit_mmap-fix.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-oom-code-from-exit_mmap-fix.patch
> >
> > This patch will later appear in the mm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> >
> > ------------------------------------------------------
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: mm-drop-oom-code-from-exit_mmap-fix
> > Date: Wed Jun  1 03:07:59 PM PDT 2022
> >
> > fix it for presense of mapletree patchset, per Suren
> 
> Andrew, could we also restore the mmap_lock_read/write retaking? It
> does make a difference for parallel memory reaping.
> If you want I can post a v3 with more explanation about that and also
> a separate patchset applied over maple-tree branch (if you have it
> separately). Should I?

Like this?


--- a/mm/mmap.c~mm-drop-oom-code-from-exit_mmap-fix-fix
+++ a/mm/mmap.c
@@ -3171,13 +3171,13 @@ void exit_mmap(struct mm_struct *mm)
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
 
-	mmap_write_lock(mm);
+	mmap_read_lock(mm);
 	arch_exit_mmap(mm);
 
 	vma = mas_find(&mas, ULONG_MAX);
 	if (!vma) {
 		/* Can happen if dup_mmap() received an OOM */
-		mmap_write_unlock(mm);
+		mmap_read_unlock(mm);
 		return;
 	}
 
@@ -3187,6 +3187,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
@@ -3194,6 +3195,7 @@ void exit_mmap(struct mm_struct *mm)
 	 * mm_is_oom_victim because setting a bit unconditionally is cheaper.
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
+	mmap_write_unlock(mm);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);
_



void exit_mmap(struct mm_struct *mm)
{
	struct mmu_gather tlb;
	struct vm_area_struct *vma;
	unsigned long nr_accounted = 0;
	MA_STATE(mas, &mm->mm_mt, 0, 0);
	int count = 0;

	/* mm's last user has gone, and its about to be pulled down */
	mmu_notifier_release(mm);

	mmap_read_lock(mm);
	arch_exit_mmap(mm);

	vma = mas_find(&mas, ULONG_MAX);
	if (!vma) {
		/* Can happen if dup_mmap() received an OOM */
		mmap_read_unlock(mm);
		return;
	}

	lru_add_drain();
	flush_cache_mm(mm);
	tlb_gather_mmu_fullmm(&tlb, mm);
	/* update_hiwater_rss(mm) here? but nobody should be looking */
	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
	unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX);
	mmap_read_unlock(mm);

	/*
	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
	 * because the memory has been already freed. Do not bother checking
	 * mm_is_oom_victim because setting a bit unconditionally is cheaper.
	 */
	set_bit(MMF_OOM_SKIP, &mm->flags);
	mmap_write_unlock(mm);
	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
		      USER_PGTABLES_CEILING);
	tlb_finish_mmu(&tlb);

	/*
	 * Walk the list again, actually closing and freeing it, with preemption
	 * enabled, without holding any MM locks besides the unreachable
	 * mmap_write_lock.
	 */
	do {
		if (vma->vm_flags & VM_ACCOUNT)
			nr_accounted += vma_pages(vma);
		remove_vma(vma);
		count++;
		cond_resched();
	} while ((vma = mas_find(&mas, ULONG_MAX)) != NULL);

	BUG_ON(count != mm->map_count);

	trace_exit_mmap(mm);
	__mt_destroy(&mm->mm_mt);
	mmap_write_unlock(mm);
	vm_unacct_memory(nr_accounted);
}

