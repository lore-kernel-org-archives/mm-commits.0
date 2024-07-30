Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7FD524C
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 06:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722321568; cv=none; b=qwTjbWLp646E2UDEi9OVJY++aH3HIXCD1AdpMN1ISZ19UsDUB5SeLd0qNA5zRs8hd4H1kvKgEk0ou135LkAujbg5RUHFbNFt3y938mRymQiuWf0kPmkoyMIw99fqGiHfYbv9z6Ztr+bvzT61jaChDcL5qlwVcAuedxAvt4H9mQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722321568; c=relaxed/simple;
	bh=mhFUYmJyszzULgQtrAQFOAHb6wfJc/4RXMX4Xxncwa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tspU/iTI7+Epldif8tH66Ya0QXhB1fB4d5Z4GCtZNXl5fOFhGmvJ/phOwzJU7cmsQffF8giA9+38wwff6UjHRBb9XWImuQerQygctwdGNhoisyaiq4hD0vUp6SuNf6Uqpp4J3HnlO97X2mbBQW5p3QY2URq3xazCNAD+7MwH424=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=w40iyMLc; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="w40iyMLc"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5a10835487fso6438306a12.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 23:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1722321562; x=1722926362; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gaJNX04eT32WkrGD4l/JvmKfPw5BxkHMWleAIMMb1+g=;
        b=w40iyMLchhR+utt8Es30bTI80jYSXI4FdgkHFCbXBQhm7A0vgUz8hzHZJ3QzT/0A6f
         j0EqAp2lBW6xUFg/oe3RGk9Swwoz6G4Aanoy6mH0O35847pDSw/wi16h0Vo1HU8zT1yR
         +6sWltMvUyuDnrZDVAjFlbuJn406R3JRONrAWT+vdjjbKnJrRThlJFof0aElVkYVmTkj
         nSb8+7m0aUxglGeKrKUqFc+RrKMiWNBUY+1ZfZzsBLAUO4u9CXqz1M+ews7ikAE4+gkJ
         qqEEyI2CDPI+m1a0ywDNXuf+7riMFxlO2nTAv0Z/cP2WW0ackStTimhLJ/hXcP0/8WJU
         pClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722321562; x=1722926362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaJNX04eT32WkrGD4l/JvmKfPw5BxkHMWleAIMMb1+g=;
        b=m6TTyOmlbAx1BIMFwYXQVXEvEdPIA2RvQ9u87r8r77rx16ryzIPOqVHn0/8SYIYHjl
         4PWqbBoVDa1WUfzg4opyGF27AeJCmmFIzu9+kxIYOd5Ht3Lb+fuC8XJ75a3AWQlTSLr6
         IsbcIsLE1jK+k9+6ejx7FSk+GPom4Ch5Ful1SqskvWti+QSHOlKAzc3EAFql7QFY3sWv
         zJJni3N4GmSxAO/fmAkl9NJmfHXle/O/PBQ8AKzHA2vVcr6mWYwwPwIlogHpysgo42QP
         zsYuALnxLDZARgti3ftGbQpoBOBRqetqzAUQZY5lKRBZsEQgjGw9/oF52HgaKLQ2Lef9
         L3fQ==
X-Gm-Message-State: AOJu0YwR5qebi2pmmof34xNOLFESzk8j6VcWcu6FkCXLn47f0TE4ha16
	yyVngPMdm8gV8S4XaeWGMFShntyl99bk7mRkTIiW/DUyAdNXjzDLumaCNDi7LHEGqk/sj26YXsr
	i
X-Google-Smtp-Source: AGHT+IEgwbzKqtJI+7jq579zXgzLQhiPY8G+ZqRguWvJixe0ZLSSUr0RYNQrZyRHVfp4DzpI89GviQ==
X-Received: by 2002:a50:f603:0:b0:5a3:d140:1a52 with SMTP id 4fb4d7f45d1cf-5b020101f48mr6882939a12.3.1722321561672;
        Mon, 29 Jul 2024 23:39:21 -0700 (PDT)
Received: from localhost (p50915eb1.dip0.t-ipconnect.de. [80.145.94.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac6377d005sm6728499a12.38.2024.07.29.23.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 23:39:21 -0700 (PDT)
Date: Tue, 30 Jul 2024 08:39:19 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, biju.das.jz@bp.renesas.com, 
	npitre@baylibre.com
Subject: Re: + mul_u64_u64_div_u64-make-it-precise-always.patch added to
 mm-nonmm-unstable branch
Message-ID: <4o4mgystlj72dh6pmtuajeagvb5g6uxivyfmmn3f4tzf2gnw5y@r4rvlbf7bohx>
References: <20240708215551.35A6CC116B1@smtp.kernel.org>
 <sgcnxxunli3rbzlf76aqf7rrtfczbtzya344lka2bms643pyxi@y6i3tj42zgis>
 <20240729133106.07068e6e3843611e1b126c88@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="citzmpzij3otyhd6"
Content-Disposition: inline
In-Reply-To: <20240729133106.07068e6e3843611e1b126c88@linux-foundation.org>


--citzmpzij3otyhd6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Andrew,

On Mon, Jul 29, 2024 at 01:31:06PM -0700, Andrew Morton wrote:
> On Mon, 29 Jul 2024 16:34:08 +0200 Uwe Kleine-K=F6nig <u.kleine-koenig@ba=
ylibre.com> wrote:
> > On Mon, Jul 08, 2024 at 02:55:50PM -0700, Andrew Morton wrote:
> > >=20
> > > The patch titled
> > >      Subject: mul_u64_u64_div_u64: make it precise always
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      mul_u64_u64_div_u64-make-it-precise-always.patch
> >=20
> > this patch appeared in next-20240723 as
> > 3cc8bf1a81efde105d8e57398cf8554b57768777. But it's not included in later
> > next snapshots and also didn't land in v6.11-rc1.
>=20
> All of mm.git has been excluded from -next for a few days, as it
> contains rather a lot of 6.12 material.
>=20
> > I have some patches pending that rely on mul_u64_u64_div_u64 being
> > precise and want to add a variant that rounds up. So getting this "in"
> > would be great.
>=20
> It was a bit late for -rc1.  I plan to add it to 6.11-rcX soon via
> mm.git's hotfixes branches.  Please send along a more complete
> description of your need for more precision so I can add that to the
> changelog to further justify a post-rc1 merge.

My personal interest is to get the calculations in pwm drivers right.
This function is used in several drivers below drivers/pwm/ . With the
errors in mul_u64_u64_div_u64(), pwm consumers might not get the
settings they request. Although I have to admit that I'm not aware it
breaks real use cases (because typically the periods used are too short
to make the involved multiplications overflow), but I pretty sure am not
aware of all usages and it breaks testing.

Another justification is commits like
https://git.kernel.org/tip/77baa5bafcbe1b2a15ef9c37232c21279c95481c,
where people start to work around the precision shortcomings of
mul_u64_u64_div_u64().

Best regards
Uwe

--citzmpzij3otyhd6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmaoipQACgkQj4D7WH0S
/k7uhAf/XpCYDYiRp4T7dIoZ3OlBaE5NzC6tXdCH1eFtSVLBSc01VPQFN+Nz06Ni
7uVA8sjNUYUZDjs501mdLaj54sYbMzQLaWqE5beVSO1X8Dzd7E3gyH0t+vNE7iWe
D46V6/kSj9NSjwIinusfx1QP2Xjtoum380YJAdwiuo1DTFMpw+B+LIL86Y+OiXpS
6xcNYRhKty6f9LxppOKrb5ExT2MBIIULDxaHeRclBiT/QHXwJZuNw5hGmXNz5zzo
+ucv9cNLfsF6SZTWJdGkAD2jBZGTNeNpxFtJDdTuQqLJ5K8lXcxASlvDP9fr91K3
HYMNexCWZwHfWyPPIdLeSTTRXk/olw==
=7bG0
-----END PGP SIGNATURE-----

--citzmpzij3otyhd6--
