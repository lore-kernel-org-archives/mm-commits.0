Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843E612C52B
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706724140; cv=none; b=dy5cELHpNDwxzeCqY7zPJ05I7s0Ttpo+HQ3IpWomGj5Q3B4FjIulXgazdhBgN2a9G5DVNIjhowQMrKr4SoAdkKodAdX4iYfENnWaMi4IxSb5L9xcP4LaK3AfQJrXFv4Wrvb4ima2VEKJZX3KNx0uhXHzsxfjO3+SaiCMgHyZeQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706724140; c=relaxed/simple;
	bh=we+BZgDFLRwVCAiwqRLSMMQZu12mNWMqdq/PsNXO5QE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ovE02HXB3T/B87lCtyLBcm2rBTY2lZ/d6Sk+9Tff8tfIXEWQ55TJmTZmtUl1mxPQ9GaVrVAIF31WJgXzIQO5Asn/mE8iqo81szep6ROt+Zj2NEL8+8OBKXXDv4mFJ7Kpaedh3QMjQfbHxPV05bhOBvf55UTO7S3EI9YkZ+DJArg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=voi1+eOh; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="voi1+eOh"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-dbed179f0faso957070276.1
        for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 10:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706724137; x=1707328937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZNrdHeGGT+ujdnBynmpFkwjaZzvCq5rGLApTiNatGE=;
        b=voi1+eOh/leTiNDAHFYnNYmBaPVvNEV233YK2ipyl4Ba/Jf4FCM+1tZD31ys5qRfVV
         hYx1dAjh5xEtb0nyQy9y0c7v9dt3CZpyshdC/WlMjfqOz3UnjjNRj34F5vM230YNSxv7
         PNy/Os3VLVKYMofFz01qBMF5YTTwae3MqfdvmEfGw9qrMc+oYTYCHOuvkK7aTxoluS5p
         ovMPChboekNlV4Vbr3P8MJnUXrDd4MR7LmhaYBoq9Ywfs2GQRc1dL/NrCl47Gnv40uEU
         /CdtQPrKhsqVk4rZAuaBqo88QqG6LzQOroSI1OoqzW4pNYjnCkt9bFiKOVV+85HfQIys
         BIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706724137; x=1707328937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nZNrdHeGGT+ujdnBynmpFkwjaZzvCq5rGLApTiNatGE=;
        b=VBJw0WhYefxJJ87jrMbZ7DWmRAcar9Bi2kAr/aB+LARw4lB5rqOLSDd5zV5ZE4PER/
         PE90RktV8qIf2MYwKGER4t5tKMvQftPZpLDh+iwf4lmsR8V9RQ3k/l0O2csbAg7UKR+B
         nCOV39uU0skn0AwaBUYdvVqpKoX27y5mAvgEVDUox5ZPPCU2rHaEYyKEurbykoYzYTm2
         KIttSCZQ+VkOg8IFPQlEFwY4yRmgWh93Ui7KfMalj9GkCkd4N17jMeMB1oJHbxGHa1GD
         h1UbN4psvREE3+o2obOL65Y6aurfmc69wxMVwi7Go1NlvjWV2wnCKc/5HqUoDbmdHVi6
         pszQ==
X-Gm-Message-State: AOJu0YxmJkpOkn1R0RufoxYinQOiWOMCxW3Ndz/Tc8WGHIBEgnA+LFxy
	S/57wi799qvmw/VH3xcqsuxl3SjgKk0KhMFoaQ47rEp8C36SqQ/XObVDT9wt/XkP6fzsB8CP7U3
	ykkPweb6NGrdG+ClRtQI2BrM7V60k59VSSakt409a8kZf1EU5CkAi
X-Google-Smtp-Source: AGHT+IH1tNn+l6L/JbmkbG7e6wr9Vsy1sKvWWERGymCeLWAzn1fjtRVW7OACHygcTkDk3vj7GpK1LJKKDV2aGEEXniQ=
X-Received: by 2002:a25:7494:0:b0:dc6:ca28:582 with SMTP id
 p142-20020a257494000000b00dc6ca280582mr1108705ybc.0.1706724135953; Wed, 31
 Jan 2024 10:02:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131092736.0C8A4C433C7@smtp.kernel.org>
In-Reply-To: <20240131092736.0C8A4C433C7@smtp.kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 31 Jan 2024 10:02:03 -0800
Message-ID: <CAJuCfpG0JH9RqxZw8ho6mYKvWkAaHzt39LVORMcMHBOY5scg+Q@mail.gmail.com>
Subject: Re: [to-be-updated] userfaultfd-handle-zeropage-moves-by-uffdio_move.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhangpeng362@huawei.com, willy@infradead.org, 
	viro@zeniv.linux.org.uk, shuah@kernel.org, ryan.roberts@arm.com, 
	rppt@kernel.org, peterx@redhat.com, ngeoffray@google.com, mhocko@suse.com, 
	lokeshgidra@google.com, Liam.Howlett@oracle.com, kaleshsingh@google.com, 
	jannh@google.com, hughd@google.com, david@redhat.com, brauner@kernel.org, 
	bgeffon@google.com, axelrasmussen@google.com, aarcange@redhat.com, 
	Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 1:27=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The quilt patch titled
>      Subject: userfaultfd: handle zeropage moves by UFFDIO_MOVE
> has been removed from the -mm tree.  Its filename was
>      userfaultfd-handle-zeropage-moves-by-uffdio_move.patch
>
> This patch was dropped because an updated version will be merged

Updated version v2 is posted at
https://lore.kernel.org/all/20240131175618.2417291-1-surenb@google.com/

>
> ------------------------------------------------------
> From: Suren Baghdasaryan <surenb@google.com>
> Subject: userfaultfd: handle zeropage moves by UFFDIO_MOVE
> Date: Wed, 24 Jan 2024 16:13:28 -0800
>
> Current implementation of UFFDIO_MOVE fails to move zeropages and returns
> EBUSY when it encounters one. We can handle them by mapping a zeropage
> at the destination and clearing the mapping at the source. This is done
> both for ordinary and for huge zeropages.
>
> Link: https://lkml.kernel.org/r/20240125001328.335127-1-surenb@google.com
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Brian Geffon <bgeffon@google.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Lokesh Gidra <lokeshgidra@google.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport (IBM) <rppt@kernel.org>
> Cc: Nicolas Geoffray <ngeoffray@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: ZhangPeng <zhangpeng362@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/huge_memory.c |  111 +++++++++++++++++++++++++--------------------
>  mm/userfaultfd.c |   42 ++++++++++++++---
>  2 files changed, 99 insertions(+), 54 deletions(-)
>
> --- a/mm/huge_memory.c~userfaultfd-handle-zeropage-moves-by-uffdio_move
> +++ a/mm/huge_memory.c
> @@ -2200,13 +2200,18 @@ int move_pages_huge_pmd(struct mm_struct
>         }
>
>         src_page =3D pmd_page(src_pmdval);
> -       if (unlikely(!PageAnonExclusive(src_page))) {
> -               spin_unlock(src_ptl);
> -               return -EBUSY;
> -       }
>
> -       src_folio =3D page_folio(src_page);
> -       folio_get(src_folio);
> +       if (!is_huge_zero_pmd(src_pmdval)) {
> +               if (unlikely(!PageAnonExclusive(src_page))) {
> +                       spin_unlock(src_ptl);
> +                       return -EBUSY;
> +               }
> +
> +               src_folio =3D page_folio(src_page);
> +               folio_get(src_folio);
> +       } else
> +               src_folio =3D NULL;
> +
>         spin_unlock(src_ptl);
>
>         flush_cache_range(src_vma, src_addr, src_addr + HPAGE_PMD_SIZE);
> @@ -2214,19 +2219,22 @@ int move_pages_huge_pmd(struct mm_struct
>                                 src_addr + HPAGE_PMD_SIZE);
>         mmu_notifier_invalidate_range_start(&range);
>
> -       folio_lock(src_folio);
> +       if (src_folio) {
> +               folio_lock(src_folio);
>
> -       /*
> -        * split_huge_page walks the anon_vma chain without the page
> -        * lock. Serialize against it with the anon_vma lock, the page
> -        * lock is not enough.
> -        */
> -       src_anon_vma =3D folio_get_anon_vma(src_folio);
> -       if (!src_anon_vma) {
> -               err =3D -EAGAIN;
> -               goto unlock_folio;
> -       }
> -       anon_vma_lock_write(src_anon_vma);
> +               /*
> +                * split_huge_page walks the anon_vma chain without the p=
age
> +                * lock. Serialize against it with the anon_vma lock, the=
 page
> +                * lock is not enough.
> +                */
> +               src_anon_vma =3D folio_get_anon_vma(src_folio);
> +               if (!src_anon_vma) {
> +                       err =3D -EAGAIN;
> +                       goto unlock_folio;
> +               }
> +               anon_vma_lock_write(src_anon_vma);
> +       } else
> +               src_anon_vma =3D NULL;
>
>         dst_ptl =3D pmd_lockptr(mm, dst_pmd);
>         double_pt_lock(src_ptl, dst_ptl);
> @@ -2235,45 +2243,54 @@ int move_pages_huge_pmd(struct mm_struct
>                 err =3D -EAGAIN;
>                 goto unlock_ptls;
>         }
> -       if (folio_maybe_dma_pinned(src_folio) ||
> -           !PageAnonExclusive(&src_folio->page)) {
> -               err =3D -EBUSY;
> -               goto unlock_ptls;
> -       }
> -
> -       if (WARN_ON_ONCE(!folio_test_head(src_folio)) ||
> -           WARN_ON_ONCE(!folio_test_anon(src_folio))) {
> -               err =3D -EBUSY;
> -               goto unlock_ptls;
> -       }
> -
> -       folio_move_anon_rmap(src_folio, dst_vma);
> -       WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr)=
);
> -
> -       src_pmdval =3D pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> -       /* Folio got pinned from under us. Put it back and fail the move.=
 */
> -       if (folio_maybe_dma_pinned(src_folio)) {
> -               set_pmd_at(mm, src_addr, src_pmd, src_pmdval);
> -               err =3D -EBUSY;
> -               goto unlock_ptls;
> +       if (src_folio) {
> +               if (folio_maybe_dma_pinned(src_folio) ||
> +                   !PageAnonExclusive(&src_folio->page)) {
> +                       err =3D -EBUSY;
> +                       goto unlock_ptls;
> +               }
> +
> +               if (WARN_ON_ONCE(!folio_test_head(src_folio)) ||
> +                   WARN_ON_ONCE(!folio_test_anon(src_folio))) {
> +                       err =3D -EBUSY;
> +                       goto unlock_ptls;
> +               }
> +
> +               folio_move_anon_rmap(src_folio, dst_vma);
> +               WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, d=
st_addr));
> +
> +               src_pmdval =3D pmdp_huge_clear_flush(src_vma, src_addr, s=
rc_pmd);
> +               /* Folio got pinned from under us. Put it back and fail t=
he move. */
> +               if (folio_maybe_dma_pinned(src_folio)) {
> +                       set_pmd_at(mm, src_addr, src_pmd, src_pmdval);
> +                       err =3D -EBUSY;
> +                       goto unlock_ptls;
> +               }
> +
> +               _dst_pmd =3D mk_huge_pmd(&src_folio->page, dst_vma->vm_pa=
ge_prot);
> +               /* Follow mremap() behavior and treat the entry dirty aft=
er the move */
> +               _dst_pmd =3D pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
> +       } else {
> +               src_pmdval =3D pmdp_huge_clear_flush(src_vma, src_addr, s=
rc_pmd);
> +               _dst_pmd =3D mk_huge_pmd(src_page, dst_vma->vm_page_prot)=
;
>         }
> -
> -       _dst_pmd =3D mk_huge_pmd(&src_folio->page, dst_vma->vm_page_prot)=
;
> -       /* Follow mremap() behavior and treat the entry dirty after the m=
ove */
> -       _dst_pmd =3D pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>         set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
>
>         src_pgtable =3D pgtable_trans_huge_withdraw(mm, src_pmd);
>         pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
>  unlock_ptls:
>         double_pt_unlock(src_ptl, dst_ptl);
> -       anon_vma_unlock_write(src_anon_vma);
> -       put_anon_vma(src_anon_vma);
> +       if (src_anon_vma) {
> +               anon_vma_unlock_write(src_anon_vma);
> +               put_anon_vma(src_anon_vma);
> +       }
>  unlock_folio:
>         /* unblock rmap walks */
> -       folio_unlock(src_folio);
> +       if (src_folio)
> +               folio_unlock(src_folio);
>         mmu_notifier_invalidate_range_end(&range);
> -       folio_put(src_folio);
> +       if (src_folio)
> +               folio_put(src_folio);
>         return err;
>  }
>  #endif /* CONFIG_USERFAULTFD */
> --- a/mm/userfaultfd.c~userfaultfd-handle-zeropage-moves-by-uffdio_move
> +++ a/mm/userfaultfd.c
> @@ -959,6 +959,31 @@ static int move_swap_pte(struct mm_struc
>         return 0;
>  }
>
> +static int move_zeropage_pte(struct mm_struct *mm,
> +                            struct vm_area_struct *dst_vma,
> +                            struct vm_area_struct *src_vma,
> +                            unsigned long dst_addr, unsigned long src_ad=
dr,
> +                            pte_t *dst_pte, pte_t *src_pte,
> +                            pte_t orig_dst_pte, pte_t orig_src_pte,
> +                            spinlock_t *dst_ptl, spinlock_t *src_ptl)
> +{
> +       pte_t zero_pte;
> +
> +       double_pt_lock(dst_ptl, src_ptl);
> +       if (!pte_same(ptep_get(src_pte), orig_src_pte) ||
> +           !pte_same(ptep_get(dst_pte), orig_dst_pte))
> +               return -EAGAIN;
> +
> +       zero_pte =3D pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
> +                                        dst_vma->vm_page_prot));
> +       ptep_clear_flush(src_vma, src_addr, src_pte);
> +       set_pte_at(mm, dst_addr, dst_pte, zero_pte);
> +       double_pt_unlock(dst_ptl, src_ptl);
> +
> +       return 0;
> +}
> +
> +
>  /*
>   * The mmap_lock for reading is held by the caller. Just move the page
>   * from src_pmd to dst_pmd if possible, and return true if succeeded
> @@ -1041,6 +1066,14 @@ retry:
>         }
>
>         if (pte_present(orig_src_pte)) {
> +               if (is_zero_pfn(pte_pfn(orig_src_pte))) {
> +                       err =3D move_zeropage_pte(mm, dst_vma, src_vma,
> +                                              dst_addr, src_addr, dst_pt=
e, src_pte,
> +                                              orig_dst_pte, orig_src_pte=
,
> +                                              dst_ptl, src_ptl);
> +                       goto out;
> +               }
> +
>                 /*
>                  * Pin and lock both source folio and anon_vma. Since we =
are in
>                  * RCU read section, we can't block, so on contention hav=
e to
> @@ -1404,19 +1437,14 @@ ssize_t move_pages(struct userfaultfd_ct
>                                 err =3D -ENOENT;
>                                 break;
>                         }
> -                       /* Avoid moving zeropages for now */
> -                       if (is_huge_zero_pmd(*src_pmd)) {
> -                               spin_unlock(ptl);
> -                               err =3D -EBUSY;
> -                               break;
> -                       }
>
>                         /* Check if we can move the pmd without splitting=
 it. */
>                         if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
>                             !pmd_none(dst_pmdval)) {
>                                 struct folio *folio =3D pfn_folio(pmd_pfn=
(*src_pmd));
>
> -                               if (!folio || !PageAnonExclusive(&folio->=
page)) {
> +                               if (!folio || (!is_huge_zero_page(&folio-=
>page) &&
> +                                              !PageAnonExclusive(&folio-=
>page))) {
>                                         spin_unlock(ptl);
>                                         err =3D -EBUSY;
>                                         break;
> _
>
> Patches currently in -mm which might be from surenb@google.com are
>
> arch-arm-mm-fix-major-fault-accounting-when-retrying-under-per-vma-lock.p=
atch
>
