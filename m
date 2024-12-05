Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0091B0F22
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409936; cv=none; b=rwhIPyCpccQPmiSE8ANnwfD8FCCPWRjVIWv8Ne9/nqdDYKqQCTZXfDWKE59ZWX/4LNzkbUOcwZ76gNKHaO3DC2/eYjcG03vlEzhnR4js0GFcHMxjmuEMjwV+tEPImbOaoOLX04TX9FVLMkiUaA7NvYm6FqfWSMeEMDHPmjxoNwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409936; c=relaxed/simple;
	bh=vx+zx/Lnk68fWg/nLqCYRt0UU434/26YdCbQkuprRtc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pw2Pa/CqdJwwn7v1sWlUmuViiUe03o71cgVIigmZZh8K1MiBiY68CjzSAB8UcIK34n07cQh6m0y3ZAos7cMYyztXttVrlMy6+GaQZR7/8OxKV/4G4LPalMhK+uxXHadZagu/qkPSOjK7+qKldPnfeydldxk9pTcSOSyscjO/9do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kDbfPcMF; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kDbfPcMF"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2f75c56f16aso8402631fa.0
        for <mm-commits@vger.kernel.org>; Thu, 05 Dec 2024 06:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733409932; x=1734014732; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgZ50owRFsT6NMxz5B4tlCz+UgP5gcWbmjYQ3Ox22Sk=;
        b=kDbfPcMF50bD5vKgyPsB3pEtkhxBE3XuuPJzLO+0dJbrJM/E5AEeRs3BM3vaOzu8Ha
         hRZuhrbrVO5NpcnFIJWcaHfX9yqhbO2dEq2idFx5Av/RNAdL66i8Xs/sEcmY7Q63YiYE
         /zdSn7ihA/gy5DaqXfPsY02B+JEarbE+u3mzjJSEWARs67B5yOxg37ksHD5Ag1yhgCef
         m16M1SWFEON5MXy03F/7kbGIbd6o+b6dSqseRHr4V4MzxDj+HXpMyLnxdTZamNUY/po3
         quTlZy3cjKuyL/qAWJ0TzepKaN2etMMrJ/J/OR5YlU4dRbSDU5lsasJVtmo9EqhU1iOS
         Etbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733409932; x=1734014732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IgZ50owRFsT6NMxz5B4tlCz+UgP5gcWbmjYQ3Ox22Sk=;
        b=pGz0FMbRuakJNBHSuufyBOmZJrFhEWN9ZYQ6OZ/7MR54bq4KuZwlSFzUYm0tQnpV8n
         NI0Uu6+Pt+Q5gofjuSAQ4NWRAGusdUCNaLdeuVWwP8/KayeG35wtvdnbuEkxq4Shwmq9
         BEulM3Nq3O5bZXK+yX8cMjF2U7oqhalLh7p8b0Sfn2WHkmtyFng5wpXBM9FSBprpFMTJ
         7jGbHY+g09guyoYvTJU/XfNw2Jz+AbKWKR+cpzGDFkuLIAl8Ls5xCo/MnKT+T+5217H8
         eI1rL5sVBLMKGjkKOyr6bnv+sp43qQNi4iHTy5GHO9oEhekH4K1IzjppjnVMk+OI3vW6
         rn6g==
X-Gm-Message-State: AOJu0YxH1VUReZf45W3WHkTugXC7y/dYGBUawCIDMsAZ0l/YVrA1/aVH
	vcReGf2o9Ctlk/lmYzQlAsKK8nfetmkc4P6bJ+c+Ge6CiwoCHhmuhI0ATHLgmw22E9J3sgyQpP+
	tElp/ik4VLfgHFcLTCTnWBlQ8p4U=
X-Gm-Gg: ASbGncskxiQuMI/4yRW36SvJz94IvO0hvP+TmdkTuzSBWxF9fnkMo8bs3K11XfiTpbP
	h/G28b09Ljz+9rc6c/FYCa9gySU0hSlWqci8N+zqv5Y2MwZQ=
X-Google-Smtp-Source: AGHT+IHVr9RTYJ3ao1OFA7FqZVZcsAPRZQZJR/94jXNNYhemhDTF+UOtyieKBrnxhMca35fpUA+LinkZ38jQvoVXFpM=
X-Received: by 2002:a2e:bc06:0:b0:2fb:4abb:7001 with SMTP id
 38308e7fff4ca-30009c0f669mr47407251fa.2.1733409932028; Thu, 05 Dec 2024
 06:45:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241130050908.721FEC4CECC@smtp.kernel.org>
In-Reply-To: <20241130050908.721FEC4CECC@smtp.kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Thu, 5 Dec 2024 09:44:56 -0500
Message-ID: <CAJ-ks9kbOW_LB5kupTPtWCQBe--Ud=wvB_hAU-XoruLBf_fONA@mail.gmail.com>
Subject: Re: + xarray-extract-helper-from-__xa_insertcmpxchg.patch added to
 mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, aliceryhl@google.com, 
	a.hindborg@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew, this patch is broken. Could you please fold this fix into it?

https://lore.kernel.org/all/CAJ-ks9kN_qddZ3Ne5d=3DcADu5POC1rHd4rQcbVSD_spnZ=
OrLLZg@mail.gmail.com/

Apologies for the breakage.
Tamir

On Sat, Nov 30, 2024 at 12:09=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: xarray: extract helper from __xa_{insert,cmpxchg}
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      xarray-extract-helper-from-__xa_insertcmpxchg.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/xarray-extract-helper-from-__xa_insertcmpxchg.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
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
> From: Tamir Duberstein <tamird@gmail.com>
> Subject: xarray: extract helper from __xa_{insert,cmpxchg}
> Date: Tue, 12 Nov 2024 14:25:37 -0500
>
> Reduce code duplication by extracting a static inline function.  This
> function is identical to __xa_cmpxchg with the exception that it does not
> coerce zero entries to null on the return path.
>
> Link: https://lkml.kernel.org/r/20241112-xarray-insert-cmpxchg-v1-2-dc2bd=
d8c4136@gmail.com
> Signed-off-by: Tamir Duberstein <tamird@gmail.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Andreas Hindborg <a.hindborg@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  lib/xarray.c |   37 ++++++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 19 deletions(-)
>
> --- a/lib/xarray.c~xarray-extract-helper-from-__xa_insertcmpxchg
> +++ a/lib/xarray.c
> @@ -1491,7 +1491,7 @@ static void *xas_result(struct xa_state
>  {
>         if (xas_error(xas))
>                 curr =3D xas->xa_node;
> -       return xa_zero_to_null(curr);
> +       return curr;
>  }
>
>  /**
> @@ -1568,7 +1568,7 @@ void *__xa_store(struct xarray *xa, unsi
>                         xas_clear_mark(&xas, XA_FREE_MARK);
>         } while (__xas_nomem(&xas, gfp));
>
> -       return xas_result(&xas, curr);
> +       return xas_result(&xas, xa_zero_to_null(curr));
>  }
>  EXPORT_SYMBOL(__xa_store);
>
> @@ -1601,6 +1601,9 @@ void *xa_store(struct xarray *xa, unsign
>  }
>  EXPORT_SYMBOL(xa_store);
>
> +static inline void *__xa_cmpxchg_raw(struct xarray *xa, unsigned long in=
dex,
> +                       void *old, void *entry, gfp_t gfp);
> +
>  /**
>   * __xa_cmpxchg() - Store this entry in the XArray.
>   * @xa: XArray.
> @@ -1620,6 +1623,13 @@ EXPORT_SYMBOL(xa_store);
>  void *__xa_cmpxchg(struct xarray *xa, unsigned long index,
>                         void *old, void *entry, gfp_t gfp)
>  {
> +       return xa_zero_to_null(__xa_cmpxchg_raw(xa, index, old, entry, gf=
p));
> +}
> +EXPORT_SYMBOL(__xa_cmpxchg);
> +
> +static inline void *__xa_cmpxchg_raw(struct xarray *xa, unsigned long in=
dex,
> +                       void *old, void *entry, gfp_t gfp)
> +{
>         XA_STATE(xas, xa, index);
>         void *curr;
>
> @@ -1637,7 +1647,6 @@ void *__xa_cmpxchg(struct xarray *xa, un
>
>         return xas_result(&xas, curr);
>  }
> -EXPORT_SYMBOL(__xa_cmpxchg);
>
>  /**
>   * __xa_insert() - Store this entry in the XArray if no entry is present=
.
> @@ -1657,26 +1666,16 @@ EXPORT_SYMBOL(__xa_cmpxchg);
>   */
>  int __xa_insert(struct xarray *xa, unsigned long index, void *entry, gfp=
_t gfp)
>  {
> -       XA_STATE(xas, xa, index);
>         void *curr;
> +       int errno;
>
> -       if (WARN_ON_ONCE(xa_is_advanced(entry)))
> -               return -EINVAL;
>         if (!entry)
>                 entry =3D XA_ZERO_ENTRY;
> -
> -       do {
> -               curr =3D xas_load(&xas);
> -               if (!curr) {
> -                       xas_store(&xas, entry);
> -                       if (xa_track_free(xa))
> -                               xas_clear_mark(&xas, XA_FREE_MARK);
> -               } else {
> -                       xas_set_err(&xas, -EBUSY);
> -               }
> -       } while (__xas_nomem(&xas, gfp));
> -
> -       return xas_error(&xas);
> +       curr =3D __xa_cmpxchg_raw(xa, index, NULL, entry, gfp);
> +       errno =3D xa_err(curr);
> +       if (errno)
> +               return errno;
> +       return (curr !=3D NULL) ? -EBUSY : 0;
>  }
>  EXPORT_SYMBOL(__xa_insert);
>
> _
>
> Patches currently in -mm which might be from tamird@gmail.com are
>
> xarray-extract-xa_zero_to_null.patch
> xarray-extract-helper-from-__xa_insertcmpxchg.patch
>
