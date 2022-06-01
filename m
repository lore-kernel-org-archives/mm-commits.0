Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF1EC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 22:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbiFAWh4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiFAWh4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 18:37:56 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6237135875
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 15:37:55 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id a64so5322364ybg.11
        for <mm-commits@vger.kernel.org>; Wed, 01 Jun 2022 15:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IQtElE62DnIbkCuA+QlZdDaVltIjfqXD5uv81M70DzI=;
        b=ERwnCmDQyhnAZpUVxQeNdRSJ3MIuKcQqk0HjtRuCAhSZb32vZcBpwWoDcHg0wiEY3W
         KD/btKFZJ/2ZzXd7ec72wIz38TQfNBeIIFea6qjasswbS6+9y7s4kWRNnODGFZsqd8c3
         ie2VxVdR+ZfuYu3cLllvD/FrSgqDWP3rAf/CCTykY2FiQBOdu7SWETlb6qvR82ZH9kbQ
         rR2OOvOgud3qNJZBRE2P3pFc58T/J42w6L/oI2ZudCZacy+7yuJcCVldEkdaYyONCEaS
         YJGfccjmbJTcL4FdbZC1Xp9lgcmK0ND/hasCS3ibWRXYDQHGriWAL8baQCdw4EJ6LAnR
         wUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IQtElE62DnIbkCuA+QlZdDaVltIjfqXD5uv81M70DzI=;
        b=DWav1H/WlR4tBlcwn+dxRvmOiM3S5G7I0GdV5SYHHzfXTgm3JOmzmOT2Wi07DCQAey
         XcSqDaiy1bVUcQmJZwi3kLp54cn4/dLXz7BDA9i4tZl4b/jKwYz/X2tgRTjP6HEYOH2x
         +DMu/zQ0uMl9eo4wEAaUQguNp1bt9QHr6GZyThZzW4Dq6OusUzbmSdbSOko2F8h31v/g
         Jb0mLSS2XtsMrOtT/XoIF6oP/JJCYEhB2+iLmFUigGCNGeEDBTpR2zzNaKVKCklRSbWc
         4oo4+XxQRH8PPiXMIpRmurRbanY718NUf7d6BT+8n0cYo90sYd7ibeokZPwzwvLsz7Qs
         xOWA==
X-Gm-Message-State: AOAM530FarLn7MRsHiSLY6PvBJ+EBl7jGvRFCMLqhSLRbE25sVSy62h1
        sQDIr3/91LVc4ZGSDJ91djigkljg2h5QEEkFVF+yH3U/5DKMUg==
X-Google-Smtp-Source: ABdhPJzp5HNytuaaiWL6uVfPKsB6syEzLgdA0SDdVqT9SSi4Zk6sFR1bBAd/vtLmrKEcmrapN0/F7yJMgBNGkRGvdbA=
X-Received: by 2002:a25:bc88:0:b0:65b:cea3:b603 with SMTP id
 e8-20020a25bc88000000b0065bcea3b603mr2139967ybk.282.1654123074376; Wed, 01
 Jun 2022 15:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220601220859.B1F0EC385A5@smtp.kernel.org> <CAJuCfpFvH0EnyNnc8bdFnMVE3tHWQX2zwN7L29Yz+PT_xsZq5A@mail.gmail.com>
 <20220601152228.9f3186da0b507f5bab859f24@linux-foundation.org>
In-Reply-To: <20220601152228.9f3186da0b507f5bab859f24@linux-foundation.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 1 Jun 2022 15:37:43 -0700
Message-ID: <CAJuCfpFYrG-xT3uX69MZsDEmLjdfXx2xksRwbwsbNwJWy6AYYg@mail.gmail.com>
Subject: Re: + mm-drop-oom-code-from-exit_mmap-fix.patch added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Liam Howlett <liam.howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 1, 2022 at 3:22 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 1 Jun 2022 15:13:54 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
>
> > On Wed, Jun 1, 2022 at 3:09 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > >
> > > The patch titled
> > >      Subject: mm-drop-oom-code-from-exit_mmap-fix
> > > has been added to the -mm mm-unstable branch.  Its filename is
> > >      mm-drop-oom-code-from-exit_mmap-fix.patch
> > >
> > > This patch will shortly appear at
> > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-oom-code-from-exit_mmap-fix.patch
> > >
> > > This patch will later appear in the mm-unstable branch at
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > >
> > > Before you just go and hit "reply", please:
> > >    a) Consider who else should be cc'ed
> > >    b) Prefer to cc a suitable mailing list as well
> > >    c) Ideally: find the original patch on the mailing list and do a
> > >       reply-to-all to that, adding suitable additional cc's
> > >
> > > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > >
> > > The -mm tree is included into linux-next via the mm-everything
> > > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > > and is updated there every 2-3 working days
> > >
> > > ------------------------------------------------------
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > Subject: mm-drop-oom-code-from-exit_mmap-fix
> > > Date: Wed Jun  1 03:07:59 PM PDT 2022
> > >
> > > fix it for presense of mapletree patchset, per Suren
> >
> > Andrew, could we also restore the mmap_lock_read/write retaking? It
> > does make a difference for parallel memory reaping.
> > If you want I can post a v3 with more explanation about that and also
> > a separate patchset applied over maple-tree branch (if you have it
> > separately). Should I?
>
> Like this?

Almost. See below:

>
>
> --- a/mm/mmap.c~mm-drop-oom-code-from-exit_mmap-fix-fix
> +++ a/mm/mmap.c
> @@ -3171,13 +3171,13 @@ void exit_mmap(struct mm_struct *mm)
>         /* mm's last user has gone, and its about to be pulled down */
>         mmu_notifier_release(mm);
>
> -       mmap_write_lock(mm);
> +       mmap_read_lock(mm);
>         arch_exit_mmap(mm);
>
>         vma = mas_find(&mas, ULONG_MAX);
>         if (!vma) {
>                 /* Can happen if dup_mmap() received an OOM */
> -               mmap_write_unlock(mm);
> +               mmap_read_unlock(mm);
>                 return;
>         }
>
> @@ -3187,6 +3187,7 @@ void exit_mmap(struct mm_struct *mm)
>         /* update_hiwater_rss(mm) here? but nobody should be looking */
>         /* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
>         unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX);
> +       mmap_read_unlock(mm);
>
>         /*
>          * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
> @@ -3194,6 +3195,7 @@ void exit_mmap(struct mm_struct *mm)
>          * mm_is_oom_victim because setting a bit unconditionally is cheaper.
>          */
>         set_bit(MMF_OOM_SKIP, &mm->flags);
> +       mmap_write_unlock(mm);

Instead of the line above ^^^
+
+       mmap_write_lock(mm);

So the code should read as:
```
        mmap_read_unlock(mm);

        /*
        * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
        * because the memory has been already freed. Do not bother checking
        * mm_is_oom_victim because setting a bit unconditionally is cheaper.
        */
        set_bit(MMF_OOM_SKIP, &mm->flags);

        mmap_write_lock(mm);
        free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
...
```


>         free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
>                       USER_PGTABLES_CEILING);
>         tlb_finish_mmu(&tlb);
> _
>
>
>
> void exit_mmap(struct mm_struct *mm)
> {
>         struct mmu_gather tlb;
>         struct vm_area_struct *vma;
>         unsigned long nr_accounted = 0;
>         MA_STATE(mas, &mm->mm_mt, 0, 0);
>         int count = 0;
>
>         /* mm's last user has gone, and its about to be pulled down */
>         mmu_notifier_release(mm);
>
>         mmap_read_lock(mm);
>         arch_exit_mmap(mm);
>
>         vma = mas_find(&mas, ULONG_MAX);
>         if (!vma) {
>                 /* Can happen if dup_mmap() received an OOM */
>                 mmap_read_unlock(mm);
>                 return;
>         }
>
>         lru_add_drain();
>         flush_cache_mm(mm);
>         tlb_gather_mmu_fullmm(&tlb, mm);
>         /* update_hiwater_rss(mm) here? but nobody should be looking */
>         /* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
>         unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX);
>         mmap_read_unlock(mm);
>
>         /*
>          * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
>          * because the memory has been already freed. Do not bother checking
>          * mm_is_oom_victim because setting a bit unconditionally is cheaper.
>          */
>         set_bit(MMF_OOM_SKIP, &mm->flags);
>         mmap_write_unlock(mm);
>         free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
>                       USER_PGTABLES_CEILING);
>         tlb_finish_mmu(&tlb);
>
>         /*
>          * Walk the list again, actually closing and freeing it, with preemption
>          * enabled, without holding any MM locks besides the unreachable
>          * mmap_write_lock.
>          */
>         do {
>                 if (vma->vm_flags & VM_ACCOUNT)
>                         nr_accounted += vma_pages(vma);
>                 remove_vma(vma);
>                 count++;
>                 cond_resched();
>         } while ((vma = mas_find(&mas, ULONG_MAX)) != NULL);
>
>         BUG_ON(count != mm->map_count);
>
>         trace_exit_mmap(mm);
>         __mt_destroy(&mm->mm_mt);
>         mmap_write_unlock(mm);
>         vm_unacct_memory(nr_accounted);
> }
>
