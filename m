Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07B0258EFF
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773088510; cv=none; b=eLVLlai100fpfiZ/AAiFl9lbtaNU5/VmPvGYb3YPDwD19jIc1o8mci4Kd2BhL+PN/DGY2VQQcZRKMELxkiMLpgCpoNeguhHaMpa4nmzFaFRt0ega8aK38txsJiCGssOQsVlITPHFK1hjwweyHGdY4uAUTc0UUNwCp8koS0VnSV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773088510; c=relaxed/simple;
	bh=1IXWQuHyAAqrYkG295KJoPeXz93gGS8v+qjLKA52VF8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=ewOSWfKR6bLpjyTqBW15OdFE3JvDdHrCSpp9LStWtsUYKxTWenmUs7rh30GHYGtLWvfmxLpdeBeC3zmbwpxTEuYddpL6PnOfXqBEyc1KYZgMTwxelU76RiFNCTQlCfel5OKN9L2IZGQEknzI17Ygs9W4E1F7oE7NroCYBEA43yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H36akbOK; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H36akbOK"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-439b790af67so5046751f8f.0
        for <mm-commits@vger.kernel.org>; Mon, 09 Mar 2026 13:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773088507; x=1773693307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1IXWQuHyAAqrYkG295KJoPeXz93gGS8v+qjLKA52VF8=;
        b=H36akbOKttgykX1aVZSYg5LS+k95Kk3R98xd2Aw+831XzNImRS393yP/liEgNxh7oC
         JC5ghx0z4wIYcF5+sa3+uATR7DBxvo1k5vaXjzhKZwfpX4SWj/9IvOg9iDlyPZz/va2V
         9kxzmH7WzrO/71BrCDdFyXYGwEmxYMZaJamGSOUyN002InGy8lrdipeGNM0JEoX6VBjI
         uRSZ3AnRm8mPpz3Xd9e47nYp4fnEC52rfnlcUs8WFgULOgLJVkq0qm3sL5sgxRwIOpMM
         pTSwDXvcIXX06hTbKGSxis96BxAHdRte86Rovs/RfV70kma6tpEcw8A1dGqODMQTHJll
         p+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773088507; x=1773693307;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1IXWQuHyAAqrYkG295KJoPeXz93gGS8v+qjLKA52VF8=;
        b=XmFq2DlO2hyruQ1aMKSHDtc36g6Vwdvt7snMfKd3+gxm6xG6AmzQJB6QZYaOuPk92Q
         QIwiqkvLLmi35umQSR2CWOWPtGUBDB2o2bXt3VUC/eTne+1ammd3BqGm93qC7nVluqDu
         cxhYrBm0BCH75zjpRHtuurUnAZCPgVwlJEqR4JN2miL1dKcarL3T242F4yggcBEF7T7z
         yjZ+rFOPUGh9DmZYWld41sTJOvu/0JXcTQO2VmptTPYOCGLEUfIrcnhhUFHGIRT3Nj6i
         Ytmw93w0Wmo2BcA5kg6zC2awUjrs0IoZ2qqwmCk5bwGN3QNSdpKh5MseC+eDkJlGtSxM
         v2fA==
X-Gm-Message-State: AOJu0Yw09MSm4qUrZb4GfGJkMpiD/TOn3Dl6+nkR9OaWBGFeIMTB3TXe
	cUJSXVIDzj3g4OeRBbQ/figitX5YopZfoc9UKT08lYGtiN+/FnZulpfE
X-Gm-Gg: ATEYQzySh8mhWc+y20W3nhpQWL6u2dS9cchWMlyoirXOvdeT5S7shOcBu8UkH9Ud1NO
	3RCBOVA2LNY+yyFN9l5wxOmRzSwBLqX2NfQ76A1wGxGkJx8vJYHT+YBM3+9aMdn9o/VtkjN6olG
	P5WhoTSyBRW0RJapQ8cLFbp2tCWlQJcxcFIx6ATCU3hl0r/jd6BnMSbngHI4vGnkn0OjSOZTBx3
	QU/PVPD4eufX5llTdxg3WU07GT5Hvk9vWyQ955o1rqEoMRksnmxEurHSDyyJROIuQGfpgM+KVUg
	WF0oh+gTp/8Vqov73CD6oCiw1wo2ws8aqIRI/KnlMWAXceBXYyKJAPTKd9NGdkSCt8ni+dbseGL
	dmT3QG6jgDRCLBuMpkFNySvnXgUptsvmg88Oeb2jt+xOlowi2E2CSqyNCCTInuiIE36zZ2dRWhC
	1l2zjViy89RK33XGqm
X-Received: by 2002:a5d:5f82:0:b0:439:ddc0:4bef with SMTP id ffacd0b85a97d-439eff2fbd3mr1832560f8f.8.1773088506852;
        Mon, 09 Mar 2026 13:35:06 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae46353sm34177466f8f.33.2026.03.09.13.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 13:35:06 -0700 (PDT)
Date: Mon, 9 Mar 2026 20:35:07 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Message-ID: <2583e57b-fb3e-4e43-9d93-a3db4c816c11@gmail.com>
In-Reply-To: <20260309202433.1ED14C4CEF7@smtp.kernel.org>
References: <20260309202433.1ED14C4CEF7@smtp.kernel.org>
Subject: Re: +
 lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch added
 to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <2583e57b-fb3e-4e43-9d93-a3db4c816c11@gmail.com>

9 Mar 2026 20:24:36 Andrew Morton <akpm@linux-foundation.org>:

>
> The patch titled
> =C2=A0=C2=A0=C2=A0=C2=A0 Subject: lib/ts_kmp: fix integer overflow in pat=
tern length calculation
> has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename is
> =C2=A0=C2=A0=C2=A0=C2=A0 lib-ts_kmp-fix-integer-overflow-in-pattern-lengt=
h-calculation.patch
>
> This patch will shortly appear at
> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git/=
akpm/25-new.git/tree/patches/lib-ts_kmp-fix-integer-overflow-in-pattern-len=
gth-calculation.patch
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
> Subject: lib/ts_kmp: fix integer overflow in pattern length calculation
> Date: Sun, 8 Mar 2026 20:20:28 +0000
>
> The ts_kmp algorithm stores its prefix_tbl[] table and pattern in a singl=
e
> allocation sized from the pattern length.=C2=A0 If the prefix_tbl[] size
> calculation wraps, the resulting allocation can be too small and
> subsequent pattern copies can overflow it.
>
> Fix this by rejecting zero-length patterns and by using overflow helpers
> before calculating the combined allocation size.
>
> Link: https://lkml.kernel.org/r/20260308202028.2889285-2-objecting@object=
ing.org
> Signed-off-by: Josh Law <objecting@objecting.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> lib/ts_kmp.c |=C2=A0=C2=A0 18 ++++++++++++++++--
> 1 file changed, 16 insertions(+), 2 deletions(-)
>
> --- a/lib/ts_kmp.c~lib-ts_kmp-fix-integer-overflow-in-pattern-length-calc=
ulation
> +++ a/lib/ts_kmp.c
> @@ -94,8 +94,22 @@ static struct ts_config *kmp_init(const
> =C2=A0=C2=A0=C2=A0 struct ts_config *conf;
> =C2=A0=C2=A0=C2=A0 struct ts_kmp *kmp;
> =C2=A0=C2=A0=C2=A0 int i;
> -=C2=A0=C2=A0 unsigned int prefix_tbl_len =3D len * sizeof(unsigned int);
> -=C2=A0=C2=A0 size_t priv_size =3D sizeof(*kmp) + len + prefix_tbl_len;
> +=C2=A0=C2=A0 unsigned int prefix_tbl_len;
> +=C2=A0=C2=A0 size_t priv_size;
> +
> +=C2=A0=C2=A0 /* Zero-length patterns would make kmp_find() read beyond k=
mp->pattern. */
> +=C2=A0=C2=A0 if (unlikely(!len))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ERR_PTR(-EINVAL);
> +
> +=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0 * kmp->pattern is stored immediately after the prefix=
_tbl[] table.
> +=C2=A0=C2=A0=C2=A0 * Reject lengths that would wrap while sizing either =
region.
> +=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0 if (unlikely(check_mul_overflow(len, sizeof(*kmp->prefix_tb=
l),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &prefix_tbl_len) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 check=
_add_overflow(sizeof(*kmp), (size_t)len, &priv_size) ||
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

Do you think these patches require Cc: stable?
Idk the severity of the bug to you, the swapped arguments got Cc stable,=C2=
=A0 overflow could cause some screwy bugs


V/R



Josh Law
