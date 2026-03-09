Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B3E36A008
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773088053; cv=none; b=X8GDt7pIM3OrVTSYRkD8g1zYOf4qqjRIOA9jmnwRWNSo4e+k1331ejyjKw9OpCG4t1wj4g1I0SzqGUERXkazBrqUHravg2ytOROZi5uEawTFxlnXD2qvDSAXa9DTz5uGApvDgX+TZP3fjn8wJFbef81UabdISJgqXddX4jdlOqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773088053; c=relaxed/simple;
	bh=AE/a4wroBZeq3Vn1aXe3fXKTSTzU3iXt4vjn5Dyiar8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=HtHRooNEiZm8QsjhTRP9mYsfP3ByfJlyfR4wcR5f97wzUMv1rZGRv3BHbDLPGiFcpx1IzDRuk9wARnTQtVMEBVX9eiH1seI/lJ79q0WgGZBw/oYXOWr1wr3j2Eng1FbQJB6GSwnh1ewNhpihYmn7ENAacXfLi04c6cL47NKUPIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePHpU4tQ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePHpU4tQ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4853c1ca73aso11171815e9.2
        for <mm-commits@vger.kernel.org>; Mon, 09 Mar 2026 13:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773088050; x=1773692850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AE/a4wroBZeq3Vn1aXe3fXKTSTzU3iXt4vjn5Dyiar8=;
        b=ePHpU4tQXMu5SwWMBKfYBhavMDd0amlXChVpenyrGJsbleeoBfzX0tXL6Tq/6AshJf
         ylJOcVv6Jk/aYmdypRgQxrFp38UAFXAimv0nfawknBEnbOgBSZtFtSiU7MQ+TL9py6Lf
         PHu07BB0KRhDY4H4e2qvge3r8Dt7siNpumWJ75AZZtSGoqnNjmPTOC8m15++DAXIYe3i
         +fKlPxSZb5hHl2sMdUMm+trOhFvGyyd1ZX1M7HP9akKL7qkia0Jihq5kJ6kufXVlTJQi
         gUCv0GjP+q7O7yohQn/PZOR2aH6nOhOwu4byTajzvL7R0ymFXd3dOhP2FZ5FHnI+5qfm
         4gmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773088050; x=1773692850;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AE/a4wroBZeq3Vn1aXe3fXKTSTzU3iXt4vjn5Dyiar8=;
        b=Jxz1p/gs1aVnKhu2j+UH8CktFRBsUukZbRUxlFXQv6ZkNMXDrKIVWmAARRekEli2CJ
         6pi1+yqgTVBBfUwPolHNX3iwxjhxF7sl70XNSjWpaC8s+5sP4eqzUXNNoOvl4hOutaQT
         zltBWo8E72P5C+zEj2OyB6aNKfm/sUxje8ElxraDPjZtcJNFyhsr/+CnrmxdxnOLA1/F
         OojLZcMKHLACjTK6ctsCaiARJz1mg3V8PNA1dc07KK5ik8u0YrgTSLdkXXijX/bswCr/
         yMpu2WycabRDOU87WjXJ8CxN4qUDnf8Xsa1G/DreD6EJRGWc8MiWSYDsJ30RkOw691Pl
         aT/Q==
X-Gm-Message-State: AOJu0YxYWgyu0kxPkFnCjDnk53S1gNR54eXjNxolnOHzSrJdbA/HXBxO
	0FNgnLWPrpLHchwYd+rBLZE7g1Qy59tYV9e8yyD+/Cg0/dYJuylkD1g6+1gbyUDYOcoTyw==
X-Gm-Gg: ATEYQzygN+g6yYkkkJwl7YIz47xE7sqi+xjyquwIMUQWVtTRxjj/LzDGeshE+TEHZt8
	gqvg0sgawryyWwxuMQd7tO0ODUWfcQ61zB4PikQYFQZaZ8FPp937tohfW/NIvaLJBd7p6P0MgL8
	bPibT6l62q/9WlThvY8Vqif/zYqPRNSDTcvO+t957tk+F1zJyPBeP3KtTnfl2bwisbJohIKU1Kx
	uRFsJc2rVLuquuy/mBx8MBV/8v+UoUb/aGlSHwViCONHFshok1GDneBc0d4XYGCnVu40f9D4hWC
	ToxmC6GlJtmgHfhjSl+Fk/mM0p1hxp46nGugQ/R5g98lp/HiLO7ydEXwpZmjIsv8Pq1nHLeIoU0
	dGuF1nRBmkyG1xSu1Punbczjtn2IsdLXZ3z1oUrfLsxx07fWgOpa8yf8Go+MF2U4gaKfJwoy6Y8
	YBCdoTtQaYOaFow+ro
X-Received: by 2002:a05:600c:138a:b0:47e:e076:c7a5 with SMTP id 5b1f17b1804b1-4852691cf3amr235490845e9.11.1773088049995;
        Mon, 09 Mar 2026 13:27:29 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541b8d4easm16659785e9.15.2026.03.09.13.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 13:27:29 -0700 (PDT)
Date: Mon, 9 Mar 2026 20:27:29 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Message-ID: <58cace1f-394f-43dd-ac9a-40335f5961ae@gmail.com>
In-Reply-To: <20260309202431.DBE90C4CEF7@smtp.kernel.org>
References: <20260309202431.DBE90C4CEF7@smtp.kernel.org>
Subject: Re: +
 lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch added to
 mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <58cace1f-394f-43dd-ac9a-40335f5961ae@gmail.com>

9 Mar 2026 20:24:34 Andrew Morton <akpm@linux-foundation.org>:

>
> The patch titled
> =C2=A0=C2=A0=C2=A0=C2=A0 Subject: lib/ts_bm: fix integer overflow in patt=
ern length calculation
> has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename is
> =C2=A0=C2=A0=C2=A0=C2=A0 lib-ts_bm-fix-integer-overflow-in-pattern-length=
-calculation.patch
>
> This patch will shortly appear at
> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git/=
akpm/25-new.git/tree/patches/lib-ts_bm-fix-integer-overflow-in-pattern-leng=
th-calculation.patch
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
> Subject: lib/ts_bm: fix integer overflow in pattern length calculation
> Date: Sun, 8 Mar 2026 20:20:27 +0000
>
> The ts_bm algorithm stores its good_shift[] table and pattern in a single
> allocation sized from the pattern length.=C2=A0 If the good_shift[] size
> calculation wraps, the resulting allocation can be too small and
> subsequent pattern copies can overflow it.
>
> Fix this by rejecting zero-length patterns and by using overflow helpers
> before calculating the combined allocation size.
>
> Link: https://lkml.kernel.org/r/20260308202028.2889285-1-objecting@object=
ing.org
> Signed-off-by: Josh Law <objecting@objecting.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> lib/ts_bm.c |=C2=A0=C2=A0 18 ++++++++++++++++--
> 1 file changed, 16 insertions(+), 2 deletions(-)
>
> --- a/lib/ts_bm.c~lib-ts_bm-fix-integer-overflow-in-pattern-length-calcul=
ation
> +++ a/lib/ts_bm.c
> @@ -163,8 +163,22 @@ static struct ts_config *bm_init(const v
> =C2=A0=C2=A0=C2=A0 struct ts_config *conf;
> =C2=A0=C2=A0=C2=A0 struct ts_bm *bm;
> =C2=A0=C2=A0=C2=A0 int i;
> -=C2=A0=C2=A0 unsigned int prefix_tbl_len =3D len * sizeof(unsigned int);
> -=C2=A0=C2=A0 size_t priv_size =3D sizeof(*bm) + len + prefix_tbl_len;
> +=C2=A0=C2=A0 unsigned int prefix_tbl_len;
> +=C2=A0=C2=A0 size_t priv_size;
> +
> +=C2=A0=C2=A0 /* Zero-length patterns would underflow bm_find()'s initial=
 shift. */
> +=C2=A0=C2=A0 if (unlikely(!len))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(-EINVAL);
> +
> +=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0 * bm->pattern is stored immediately after the good_sh=
ift[] table.
> +=C2=A0=C2=A0=C2=A0 * Reject lengths that would wrap while sizing either =
region.
> +=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0 if (unlikely(check_mul_overflow(len, sizeof(*bm->good_shift=
),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &prefix_tbl_len) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 check=
_add_overflow(sizeof(*bm), (size_t)len, &priv_size) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 check=
_add_overflow(priv_size, prefix_tbl_len, &priv_size)))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(-EINVAL);
>
> =C2=A0=C2=A0=C2=A0 conf =3D alloc_ts_config(priv_size, gfp_mask);
> =C2=A0=C2=A0=C2=A0 if (IS_ERR(conf))
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

Yay! thanks Andrew


V/R


(Your favourite reviewer totally)


Josh law
