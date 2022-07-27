Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543EEC04A68
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jul 2022 19:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiG0TCs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jul 2022 15:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiG0TCa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2022 15:02:30 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB8C78DC7
        for <mm-commits@vger.kernel.org>; Wed, 27 Jul 2022 11:17:31 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 123so8736555ybv.7
        for <mm-commits@vger.kernel.org>; Wed, 27 Jul 2022 11:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fo8Eqa356iNIZgJgf3cJobM6yNmbxSkFduar/22VyJ0=;
        b=lNJavfPslpDGAv52YRj6RAppERFqlKPK5+Viq8HO1Wb9HX5du4kE3c7yUUD/NqKy9e
         hlhoN/D37Q4FKslN5cROPHXBdGe/Qj5lXMAMOMGLSdqXcHWotA28YgxxXCaHeoFephUi
         ByGsTOXlzP61C0VPUUlYkVjauqABT/p9o5MWnP1dl84M+fsa6W26TVTM5OSl76dxBhOh
         ncXxEJktMmqWUSleV3A+69yz+LlKoihK/6JnVe6KrhFqxl9qKNQ3eWbUBuOePL+nWa9K
         rqahJxWlz8FIxkw9l3wV5OJHq97dtS1eJLSE5Y7nQrROR1rH4zdOsIJJJLbExSC7iIZ/
         JL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fo8Eqa356iNIZgJgf3cJobM6yNmbxSkFduar/22VyJ0=;
        b=kAwY+eXjg33MN9U/YyXpGbUlbqZYIGVafe/aY0/ORaob7FqmgNAeg2rX/FCl3Xqve6
         irPXcHNzdi1IzmB2aKzqoPHS/2Qtnc4HMKao347zwh05YLiXh1UUN6qSTf/DLO3168wh
         SUX1aJx8fduQYSZJq9OndcEYY/IA6wUIgX8su3lzUh591/L5wJ0swWO5c8YhNtN97sNx
         qU+vx2c1tDPp2Hq1fufs5gqBv4Nq8yJUNARk28hi2/JuPdD4jvK34BJT2hija9P4g+oU
         jVFug6oUE2v4LQv7guwJAQyM32QI4ypFF0esntwTOESX2Xsz8plHJaQWs7k2P0SGPTNe
         N9WQ==
X-Gm-Message-State: AJIora+MlPKM0tXFQk97QDbVxjYCBDzTsPwO85VhLhkRY0LrbBvLY5r8
        fpLlB/1SLb7BKoy1pKIPfbi76EPcaEq4YGpk/ze3Q2tp23Uwiw==
X-Google-Smtp-Source: AGRyM1t6nxWcZpc302L2zDS7Yu0vf6wvU/t+mt5HWpazznc7rmdpC7RU/G5HVqRvCl7ZFtSsg9DEsR+sFEmmIMAiT24=
X-Received: by 2002:a25:e795:0:b0:671:6d9f:5db3 with SMTP id
 e143-20020a25e795000000b006716d9f5db3mr7835654ybh.282.1658945850950; Wed, 27
 Jul 2022 11:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220601213751.9305CC385A5@smtp.kernel.org>
In-Reply-To: <20220601213751.9305CC385A5@smtp.kernel.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 27 Jul 2022 11:17:20 -0700
Message-ID: <CAJuCfpE3V6LzL+XW2mzLm-h1f9KVurp8v_cKNstR+dqmw1MYNw@mail.gmail.com>
Subject: Re: + mm-delete-unused-mmf_oom_victim-flag.patch added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On Wed, Jun 1, 2022 at 2:37 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm: delete unused MMF_OOM_VICTIM flag
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-delete-unused-mmf_oom_victim-flag.patch

I can't find this and the accompanying patch
(https://lore.kernel.org/all/20220601213748.DAF1DC385A5@smtp.kernel.org/
and https://lore.kernel.org/all/20220601213751.9305CC385A5@smtp.kernel.org/)
in any tree now and can't find any notifications about them being
dropped. Could you please check what happened to them? I remember
there was a minor conflict with maple-tree patchset that we resolved,
so maybe they are queued together?
Thanks,
Suren.

>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-delete-unused-mmf_oom_victim-flag.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Suren Baghdasaryan <surenb@google.com>
> Subject: mm: delete unused MMF_OOM_VICTIM flag
> Date: Tue, 31 May 2022 15:31:00 -0700
>
> With the last usage of MMF_OOM_VICTIM in exit_mmap gone, this flag is now
> unused and can be removed.
>
> Link: https://lkml.kernel.org/r/20220531223100.510392-2-surenb@google.com
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/oom.h            |    9 ---------
>  include/linux/sched/coredump.h |    7 +++----
>  mm/oom_kill.c                  |    4 +---
>  3 files changed, 4 insertions(+), 16 deletions(-)
>
> --- a/include/linux/oom.h~mm-delete-unused-mmf_oom_victim-flag
> +++ a/include/linux/oom.h
> @@ -78,15 +78,6 @@ static inline bool tsk_is_oom_victim(str
>  }
>
>  /*
> - * Use this helper if tsk->mm != mm and the victim mm needs a special
> - * handling. This is guaranteed to stay true after once set.
> - */
> -static inline bool mm_is_oom_victim(struct mm_struct *mm)
> -{
> -       return test_bit(MMF_OOM_VICTIM, &mm->flags);
> -}
> -
> -/*
>   * Checks whether a page fault on the given mm is still reliable.
>   * This is no longer true if the oom reaper started to reap the
>   * address space which is reflected by MMF_UNSTABLE flag set in
> --- a/include/linux/sched/coredump.h~mm-delete-unused-mmf_oom_victim-flag
> +++ a/include/linux/sched/coredump.h
> @@ -71,9 +71,8 @@ static inline int get_dumpable(struct mm
>  #define MMF_UNSTABLE           22      /* mm is unstable for copy_from_user */
>  #define MMF_HUGE_ZERO_PAGE     23      /* mm has ever used the global huge zero page */
>  #define MMF_DISABLE_THP                24      /* disable THP for all VMAs */
> -#define MMF_OOM_VICTIM         25      /* mm is the oom victim */
> -#define MMF_OOM_REAP_QUEUED    26      /* mm was queued for oom_reaper */
> -#define MMF_MULTIPROCESS       27      /* mm is shared between processes */
> +#define MMF_OOM_REAP_QUEUED    25      /* mm was queued for oom_reaper */
> +#define MMF_MULTIPROCESS       26      /* mm is shared between processes */
>  /*
>   * MMF_HAS_PINNED: Whether this mm has pinned any pages.  This can be either
>   * replaced in the future by mm.pinned_vm when it becomes stable, or grow into
> @@ -81,7 +80,7 @@ static inline int get_dumpable(struct mm
>   * pinned pages were unpinned later on, we'll still keep this bit set for the
>   * lifecycle of this mm, just for simplicity.
>   */
> -#define MMF_HAS_PINNED         28      /* FOLL_PIN has run, never cleared */
> +#define MMF_HAS_PINNED         27      /* FOLL_PIN has run, never cleared */
>  #define MMF_DISABLE_THP_MASK   (1 << MMF_DISABLE_THP)
>
>  #define MMF_INIT_MASK          (MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
> --- a/mm/oom_kill.c~mm-delete-unused-mmf_oom_victim-flag
> +++ a/mm/oom_kill.c
> @@ -765,10 +765,8 @@ static void mark_oom_victim(struct task_
>                 return;
>
>         /* oom_mm is bound to the signal struct life time. */
> -       if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm)) {
> +       if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
>                 mmgrab(tsk->signal->oom_mm);
> -               set_bit(MMF_OOM_VICTIM, &mm->flags);
> -       }
>
>         /*
>          * Make sure that the task is woken up from uninterruptible sleep
> _
>
> Patches currently in -mm which might be from surenb@google.com are
>
> mm-drop-oom-code-from-exit_mmap.patch
> mm-delete-unused-mmf_oom_victim-flag.patch
>
