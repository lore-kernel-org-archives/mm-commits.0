Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3CD3F23B7
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772821490; cv=none; b=SP2mewa+2cYESZLZlvI9chcU8u5RdZm+CjO017rS+DUR1b+BTKnIpDLMGUE9zfh8WOkyXrudNyYz1xF3jRyQalyVgqu2SIqcGSPOAJwpoV2k7BZm8Y8E/3FcBJchyqa9Q5u602Hle3wJPaFqSMxQfS4LQZdCNZ7q9M1oTOuyIps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772821490; c=relaxed/simple;
	bh=Tgnblyk0pK/fdywoh8brY0jN1jWEsvcaPYzaAKWew54=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=Jrn7U6ldF85nKPb2gnZmUsU7j5bIgI82R4e+Ni7DGBvUgBD9G1KAJhVVblHm+W06oimStbOmeSAI1HSvVXcZb3OtkPOdMtolUZCaPbUJOVaUwOzMPk3ytZ47JdMh0+hIFQV5mhjC+Rh0yet4XzKhVorw3XDY/LUF9bMZARUwGDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nRkTPfk4; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRkTPfk4"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso104221525e9.0
        for <mm-commits@vger.kernel.org>; Fri, 06 Mar 2026 10:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772821488; x=1773426288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tgnblyk0pK/fdywoh8brY0jN1jWEsvcaPYzaAKWew54=;
        b=nRkTPfk4tcMr9Yf3iqN0SKh1mlRnSwANsoPEqY7aqCHR2XpGhfLIYggIpgQ+4Le1xh
         UNS3sN3ilRrst4n6ktF8s5OQa39BYKldB8i/77ePTZAB/3kBxqeZBCFN6IWwgE5dd7pR
         FSdP70cbJf1miX6ABAmm4Ft2NUvFPeWaqVzuLpt1sqyIy+LB23z0XdOGIaKqPhxuoY4j
         MKaRm0B3R6zznVPWrXf4X3b1FtNpjUQRkHFLHul1xqVj/B5ySsqecBWAcjHp6P3KrNn7
         p9VtWX8lyLJmJu/xzbNt0Wv9gYegh+yALMIRN1tG0Ang0OhYiJb0zTdLCjAdtrBeR65K
         ScaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772821488; x=1773426288;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tgnblyk0pK/fdywoh8brY0jN1jWEsvcaPYzaAKWew54=;
        b=XdStJfutB8YsZXaBFa7PX93RNSbMya78rzpW1Hq8eiYNbxRA4iZkOI6GWfG7xQUYyu
         5xbEhdQu+dbX8X87IVxaSwjB1yRG5eNwlV5RhAKk63MAHq7EdRPMOi3qxR79OhHQduOb
         O5Cg1DeKOFZiY8AZVZniOodYZpjsnrFlcoxsHYHVgEVIm2L3DRzKM3ugJBH3I1PAsuFm
         yMzayIQQA6E3rUIOITew8e2jBeyi0UGHHQHoeqr+EA4Csp5v+lKv7WRtHoJRIoWVdwu9
         dGCgDXfoV7N/NneGyxn8Z5/lImMj3g0x4ZUrUiQWNACWaY2TbvWsps78/FKVy+tBgEUW
         3G/A==
X-Gm-Message-State: AOJu0YyyhMun1y6dd6RQDFijcn/kmluRDSZTHkMApVzJN6cw5UZRJ+ID
	9gnWteOIJYp29FfUzqS7jdcvuOBl7/FBeTKp3MA77S/uvJu6wpHvlR/J0q6PZWoHf1I=
X-Gm-Gg: ATEYQzwqLodQa6N/mMAQ7VT+VdDR3CTalYhrqpFEVfRC2Pz0lrrVahEZu11K3tWK3wd
	DgWKsGdGKm+hQ5vq1CC8itQ5vI2BRaa2+m9ukDkG9kISiEJdol2yJXI/vrW9xmFSLoPACK7olfQ
	0NMxuAVhLZvxGu7hFzoi/LIJNaELq8RY8VtJz6qOAjzijAsOB1z6ln3RpIOav7bE6UP6PFVkKzb
	2mxzcxrYlBscD1fkZPIFNkaXCSzLDS/KS/k3IkV0MzoiUriLZR0FM+haK2E2zvtUuOFyz3/Ao/N
	snLHpbZyOhCEMxWHOuD/lOmuFVarT9zr6oYDs51bL0id8UQKVzG/JlSU+lGaLpHQwvAVy+kCZpt
	d5gADIEIPsTGp1tc8V8JkeMw1OIRz0MS6VDGy0uf/kuVmNFxqG7GiQuz1KFQ7HRtnX9Agy8WXz2
	msvMvpKduXy4kMjL22
X-Received: by 2002:a05:600c:3b0c:b0:483:ad56:8d16 with SMTP id 5b1f17b1804b1-48526918944mr51536245e9.6.1772821487511;
        Fri, 06 Mar 2026 10:24:47 -0800 (PST)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48527686bcesm78098765e9.7.2026.03.06.10.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 10:24:47 -0800 (PST)
Date: Fri, 6 Mar 2026 18:24:47 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Message-ID: <e482cb23-ba2c-4958-851a-7054e899f6b4@gmail.com>
In-Reply-To: <20260306180808.D1462C4CEF7@smtp.kernel.org>
References: <20260306180808.D1462C4CEF7@smtp.kernel.org>
Subject: Re: +
 lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch added to
 mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <e482cb23-ba2c-4958-851a-7054e899f6b4@gmail.com>

6 Mar 2026 18:08:09 Andrew Morton <akpm@linux-foundation.org>:

>
> The patch titled
> =C2=A0=C2=A0=C2=A0=C2=A0 Subject: lib/inflate: fix typo "This results" to=
 "The results" in comment
> has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename is
> =C2=A0=C2=A0=C2=A0=C2=A0 lib-inflate-fix-typo-this-results-to-the-results=
-in-comment.patch
>
> This patch will shortly appear at
> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git/=
akpm/25-new.git/tree/patches/lib-inflate-fix-typo-this-results-to-the-resul=
ts-in-comment.patch
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
> From: Josh Law <hlcj1234567@gmail.com>
> Subject: lib/inflate: fix typo "This results" to "The results" in comment
> Date: Fri, 6 Mar 2026 16:17:32 +0000
>
> Fix "This results of this trade" to "The results of this trade" in the
> comment describing the lbits and dbits tuning parameters.
>
> Link: https://lkml.kernel.org/r/20260306161732.2812132-1-objecting@object=
ing.org
> Signed-off-by: Josh Law <objecting@objecting.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> lib/inflate.c |=C2=A0=C2=A0=C2=A0 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/lib/inflate.c~lib-inflate-fix-typo-this-results-to-the-results-in-c=
omment
> +++ a/lib/inflate.c
> @@ -286,7 +286,7 @@ static void free(void *where)
> =C2=A0=C2=A0=C2=A0 the longer codes.=C2=A0 The time it costs to decode th=
e longer codes is
> =C2=A0=C2=A0=C2=A0 then traded against the time it takes to make longer t=
ables.
>
> -=C2=A0=C2=A0 This results of this trade are in the variables lbits and d=
bits
> +=C2=A0=C2=A0 The results of this trade are in the variables lbits and db=
its
> =C2=A0=C2=A0=C2=A0 below.=C2=A0 lbits is the number of bits the first lev=
el table for literal/
> =C2=A0=C2=A0=C2=A0 length codes can decode in one step, and dbits is the =
same thing for
> =C2=A0=C2=A0=C2=A0 the distance codes.=C2=A0 Subsequent tables are also l=
ess than or equal to
> _
>
> Patches currently in -mm which might be from hlcj1234567@gmail.com are
>
> lib-glob-add-missing-spdx-license-identifier.patch
> lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
> lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.pat=
ch
> lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.p=
atch
> lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
> lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch

I also made a couple for bug.c
They make the code run a tad faster

V/R
