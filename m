Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6540CC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjDRXlQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjDRXlC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:02 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4163118D5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:39:52 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-54ee0b73e08so482066867b3.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681861192; x=1684453192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//5+4+WNWSvANP8V8LVMMjYGHaRSHFgKB1LdOKj9pmc=;
        b=1nvoHHrgxtGXpaTMoCPjgC+FJb75dwSZ1wqBQVhTxPkH3x5NbZEi930YJmP24D7Qoq
         gMEa4WOjTMaD9FPIfW5pKLBH/s2NxSenE2CszGKW/+XdlNLr/09NBxB/1daWkIugLrzu
         cy/femaCs6Ma30b2ZIlbIlN3r+jqzQQOJOmySsFO7hiCYzGJZgy7wwIxxEjEEBG5tQiO
         bJ1ghFHMU+2R7L/MX3X+5GgEspDnzZmwCkbbwuMyk2vTSWfRXiNsDd7WfICF7lchMTga
         0UMoQExd80R7Te6iw0nFtWfrVz8olou5+a9lKlWNXZ2DxMWX3+bSyZdokAZnEA30qw5D
         KRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681861192; x=1684453192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//5+4+WNWSvANP8V8LVMMjYGHaRSHFgKB1LdOKj9pmc=;
        b=KlIr/yhxtGxEFRsAYJDNBKTDTOA3c0w+6DTIA7s4Zkx8r65Vl7NwFiowdTKI/BU1rZ
         JO1icotoRIc8S+QKD6K0rcFHCKLp7KCWtOoX05I9SY7W4U6Q5E2zypQM+kclozBGhG7l
         xvhweq5Fqji3tEMQRq9rhKkzLUl7bZhLNcPE5/s0Mt5VvlnyeF010FfG0xlmNaO4qnou
         dhnOLc/08TNmxA3bmCJEXVA+9vMRQHUh5n9ESUQ4KoFMS4HdW5m8ESouYm3ERdKJImh4
         EtMolAVGRaQ0g8nMUziThHtD5+yQJL7VkqznTZe5pKJBFePUZKIRHvkGJ+6UDD5g18Gh
         +lRg==
X-Gm-Message-State: AAQBX9dTCCw0RYSN0TDA6H1HqOYHoWdJtbN47fsC5f/OzbxqHLQOiKih
        phjF1cOmD0FsAkXKgAJR7FPO902IA6UiGuXMBm3Y3w==
X-Google-Smtp-Source: AKy350bJZMlZtDF2P6UFS9FTPbyaf/YoUuMYaL8YEJ4bFMTb2M4ZGRbHkd0Lm0cf6E4HwvsdX5pA8inZOvC4Xdp+LMs=
X-Received: by 2002:a81:8444:0:b0:541:7565:e35b with SMTP id
 u65-20020a818444000000b005417565e35bmr395789ywf.26.1681861191924; Tue, 18 Apr
 2023 16:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230418233556.91AA5C433D2@smtp.kernel.org>
In-Reply-To: <20230418233556.91AA5C433D2@smtp.kernel.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 18 Apr 2023 16:39:40 -0700
Message-ID: <CAJuCfpFjfZEWpS2G4YijK0SQ2+0fHqk9k-4YLHsyw9jNQm8RnA@mail.gmail.com>
Subject: Re: [merged mm-stable] mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked.patch
 removed from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        punit.agrawal@bytedance.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hannes@cmpxchg.org,
        dave@stgolabs.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Apr 18, 2023 at 4:35=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The quilt patch titled
>      Subject: mm: handle swap page faults under vma lock if page is uncon=
tended
> has been removed from the -mm tree.  Its filename was
>      mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Andrew, there are cases which are not properly handled in this patch,
outlined here: https://lore.kernel.org/all/87sfczuxkc.fsf@nvidia.com/
Please drop it for now until I post the next version. It's not stable
material yet. Thanks!

>
> ------------------------------------------------------
> From: Suren Baghdasaryan <surenb@google.com>
> Subject: mm: handle swap page faults under vma lock if page is uncontende=
d
> Date: Fri, 14 Apr 2023 11:00:43 -0700
>
> When page fault is handled under VMA lock protection, all swap page fault=
s
> are retried with mmap_lock because folio_lock_or_retry implementation has
> to drop and reacquire mmap_lock if folio could not be immediately locked.
>
> Instead of retrying all swapped page faults, retry only when folio lockin=
g
> fails.
>
> Link: https://lkml.kernel.org/r/20230414180043.1839745-1-surenb@google.co=
m
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
> Cc: Lorenzo Stoakes <lstoakes@gmail.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Michel Lespinasse <michel@lespinasse.org>
> Cc: Minchan Kim <minchan@google.com>
> Cc: Punit Agrawal <punit.agrawal@bytedance.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/filemap.c |    6 ++++++
>  mm/memory.c  |    5 -----
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> --- a/mm/filemap.c~mm-handle-swap-page-faults-if-the-faulting-page-can-be=
-locked
> +++ a/mm/filemap.c
> @@ -1706,6 +1706,8 @@ static int __folio_lock_async(struct fol
>   *     mmap_lock has been released (mmap_read_unlock(), unless flags had=
 both
>   *     FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_RETRY_NOWAIT set, in
>   *     which case mmap_lock is still held.
> + *     If flags had FAULT_FLAG_VMA_LOCK set, meaning the operation is pe=
rformed
> + *     with VMA lock only, the VMA lock is still held.
>   *
>   * If neither ALLOW_RETRY nor KILLABLE are set, will always return true
>   * with the folio locked and the mmap_lock unperturbed.
> @@ -1713,6 +1715,10 @@ static int __folio_lock_async(struct fol
>  bool __folio_lock_or_retry(struct folio *folio, struct mm_struct *mm,
>                          unsigned int flags)
>  {
> +       /* Can't do this if not holding mmap_lock */
> +       if (flags & FAULT_FLAG_VMA_LOCK)
> +               return false;
> +
>         if (fault_flag_allow_retry_first(flags)) {
>                 /*
>                  * CAUTION! In this case, mmap_lock is not released
> --- a/mm/memory.c~mm-handle-swap-page-faults-if-the-faulting-page-can-be-=
locked
> +++ a/mm/memory.c
> @@ -3711,11 +3711,6 @@ vm_fault_t do_swap_page(struct vm_fault
>         if (!pte_unmap_same(vmf))
>                 goto out;
>
> -       if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
> -               ret =3D VM_FAULT_RETRY;
> -               goto out;
> -       }
> -
>         entry =3D pte_to_swp_entry(vmf->orig_pte);
>         if (unlikely(non_swap_entry(entry))) {
>                 if (is_migration_entry(entry)) {
> _
>
> Patches currently in -mm which might be from surenb@google.com are
>
>
