Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A70C32ABDB
	for <mm-commits@vger.kernel.org>; Wed,  3 Dec 2025 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775104; cv=none; b=fJUFbP/3O3kl3PhcDmWdPxn3PN1+U+59XlgHzF3ZapU4PNFaFzQEC0ETokA4J8xyCVfmICpPAPQtS3uHOOjNkKi5GQsW8JuMUkVk2mG4//c/NLoNPM2/2Ok0sVsbdeYKVXDIm2T46nQ4aRmDBOBqe1cYQVD1L7L0R2ALakN8/4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775104; c=relaxed/simple;
	bh=ABZJVd0vwxXIRcA1EMlVWzzqKDbyKyTfRUgBrr74vqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fs/x4d+P3aqjkz5YMV9QsLkQuESVU4939lyf21Mdzw2VC7BcsJoVO33Qu13yUHr6mvzb/xa34GYUIjgagLwrlPK+7ahuc2Yi+mRV9yZe54s3UMYXPfGvSRWPUI1wUxWFS6E17d5OKTRmJW1r3h333obX3OM47YAOGRnpCakB5sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WZ++y0Wf; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WZ++y0Wf"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42e2ce8681eso3217353f8f.0
        for <mm-commits@vger.kernel.org>; Wed, 03 Dec 2025 07:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764775101; x=1765379901; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHkKMPEnQ9YySxWfhJQb2dUyJQ3XmA+wblB+0uzx3ww=;
        b=WZ++y0WfCojxOP+1/Nts6psHO+LkDswLRMti9Dp85IfKo2f+obn7bUjSfNi/woLPx8
         Ap0hvM3tZVgtKBqk/2ZMl6C0tmRQbOyzDINmDy2kNWL2yRyC43m16T3Zsr5Lz0a/Hh01
         mkxf6FL+iLzYelMTLyjAiquNhVbghf3lmlti1q5YNtF+iZMhlKxCXtWFIBrshK923C8/
         WlpzOgSdsZNxmG7hStvC4Bmi5Vyj2EpDKtAcCfR0SOsKSjCbRmPXBWatgf3zO59pL90A
         oT9wxLGoqNDOCmVLjRD35UEVigEtjuFHqZj9jssYTJAupv+mSUEfnJ09Rw2U+BWI4LBf
         jhNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764775101; x=1765379901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fHkKMPEnQ9YySxWfhJQb2dUyJQ3XmA+wblB+0uzx3ww=;
        b=BZUQdkatSv/kaZu6WipYt6hkWp0B1x2oNQPTwYZwlbdJ7QSWP1BuydGPmJtzXMzEH3
         FJFsTzw3HAtGQe2eIGj7qXhAdaQYcOfG8mFP2KwZeJSJljMio9vSmR+NTdMaIBIuJagS
         W145YRuqMaat6uaPx1jNJhz3Df2fop0kXeGltTZw37Y5v74BBcYJZgVz0FCEUgXSzIQY
         V+MwgbrSyX20mace5pd8O3sh749XO80TB4ilHl88j6aKLo72pAPMwdTl03ZKYuxcUbhl
         svn7s+OsJfuNQXNRMbF1bc92QsOykZxXudlQKG7UEF7YCm1FwQI4GFwSSpwHur3fntim
         7Vfg==
X-Gm-Message-State: AOJu0YyE/mAQ216TYXYrFBwmGFu/sidkHbptpsC/SN9NPX5KoQ+85w3v
	VGD85N26UOXp3bLHIJdAEi/Q7KnW/WhC7+9HOlALViWj+o/9loGlTvnbLAyh9IAaQjQOsAL4fSC
	BeXpeJK7uhI4k3aYtuDZlEYGVc+iPbAo=
X-Gm-Gg: ASbGnct+NOvDDp53PLFnM32PESlOYWokZPTkVPWsxfyS/jp2eaQ0W+61v3AvRK8IFXl
	H8FCcjOI0upaGeavtYNozpSxOtrKXPTZRZ1XUmcUG2Otz0FQwUHllgOkmQOJwD1WLaXIZTuA3IG
	aj4EM5K5iCcKp2Sd9e6rTy15L6evwF9gvsRMJykr27/XEa3Zr1NVmiYs2W6YQKFaCbAKGH720np
	ja0sZv9nK/E6JYYixgSsPI9BXkI1T1SXGyh+6m4AnIIoXLRx0aZTbU4BhsV2FPOXfsLD27LoERR
	UP2f7udQES4bHzrxhEWsJNEufrT9YFpLRKSnalzeBxXo
X-Google-Smtp-Source: AGHT+IHwAOgKdZnjv8Ra6NRCH56wK2VLEzPW8OibPCEBWdRd2pmyHYQV/MPmjLsAx3h7bvr0pXS5J2RD3mxuOVyH004=
X-Received: by 2002:a5d:64c5:0:b0:429:d6dc:ae30 with SMTP id
 ffacd0b85a97d-42f731c2b6cmr2934585f8f.46.1764775100859; Wed, 03 Dec 2025
 07:18:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128185523.B995CC4CEFB@smtp.kernel.org>
In-Reply-To: <20251128185523.B995CC4CEFB@smtp.kernel.org>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 3 Dec 2025 16:18:10 +0100
X-Gm-Features: AWmQ_bkUSZqwRcjEKOHC2jF7jJ05Jhr7oMctTnmr-36-DTvY88P7pB7sfUaL8pw
Message-ID: <CA+fCnZeKm4uZuv2hhnSE0RrBvjw26eZFNXC6S+SPDMD0O1vvvA@mail.gmail.com>
Subject: Re: + mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch
 added to mm-hotfixes-unstable branch
To: jiayuan.chen@linux.dev, Kees Cook <kees@kernel.org>
Cc: mm-commits@vger.kernel.org, vincenzo.frascino@arm.com, urezki@gmail.com, 
	stable@vger.kernel.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, dakr@kernel.org, kasan-dev <kasan-dev@googlegroups.com>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 7:55=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: Jiayuan Chen <jiayuan.chen@linux.dev>
> Subject: mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN
> Date: Fri, 28 Nov 2025 19:15:14 +0800

Hi Jiayuan,

Please CC kasan-dev@googlegroups.com when sending KASAN patches.

>
> Syzkaller reported a memory out-of-bounds bug [1]. This patch fixes two
> issues:
>
> 1. In vrealloc, we were missing the KASAN_VMALLOC_VM_ALLOC flag when
>    unpoisoning the extended region. This flag is required to correctly
>    associate the allocation with KASAN's vmalloc tracking.
>
>    Note: In contrast, vzalloc (via __vmalloc_node_range_noprof) explicitl=
y
>    sets KASAN_VMALLOC_VM_ALLOC and calls kasan_unpoison_vmalloc() with it=
.
>    vrealloc must behave consistently =E2=80=94 especially when reusing ex=
isting
>    vmalloc regions =E2=80=94 to ensure KASAN can track allocations correc=
tly.
>
> 2. When vrealloc reuses an existing vmalloc region (without allocating ne=
w
>    pages), KASAN previously generated a new tag, which broke tag-based
>    memory access tracking. We now add a 'reuse_tag' parameter to
>    __kasan_unpoison_vmalloc() to preserve the original tag in such cases.

I think we actually could assign a new tag to detect accesses through
the old pointer. Just gotta retag the whole region with this tag. But
this is a separate thing; filed
https://bugzilla.kernel.org/show_bug.cgi?id=3D220829 for this.

>
> A new helper kasan_unpoison_vralloc() is introduced to handle this reuse
> scenario, ensuring consistent tag behavior during reallocation.
>
>
> Link: https://lkml.kernel.org/r/20251128111516.244497-1-jiayuan.chen@linu=
x.dev
> Link: https://syzkaller.appspot.com/bug?extid=3D997752115a851cb0cf36 [1]
> Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizin=
g")
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> Reported-by: syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68e243a2.050a0220.1696c6.007d.GAE@goo=
gle.com/T/
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: Dmitriy Vyukov <dvyukov@google.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/kasan.h |   21 +++++++++++++++++++--
>  mm/kasan/hw_tags.c    |    4 ++--
>  mm/kasan/shadow.c     |    6 ++++--
>  mm/vmalloc.c          |    4 ++--
>  4 files changed, 27 insertions(+), 8 deletions(-)
>
> --- a/include/linux/kasan.h~mm-kasan-fix-incorrect-unpoisoning-in-vreallo=
c-for-kasan
> +++ a/include/linux/kasan.h
> @@ -596,13 +596,23 @@ static inline void kasan_release_vmalloc
>  #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
>
>  void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
> -                              kasan_vmalloc_flags_t flags);
> +                              kasan_vmalloc_flags_t flags, bool reuse_ta=
g);
> +
> +static __always_inline void *kasan_unpoison_vrealloc(const void *start,
> +                                                    unsigned long size,
> +                                                    kasan_vmalloc_flags_=
t flags)
> +{
> +       if (kasan_enabled())
> +               return __kasan_unpoison_vmalloc(start, size, flags, true)=
;
> +       return (void *)start;
> +}
> +
>  static __always_inline void *kasan_unpoison_vmalloc(const void *start,
>                                                 unsigned long size,
>                                                 kasan_vmalloc_flags_t fla=
gs)
>  {
>         if (kasan_enabled())
> -               return __kasan_unpoison_vmalloc(start, size, flags);
> +               return __kasan_unpoison_vmalloc(start, size, flags, false=
);
>         return (void *)start;
>  }
>
> @@ -629,6 +639,13 @@ static inline void kasan_release_vmalloc
>                                          unsigned long free_region_end,
>                                          unsigned long flags) { }
>
> +static inline void *kasan_unpoison_vrealloc(const void *start,
> +                                           unsigned long size,
> +                                           kasan_vmalloc_flags_t flags)
> +{
> +       return (void *)start;
> +}
> +
>  static inline void *kasan_unpoison_vmalloc(const void *start,
>                                            unsigned long size,
>                                            kasan_vmalloc_flags_t flags)
> --- a/mm/kasan/hw_tags.c~mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-f=
or-kasan
> +++ a/mm/kasan/hw_tags.c
> @@ -317,7 +317,7 @@ static void init_vmalloc_pages(const voi
>  }
>
>  void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
> -                               kasan_vmalloc_flags_t flags)
> +                               kasan_vmalloc_flags_t flags, bool reuse_t=
ag)
>  {
>         u8 tag;
>         unsigned long redzone_start, redzone_size;
> @@ -361,7 +361,7 @@ void *__kasan_unpoison_vmalloc(const voi
>                 return (void *)start;
>         }
>
> -       tag =3D kasan_random_tag();
> +       tag =3D reuse_tag ? get_tag(start) : kasan_random_tag();
>         start =3D set_tag(start, tag);
>
>         /* Unpoison and initialize memory up to size. */
> --- a/mm/kasan/shadow.c~mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-fo=
r-kasan
> +++ a/mm/kasan/shadow.c
> @@ -625,7 +625,7 @@ void kasan_release_vmalloc(unsigned long
>  }
>
>  void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
> -                              kasan_vmalloc_flags_t flags)
> +                              kasan_vmalloc_flags_t flags, bool reuse_ta=
g)

Since we already have kasan_vmalloc_flags_t, I think it makes sense to
add reuse_tag as another flag.

>  {
>         /*
>          * Software KASAN modes unpoison both VM_ALLOC and non-VM_ALLOC
> @@ -648,7 +648,9 @@ void *__kasan_unpoison_vmalloc(const voi
>             !(flags & KASAN_VMALLOC_PROT_NORMAL))
>                 return (void *)start;
>
> -       start =3D set_tag(start, kasan_random_tag());
> +       if (!reuse_tag)
> +               start =3D set_tag(start, kasan_random_tag());

The HW_TAGS mode should also need this fix. Please build it (the build
should be failing with your patch as is), boot it, and run the KASAN
tests. And do the same for the other modes.

Would be good to have tests for vrealloc too. Filed
https://bugzilla.kernel.org/show_bug.cgi?id=3D220830 for this.

> +
>         kasan_unpoison(start, size, false);
>         return (void *)start;
>  }
> --- a/mm/vmalloc.c~mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kas=
an
> +++ a/mm/vmalloc.c
> @@ -4175,8 +4175,8 @@ void *vrealloc_node_align_noprof(const v
>          * We already have the bytes available in the allocation; use the=
m.
>          */
>         if (size <=3D alloced_size) {
> -               kasan_unpoison_vmalloc(p + old_size, size - old_size,
> -                                      KASAN_VMALLOC_PROT_NORMAL);
> +               kasan_unpoison_vrealloc(p, size,
> +                                       KASAN_VMALLOC_PROT_NORMAL | KASAN=
_VMALLOC_VM_ALLOC);

Orthogonal to this series, but is it allowed to call vrealloc on
executable mappings? If so, we need to only set
KASAN_VMALLOC_PROT_NORMAL for non-executable mappings. And
kasan_poison_vmalloc should not be called for them as well (so we
likely need to pass a protection flag to it to avoid exposing this
logic).

Kees, I see you worked on vrealloc annotations, do you happen to know?


>                 /*
>                  * No need to zero memory here, as unused memory will hav=
e
>                  * already been zeroed at initial allocation time or duri=
ng
> _
>
> Patches currently in -mm which might be from jiayuan.chen@linux.dev are
>
> mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch
> mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch
>
