Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A42841C0BD
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772820398; cv=none; b=Wj2FNmLcXGJvYIyODl3HAwK5jbPJyS1cv7wYWfNmD8OxoIqLbboY4dRWTAmeFpK2QagBVS4u5/Js1uKSU/61Jq7Kjk80Djli8i45xmuV2hLGLrDxo2o9KQWNk4BPry7tc5jQ+VvG2P3e0tUTLHqNP4FubZ1XH7msQ3WvaTyCTD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772820398; c=relaxed/simple;
	bh=iqmkc3D8cOnm9eFZk4Thm7JKWwh5UueNG1M/H6mzQ1w=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=LlecFRUtioKSGfz7zR0RgTfeAe5Ib9yZca+NF+0Q3O/yiGxDc+i0kR/NjWVO6Ncudisycf4567ciWNgjLZc9QT2iTXEBPn3OwKLHFTcEpya9pFCjo/A+H/MGcl2n3ezti9uuJpQHeTSj6XHg7DgtZ82oqfGe35sLHiyfQx/uXjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cdt/Thvb; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdt/Thvb"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b936331786dso1039667366b.3
        for <mm-commits@vger.kernel.org>; Fri, 06 Mar 2026 10:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772820395; x=1773425195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqmkc3D8cOnm9eFZk4Thm7JKWwh5UueNG1M/H6mzQ1w=;
        b=cdt/ThvbT44wWH9XBPMcV5GWozKSduKabCkd5B7/D8Ca4Lpzd54gpQ+/Tt0gBbQ7Lb
         jmejVfJMMZyEX+H3SCiP1r8V6MdXMADRpf21O52znovCFGJTvUEovAZGJMXFoj1iruLt
         59FFddR/KUDOydKflm0rTMywr7M4Wrxm2AH6T831BkSjfHSzAiiJQ4qGxs6RkdT9khT4
         VxMUqjwefxYbA4FP7dFyNt45Jz+sI7zPML3P2WGaqsa76m7Q62gLW/kg0iq84THTORnB
         cEK1dE8fSpk493fbnIHM1Kv1YaZvW/Ix4uQj6Ln2BpzYZuPeZsGpSZxYP+mbbhlB7itm
         q7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772820395; x=1773425195;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iqmkc3D8cOnm9eFZk4Thm7JKWwh5UueNG1M/H6mzQ1w=;
        b=c6BJ4zTfC56G2ZANt2ncksUkekLeiyqZDaBt2EOxpgFtmoo4VVjeVV4Fm6iR9Ux5dc
         w6JlM6JghYfjxVDtW+1m0E15wBt4mYKES3mBTw0UcomDDbqFy+JRoKp5JtkSJ5326Lac
         G1K/JGn6xexu5Svc7lIx4WG4GmKcDjUb+lovuCrdrotWmeumGDGxJiBmriLWMWsZS+51
         KkPdCuMnpxV34bSQ3nvkH8hvGOazGUcLizy8W8JH2FBRrkwUnFVvvVLhcMA1cpsXf0lk
         SByKH6zvqI3lhWkxoN2Kq33IeviWzS5vHfThdu7EP5Q2rmyDPJMn0DZyPugfUwIAF3J9
         cXFg==
X-Gm-Message-State: AOJu0Yxquc5WbNZImnZdts8CKATKJBoMTzpsmFo6JSfEwovB9ZTtG/Yf
	sIPbTodyasL/gAKuPInexVMg2Aqn3iymMCUCsAVhT91K8WTMVqapX1Zuca6FwqOnjv0=
X-Gm-Gg: ATEYQzwAMjiUTnlLlZ/7XuNWoPoCmQl6Jn49DfjAD67STX+uCHB9ciZWzKJQ5Ya4Zbn
	6Wru7WhGK85+CyJSJYZQBbkvUUXB6rLr3LOhRUql+kn+mjD+FlRL92kIgHiiHCuBYOpbl6keg0H
	HJWPiwbr2wMy5HHf4ci36oV4XxIvdCnNoSsSPCvf5cGfft7pQV/xQ62iLF+rUTNv1443gwpTjPG
	RpJKZWxC8+1BQorb5D/mv1VrWkjxXk/FbQL6IvJoF8cPRgBXye1/8tN+wI1qrxnRI3JGoNLvFGJ
	rOL6qf5HiurCxaUGiOiXLuSbqU+NhjLhBm3M8/eXOPjiMaYyll8WO9EBk1bX5Wrn1CIZNpITx0p
	yL3UpVFCtWLXL+RZrEqCl7EUX/ImfWq8rBZjLVTPmggNiWD/Tsg7MGgFyytIKcuEWNs4mvkCQna
	H4zRMKZMC2BJQHwl9b
X-Received: by 2002:a17:907:6e8a:b0:b73:4d06:bc8 with SMTP id a640c23a62f3a-b942e056010mr185541466b.53.1772820394453;
        Fri, 06 Mar 2026 10:06:34 -0800 (PST)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942ec2b4b5sm80178066b.0.2026.03.06.10.06.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 10:06:34 -0800 (PST)
Date: Fri, 6 Mar 2026 18:06:34 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org,
	andriy.shevchenko@linux.intel.com
Message-ID: <31179f43-6f3c-444e-ad40-cb2d3174d24b@gmail.com>
In-Reply-To: <20260306175637.1A903C4CEF7@smtp.kernel.org>
References: <20260306175637.1A903C4CEF7@smtp.kernel.org>
Subject: Re: + lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
 added to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <31179f43-6f3c-444e-ad40-cb2d3174d24b@gmail.com>

6 Mar 2026 17:56:37 Andrew Morton <akpm@linux-foundation.org>:

>
> The patch titled
> =C2=A0=C2=A0=C2=A0=C2=A0 Subject: lib/uuid: fix typo "reversion" to "revi=
sion" in comment
> has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename is
> =C2=A0=C2=A0=C2=A0=C2=A0 lib-uuid-fix-typo-reversion-to-revision-in-comme=
nt.patch
>
> This patch will shortly appear at
> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git/=
akpm/25-new.git/tree/patches/lib-uuid-fix-typo-reversion-to-revision-in-com=
ment.patch
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
> Subject: lib/uuid: fix typo "reversion" to "revision" in comment
> Date: Fri, 6 Mar 2026 16:12:50 +0000
>
> Fix a typo in __uuid_gen_common() where "reversion" (meaning to revert)
> was used instead of "revision" when describing the UUID variant field.
>
> Link: https://lkml.kernel.org/r/20260306161250.2811500-1-objecting@object=
ing.org
> Signed-off-by: Josh Law <objecting@objecting.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
> lib/uuid.c |=C2=A0=C2=A0=C2=A0 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/lib/uuid.c~lib-uuid-fix-typo-reversion-to-revision-in-comment
> +++ a/lib/uuid.c
> @@ -54,7 +54,7 @@ EXPORT_SYMBOL(generate_random_guid);
> static void __uuid_gen_common(__u8 b[16])
> {
> =C2=A0=C2=A0=C2=A0 get_random_bytes(b, 16);
> -=C2=A0=C2=A0 /* reversion 0b10 */
> +=C2=A0=C2=A0 /* revision 0b10 */
> =C2=A0=C2=A0=C2=A0 b[8] =3D (b[8] & 0x3F) | 0x80;
> }
>
> _
>
> Patches currently in -mm which might be from hlcj1234567@gmail.com are
>
> lib-glob-add-missing-spdx-license-identifier.patch
> lib-uuid-fix-typo-reversion-to-revision-in-comment.patch

Hello Andrew, I done loads of patches in lib/
Sorry I haven't grouped them, but they are quite useful
V/R
V/R
