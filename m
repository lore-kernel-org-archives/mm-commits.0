Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A589481C4;
	Sun, 26 Jan 2025 20:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737923304; cv=none; b=XhySxssaO1+hpR89aGJk26y2tQAf+l1YVfyeMTp4ZbEVTIUCp2goJTai8SgCwuuOS1QUnzseBuzOJyi/4rQFCrZuaG7RVOZjKHYBRIvvR93iPTSm9hi+H/Xo2AhTR49Iv0p87OH6+4a+xSzUoqb9ncPH0WGwB8OFDLU0xe/iU/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737923304; c=relaxed/simple;
	bh=WJ3s63Ee+SJowwEtWuVwGlGziyLOwhZNclPoIvWf2Z4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MthkbtCxW0m91x4PZMaDjpC2r5uy19MeyeiI+dov0i/V5vjXcbRpXfG5v8WSvKQGbFos28ucOnVO91FjQWFcYdRmQQFjK0r1uXBiVhECKxhIEL1V9pxmXn5HL2waavBDAbI/pBkJkBnUObKi+0f3abj664uRztYxvuMpQ6JRpZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KS6t0AqH; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KS6t0AqH"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f440e152fdso908644a91.0;
        Sun, 26 Jan 2025 12:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737923302; x=1738528102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/fuOemPeHf82tYw4L82oPf1R2tiFXPm8M1M6oFL6y7E=;
        b=KS6t0AqH9eCyqZ9XDM/gLJ1CKKBxGUgOVQpVVxjHWwoKMVEqSniOtLmIJG7+5mM3J6
         +PTKsZ8f+D5AsyYS1M/9rzXToExKjQxRMuaHQVOTW5Pt06LFngKW3FcQBKvQ7KoWlxsz
         7768aKL8VyhJNfsdKk0luI0Oxx9eML7/Ynuq1aGOFO54aolNCDjj3FInFVfeyxDkhaAf
         kyZsvjluveKI0h6rNLhhjGYwpV8f6oMduEiVWQKdvEc/XFjta7e3Mv0bas7SshI30wc0
         /h9OTUteHySWhhKCrkVW1i+S16s3TXW5NvRLjm50cKKKMuFb61fH3Da/CG4DgaeXzjvt
         E/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737923302; x=1738528102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/fuOemPeHf82tYw4L82oPf1R2tiFXPm8M1M6oFL6y7E=;
        b=It4g+fGho44SdJ0/Rw5OyFkOW79isamvAMtqY1Iz3lXeF2eK2SGrv9RE6ZxQMEB+XB
         tQeYV2cDyASgwxRRPzxz8xD50MdNCxqW/LXVxa6W3+xvO9IPE87cdPUH8Eep7mFEKUM6
         3f+luqFbmdgWrAGvBaDdxGUhwKChJpz/oY9uXW/RqwOrdo5eOWw3JdMGG2haXgcci7za
         Q1H1q0aQJPvaUMsPRzv+oVNPlahkA4t9+yuJEX2Aw6e342kd06C9QjA7of3hWtmDuMsF
         CpSxv8voLZij/xd14Q1CXLUr3Ahnb0pZg7dFNhkB7BDMxivs7DDdPb6WmbsHr8TrdGCN
         8PEA==
X-Forwarded-Encrypted: i=1; AJvYcCWBB9rQCCxSgLl8I+2XGfHQ5TMiNFxvYkwCSHom50UYrOs+e6i71tbEgk3e+8PHgD4Sns5tmP40mgdITaE=@vger.kernel.org, AJvYcCXWVXa9Rx1bwLMeNJvH57uTP67E3DUVU6bTNO0SQsBT1i0M3NTMfCYE5zmK1A24g2ipbPbFGsaVNcE0sA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv3hP0P3WHYJhsFZOdyPHgj0YhLegdNHkrmEtF2i48jYCW+oz4
	Qik/1fmcLvdKdH/MXAHRHUlTEg2+HATxm+dI3z6nmQU5aTtVM+NcF02X8d2JJAj36hFvJwqhSdo
	EKYY0rO17SPpFxoF27047PrqOpOgL7WEDPi4=
X-Gm-Gg: ASbGncsc8neGzmv+h+alhOCKd+vJ7uJIlga4sYJaPb7PnnQzeyB7Tx90Nknxi4pVfB6
	90rbonr5udnNynm2cWcuXzIaRZ0beZGGpFcrK7WoqFq2eTwvsjNJlYsGJ88mWgA==
X-Google-Smtp-Source: AGHT+IEPv6sJDDhiY47r9rGAf5q/XfElXvkpnd8oy5nfzGr+m/r0VDdGbzc6I8QeVns4ODtsI2pMDYTKFBsjit/TQeI=
X-Received: by 2002:a17:90b:2e8b:b0:2ee:b665:12ce with SMTP id
 98e67ed59e1d1-2f782c561fbmr20992587a91.1.1737923302405; Sun, 26 Jan 2025
 12:28:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
 <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com> <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
In-Reply-To: <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 26 Jan 2025 21:28:09 +0100
X-Gm-Features: AWEUYZmMuLqELedibeFOYeUnW9YSynLGvn2hlU7yK40dMVZ0aNvGaZhd631In6c
Message-ID: <CANiq72mC7Fr6pB-D_JT9A2gCc2Yr0TLf16eRyY4_UWqRrKNVZg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2025 at 7:30=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Let's add Miguel to the participants. Miguel, see
>
>    https://lore.kernel.org/all/CAHk-=3DwhddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=
=3Da1eRig5Gxg@mail.gmail.com/

Thanks for the Cc -- I build linux-next with Rust enabled with some
configs/compilers/arches variations, and I also have a run using
Fedora's latest container image for rust-next, but not the combination
of both (and I mostly do Clang builds).

I will add a couple distro builds for linux-next in my matrix, one
including GCC, so that hopefully at least you don't get blocked with
something like this.

> for my "this doesn't work" report, and then Uros' suggested fix in
>
>    https://lore.kernel.org/all/CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34B=
rM-b_cQCQ@mail.gmail.com/

RUSTC_LLVM_VERSION is indeed not necessarily bindgen's libclang. One
can see the latter's version with:

    bindgen --version --verbose

Though in `scripts/rust_is_available.sh` we use this to support older ones:

    bindgen scripts/rust_is_available_bindgen_libclang.h 2>&1 |
        sed -nE 's:.*clang version ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'

So we could easily add a `BINDGEN_LLVM_VERSION` if we go that route.
(We also fetch bindgen's Clang version in `rust/Makefile` already to
tweak a flag, so this could be useful anyway.)

We could also do a `BINDGEN_CLANG_HAS_TYPEOF_UNQUAL`, i.e. mimicking
the `CC` one.

A bigger hammer is using the `#define` we already pass when using
`bindgen`, i.e. `!defined(__BINDGEN__)`, in the source code. I tried
this one quickly and seems to work, but we would need it in both
places `__CHECKER__` is.

> That does seem to work, but I'd admittedly be happier if we could just
> find some way to dynamically disable/enable __typeof_unqual__ based on
> which compiler is used, rather than make it a config option. So that
> bindgen would not see it, but a recent enough C compiler would.
>
> We already use '__has_attribute()' for some of these things. There's a
> '__has_extension()' thing that comes from clang but that gcc also
> supports.
>
> But I can't find the list of extensions that that model supports, and
> I guess typeof_unqual isn't on that list if I find it.

In LLVM it seems to be at `clang/include/clang/Basic/Features.def`,
but from a quick look at that and the commits that added
`typeof_unqual` I don't see it (but it seems it could have been there,
indeed, given other keywords are listed there):

    https://github.com/llvm/llvm-project/blob/main/clang/include/clang/Basi=
c/Features.def

In GCC I see a few at `gcc/c-family/c-common.cc` (`has_feature_table`)
and `gcc/c/c-objc-common.cc` (`c_feature_table`). I can't see
`typeof_unqual`.

> This does show that our whole "CC_HAS_XYZ" is kind of broken for the
> Rust integration in general.

Yes, bindgen being libclang-only is one of the main reasons why we
call GCC builds with Rust enabled "very experimental" (and why Rust
doesn't work with GCC's randstruct plugin and things like that).

Ideally bindgen would have a way to parse code using GCC
(https://github.com/rust-lang/rust-bindgen/issues/1949), or perhaps it
could fetch layout information in a completely different way, e.g.
building a C file that computes it. There have been some discussions
and even some code written about this over the years, but so far
nothing really usable yet.

Cheers,
Miguel
