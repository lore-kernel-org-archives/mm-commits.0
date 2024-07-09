Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1BF15B57D
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720536870; cv=none; b=gRxgK5SRCi+0wSCI2nWNS/qgMIs5J3WME+LJu1zuAB5WEKvnKBRph5FiDicTisEx68/WifST/RfHP3Xk+nfp07wqwiV49V/29JJYyJdSkZn4f7CFklNmSbQyKFQhkkUsD6nTlCKt28uyl1VUymG409xJviQ6+x0zB/gpIq2HXz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720536870; c=relaxed/simple;
	bh=uP2OHUFhkLNtEK0GCmtWwsqjAIMP65rJkrvnOckgnXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aehr+D0rEibn5OiYC7m+fG76oljCGFJbA8GNS6H/1ZyAttTdE5IjNaOH+raGbQYdWqIFwzKCdD5kAvv7UCQbmtr+MnAKw4m0PnhCs2DEhsVtY7L0DC7LF6n5+s12XmmFFYxn3kz91mAxBvXJ2CC1pjnyvYWjg7Ke4wIcbeAh8Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zSwGpOOZ; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zSwGpOOZ"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-654ce021660so32674737b3.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Jul 2024 07:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720536868; x=1721141668; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHkPyFFHmyuCeBX/l3Lh11XlVs4wwRttCS/2GKqfMNc=;
        b=zSwGpOOZDpHOmWRtUh0nzHpwIr0Q6Ku+K1iT294yIkFi5OFNnrnF2Q8VCRGv1JWZt+
         AMhzqiZik/U+zH3pMIS34LDpewtrOtRXLiE2xC+jo0179wac2bPqEKGCfE86R323dHoo
         OmOyea2jgFVIkbwpFqqvk7NYu3qrwV17NMruo4lNPiORHdOP7YDeX0UKFeQ0g+kmqVK1
         wdIZSVMKEQszo9GYyU8FeCf/Di8/DIgLmwGbWmuk4m0IgfxBArL2ri6oqYP0F9fuJTUW
         gfSMwd9iaTZ6eKYIO78J6DocF25PkiwFFlYDmbY1k6+6U9yG8RZCAdFsWAailWiuVhk7
         meBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720536868; x=1721141668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hHkPyFFHmyuCeBX/l3Lh11XlVs4wwRttCS/2GKqfMNc=;
        b=wwrRqb3Ckz2Rdagty0KsLUPHWfPHz4HbJYReu6nRLODwe9ZpI9MqcqxwPWEOAXGBEP
         UsdPwdGT/5cqatYLcp7kznyHORpl92Qd6W9A4ocWi9Tq1AHI6Ku8VzFjGVkhJZ5sgil1
         GZsbxPcOnJkAQWOyaNEIxQelKNM71MrIcS7mKGczjaAhKrEhYPIfIdqWF6fDSqCZYlEO
         jLu3qo+Y6ZdDI40hZxt1D34oiy83SFnb99NY5z91WYD5UaxMk5RYuYaR/F+hJQMafiHe
         /J9Rv1KADC7sOfkZBXpkYhRbR+wRIsFl/dmR2PdJasjzfPlEQBIlh/k/VATxJb0EWgP/
         TUhw==
X-Forwarded-Encrypted: i=1; AJvYcCWpBYhv7rv6Dl2dlOexkKuqTM/2PZr21/9aJK/2u8szFvqaalt92obP0BdrVm8CCetNjag53bYxwEfZFCohtaGfQsR1f4YGfpxwww==
X-Gm-Message-State: AOJu0YyqJxAnnoyKPmCFYyggpD2BaT+9yxOkMQL1nf0Pmdm9Sqe6Lwce
	adp3ralUUN0AMFLUGlBm3B2Duf+g10+RN24Apc8eIQEDa+/MYjl99OELEbwmKtbZxnlFFIHtGK2
	r4hPpyXsHkAO70PLD+lc2UgFJPrzondE40ruT
X-Google-Smtp-Source: AGHT+IE6ZBQxvN9fZCnKfGSJ2ZtjijlrWrLdZVH4KGeKoa+ABsED3RFlYgnjMkE8w8UgN9J/2AIJYMCTUcD0OQqmtOM=
X-Received: by 2002:a05:690c:630b:b0:64a:3d6c:476d with SMTP id
 00721157ae682-658ef24af88mr35871327b3.25.1720536867432; Tue, 09 Jul 2024
 07:54:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708214255.9F454C116B1@smtp.kernel.org> <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
 <7c4b1be3-d161-4a91-bd63-b5c9d69c75c7@gmail.com> <CAJuCfpFqVf=-e0b1ZbdY+7y5uuA7P267Z8AQ22wj7pRBMFSdYg@mail.gmail.com>
 <bd270dab-c0d1-4da5-8383-bbf4443d17ff@gmail.com> <d1c603d0-6d6b-42c4-a690-a6647131998b@suse.cz>
In-Reply-To: <d1c603d0-6d6b-42c4-a690-a6647131998b@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Jul 2024 07:54:14 -0700
Message-ID: <CAJuCfpFQc2PLu-PzzKCLDYFbSDsrVeJzgLk7nDZqp6+ye-bLow@mail.gmail.com>
Subject: Re: + mm-memcg-alignment-memcg_data-define-condition.patch added to
 mm-unstable branch
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alex Shi <seakeel@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, keescook@chromium.org, 
	hannes@cmpxchg.org, alexs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 9, 2024 at 2:17=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 7/9/24 10:19 AM, Alex Shi wrote:
> >
> >
> > On 7/9/24 12:34 PM, Suren Baghdasaryan wrote:
> >> On Tue, Jul 9, 2024 at 1:53=E2=80=AFAM Alex Shi <seakeel@gmail.com> wr=
ote:
> >>>
> >>>
> >>>
> >>> On 7/9/24 9:14 AM, Suren Baghdasaryan wrote:
> >>>> On Mon, Jul 8, 2024 at 2:42=E2=80=AFPM Andrew Morton <akpm@linux-fou=
ndation.org> wrote:
> >>>>>
> >>>>>
> >>>>> The patch titled
> >>>>>      Subject: mm/memcg: alignment memcg_data define condition
> >>>>> has been added to the -mm mm-unstable branch.  Its filename is
> >>>>>      mm-memcg-alignment-memcg_data-define-condition.patch
> >>>>
> >>>> FYI, just posted my objection to this change at
> >>>> https://lore.kernel.org/all/CAJuCfpEjB8wvodBDB__yR8pF5F3uGMPxue-tap6=
8RYCO0O-K1Q@mail.gmail.com/
> >>>> It will break CONFIG_MEM_ALLOC_PROFILING=3Dy && CONFIG_MEMCG=3Dn cas=
e.
> >>>
> >>> Hi Suren,
> >>>
> >>> Thanks a lot for point out the problem!
> >>> Now I understand why we put page/folio.memcg_data under CONFIG_SLAB_O=
BJ_EXT.
> >>> We need the memcg_data member only for SLAB_MATCH(memcg_data, obj_ext=
s), even
> >>> no CONFIG_MEMCG, isn't it?
> >>>
> >>> So for the config logical and SLAB_MATCH needs, could we keep this pa=
tch
> >>> with a fix like the following? The match only checked with both confi=
gs
> >>> enabled.
> >>
> >> No. The point of that check is to enforce that slab.obj_exts always
> >> matches page.memcg_data / folio.memcg_data (enforcing the same layout
> >> for slab, page and folio structs). Consider your original change when
> >> CONFIG_MEM_ALLOC_PROFILING=3Dy && CONFIG_MEMCG=3Dn. slab.obj_exts exis=
ts
> >> but page.memcg_data does not, so layouts of these structs do not
> >> match. By adding the change you are suggesting below you simply avoid
> >> the check that warns you about this mismatch. So, you are not fixing
> >> the problem, just removing the safety checks that would correctly
> >> complain about it.
> >>
> >
> > Hi Suren,
> >
> > Thanks for reply!
> > But what's the point of 2 members match each other in different struct?

"struct slab" is a "struct page" in disguise :)

> > Is there any problem w/o the match checking on CONFIG_MEM_ALLOC_PROFILI=
NG=3Dy
> > && CONFIG_MEMCG=3Dn?
> >
> > No, the kernel works well under my test with MEM_ALLOC_PROFILING/MEMCG/=
KASAN
> > random combined.
>
> I'm guessing it works only by luck thanks to _struct_page_alignment.

Agree.

> Once you keep obj_exts in struct slab, but remove memcg_data in struct
> page/folio, it could (on 64bit) result in struct page/folio being 56 byte=
s,
> and struct slab being 64 bytes, and then this will fail:
>
> static_assert(sizeof(struct slab) <=3D sizeof(struct page));
>
> _struct_page_alignment might fix it up silently, but only with
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE.
>
> We could maybe make it more obvious like this? for page/folio
>
> #ifdef CONFIG_MEMCG
>         unsigned long memcg_data;
> #elif defined(CONFIG_SLAB_OBJ_EXT)
>         unsigned long _unused_slab_obj_ext;
> #endif
>
> And adjusting SLAB_MATCH() assertions accordingly. As a result it will st=
op
> exposing the unused memcg_data field in page/folio with !CONFIG_MEMCG &&
> CONFIG_MEM_ALLOC_PROFILING.

Yes, that would be a valid solution but with required changes in
SLAB_MATCH() it would make the code more complex than what it is now.
Not sure if it's worth it but I would not oppose it.

>
> Or maybe CONFIG_MEM_ALLOC_PROFILING could reuse the field in that !MEMCG
> case instead of needing a page_ext? (or was that the plan already?)

CONFIG_MEM_ALLOC_PROFILING already uses this field under
`slab.obj_exts` name for slab allocations. page_ext is used only for
page allocations.

>
> Vlastimil
>
> > As Willy's purpose, the page struct will be replaced by "unsigned long =
mem_desc;"
> > https://lore.kernel.org/lkml/YvV1KTyzZ+Jrtj9x@casper.infradead.org/
> > With this destination, slab, folio, page struct better be used differen=
tly
> > and not to relay on each other.
> >
> > In fact there is another solution work conventionally for logical match=
:
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index ef09c4eef6d3..8f9a01a24f18 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -180,7 +180,7 @@ struct page {
> >         /* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
> >         atomic_t _refcount;
> >
> > -#ifdef CONFIG_SLAB_OBJ_EXT
> > +#if defined(CONFIG_SLAB_OBJ_EXT) || defined(CONIFG_MEMCG)
> >         unsigned long memcg_data;
> >  #endif
> >
> > @@ -343,7 +343,7 @@ struct folio {
> >                         };
> >                         atomic_t _mapcount;
> >                         atomic_t _refcount;
> > -#ifdef CONFIG_SLAB_OBJ_EXT
> > +#if defined(CONFIG_SLAB_OBJ_EXT) || defined(CONIFG_MEMCG)
> >                         unsigned long memcg_data;
> >  #endif
> >  #if defined(WANT_PAGE_VIRTUAL)
> >
> > But compere above convention solution, the current way is simple and cl=
oser
> > to our destination, and we could easy fall back even it fails, isn't it=
?
> >
> > Thanks
> > Alex
> >
> >>>
> >>> Thanks a lot!
> >>> Alex
> >>>
> >>> diff --git a/mm/slab.h b/mm/slab.h
> >>> index 3586e6183224..9e7ccaf868e2 100644
> >>> --- a/mm/slab.h
> >>> +++ b/mm/slab.h
> >>> @@ -97,7 +97,7 @@ struct slab {
> >>>  SLAB_MATCH(flags, __page_flags);
> >>>  SLAB_MATCH(compound_head, slab_cache); /* Ensure bit 0 is clear */
> >>>  SLAB_MATCH(_refcount, __page_refcount);
> >>> -#ifdef CONFIG_SLAB_OBJ_EXT
> >>> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_MEMCG)
> >>>  SLAB_MATCH(memcg_data, obj_exts);
> >>>  #endif
> >>>  #undef SLAB_MATCH
> >>>>
> >>>>>
> >>>>> This patch will shortly appear at
> >>>>>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.gi=
t/tree/patches/mm-memcg-alignment-memcg_data-define-condition.patch
> >>>>>
> >>>>> This patch will later appear in the mm-unstable branch at
> >>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >>>>>
> >>>>> Before you just go and hit "reply", please:
> >>>>>    a) Consider who else should be cc'ed
> >>>>>    b) Prefer to cc a suitable mailing list as well
> >>>>>    c) Ideally: find the original patch on the mailing list and do a
> >>>>>       reply-to-all to that, adding suitable additional cc's
> >>>>>
> >>>>> *** Remember to use Documentation/process/submit-checklist.rst when=
 testing your code ***
> >>>>>
> >>>>> The -mm tree is included into linux-next via the mm-everything
> >>>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >>>>> and is updated there every 2-3 working days
> >>>>>
> >>>>> ------------------------------------------------------
> >>>>> From: "Alex Shi (Tencent)" <alexs@kernel.org>
> >>>>> Subject: mm/memcg: alignment memcg_data define condition
> >>>>> Date: Mon, 8 Jul 2024 14:32:36 +0800
> >>>>>
> >>>>> commit 21c690a349ba ("mm: introduce slabobj_ext to support slab obj=
ect
> >>>>> extensions") changed the folio/page->memcg_data define condition fr=
om
> >>>>> MEMCG to SLAB_OBJ_EXT.  The code works well, since config SLAB_OBJ_=
EXT is
> >>>>> fold into MEMCG in init/Kconfig.
> >>>>>
> >>>>> But many related functions that deal with memcg_data still defined =
under
> >>>>> MEMCG instead of SLAB_OBJ_EXT, and FOLIO_MATCH with memcg_data are =
defined
> >>>>> under MEMCG too.  That looks weird and incorrect with memcg_data ra=
w
> >>>>> meaning.
> >>>>>
> >>>>> So let's put memcg_data under MEMCG config to alignment the definit=
ion
> >>>>> with FOLIO_MATCH and its usage in functions.
> >>>>>
> >>>>> Link: https://lkml.kernel.org/r/20240708063236.1096395-1-alexs@kern=
el.org
> >>>>> Signed-off-by: Alex Shi (Tencent) <alexs@kernel.org>
> >>>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
> >>>>> Cc: Kees Cook <keescook@chromium.org>
> >>>>> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> >>>>> Cc: Suren Baghdasaryan <surenb@google.com>
> >>>>> Cc: Vlastimil Babka <vbabka@suse.cz>
> >>>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>>>> ---
> >>>>>
> >>>>>  include/linux/mm_types.h |    4 ++--
> >>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> --- a/include/linux/mm_types.h~mm-memcg-alignment-memcg_data-define=
-condition
> >>>>> +++ a/include/linux/mm_types.h
> >>>>> @@ -180,7 +180,7 @@ struct page {
> >>>>>         /* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
> >>>>>         atomic_t _refcount;
> >>>>>
> >>>>> -#ifdef CONFIG_SLAB_OBJ_EXT
> >>>>> +#ifdef CONFIG_MEMCG
> >>>>>         unsigned long memcg_data;
> >>>>>  #endif
> >>>>>
> >>>>> @@ -343,7 +343,7 @@ struct folio {
> >>>>>                         };
> >>>>>                         atomic_t _mapcount;
> >>>>>                         atomic_t _refcount;
> >>>>> -#ifdef CONFIG_SLAB_OBJ_EXT
> >>>>> +#ifdef CONFIG_MEMCG
> >>>>>                         unsigned long memcg_data;
> >>>>>  #endif
> >>>>>  #if defined(WANT_PAGE_VIRTUAL)
> >>>>> _
> >>>>>
> >>>>> Patches currently in -mm which might be from alexs@kernel.org are
> >>>>>
> >>>>> mm-memcg-alignment-memcg_data-define-condition.patch
> >>>>>
>
