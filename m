Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAF833ADA3
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772821818; cv=none; b=tKHH+Z2TO0XPN58ceTQMIkc5Q5OceIP9pvu06Eeyd4T6qjYa/HDfdyoWIr22Sp7Yzxv3ubEfnRzVBsVWiYZVF6lh2qW9AiL9YNZyHR/crFpCYLIwd+vllXJAadG8H0gH5MY/ldbZ2UqjtFslL+2lwcpXYU6VkZvcCtlgf5aDdBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772821818; c=relaxed/simple;
	bh=u2O66pNvE+v9eOTZO8xaMDCjds3EFIobm3ARp/25D68=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=DFRtH1Cdl4Rvxo7YsOxCKJtWDtGouT3qMvO+0yEXMLaddKh3ZXIOV/Bi7RG3dmzH7yZWgcjJTlQVmR81xaxRiw+Re69zd+jpclYKXfD3S6vX2gGroAmqWxZvjIQYMg7jbPyovbdFrLyCwdOPsjLnHbx7d6Q1o5uG0uTfw4rlCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jpK/Avc7; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpK/Avc7"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4836e3288cdso64918285e9.0
        for <mm-commits@vger.kernel.org>; Fri, 06 Mar 2026 10:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772821815; x=1773426615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2O66pNvE+v9eOTZO8xaMDCjds3EFIobm3ARp/25D68=;
        b=jpK/Avc7UmqkobDzogl3/DWVHnwL4wrpkJA89T6fY5fxQyqu+m6x0I2udbZ/JFie43
         NCHeU6CNEVPWp7M7NlvotiWbxr6d11QxPOerOVDDBYyRpD2HQhrvyjhP31xLUT+IIOKl
         cV29gkAvkjoQzbuTO34VtPBqcrhBwwr63xtbdzYfp+irBK3XVYjq0T682PC/ufqPDHx4
         a1nYUs/SwGBWxDZZs1urKD9TcD9Uret1F0bvs0vWT/biz7x2VCksjH0tK4QGix5D1JHL
         55xYYgE5fVQpTiM6qddVPHEmq5fNqxz7Kl/zWGFVi150DVf64o1EUwT+73PPYGrvYBhd
         RrkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772821815; x=1773426615;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u2O66pNvE+v9eOTZO8xaMDCjds3EFIobm3ARp/25D68=;
        b=kAiWXJPvUsAsYENWAdn3X6xKFPsx/hQMunO9xuMK48LJBuRDg1gwK5cvcbmeE9v+qS
         6mIVST3or4lY6yCBlO1N2n44q8hGsr0vIvFEsAaKfAp4rg4ZbFLbPCcBlfnXWHtA6j/n
         oxXJAjAF0bcP1+fXzGJ2uRkPyDkMO7X8CsnAYXG/ISnXUrWS26hE8KYghmUwcSD8h6dW
         ebcPHa01PG+41jW2FuVzmPes9RCRk26uN204PGDnlCoWw1tMI0H634ONXvY1iaEbxsmM
         h2XWD2vOb7vhADSqENiPmI4FcFawnubR0XV+Q7Ohbt11rs4BcdqBfHp8ZWt1mK1tnqVl
         P/og==
X-Gm-Message-State: AOJu0Ywbwqt5gGq3ODo1Dc3RAiQU2p9y6Cc19yTJhsPN594Iwwzcr1GR
	wtPdciv+3voWAhhzL7Qf0kKg7JtZdBVgRWI8XdBj8IAFV1tIB8W+hFDJ
X-Gm-Gg: ATEYQzz0zzsaeyRfDsGcwdzMs9LdKz6yCqSfSHqvFSilnLr08zyblgGrNmZwMrALbbB
	xCryggM7BDWlujtE6cf+NVq5W2sOxuk/v0HpNUrYOW16x/lHmf3q/9R8Ss/5kfX8qSiU6b4aBv6
	43O/dt2Qq9sW+E/quKSXziCPI7KEZDGiDkLxNMTquYB+WL9HekObOWAt0obKgX27OwvPiQWXNxI
	qrqVR/y3U7lj7OjlVDUhTOS+QHEmzXweOv3UzqFi4e4eSkLILJhJVXe+xIXDntFFzJ+2TmfEHKV
	AQDykynijtEz0MjlSKq2cZGbCkeW2Ud7npMh9sv7UgMCUcQf5kE+tsLGjxWTUoZrfLQggEVm7S2
	zoi3njFC2qn5U8VhkLoMp6ID/vadM3sgpR4h0XsxUCkzYmG3Hm+5hqV8jDbNEPKByKC/lAdBkHR
	JJ+QpAgrrPbbbAoDxZ
X-Received: by 2002:a05:600c:198a:b0:483:a352:b4e4 with SMTP id 5b1f17b1804b1-4852671c9b1mr50156595e9.6.1772821814929;
        Fri, 06 Mar 2026 10:30:14 -0800 (PST)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485276bc6bbsm49809595e9.15.2026.03.06.10.30.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 10:30:14 -0800 (PST)
Date: Fri, 6 Mar 2026 18:30:15 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Message-ID: <b008ddd7-4a7e-4b8f-8e64-ef73687bc403@gmail.com>
In-Reply-To: <20260306182842.814D1C4CEF7@smtp.kernel.org>
References: <20260306182842.814D1C4CEF7@smtp.kernel.org>
Subject: Re: + lib-bug-remove-unnecessary-variable-initializations.patch
 added to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <b008ddd7-4a7e-4b8f-8e64-ef73687bc403@gmail.com>

6 Mar 2026 18:28:43 Andrew Morton <akpm@linux-foundation.org>:

>
> The patch titled
> =C2=A0=C2=A0=C2=A0=C2=A0 Subject: lib/bug: remove unnecessary variable in=
itializations
> has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename is
> =C2=A0=C2=A0=C2=A0=C2=A0 lib-bug-remove-unnecessary-variable-initializati=
ons.patch
>
> This patch will shortly appear at
> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git/=
akpm/25-new.git/tree/patches/lib-bug-remove-unnecessary-variable-initializa=
tions.patch
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
> Subject: lib/bug: remove unnecessary variable initializations
> Date: Fri, 6 Mar 2026 16:24:18 +0000
>
> Remove the unnecessary initialization of 'rcu' to false in
> report_bug_entry() and report_bug(), as it is assigned by warn_rcu_enter(=
)
> before its first use.
>
> Link: https://lkml.kernel.org/r/20260306162418.2815979-1-objecting@object=
ing.org
> Signed-off-by: Josh Law <objecting@objecting.org>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> lib/bug.c |=C2=A0=C2=A0=C2=A0 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/lib/bug.c~lib-bug-remove-unnecessary-variable-initializations
> +++ a/lib/bug.c
> @@ -263,7 +263,7 @@ static enum bug_trap_type __report_bug(s
> enum bug_trap_type report_bug_entry(struct bug_entry *bug, struct pt_regs=
 *regs)
> {
> =C2=A0=C2=A0=C2=A0 enum bug_trap_type ret;
> -=C2=A0=C2=A0 bool rcu =3D false;
> +=C2=A0=C2=A0 bool rcu;
>
> =C2=A0=C2=A0=C2=A0 rcu =3D warn_rcu_enter();
> =C2=A0=C2=A0=C2=A0 ret =3D __report_bug(bug, bug_addr(bug), regs);
> @@ -275,7 +275,7 @@ enum bug_trap_type report_bug_entry(stru
> enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs=
)
> {
> =C2=A0=C2=A0=C2=A0 enum bug_trap_type ret;
> -=C2=A0=C2=A0 bool rcu =3D false;
> +=C2=A0=C2=A0 bool rcu;
>
> =C2=A0=C2=A0=C2=A0 rcu =3D warn_rcu_enter();
> =C2=A0=C2=A0=C2=A0 ret =3D __report_bug(NULL, bugaddr, regs);
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
> lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
> lib-bug-remove-unnecessary-variable-initializations.patch

Wow! You merged them all
Thank you very much

V/R


Josh law
