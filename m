Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF186AD2C
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 22:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716504931; cv=none; b=RWVBFZVMSNcFy5WKshBkZGyX4aMF5gY9aVzXAfUKBkKoKPymGlYLuFK0bp2LXiyxHcqVlg4+FWXlzGF/961NJEoxZ47kFkinsCWWvM2uAyLOeBO8aVvD66XtOtUGcYm+AtKu5CDQull8sUke8z5nFSIDpGEqHgWTRv7ff3DHN0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716504931; c=relaxed/simple;
	bh=cgkWUpojge7aRHzNKcHeON56ZkInhjAX1sNV6Gg3XBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DoiDivFwx8SH5WMijCQURzTYfWBh193X89muYQOrotZtMCVaBWqHD3B4C6OpZN2poLR/k7KJiNsodLBKQnDhs0jSyBF1xcuibd3HoOJ1ocomRTnV53Vg+lwhD847kvmKr/Q86BJKMLI7vIiyxJYAXyXpzpqipIQQGNBpU3ewymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-804579f4130so280921241.3
        for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 15:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716504929; x=1717109729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ij+MEmBE1Vo8aZigre0y66llvwNWskXl4fF/xztwXpE=;
        b=lkGoIRd9XKxk3zlKz2Di91fUMfaWt7o5r/7+A+n+O+0PyI2x1s32yaTjAN00oiUXpt
         gSXDnRV3sq76u4WZI6pvHXG+9VDhNlnctuHrIHBIndnTfWAkH1OGoSbRpm4obu1n3rR4
         Lrpb1VmQFSXK+fiYC7mFhYWB/rAZtXhTgbMd02TQUjKnQgbM5pCopndfflzVxZL+bLqQ
         li0mR5LC9e16nuDbynH7w2/NRzxFQR8xqKbr28LHD1/y6aGObMYq3oN62mZ3ehS+nmZm
         Yi7E5pB66E2n1pIQbgeCDFeCzw6UpogzE0H39X7BjwGXOvoZP7hx0ixgiT9aXrUwnQgx
         fa/A==
X-Gm-Message-State: AOJu0YxWOIqnsQ37MLIQpHUfzZEfLC5yfZ66cnXRX1sQaeVrTOID11JN
	rGGXtI0j4KsFl/Y3CY578yJB1+JPFpTqlVf32vfFRXyPUyvt9J8PA/BQDKkGQRmb/3wNLbcXM9z
	Fp0yJHK5HhALsaKnI3y2sb3kOQSU=
X-Google-Smtp-Source: AGHT+IEZGQNOjYZFyPF40HmYTcvMm93qJNslDpzufi8VLyRFAccit956nC/Dj/OUnGvfqEcAnyM1d/rW+EtnSaM1OxI=
X-Received: by 2002:a67:e30a:0:b0:47f:684:a3f with SMTP id ada2fe7eead31-48a386556b2mr983414137.25.1716504928609;
 Thu, 23 May 2024 15:55:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240523194021.CF145C2BD10@smtp.kernel.org>
In-Reply-To: <20240523194021.CF145C2BD10@smtp.kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 24 May 2024 10:55:17 +1200
Message-ID: <CAGsJ_4z_FiDM8v8h8gbfmr5ooU8Dw6TyQrG3MXRUdOzQfmrjhg@mail.gmail.com>
Subject: Re: + mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch added
 to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com, 
	willy@infradead.org, ryan.roberts@arm.com, ioworker0@gmail.com, 
	david@redhat.com, baolin.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2024 at 7:40=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: mm: drop the 'anon_' prefix for swap-out mTHP counters
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch

Hi Andrew,

Baolin is aiming to implement this rename for version 6.10. If not,
we'll encounter
ABI compatibility issues between versions 6.10 and 6.11 and beyond. Therefo=
re,
I assume it should be included in the mm-hotfix-unstable branch rather than=
 the
mm-unstable branch?  Or am I mistaken? Does the mm-unstable branch also hav=
e
a pathway to be included in version 6.10?

>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch
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
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
> Subject: mm: drop the 'anon_' prefix for swap-out mTHP counters
> Date: Thu, 23 May 2024 10:36:39 +0800
>
> The mTHP swap related counters: 'anon_swpout' and 'anon_swpout_fallback'
> are confusing with an 'anon_' prefix, since the shmem can swap out
> non-anonymous pages.  So drop the 'anon_' prefix to keep consistent with
> the old swap counter names.
>
> Link: https://lkml.kernel.org/r/7a8989c13299920d7589007a30065c3e2c19f0e0.=
1716431702.git.baolin.wang@linux.alibaba.com
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Suggested-by: "Huang, Ying" <ying.huang@intel.com>
> Acked-by: Barry Song <baohua@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <ioworker0@gmail.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  Documentation/admin-guide/mm/transhuge.rst |    4 ++--
>  include/linux/huge_mm.h                    |    4 ++--
>  mm/huge_memory.c                           |    8 ++++----
>  mm/page_io.c                               |    2 +-
>  mm/vmscan.c                                |    2 +-
>  5 files changed, 10 insertions(+), 10 deletions(-)
>
> --- a/Documentation/admin-guide/mm/transhuge.rst~mm-drop-the-anon_-prefix=
-for-swap-out-mthp-counters
> +++ a/Documentation/admin-guide/mm/transhuge.rst
> @@ -467,11 +467,11 @@ anon_fault_fallback_charge
>         instead falls back to using huge pages with lower orders or
>         small pages even though the allocation was successful.
>
> -anon_swpout
> +swpout
>         is incremented every time a huge page is swapped out in one
>         piece without splitting.
>
> -anon_swpout_fallback
> +swpout_fallback
>         is incremented if a huge page has to be split before swapout.
>         Usually because failed to allocate some continuous swap space
>         for the huge page.
> --- a/include/linux/huge_mm.h~mm-drop-the-anon_-prefix-for-swap-out-mthp-=
counters
> +++ a/include/linux/huge_mm.h
> @@ -269,8 +269,8 @@ enum mthp_stat_item {
>         MTHP_STAT_ANON_FAULT_ALLOC,
>         MTHP_STAT_ANON_FAULT_FALLBACK,
>         MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
> -       MTHP_STAT_ANON_SWPOUT,
> -       MTHP_STAT_ANON_SWPOUT_FALLBACK,
> +       MTHP_STAT_SWPOUT,
> +       MTHP_STAT_SWPOUT_FALLBACK,
>         __MTHP_STAT_COUNT
>  };
>
> --- a/mm/huge_memory.c~mm-drop-the-anon_-prefix-for-swap-out-mthp-counter=
s
> +++ a/mm/huge_memory.c
> @@ -558,15 +558,15 @@ static struct kobj_attribute _name##_att
>  DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
>  DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK=
);
>  DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_F=
ALLBACK_CHARGE);
> -DEFINE_MTHP_STAT_ATTR(anon_swpout, MTHP_STAT_ANON_SWPOUT);
> -DEFINE_MTHP_STAT_ATTR(anon_swpout_fallback, MTHP_STAT_ANON_SWPOUT_FALLBA=
CK);
> +DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
> +DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
>
>  static struct attribute *stats_attrs[] =3D {
>         &anon_fault_alloc_attr.attr,
>         &anon_fault_fallback_attr.attr,
>         &anon_fault_fallback_charge_attr.attr,
> -       &anon_swpout_attr.attr,
> -       &anon_swpout_fallback_attr.attr,
> +       &swpout_attr.attr,
> +       &swpout_fallback_attr.attr,
>         NULL,
>  };
>
> --- a/mm/page_io.c~mm-drop-the-anon_-prefix-for-swap-out-mthp-counters
> +++ a/mm/page_io.c
> @@ -217,7 +217,7 @@ static inline void count_swpout_vm_event
>                 count_memcg_folio_events(folio, THP_SWPOUT, 1);
>                 count_vm_event(THP_SWPOUT);
>         }
> -       count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_SWPOUT);
> +       count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
>  #endif
>         count_vm_events(PSWPOUT, folio_nr_pages(folio));
>  }
> --- a/mm/vmscan.c~mm-drop-the-anon_-prefix-for-swap-out-mthp-counters
> +++ a/mm/vmscan.c
> @@ -1230,7 +1230,7 @@ retry:
>                                                         THP_SWPOUT_FALLBA=
CK, 1);
>                                                 count_vm_event(THP_SWPOUT=
_FALLBACK);
>                                         }
> -                                       count_mthp_stat(order, MTHP_STAT_=
ANON_SWPOUT_FALLBACK);
> +                                       count_mthp_stat(order, MTHP_STAT_=
SWPOUT_FALLBACK);
>  #endif
>                                         if (!add_to_swap(folio))
>                                                 goto activate_locked_spli=
t;
> _
>
> Patches currently in -mm which might be from baolin.wang@linux.alibaba.co=
m are
>
> mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch
>

Thanks
Barry
