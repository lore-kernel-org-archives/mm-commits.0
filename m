Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB80359A8B
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 20:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346919; cv=none; b=WUxHI0OAAEBC+XWG5GngK1hUVGhdPWzt112PXqgCKxaXbXNyFLERl0p+NPu1aUwgu4n7Yo1OFMOrcWR4H5t82JQsC4EqoyyCrgO1oxsMoST/UtjA5e2c78NEFugVGLRU22gmvD9KbZKRgl9NIiOLYXdF4ZN5dfHI/aNvYM5B9XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346919; c=relaxed/simple;
	bh=EWW273u0OKqkvsmHwhcbyon8iRdaKFojapiWuwAbMjU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=jBXIa/vkd19VsVfwa4DorbK7NZoFggkUbOecJ75WLidyNhvAWcpPqnzqYXkkQQzRq/IYZH4xunrflB3SmIzlARHXFa8UoegthMEYihPORvW4AVODDnlnsrIBPJPfe3shUFmKp30lNDv61wGQ8pm8OZWi39UlMoaJPLUK+seHTbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sn8hsK+r; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sn8hsK+r"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-485409ab264so10167135e9.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 13:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773346916; x=1773951716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWW273u0OKqkvsmHwhcbyon8iRdaKFojapiWuwAbMjU=;
        b=Sn8hsK+r652dvw+yMUyilQrgmIV7rrKyOvfpWZOG5cUx4XVTLL1psYXtBOhQv2t5mI
         806zotyGmrOlUKgaMTObBfkYOJqyO6blEP7AG/BUfWnhvnuxk+5nL3tz0g9WAGY1PUVr
         CMfcBM9JKsnQO2sTidY6g8zOfP8Cal2Gn+kz+LLT5DxAH4zTSLA5yAx0N8BzGuAS1qM7
         WseY4JS/ToEW61KA+0zTyULP25aleXjPrNiDrktf+gMGyDFPkLdcU0jfClxGkOniirNB
         o7jZfLctzTWlXLMO7ReBk3xqtsZs9bHcL4hH7JPSGxqdrZ6hfNgnES6sRu65vqrt2CN/
         ix6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773346916; x=1773951716;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EWW273u0OKqkvsmHwhcbyon8iRdaKFojapiWuwAbMjU=;
        b=EKyikMxJCXqSihOt9wWsuy1Veu0N1esWY05Ei55lmh7alxWzYjNFqQpiG9FO2Elem+
         yKvN98OY1nZXyRMB7V8eHvUtfu7OZKj66K3wKXNT8pZjK+OwlylPfVFIfeBGRfaqlwu8
         ZR/cTP1GaIqe4W9POF1x/Jufdu3mnKo9sIZFwsTHEy+D1/8RihHDzzD9mgVZcoV6zr7V
         nCnDyNmQCGOradnQAjNns0tfrhfRf3NmaU9Pb0GrmSsZ/3PDw9mfAalENsZ+bbwnhw7o
         s3U5wu8DSGVpYt0QXpL0Rva7UgB06Cs1QeVqqHMaBRNaIUaLnOcJy80LFLaykuiUUeYj
         rVdw==
X-Gm-Message-State: AOJu0YySl5y1fW9ROg/tYSOypgVj6AYMfxKt+8jud6LhgI8y1bDcLahI
	GA4d1NZxqrWPkNgDzSrdC7bY01OxSe5xR/eFRGQuFSUEaTSmGu0qaxLV
X-Gm-Gg: ATEYQzxoDJ64lfik0ZorPKUc3LR231iHelCQNDH0y0cUPUy4+o85SLkNgAv0/TC+IZL
	U0xcHSiqKXkkq8pDX4b26s+iZAuMwUVUhV+uS5O3pSJwNzk8YFrggem/3fICz5t8qzViDtl2/iO
	WS166ThYDYIqI5hnNHfuljd5SMOvQFyC/Zy3lK+K4FfytEKPkVLy2SW2OybVWbt2o+zYkXDjj0f
	lljjaq0ToLsGCDyfzMKQbuCfVwIGj05uDAWcJ8EPbLnijRlE56NtRLK/ypPVuKjzw25+EUC65PH
	1NYxN/1THH0SI2/Hih/plvbPlPmmZzNwZLl5MA2wNDuk5HpcgzeRpBcoIOMWLq8TlDeQNyDdate
	GnnQhu2kxInkXIahbH8ZBzIFHfTq3cylfCCx2GYIk14dNjXHhdo1nwXkwF958o5ou86ee9Qa9YK
	xDSQ/YBJBro6X+HI7o
X-Received: by 2002:a05:600c:83c5:b0:477:9890:9ab8 with SMTP id 5b1f17b1804b1-48555ab09abmr16142795e9.3.1773346916219;
        Thu, 12 Mar 2026 13:21:56 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854e67ea40sm112345275e9.7.2026.03.12.13.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 13:21:55 -0700 (PDT)
Date: Thu, 12 Mar 2026 20:21:56 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, mhiramat@kernel.org, objecting@objecting.org
Message-ID: <7a082e98-d66d-49e8-ad32-d3066e47012f@gmail.com>
In-Reply-To: <20260312201919.95880C4CEF7@smtp.kernel.org>
References: <20260312201919.95880C4CEF7@smtp.kernel.org>
Subject: Re: +
 lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch added
 to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <7a082e98-d66d-49e8-ad32-d3066e47012f@gmail.com>

12 Mar 2026 20:19:23 Andrew Morton <akpm@linux-foundation.org>:

>
> The patch titled
> =C2=A0=C2=A0=C2=A0=C2=A0 Subject: lib/bootconfig: check bounds before wri=
ting in __xbc_open_brace()
> has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename is
> =C2=A0=C2=A0=C2=A0=C2=A0 lib-bootconfig-check-bounds-before-writing-in-__=
xbc_open_brace.patch
>
> This patch will shortly appear at
> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git/=
akpm/25-new.git/tree/patches/lib-bootconfig-check-bounds-before-writing-in-=
__xbc_open_brace.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
> =C2=A0=C2=A0=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
> =C2=A0=C2=A0 a) Consider who else should be cc'ed
> =C2=A0=C2=A0 b) Prefer to cc a suitable mailing list as well
> =C2=A0=C2=A0 c) Ideally: find the original patch on the mailing list and =
do a
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reply-to-all to that, adding suitable addi=
tional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
>
> ------------------------------------------------------
> From: Josh Law <objecting@objecting.org>
> Subject: lib/bootconfig: check bounds before writing in __xbc_open_brace(=
)
> Date: Thu, 12 Mar 2026 19:11:42 +0000
>
> The bounds check for brace_index happens after the array write.=C2=A0 Whi=
le the
> current call pattern prevents an actual out-of-bounds access (the previou=
s
> call would have returned an error), the write-before-check pattern is
> fragile and would become a real out-of-bounds write if the error return
> were ever not propagated.
>
> Move the bounds check before the array write so the function is
> self-contained and safe regardless of caller behavior.
>
> Link: https://lkml.kernel.org/r/20260312191143.28719-3-objecting@objectin=
g.org
> Signed-off-by: Josh Law <objecting@objecting.org>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> lib/bootconfig.c |=C2=A0=C2=A0=C2=A0 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/lib/bootconfig.c~lib-bootconfig-check-bounds-before-writing-in-__xb=
c_open_brace
> +++ a/lib/bootconfig.c
> @@ -532,9 +532,9 @@ static char *skip_spaces_until_newline(c
> static int __init __xbc_open_brace(char *p)
> {
> =C2=A0=C2=A0=C2=A0 /* Push the last key as open brace */
> -=C2=A0=C2=A0 open_brace[brace_index++] =3D xbc_node_index(last_parent);
> =C2=A0=C2=A0=C2=A0 if (brace_index >=3D XBC_DEPTH_MAX)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return xbc_parse_error("Exceed=
 max depth of braces", p);
> +=C2=A0=C2=A0 open_brace[brace_index++] =3D xbc_node_index(last_parent);
>
> =C2=A0=C2=A0=C2=A0 return 0;
> }
> _
>
> Patches currently in -mm which might be from objecting@objecting.org are
>
> lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
> lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
> lib-glob-add-explicit-include-for-exporth.patch
> lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
> lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch
> lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
> lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.pat=
ch
> lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.p=
atch
> lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
> lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
> lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
> lib-bug-remove-unnecessary-variable-initializations.patch
> lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patc=
h
> lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch
> maintainers-add-josh-law-as-reviewer-for-library-code.patch
> lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch
> lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
> lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
> lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.pat=
ch
> lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch
> lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_afte=
r.patch

Hi Andrew, before you complain about the other patches, "email" situation,



Tomorrow I'll properly setup objecting@objecting.org to be able to send ema=
ils, to mitigate this, thanks for the understanding

V/R



Josh Law
