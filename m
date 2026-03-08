Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47269218AB9
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 20:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773001579; cv=none; b=oaLqYYsUCFSOyiZqlNlVzA1Mw2cMXtmFTFl1zMNBCCbTVBexkP8ubrTm2dNC0qGzZFFiwrLpHo2qMleKhZzSU0apfvlGVUeC2+4b7DDIL/L8TdYP9urkCXo3ff9hiVS6wLWZCaEWaETvTjnmupbkWOmvvvdVVEnvC5iHMZL2jSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773001579; c=relaxed/simple;
	bh=Kz4QHbqBbAE4l1dplnqXyGi2Cvt19HicrOZaW07pezs=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=QngLmFORNwXrDiZIrH/FkW3r2baBYfBHo9bTkDcOUapLozbsBXWQCMHR3ZVtBvSHuv20L1IuGPk4JmT16wJrR5XdqSNv6y4jop51XJRO+QXs0rBqA6UVqNhb2P3RxOSSFowW/HjRZLhXGM6IOg1kB/Ce/3unYp0svXKdP/JkPrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gbigp18m; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gbigp18m"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439b78b638eso8044662f8f.2
        for <mm-commits@vger.kernel.org>; Sun, 08 Mar 2026 13:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773001577; x=1773606377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kz4QHbqBbAE4l1dplnqXyGi2Cvt19HicrOZaW07pezs=;
        b=gbigp18m+9N/4jd4qbO6zkfRO47dUL7UyA99JR8A+e0x1jhYWQDezv9ABIHy2nTASP
         I66bvc6e6AMtpQWw8Req6WW7QiLPm3HevnDuiFGipJBd8X6hHVaR9U53Y8p4VqIZj2T3
         /6XPGs40jen9hOnETpmGOU6DuvVV3R6lXnugTJulmHgA/gB1ZeUcB/Aj946JksYs3W5s
         CyAe0djYeFRZP5Qb2DiV8q8pPg02epZbGZSZ1sygej3lbuKsoViKYDD57EE6/0+rw7TP
         jQfD2JoL1nAvXBcnzOmTnpIy3WrxphG6SB1f1ZBsZI5yhpj7Gb/PcXryxZbZks6c+kyV
         uf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773001577; x=1773606377;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kz4QHbqBbAE4l1dplnqXyGi2Cvt19HicrOZaW07pezs=;
        b=bJ0R9b/SpDbYA7jZnVwBcA1ffhEnSlT5Jsjx0L6gaXXmZGMbytL97hpUsfFGhSYdG+
         o6cKzDqxLoHUHRgxqDDB6Squ0cZzUJ3eTdv4uHm2v1vA/zWzncYBVhiWPG8VV8qk+y71
         7H0NnBaYthabCiHk8R84IULpNyxtpHMD14hpR3tBXzNNiqkZq5UDA4AdcnZmXRB5KOxU
         JdJhFhVFmeC57D41cAvRkW3QKp47liTn2BheT0cok7UrWauOrAeAIYWXXMGFtvRsS7r3
         9cnv6opqLy/C5Pzha71Eat4W4lJRLQduh3zPJQz/xmwQ2+K6RnfqXqaAaR3cVt6fSels
         jmYQ==
X-Gm-Message-State: AOJu0Yy8ad6zg/YOTGsvLgkehksDPkJi4Wlx9U81fOL5gk8gGMhjSdKp
	Lp/hXUdN+My+IJS/U8MJpgtWI3k5iHlQTcRITO7FmmXvWlib/fVg46m7
X-Gm-Gg: ATEYQzxO/J4ud3Js06M3DimMvIErVLMPLuO4sbLMHb6YSbqWjUSwqnPVDTjfYeMh5Fq
	MP5fX2MvB4F+vocxF+PueOAmlxjCcfuOnaWHTDY/iQOgv2IX4tLXhVV8YF00HTD6qIRSvFE0MYt
	SYp0GXrKDCdxQau+P8ReDDLJgFC1D2yPzVL4lhuJ1nZB08E7FzA/J3VqYT4uxqtT7kzZ6yY/AdF
	VbUlvVp2a6xax3ChDfC7FjI5Db/9dpFEhtz910pusNXFEhELTtWZR74KrvVNPoswd6HCieEbjIy
	j7+tvGkE9STKv72vsdJAyoC2wYSUW1qH/Vz+tDnethorVL0Wl/Kmwj61+Lh8KXrdvq9rr0zOYYq
	WQ44K8Fv201NhbT9wygoztPUhV5UjAgDG1qip37Rs8VC+ePJGPQtF2oSW0ZkVTClSCZ3x34xUHK
	no7yYyykPNj0eb0e/5
X-Received: by 2002:a05:6000:604:b0:439:b715:6f4b with SMTP id ffacd0b85a97d-439da8a78d1mr16511094f8f.57.1773001576296;
        Sun, 08 Mar 2026 13:26:16 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dadac2a7sm20494787f8f.15.2026.03.08.13.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2026 13:26:16 -0700 (PDT)
Date: Sun, 8 Mar 2026 20:26:12 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Message-ID: <667b75ad-bce9-4997-8ebf-8077952c2797@gmail.com>
In-Reply-To: <20260308202425.C9EE4C116C6@smtp.kernel.org>
References: <20260308202425.C9EE4C116C6@smtp.kernel.org>
Subject: Re: + maintainers-add-josh-law-as-reviewer-for-library-code.patch
 added to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <667b75ad-bce9-4997-8ebf-8077952c2797@gmail.com>

8 Mar 2026 20:24:28 Andrew Morton <akpm@linux-foundation.org>:

>
> The patch titled
> =C2=A0=C2=A0=C2=A0=C2=A0 Subject: MAINTAINERS: add Josh Law as reviewer f=
or library code
> has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename is
> =C2=A0=C2=A0=C2=A0=C2=A0 maintainers-add-josh-law-as-reviewer-for-library=
-code.patch
>
> This patch will shortly appear at
> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git/=
akpm/25-new.git/tree/patches/maintainers-add-josh-law-as-reviewer-for-libra=
ry-code.patch
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
> Subject: MAINTAINERS: add Josh Law as reviewer for library code
> Date: Sat, 7 Mar 2026 22:21:54 +0000
>
> Add myself as a designated reviewer for the library code to help review
> incoming patches and improvements.
>
> Link: https://lkml.kernel.org/r/20260307222154.2848660-1-objecting@object=
ing.org
> Signed-off-by: Josh Law <objecting@objecting.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> MAINTAINERS |=C2=A0=C2=A0=C2=A0 1 +
> 1 file changed, 1 insertion(+)
>
> --- a/MAINTAINERS~maintainers-add-josh-law-as-reviewer-for-library-code
> +++ a/MAINTAINERS
> @@ -14616,6 +14616,7 @@ F:=C2=A0 tools/testing/nvdimm/
>
> LIBRARY CODE
> M: Andrew Morton <akpm@linux-foundation.org>
> +R: Josh Law <objecting@objecting.org>
> L: linux-kernel@vger.kernel.org
> S: Supported
> T: git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm=
-unstable
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

Thanks man, I'm honoured to be reviewer
