Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D347302753
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 19:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772392959; cv=none; b=DqftOviFHap5paot3osdxG9dQQ4BVwnDUf6BXYmSgRi9LP8R45yna+Gxz0hLvkoc54wcgIpsRnDdiRviRc8WIFXPgdHvjh771fXjZ7RcnUNAEBS0sE576i3zO61p5dgDgAhPAGnY/c7cOApA+Wp8+ZZfIb+XJRhIT7GMSvDPNWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772392959; c=relaxed/simple;
	bh=rDOVb7oEwj5cG6+ZnxxtDH4m0snjN1VJIy+f8qvTFko=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=nBPIN5jTqAY4JbAzDHG1xGfxeFbalgac5iNSe6Xs2KUUebIKdUTTZAGITu/MU3X+caJJi1M7lSXuVrMP9mU+dSNLQt43ZhVuHyq5tRNThzu9GmILdAOcq+TpCjy+caFyzSY3uepJZotbi6f6u30/sAkpyrJV3+FrItfk1E96N6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=au0eGChm; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="au0eGChm"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4836f363ad2so44153785e9.1
        for <mm-commits@vger.kernel.org>; Sun, 01 Mar 2026 11:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772392956; x=1772997756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDOVb7oEwj5cG6+ZnxxtDH4m0snjN1VJIy+f8qvTFko=;
        b=au0eGChmh6tKHM4rtgyWOcTwhea+0hoOfUhG6/LBG90ZtfEGyiQuG7u1vYcPRCqdXN
         NCmjmfITAwpZmza5AHCTSTR/JBR8xDVUzwTnRMPrJBq8h3zrzqtulrCPdqALacCDl5TA
         DAbcaSwTu0eheeNpxNeTzqcXZ2nMzmT1TVqdcdFblajp/M0RvdIWoQCVqhutiRa9VJUk
         2f1J7xEi5TI7sxyuE8Q+Cx9I3ZsYb/Z+FXFOR+rEDIyHMu82/7UPON42oYRMphyDAdd0
         RezJOBhzkR9NMjhtD2fi/Spf52WuOaEo0we+1ttpKg+x7s6EYdqnUWcFVxG5gQFQtSdr
         5Yfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772392956; x=1772997756;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rDOVb7oEwj5cG6+ZnxxtDH4m0snjN1VJIy+f8qvTFko=;
        b=wSmkui+cBHGtlgiBNHJ9svUblVTBANVq2vndZNB+lzXeNwtTm9FhCjuxJJw3/57Yqm
         YTvnBstBAsX54NQYhIRQI0cr1PpfTZynVL6LkspQiRphJtRw4gvBACOkwRHcdzlABs18
         ze+Yo8Aezv+y2m7OStF4/6QmUetNeFHVsdPe4fKWN7Raw9Jrt9KEcVu5mGBXVdQTicwt
         C0KgliuIQugRLkFknKcZPDH0qiaXVPlNHJsOBnOjTw4g1oDeX8rZtX6+MK4oBukG2uRA
         vq6SUsk8Ea70/LGU4A9vsfmb2NP7oMjzdj0pmlaIqBThyjm6EWbI7zRdWUJdIGRsc3B0
         0E0A==
X-Gm-Message-State: AOJu0YzdmTs1GD4BuCzIxDZxEAY4wZ437kRVOLqo/btRHQWvNlr+j8qM
	d+4DDQHWnQ9THsoJfHhasCDjto4xJgOEBXismBiyrGB5D2gmNvbawxNLa3OwmCT5VY2hxA==
X-Gm-Gg: ATEYQzxYlzhJ+tKlulnyLdy2dtl0IZgPclXt17lNITSE37hLGOUD31dmCrKNW+f3NHb
	5bcdXFKU9J1Y8OOBk9E0IKOlEtdzfqNKlDLjlvQr0DKIG6iGTt63eO222/d3pmBaGhzDZOlJXlo
	jzUhUJ3gHfhJJzM5ZOWDgf/J+imq92nyxz0JugLiu5z0+ySejCfetgrIRkCFjfW3nzKP0zJMY6r
	U5mj2JKgHR/SANPVkta3+Jm/AUCiyxIio7NYuSaqJV1Ss0++Xy0Vc3Ys5QkR1utkV6LTI8d1mrB
	pBZz5AOCJPMO5q4SwfLkpZOM2VXbnRxYDCa3gKTHvOfjlVxN3kqZlU36ZxIqmF/AguHkGqEuiGB
	zhcGJw+Hg9ZqPSHGdp5BzVJmGroha09Kwq7Zo0wuLJ0MbqOR+A43TICaRgmA1/or0XUH6TfPxgv
	837M8pjNWnzs6NediK6gFKV3HXwwI=
X-Received: by 2002:a05:600c:c490:b0:480:20f1:7abd with SMTP id 5b1f17b1804b1-483c9c204b0mr167355445e9.31.1772392956304;
        Sun, 01 Mar 2026 11:22:36 -0800 (PST)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcb4f8bsm275937855e9.4.2026.03.01.11.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 11:22:36 -0800 (PST)
Date: Sun, 1 Mar 2026 19:22:35 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Message-ID: <4c42c4b7-5f1c-427b-bc4e-461d1c033f94@gmail.com>
In-Reply-To: <20260301192011.EA874C116C6@smtp.kernel.org>
References: <20260301192011.EA874C116C6@smtp.kernel.org>
Subject: Re: +
 lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch added to
 mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <4c42c4b7-5f1c-427b-bc4e-461d1c033f94@gmail.com>

Hello, Sorry for being annoying, but can you have a look at all of my other=
 patches? You will benefit from these patches, sorry I haven't ordered them=
 correctly, I usually use GitHub and this is new to me lol

V/R

1 Mar 2026 19:20:12 Andrew Morton <akpm@linux-foundation.org>:

>=20
> The patch titled
> =C2=A0=C2=A0=C2=A0=C2=A0 Subject: lib: glob: fix grammar and replace non-=
inclusive terminology
> has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename is
> =C2=A0=C2=A0=C2=A0=C2=A0 lib-glob-fix-grammar-and-replace-non-inclusive-t=
erminology.patch
>=20
> This patch will shortly appear at
> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git/=
akpm/25-new.git/tree/patches/lib-glob-fix-grammar-and-replace-non-inclusive=
-terminology.patch
>=20
> This patch will later appear in the mm-nonmm-unstable branch at
> =C2=A0=C2=A0=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>=20
> Before you just go and hit "reply", please:
> =C2=A0=C2=A0 a) Consider who else should be cc'ed
> =C2=A0=C2=A0 b) Prefer to cc a suitable mailing list as well
> =C2=A0=C2=A0 c) Ideally: find the original patch on the mailing list and =
do a
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reply-to-all to that, adding suitable addi=
tional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>=20
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
>=20
> ------------------------------------------------------
> From: Josh Law <hlcj1234567@gmail.com>
> Subject: lib: glob: fix grammar and replace non-inclusive terminology
> Date: Sun, 1 Mar 2026 15:45:53 +0000
>=20
> Fix a missing article ('a') in the comment describing the glob
> implementation, and replace 'blacklists' with 'denylists' to align with
> the kernel's inclusive terminology guidelines.
>=20
> Link: https://lkml.kernel.org/r/20260301154553.2592681-1-objecting@object=
ing.org
> Signed-off-by: Josh Law <objecting@objecting.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
> lib/glob.c |=C2=A0=C2=A0=C2=A0 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/lib/glob.c~lib-glob-fix-grammar-and-replace-non-inclusive-terminolo=
gy
> +++ a/lib/glob.c
> @@ -21,7 +21,7 @@ MODULE_LICENSE("Dual MIT/GPL");
> =C2=A0 * Pattern metacharacters are ?, *, [ and \.
> =C2=A0 * (And, inside character classes, !, - and ].)
> =C2=A0 *
> - * This is small and simple implementation intended for device blacklist=
s
> + * This is a small and simple implementation intended for device denylis=
ts
> =C2=A0 * where a string is matched against a number of patterns.=C2=A0 Th=
us, it
> =C2=A0 * does not preprocess the patterns.=C2=A0 It is non-recursive, and=
 run-time
> =C2=A0 * is at most quadratic: strlen(@str)*strlen(@pat).
> _
>=20
> Patches currently in -mm which might be from hlcj1234567@gmail.com are
>=20
> lib-glob-add-missing-spdx-license-identifier.patch
> lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
