Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9012BAF3
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 04:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720499700; cv=none; b=iYE6luNrP6P9uvUw4Nuz5e/A+Y1DJA6kj1utJpDUSCiEA57tzKGMpzPFIwF+V4/y3TQiA3uUE0uT8w+yOywgdy6CCaJuNov0qFnXSgGMotD+UO5NmMdyRTEbpyzsTiAC6MaFbYBvxARKIVVb91TQh5gnvx3xgM1gbp9AFDev0XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720499700; c=relaxed/simple;
	bh=H2bR9SeWsdxvPvKdbMwZe6oALybMQxZa5j+8BHwe22k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KM/c+LmP1dy/Aer38Cd5u4rN1B56G2XuzeCv+M7GEI8Pt6KqouCC0Y1EPMA7kSYQjklOj/cMAqD/tOtVDmo6YB2c6ZX/7yI9QbH0ANCJ1s+liCJ+epBfbdrEgu3aWJHVYHp/mtTMuTj6gw669I0nk2cf+4CqYyNiP1psTaUvMog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2+/1D8zq; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2+/1D8zq"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-64b3655297aso45606987b3.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Jul 2024 21:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720499697; x=1721104497; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TX9Egx96Z5A/+pXiw1FmOA2aVO2i3MEs/DH8OiWX950=;
        b=2+/1D8zqqCtSpijgGJRYcYnfsFETOGOoZVQv9aI7uD64lb34OKMR69h+C8rJ52Wpp1
         XE0T001ywhovWyURWYMPM9kFD89T/sCk5J4OybxlQ2M1dceh0XTe1MON1XXyu97tj8ZP
         itYJI2xk2Dieyi5j6YtmnkCjcfjbuuaLAWOVGhl91rm99EcbSm2Px5jgqs1oLvOF+zol
         7GuzjYFXBVVa67hGXuNbtIsf8ce3EMzvPtSQSXRSjqxNroTcgMq0Qj9/g8rvkQ5EGRCj
         dfdgtqCZDDVrwPsB0XTbIf4Aq2AwZAW1htc7hr75CX9oeHCzW2JtCsT494SXD2J5yot3
         I5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720499697; x=1721104497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TX9Egx96Z5A/+pXiw1FmOA2aVO2i3MEs/DH8OiWX950=;
        b=Ub6KR9YgKsC49D6xdlA/JE2r5GWo/U8gdaIhdzzjKetrMZfkBdItZHIPprDBf9wboq
         GUQA/lgSvkqHnc8b1zt+eZEPRbP44WpgWvs18OhvQJRHHrQcC+9lmuhJ9LiXMTNXhE3X
         sIuQ8VKpIb1TQ7XtHiu8MmhvSG6liOk84Dxk8mtU8/HunUMo4iZ2D4l2ai+oevXwwOag
         gBtQFs2612xzPsD41LFLZ/odzcuKiLwYbpQG5OJ+aikM5Z2VsQrgcVyXwojilABPUYtA
         5A1wxA3RmMHtmxWfOu1n63Z0R55APF60nks5IA7xRbTul4+1LRCgOvzqqZhjGD/TnK8I
         zqTQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6MvfYzpqUTE4H4lppvadJzoakAmtjO2mpD9cJO8xWoMq13LC+PtMGjpg5djnvqbJ1DZTpUHOzhMx6a96s6gikSeppzknZU2vu6A==
X-Gm-Message-State: AOJu0YywYS/9IuBdOS1LfT2JQhk3sK8yT2/Y1+MnR7mYRkL8IHwtpu36
	oYeYXjSM+pIOx4Vp7nkmbOv2YU4HOm1RR8x9CxQrWUhdJJyqK+iQyWna5GdwhK5xbwueptJyfuc
	j6juy/kKFWwpL+Xv59wu40HlZDdaE/shulfr3
X-Google-Smtp-Source: AGHT+IEEbHKDYB7R1ceZlcz7Um5HkKBHsklnaid5FpIBM94jD+CYJxyrHDizh3SBqQ4e5Fg+SM1uTrcK8lpjAvG0obE=
X-Received: by 2002:a05:690c:d0b:b0:64a:90fe:9108 with SMTP id
 00721157ae682-658ef341613mr17999997b3.30.1720499697093; Mon, 08 Jul 2024
 21:34:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708214255.9F454C116B1@smtp.kernel.org> <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
 <7c4b1be3-d161-4a91-bd63-b5c9d69c75c7@gmail.com>
In-Reply-To: <7c4b1be3-d161-4a91-bd63-b5c9d69c75c7@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Jul 2024 21:34:44 -0700
Message-ID: <CAJuCfpFqVf=-e0b1ZbdY+7y5uuA7P267Z8AQ22wj7pRBMFSdYg@mail.gmail.com>
Subject: Re: + mm-memcg-alignment-memcg_data-define-condition.patch added to
 mm-unstable branch
To: Alex Shi <seakeel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, vbabka@suse.cz, 
	pasha.tatashin@soleen.com, keescook@chromium.org, hannes@cmpxchg.org, 
	alexs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 9, 2024 at 1:53=E2=80=AFAM Alex Shi <seakeel@gmail.com> wrote:
>
>
>
> On 7/9/24 9:14 AM, Suren Baghdasaryan wrote:
> > On Mon, Jul 8, 2024 at 2:42=E2=80=AFPM Andrew Morton <akpm@linux-founda=
tion.org> wrote:
> >>
> >>
> >> The patch titled
> >>      Subject: mm/memcg: alignment memcg_data define condition
> >> has been added to the -mm mm-unstable branch.  Its filename is
> >>      mm-memcg-alignment-memcg_data-define-condition.patch
> >
> > FYI, just posted my objection to this change at
> > https://lore.kernel.org/all/CAJuCfpEjB8wvodBDB__yR8pF5F3uGMPxue-tap68RY=
CO0O-K1Q@mail.gmail.com/
> > It will break CONFIG_MEM_ALLOC_PROFILING=3Dy && CONFIG_MEMCG=3Dn case.
>
> Hi Suren,
>
> Thanks a lot for point out the problem!
> Now I understand why we put page/folio.memcg_data under CONFIG_SLAB_OBJ_E=
XT.
> We need the memcg_data member only for SLAB_MATCH(memcg_data, obj_exts), =
even
> no CONFIG_MEMCG, isn't it?
>
> So for the config logical and SLAB_MATCH needs, could we keep this patch
> with a fix like the following? The match only checked with both configs
> enabled.

No. The point of that check is to enforce that slab.obj_exts always
matches page.memcg_data / folio.memcg_data (enforcing the same layout
for slab, page and folio structs). Consider your original change when
CONFIG_MEM_ALLOC_PROFILING=3Dy && CONFIG_MEMCG=3Dn. slab.obj_exts exists
but page.memcg_data does not, so layouts of these structs do not
match. By adding the change you are suggesting below you simply avoid
the check that warns you about this mismatch. So, you are not fixing
the problem, just removing the safety checks that would correctly
complain about it.

>
> Thanks a lot!
> Alex
>
> diff --git a/mm/slab.h b/mm/slab.h
> index 3586e6183224..9e7ccaf868e2 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -97,7 +97,7 @@ struct slab {
>  SLAB_MATCH(flags, __page_flags);
>  SLAB_MATCH(compound_head, slab_cache); /* Ensure bit 0 is clear */
>  SLAB_MATCH(_refcount, __page_refcount);
> -#ifdef CONFIG_SLAB_OBJ_EXT
> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_MEMCG)
>  SLAB_MATCH(memcg_data, obj_exts);
>  #endif
>  #undef SLAB_MATCH
> >
> >>
> >> This patch will shortly appear at
> >>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/t=
ree/patches/mm-memcg-alignment-memcg_data-define-condition.patch
> >>
> >> This patch will later appear in the mm-unstable branch at
> >>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >>
> >> Before you just go and hit "reply", please:
> >>    a) Consider who else should be cc'ed
> >>    b) Prefer to cc a suitable mailing list as well
> >>    c) Ideally: find the original patch on the mailing list and do a
> >>       reply-to-all to that, adding suitable additional cc's
> >>
> >> *** Remember to use Documentation/process/submit-checklist.rst when te=
sting your code ***
> >>
> >> The -mm tree is included into linux-next via the mm-everything
> >> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >> and is updated there every 2-3 working days
> >>
> >> ------------------------------------------------------
> >> From: "Alex Shi (Tencent)" <alexs@kernel.org>
> >> Subject: mm/memcg: alignment memcg_data define condition
> >> Date: Mon, 8 Jul 2024 14:32:36 +0800
> >>
> >> commit 21c690a349ba ("mm: introduce slabobj_ext to support slab object
> >> extensions") changed the folio/page->memcg_data define condition from
> >> MEMCG to SLAB_OBJ_EXT.  The code works well, since config SLAB_OBJ_EXT=
 is
> >> fold into MEMCG in init/Kconfig.
> >>
> >> But many related functions that deal with memcg_data still defined und=
er
> >> MEMCG instead of SLAB_OBJ_EXT, and FOLIO_MATCH with memcg_data are def=
ined
> >> under MEMCG too.  That looks weird and incorrect with memcg_data raw
> >> meaning.
> >>
> >> So let's put memcg_data under MEMCG config to alignment the definition
> >> with FOLIO_MATCH and its usage in functions.
> >>
> >> Link: https://lkml.kernel.org/r/20240708063236.1096395-1-alexs@kernel.=
org
> >> Signed-off-by: Alex Shi (Tencent) <alexs@kernel.org>
> >> Cc: Johannes Weiner <hannes@cmpxchg.org>
> >> Cc: Kees Cook <keescook@chromium.org>
> >> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> >> Cc: Suren Baghdasaryan <surenb@google.com>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> ---
> >>
> >>  include/linux/mm_types.h |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> --- a/include/linux/mm_types.h~mm-memcg-alignment-memcg_data-define-co=
ndition
> >> +++ a/include/linux/mm_types.h
> >> @@ -180,7 +180,7 @@ struct page {
> >>         /* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
> >>         atomic_t _refcount;
> >>
> >> -#ifdef CONFIG_SLAB_OBJ_EXT
> >> +#ifdef CONFIG_MEMCG
> >>         unsigned long memcg_data;
> >>  #endif
> >>
> >> @@ -343,7 +343,7 @@ struct folio {
> >>                         };
> >>                         atomic_t _mapcount;
> >>                         atomic_t _refcount;
> >> -#ifdef CONFIG_SLAB_OBJ_EXT
> >> +#ifdef CONFIG_MEMCG
> >>                         unsigned long memcg_data;
> >>  #endif
> >>  #if defined(WANT_PAGE_VIRTUAL)
> >> _
> >>
> >> Patches currently in -mm which might be from alexs@kernel.org are
> >>
> >> mm-memcg-alignment-memcg_data-define-condition.patch
> >>
