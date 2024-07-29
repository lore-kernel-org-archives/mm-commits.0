Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4785515AAC1
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722263656; cv=none; b=ewOk/EJgEPEiEspH7aJujA0SSGPsjg0T/92ckbijAkCBt/Cz8pcdModIStdhcR4RGYtJpSNtatuzBKS810hovvKbnxoXO8N29Gxi0T6UtWoxDdq+68fl+yxBPS97qd7vGLiY05dcm2EYxclh/D6QyUR0KfCCwT8iGsMlZIdPDvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722263656; c=relaxed/simple;
	bh=veSlehZ9JRx1s9Uk9A+rqtHtyrgvzdbfqY0gqL9xnqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JfMMLmXwM4qooaGpDF2yOtcC+HN2KrdtATLa/OsJbhyL9aC3BvMLxsHMhki409iW+857WibKjzBWT/E9hsqSe2OvXsl7CkTSYhqSwJ8aOer5uCfaaW+Zb2WNQVeYfAEmTusFLz5TumAwBHHXgUPGq9AeXzylw0ovnvPSB+g17lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=qMyxDLVR; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="qMyxDLVR"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3685b9c8998so1300788f8f.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 07:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1722263651; x=1722868451; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wnLJpLzQZbBpgHoI2SjjDwM1HnelbXFiNCC30gWvnYM=;
        b=qMyxDLVRmWgcPeCloRD2FXf4dhsEaoTvp2jS5VHRVHbzqPctP8HDgrcvkkapQEI1fl
         ACe3fAXiSCAqS6vU7jof3HFp8N9tE9mg501fxES0z7p0AaT3DPhdW0WOTiq6loTYix1N
         LI4maMzwxAUExvosrbfvlJjDSddesptroMJOsvWNkKnDsQ5jjJW5DLtORgyWrUv6aewg
         61Whnj75VNoPiaxeuKKFoknvOPFe14AmNaoN+Z9FsbkDabWRWl2DSypBKZ3+sbRgQToT
         fSsXshFLT3ohfEB4DrPk9BGTTZQgVhJJ8TlpRmAeuimJbQdQSP05Td0G5J2AMI1pnf1y
         p77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722263651; x=1722868451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wnLJpLzQZbBpgHoI2SjjDwM1HnelbXFiNCC30gWvnYM=;
        b=xOvzpzqe6oHEgd8J/JnXpnU+pCz2SJq4gaZrA4hQzVvMEVoYop0s3KEomd7C1Y5eRk
         al2yZMwi1rcVAvCFH5OcS/x95ZADzTGWD3hKoum82+s1eVlMkhCZee1m4RBONXENAhC/
         98XJbg6l9gTAKFlcyIG1XbMDwfTV+Q3VdsRteRcmm6LzMgWWEp+QtoAkWgVnXWBAFljD
         D1RCSmGIeq7zeu9lOiX4cejPA/9WAu9LronLVKLcxmPpRtsBRc2T14ehNJjrZkWGFTgx
         LZmDOHT+dFBGBrVVqPlRTx7yjnSkhoFSMZYYXYMmp4M3UvfsRDjBcPLxGb0+UDzs0qIy
         LJMA==
X-Gm-Message-State: AOJu0YyL54yfmCvq6hqnhfszi96ocbGXzy/vnPeMDsalnH+tQgtYyGRE
	wdCVhfBSHHHvoo1E5kIu68ztN6oSsR56cQvegQfsaFeVP4MYlzyvUwhXes2qgHM=
X-Google-Smtp-Source: AGHT+IFzSGKI1UEPgWLIKI2LrAHnGvCfNK6qEnbbxjRiaTWB9rVJOtbIctxmEyLzTYWgd8HA95YZ2Q==
X-Received: by 2002:adf:e0c7:0:b0:368:41bd:149b with SMTP id ffacd0b85a97d-36b5cf1f81emr5434442f8f.34.1722263651404;
        Mon, 29 Jul 2024 07:34:11 -0700 (PDT)
Received: from localhost ([2a02:8071:b783:6940:59dd:510e:47d0:643f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b367c028bsm12330367f8f.24.2024.07.29.07.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 07:34:10 -0700 (PDT)
Date: Mon, 29 Jul 2024 16:34:08 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, biju.das.jz@bp.renesas.com, 
	npitre@baylibre.com
Subject: Re: + mul_u64_u64_div_u64-make-it-precise-always.patch added to
 mm-nonmm-unstable branch
Message-ID: <sgcnxxunli3rbzlf76aqf7rrtfczbtzya344lka2bms643pyxi@y6i3tj42zgis>
References: <20240708215551.35A6CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vx6njqbhmib6rmjf"
Content-Disposition: inline
In-Reply-To: <20240708215551.35A6CC116B1@smtp.kernel.org>


--vx6njqbhmib6rmjf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Andrew,

On Mon, Jul 08, 2024 at 02:55:50PM -0700, Andrew Morton wrote:
>=20
> The patch titled
>      Subject: mul_u64_u64_div_u64: make it precise always
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      mul_u64_u64_div_u64-make-it-precise-always.patch

this patch appeared in next-20240723 as
3cc8bf1a81efde105d8e57398cf8554b57768777. But it's not included in later
next snapshots and also didn't land in v6.11-rc1. What is your plan with
it?

I have some patches pending that rely on mul_u64_u64_div_u64 being
precise and want to add a variant that rounds up. So getting this "in"
would be great.

Best regards
Uwe

--vx6njqbhmib6rmjf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmanqFwACgkQj4D7WH0S
/k6dsAf+MIz2by/PdrwE01Sk0DVmCl+88Fhi8FtUW3u2D29vmDP0PwaubZuBEnjc
CfW95kB1JLFTuG8Ai5BQSgLwuEfFtNUbHyX3MqzgMzj5aqrSezod8UY4akMOCllb
6Jq6h5edlJKfqCbIgV6uAic1uRe4aWKrnRSwawnUJ9h+3eUNCmFIIA22O28UIdUE
GfgclcJdmMyUKog1xX1odZ9j/KAS85mkt8Ieoxr5yLGdpCIr5TyIxoHTj0/S9pW8
tbAuqaYiF8I9XMZ5EgHA4RsPnHBNKleOOw8pFDqJKrXHHLZJ+IIooRAL0LEPfZ/Q
h04IiQf8P6ncHbRAxEMCfqYA+4TXHw==
=Iwu7
-----END PGP SIGNATURE-----

--vx6njqbhmib6rmjf--
