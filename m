Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B4413D893
	for <mm-commits@vger.kernel.org>; Tue, 17 Dec 2024 02:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734402032; cv=none; b=eHZKu6yKY32AUtgpKCcVkl7qS1FLQJARb8OdhqR5CxSp8Uj3FV0eF7yJSHzAN8JQbDI8dq8rRUPW3d4uIh56z6DEOPr2hi8xY8j5ZI6NZVU3Xb/sDQ/QDO1jTAYchgkMFFkaizggye5I3+LVT5ihjpCw1WAarMFkyOO8K3OejAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734402032; c=relaxed/simple;
	bh=wQfx8qtmxRUzI9+SD70Kw2S+j6lhnDip/WQq4spwh44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WhmPeSikK4JcEkVKeGAM+YSl1uLLpAO4lgPVF7A6saGRvrLqfd6L/eTQYrWwcR/gz0Yn+l7ajY4tWuHLz1r/MIgFz029bkI9Dv8fkRg0iJQaP2duvnzUkkVpmaYEgHyfUw0LoY21fHLglzuRnHLhSvGseGHwRnkUupYNNV4hBd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ND6hICh/; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ND6hICh/"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e460717039fso2351774276.0
        for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 18:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734402029; x=1735006829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Poj65mCzB7tacpKeqSVrfVvfMEqzew22PoBVSPrlv4I=;
        b=ND6hICh/FGbeNSegQMevHmDOpcJH76SPDUcZmYDENZTu57X640IoxuT8qR1wxa4/7M
         NWgfgblpSfhKcxxNJXa4Et9HZLEIC/DjkswrJjph/DbWx51oG9i4jtRR5CKhpGOa4S7a
         hXnB0vtNc24ulbo9hJWowhnL812T3LFkwjpuFjCjX736xfLhhDdH1ADHvzot/TfWGXKF
         1M9tM0xqy3RggbAKuAYG/ehIPeE8eIwlsGHwyJvrEkG+D3GjEQbGtYTOUSGIoW02Pspk
         LbgS1Z7oHHi0CzXdwXalqC/bQC2620aNfNlWPdRv1Ty0ss6PwX+qISkM/pUiSdGMAuLU
         upxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734402029; x=1735006829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Poj65mCzB7tacpKeqSVrfVvfMEqzew22PoBVSPrlv4I=;
        b=O47qp3sM+XeEd0uM+BRiwf+ZVf1URaHx91nk+nQx81hv1SK/ceIRdlCUA/D7pJ+C5h
         GDPgq7AL32oAMIG6hiMuqIKzXEwB1aFnwprF8TBMqvE/UhZACtUFs9hlInf+AeQQ6UBe
         ViIE1/EgffnURyv49cA7QcB/iG86W0C/RMJK5jCOnTTjEF6Dukl+hkgIlHcRB2y4Gmxd
         soKYGSZ1Qjb1z5YOPhq7Vo7EH27ZiIeHGlqQ/ZY02Ro63CJ6c6UAJKzrBczwWvYNK97y
         MPg24OpgQ8ttnxRN72iBuK60l2E3ALIGeJMJmQsSVOYPWacZcDpGC9CCCxBo0ln0NONS
         WRig==
X-Gm-Message-State: AOJu0YwxXdj/u2gSSwJPdDT2Q2/Vl662yZ1w2pa/qbIS8eqiz2T9+Bmt
	SA3skhJNAWX5om5v7ly2YhZLph/ZYLeQZMdZWzpsDbZA0ocD75G0
X-Gm-Gg: ASbGncuFTs9mWh65c//HnKKG5o7rJ0VpT/QS8+Bc05nJplN6X+7TxrXZcKIVQB0Itqu
	cIRnXRP8X4k5RuapE4tY6vlKTIReem2NShtjNiqvRFVn/TMhGD9rDNGn8ZkUb/4Z2EG4h55kcDe
	iK1JiOdoN92N4LPb7wOy212aTGlKsSzaju614uBYEoH1TdPPK2tUG0hGbxRJj0D6slGRKTBObm/
	WZO3Ut47yHaho7R1rp9faSbUV9ArVGVfu3lDhqUv+reZCEWX3MndxwMuXknpvzTl7O8Zc1FRxiC
	yb8Mo7axETQ+C6BR
X-Google-Smtp-Source: AGHT+IHLjPbj+mBwuvBDgu0s5mJY9OONmbha1WiAM9rIYbid13ex4igAm1modVnd/OvFw9x846VVvw==
X-Received: by 2002:a05:6902:2413:b0:e38:8a2e:e3bc with SMTP id 3f1490d57ef6-e4348b31398mr12456864276.5.1734402029232;
        Mon, 16 Dec 2024 18:20:29 -0800 (PST)
Received: from localhost (c-24-129-28-254.hsd1.fl.comcast.net. [24.129.28.254])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e470316140dsm1662183276.16.2024.12.16.18.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2024 18:20:28 -0800 (PST)
Date: Mon, 16 Dec 2024 18:20:26 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
	masahiroy@kernel.org, mailhol.vincent@wanadoo.fr,
	linux@rasmusvillemoes.dk, david.laight@aculab.com
Subject: Re: + linux-bitsh-simplify-genmask.patch added to mm-nonmm-unstable
 branch
Message-ID: <Z2Df6iv0qZ6eg0Dp@yury-ThinkPad>
References: <20241216170002.1F143C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241216170002.1F143C4CED0@smtp.kernel.org>

On Mon, Dec 16, 2024 at 09:00:01AM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: linux/bits.h: simplify GENMASK()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      linux-bitsh-simplify-genmask.patch
> 

Hi Andrew,

Can you put this on hold for a while? I have a couple questions for
David about this. Also, if it comes to v2, I'd like to move it in my
branch.

Thanks,
Yury


> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/linux-bitsh-simplify-genmask.patch
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
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: David Laight <David.Laight@ACULAB.COM>
> Subject: linux/bits.h: simplify GENMASK()
> Date: Mon, 16 Dec 2024 09:39:23 +0000
> 
> Change 95b980d62d52c replaced ~0ul and ~0ull with ~UL(0) and ~ULL(0) in
> the GENMASK() defines as part of a change to allow the bitops definitions
> be used from assembly.
> 
> The definitions have since been moved to a uapi header which probably
> shouldn't require some other header be included first.
> 
> The definition of __GENMASK() is also overcomplicated partially due to
> avoiding overflow warnings from shifting ~0u left.
> 
> Implement GENMASK() using the simpler (1u << hi) * 2 - (1u << lo) formula.
> This doesn't rely on right shifts and doesn't need to know the number of
> bits in the integral type.  It can be used for different types by just
> changing the type of the 1u.  __GENMASK() __GENMASK_ULL() and
> __GENMASK_U128() can now implemeted using a single ___GENMASK(one, hi,
> lo).
> 
> Overflow warnings (from shifting out the MSB) are avoided by subtracting 1
> before the multiply and adding two back in later.  The complers see
> straight through the subterfuge when generating code.
> 
> Since there are already conditionals for ASSEMBLY in bits.h, for ASSEMBLY
> directly expand GENMASK() and GENMASK_ULL() as ___GENMASK(1, hi, lo)
> rather than through the __GENMASK() and __GENMASK_ULL() uapi defines. 
> Remove the UL(x) and ULL(x) from the uapi file.
> 
> GENMASK() and GENMASK_ULL() now generate the correct values when ASSEMBLY
> is defined.  Fortunately they've never been used.
> 
> Rename 'h' to 'hi' and 'l' to 'lo' because 'l' looks like '1' in many fonts.
> 
> Link: https://lkml.kernel.org/r/7a1b1534e51342769740985db773d5e1@AcuMS.aculab.com
> Signed-off-by: David Laight <david.laight@aculab.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Cc: Yury Norov <yury.norov@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/bits.h      |   43 ++++++++++++++----------------------
>  include/uapi/linux/bits.h |   15 +++++-------
>  2 files changed, 24 insertions(+), 34 deletions(-)
> 
> --- a/include/linux/bits.h~linux-bitsh-simplify-genmask
> +++ a/include/linux/bits.h
> @@ -14,41 +14,32 @@
>  #define BITS_PER_BYTE		8
>  
>  /*
> - * Create a contiguous bitmask starting at bit position @l and ending at
> - * position @h. For example
> + * Create a contiguous bitmask starting at bit position @lo and ending at
> + * position @hi. For example
>   * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
>   */
>  #if !defined(__ASSEMBLY__)
>  #include <linux/build_bug.h>
> -#define GENMASK_INPUT_CHECK(h, l) \
> +#define GENMASK_INPUT_CHECK(hi, lo) \
>  	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
> -		__is_constexpr((l) > (h)), (l) > (h), 0)))
> -#else
> -/*
> - * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
> - * disable the input check if that is the case.
> - */
> -#define GENMASK_INPUT_CHECK(h, l) 0
> -#endif
> +		__is_constexpr((lo) > (hi)), (lo) > (hi), 0)))
>  
> -#define GENMASK(h, l) \
> -	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
> -#define GENMASK_ULL(h, l) \
> -	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_ULL(h, l))
> +#define GENMASK(hi, lo) \
> +	(GENMASK_INPUT_CHECK(hi, lo) + __GENMASK(hi, lo))
> +#define GENMASK_ULL(hi, lo) \
> +	(GENMASK_INPUT_CHECK(hi, lo) + __GENMASK_ULL(hi, lo))
>  
> -#if !defined(__ASSEMBLY__)
> +#define GENMASK_U128(hi, lo) \
> +	(GENMASK_INPUT_CHECK(hi, lo) + __GENMASK_U128(hi, lo))
> +#else
>  /*
> - * Missing asm support
> - *
> - * __GENMASK_U128() depends on _BIT128() which would not work
> - * in the asm code, as it shifts an 'unsigned __init128' data
> - * type instead of direct representation of 128 bit constants
> - * such as long and unsigned long. The fundamental problem is
> - * that a 128 bit constant will get silently truncated by the
> - * gcc compiler.
> + * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
> + * 128bit exprssions don't work, neither can C 0UL (etc) constants be used.
> + * These definitions only have to work for constants and don't require
> + * that ~0 have any specific number of set bits.
>   */
> -#define GENMASK_U128(h, l) \
> -	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_U128(h, l))
> +#define GENMASK(hi, lo) ___GENMASK(1, hi, lo)
> +#define GENMASK_ULL(hi, lo) ___GENMASK(1, hi, lo)
>  #endif
>  
>  #endif	/* __LINUX_BITS_H */
> --- a/include/uapi/linux/bits.h~linux-bitsh-simplify-genmask
> +++ a/include/uapi/linux/bits.h
> @@ -4,15 +4,14 @@
>  #ifndef _UAPI_LINUX_BITS_H
>  #define _UAPI_LINUX_BITS_H
>  
> -#define __GENMASK(h, l) \
> -        (((~_UL(0)) - (_UL(1) << (l)) + 1) & \
> -         (~_UL(0) >> (__BITS_PER_LONG - 1 - (h))))
> +/* Result is '(1u << (hi + 1)) - (1u << lo)' coded to avoid overflow. */
> +#define ___GENMASK(one, hi, lo) \
> +	((((one) << (hi)) - 1) * 2 + 1 - (((one) << (lo)) - 1))
>  
> -#define __GENMASK_ULL(h, l) \
> -        (((~_ULL(0)) - (_ULL(1) << (l)) + 1) & \
> -         (~_ULL(0) >> (__BITS_PER_LONG_LONG - 1 - (h))))
> +#define __GENMASK(hi, lo) ___GENMASK(1UL, hi, lo)
>  
> -#define __GENMASK_U128(h, l) \
> -	((_BIT128((h)) << 1) - (_BIT128(l)))
> +#define __GENMASK_ULL(hi, lo) ___GENMASK(1ULL, hi, lo)
> +
> +#define __GENMASK_U128(hi, lo) ___GENMASK((unsigned __int128)1, hi, lo)
>  
>  #endif /* _UAPI_LINUX_BITS_H */
> _
> 
> Patches currently in -mm which might be from David.Laight@ACULAB.COM are
> 
> minmaxh-add-whitespace-around-operators-and-after-commas.patch
> minmaxh-update-some-comments.patch
> minmaxh-reduce-the-define-expansion-of-min-max-and-clamp.patch
> minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
> minmaxh-move-all-the-clamp-definitions-after-the-min-max-ones.patch
> minmaxh-simplify-the-variants-of-clamp.patch
> minmaxh-remove-some-defines-that-are-only-expanded-once.patch
> linux-bitsh-simplify-genmask.patch
