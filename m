Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACC08F45
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 04:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720585082; cv=none; b=sX2ZwrnjIEUU18zuzP8ylSCM0FfsRcTnvUQ1pBcP+lpveFNxfI4d/MrgcD70LJvL94cNQWDUq+nPKB+F88FmQ3GukfvIIGGtGyx8yQ54bMa4yEfLc1yvy0lGfLMt4DyNHU7p0BBf4cNWSPmph0vfT1+sCYej22vVLrQRt58owgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720585082; c=relaxed/simple;
	bh=X4T6V636X5Jm4/8dqx4K7G3gjPKu22+31RZcUPuoFuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ANBRDKR4nQwCYLQsO926QcIEA/tgkcO0o0+C+gnoNNUEfLpZe0AM1TqKTfcdBvMEo5793rGOaVj89NzmS/Ybd2jzLO4pkHqdCASvGJ9bVOar0z45XLbP59FsKcImiCOtoV2UcS+zcOxKtRDmK/UJLkRQrrKzQd3KyIGwlyOVfGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rgrSLEJz; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rgrSLEJz"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e03a6196223so6328123276.3
        for <mm-commits@vger.kernel.org>; Tue, 09 Jul 2024 21:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720585079; x=1721189879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J2DAkGaIfYdH6Gvk1SnONELS/jxAtOyNUGsmdpWizlc=;
        b=rgrSLEJz6O43uY/49Mli0GQWuah+1RxCpfBrxb5ZSUM69roRXzE/ScgS4UKyqdMBpn
         elZOE/l8szLV1QCLEbMBhsQ98yO68gyuUIW8kMVZHAezLpjl+F7cyzKK4XQ20tAOthhY
         m2lBj0f7hGULPvarnz2fiI1X/LX3+43ieDU7adQeDPWJOY6NtfmtzY9OPUAyrDfv37Y3
         D7V195vbginbq4MRJNaNegc/gPFF/UcOHTsSvGhsv1ydnn+/hxoJtWYZjA7M9g0YSwPW
         AUWX3As7dGUInqB0U4a5KmzAibs7I+ln+OTDK4RXVlRgH90E55Mk7rA5MHcjWqctykYU
         mMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720585079; x=1721189879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J2DAkGaIfYdH6Gvk1SnONELS/jxAtOyNUGsmdpWizlc=;
        b=age4cm5GBLG31a1k/3YZImvEajf1jYCi2yEmSLdZYnj4QpPM7rKuyAOfVGlFNnhfeN
         U5AWXf7x5KeW3VVE4C/YGMTfxh95ftzabotxVaAJxPmAMm/+fE+0xjfpY07kzUSCyLf5
         aI6uMoYt+dgFn8fzVuKIokbcDwbnkEkeeREGm2lVasQ8wpi/zTkJpCd9p36C2iD2kXyZ
         ZoQG+iXAtedvxn3SobzuDaXvtvk8NckUSwzk6XNMvYcAR/yuY+IycWFE4EHaUG7pfe7E
         EWNW9IdcB66PWZ/6XJDsprUahgzFLkCHixTytfqCqU57LiVCrnoIn9BUM6wUzUAoV2wx
         Gqcg==
X-Forwarded-Encrypted: i=1; AJvYcCWTpfEudABQPGyBrXyedU9+ojhOUfxfnP0Ryb22OndSuywt5iPBLqbmTIDiLIZhZDiyW20nx1QHpgZguXCdoEDiuyYQVveen2Q/6w==
X-Gm-Message-State: AOJu0Yzyf8R1URH2dDdqJDaCYAS0ZplT2T8ODe3hHlr7lHTS13zNfy0q
	n1uP81+JAPEt0vlrR8LWoN+Ng5Ru115HGtTcJ0n7umUBEjVMzoVeSvfM8CrsYlewiOBZDYFLYbu
	XK7w4JMds4/v+17CmYVkmp0YofoENWeh2jbYd
X-Google-Smtp-Source: AGHT+IG5ihz7WBCyzub9AqjB15U7OfV0L2m74XqYYXLEN58+nci/m0Ii78u7ECCfLWvEUW8qqzERdrhQr5BCMPMh/PE=
X-Received: by 2002:a25:2e03:0:b0:e03:5904:c854 with SMTP id
 3f1490d57ef6-e041b1729d2mr5022872276.57.1720585079336; Tue, 09 Jul 2024
 21:17:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240708214255.9F454C116B1@smtp.kernel.org> <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
 <7c4b1be3-d161-4a91-bd63-b5c9d69c75c7@gmail.com> <CAJuCfpFqVf=-e0b1ZbdY+7y5uuA7P267Z8AQ22wj7pRBMFSdYg@mail.gmail.com>
 <bd270dab-c0d1-4da5-8383-bbf4443d17ff@gmail.com> <d1c603d0-6d6b-42c4-a690-a6647131998b@suse.cz>
 <CAJuCfpFQc2PLu-PzzKCLDYFbSDsrVeJzgLk7nDZqp6+ye-bLow@mail.gmail.com> <8861d515-3759-4f3d-b0ed-aff974a83d44@gmail.com>
In-Reply-To: <8861d515-3759-4f3d-b0ed-aff974a83d44@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Jul 2024 21:17:46 -0700
Message-ID: <CAJuCfpE+QFn04J=pqXZ47NjEj7QB3irv3+_kz_8VhJ023NmNbg@mail.gmail.com>
Subject: Re: + mm-memcg-alignment-memcg_data-define-condition.patch added to
 mm-unstable branch
To: Alex Shi <seakeel@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, keescook@chromium.org, 
	hannes@cmpxchg.org, alexs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 9, 2024 at 7:24=E2=80=AFPM Alex Shi <seakeel@gmail.com> wrote:
>
>
>
> On 7/9/24 10:54 PM, Suren Baghdasaryan wrote:
> > On Tue, Jul 9, 2024 at 2:17=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz>=
 wrote:
> >>
> >>>>> Hi Suren,
> >>>>>
> >>>>> Thanks a lot for point out the problem!
> >>>>> Now I understand why we put page/folio.memcg_data under CONFIG_SLAB=
_OBJ_EXT.
> >>>>> We need the memcg_data member only for SLAB_MATCH(memcg_data, obj_e=
xts), even
> >>>>> no CONFIG_MEMCG, isn't it?
> >>>>>
> >>>>> So for the config logical and SLAB_MATCH needs, could we keep this =
patch
> >>>>> with a fix like the following? The match only checked with both con=
figs
> >>>>> enabled.
> >>>>
> >>>> No. The point of that check is to enforce that slab.obj_exts always
> >>>> matches page.memcg_data / folio.memcg_data (enforcing the same layou=
t
> >>>> for slab, page and folio structs). Consider your original change whe=
n
> >>>> CONFIG_MEM_ALLOC_PROFILING=3Dy && CONFIG_MEMCG=3Dn. slab.obj_exts ex=
ists
> >>>> but page.memcg_data does not, so layouts of these structs do not
> >>>> match. By adding the change you are suggesting below you simply avoi=
d
> >>>> the check that warns you about this mismatch. So, you are not fixing
> >>>> the problem, just removing the safety checks that would correctly
> >>>> complain about it.
> >>>>
> >>>
> >>> Hi Suren,
> >>>
> >>> Thanks for reply!
> >>> But what's the point of 2 members match each other in different struc=
t?
> >
> > "struct slab" is a "struct page" in disguise :)
> >
> >>> Is there any problem w/o the match checking on CONFIG_MEM_ALLOC_PROFI=
LING=3Dy
> >>> && CONFIG_MEMCG=3Dn?
> >>>
> >>> No, the kernel works well under my test with MEM_ALLOC_PROFILING/MEMC=
G/KASAN
> >>> random combined.
> >>
> >> I'm guessing it works only by luck thanks to _struct_page_alignment.
> >
> > Agree.
> >
> >> Once you keep obj_exts in struct slab, but remove memcg_data in struct
> >> page/folio, it could (on 64bit) result in struct page/folio being 56 b=
ytes,
> >> and struct slab being 64 bytes, and then this will fail:
> >>
> >> static_assert(sizeof(struct slab) <=3D sizeof(struct page));
> >>
> >> _struct_page_alignment might fix it up silently, but only with
> >> CONFIG_HAVE_ALIGNED_STRUCT_PAGE.
> >>
> >> We could maybe make it more obvious like this? for page/folio
> >>
> >> #ifdef CONFIG_MEMCG
> >>         unsigned long memcg_data;
> >> #elif defined(CONFIG_SLAB_OBJ_EXT)
> >>         unsigned long _unused_slab_obj_ext;
> >> #endif
> >>
> >> And adjusting SLAB_MATCH() assertions accordingly. As a result it will=
 stop
> >> exposing the unused memcg_data field in page/folio with !CONFIG_MEMCG =
&&
> >> CONFIG_MEM_ALLOC_PROFILING.
>
> Hi Suren & Vlastimil,
>
> Thanks a lot for comments! I will follow your suggestion to update the pa=
tch.
> But there are another issue related to the problem, in Suren's patch, mak=
e the
> MEMCG select SLAB_OBJ_EXT? why memcg needs this? I checked the mm/memcont=
rol.c
> seems should work with !SLAB_OBJ_EXT.

It would help you understand this if you think of slab.obj_exts and
page.memcg_data as the same pointer with two different names. When one
exists, the other should exist and vice versa, when one does not exist
the other should not exist. In my patches they both depend on
CONFIG_SLAB_OBJ_EXT. Now, since CONFIG_MEMCG requires page.memcg_data,
it should make sure page.memcg_data exists and that's what it does by
selecting CONFIG_SLAB_OBJ_EXT.

The above description is how things work today. If you are changing
the way Vlastimil suggested then this dependency can go away depending
on how you implement it.
Cheers,
Suren.

>
> Thanks
> Alex
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 26bf8bb0a7ce..61e43ac9fe75 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -965,7 +965,6 @@ config MEMCG
>         bool "Memory controller"
>         select PAGE_COUNTER
>         select EVENTFD
> -       select SLAB_OBJ_EXT
>         help
>           Provides control over the memory footprint of tasks in a cgroup=
.
>
