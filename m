Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D156BB5B;
	Thu, 24 Jul 2025 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753364845; cv=none; b=aKSe4H38vCUczlP6Qfv0zX3OaqPcU6mgJQ7TtcvphHfBwlo1ZYHnaVGhTkxlAURFk3hMet92pTwp7PBoNUf4RsCTV1u1loTn5DI06tuj9zZri2ZGqpnCz6/Nm7a7K8ODQcQlP7ZsS5D1EdBc8btKR28Q+XPwH/FxjzfLaz8DaRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753364845; c=relaxed/simple;
	bh=2kdZ4xvUYXwlOleN9a/KN6UiK3wSYlarxxKPxFl/eFc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TddJYt3J7AXLwDMwcnVN4UdWqryDy6xIlz1cIPSNN9YlVkIZ4hvuk+4Up+LMe9fqSZg0edRgduQgm0kQjBvB4UskxMtxTtX9u+4206fR5VNGa5CjVR6gBKQuN4/4ilonABzflXmv/Bz5IEZd5mllbF4Vot7bbseYZ3fMm8AjdjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=bgKWeb14; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="bgKWeb14"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1753364660;
	bh=Wyb3wp6qFEX/SdEeQNb+HyojfhrBOwJWLpGcOwCl/BE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bgKWeb14NXrC8IjsZdHw3Wra65z2AAsBaaK0hwmMo1krznGejfEj+0/HCuB4ODZ4t
	 HebyBOsEr/m8WSXKT0AQa7ZJwAJfXSM9onHB3X8U9R4TZO566g2NARgeRVeR7Pail3
	 /4conJbtaBvwpC9T75aovj2iVjby5Psy3NIMDtyUWHlD2AXPpiPECI4oaqzKITSf85
	 g78rw/PgnSxvLTmB8ityt4Chm/Wvnxr5fDagVhrSV54hvagATTrL06vMcHSVDHlXo1
	 yKoAEPPHITGb5Zew//Qyh8pTkO+s3ICItEreX80akhMvNUXKNod99jwOXkj0FJfQ7b
	 LjCUDnwb30uDQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4bnsg44GQrz4x11;
	Thu, 24 Jul 2025 23:44:16 +1000 (AEST)
Date: Thu, 24 Jul 2025 23:46:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 stable@vger.kernel.org, senozhatsky@chromium.org, rostedt@goodmis.org,
 pmladek@suse.com, linux@rasmusvillemoes.dk, herbert@gondor.apana.org.au
Subject: Re: + sprintfh-requires-stdargh.patch added to mm-hotfixes-unstable
 branch
Message-ID: <20250724234547.737912c1@canb.auug.org.au>
In-Reply-To: <aIIcGulQp7MOsYtP@smile.fi.intel.com>
References: <20250721211353.41334C4CEED@smtp.kernel.org>
	<aID_3hHxWXd1LC5F@smile.fi.intel.com>
	<20250724084012.5d7bbc47@canb.auug.org.au>
	<aIIcGulQp7MOsYtP@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aMLhU40Npbud8+Di1qBqoOL";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/aMLhU40Npbud8+Di1qBqoOL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Thu, 24 Jul 2025 14:42:18 +0300 Andy Shevchenko <andriy.shevchenko@linux=
.intel.com> wrote:
>
> > > >  #include <linux/compiler_attributes.h>
> > > >  #include <linux/types.h>
> > > > +#include <linux/stdarg.h>   =20
> > >=20
> > > Can we prevent the ordering? =20
> >=20
> > I am not sure what you mean by this.  Do you want alphabetical, reverse
> > christmas tree, or something else?  Or are you concerned with something
> > completely different? =20
>=20
> Alphabetical
>=20
> #include <linux/compiler_attributes.h>
> #include <linux/stdarg.h> =20
> #include <linux/types.h>

I have no strong opinion, so fine by me.

--=20
Cheers,
Stephen Rothwell

--Sig_/aMLhU40Npbud8+Di1qBqoOL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmiCOVMACgkQAVBC80lX
0GwonQf9EHmHJ7tpYBFmwqQVKPGqnctEg41METeKXPZSiZsXEIngKsd2gjv7pPVs
qNwY/sDMq1HJ/ErsozcEUv8/w5ukuz12uNVEp/sioLx7V6G7nW5iBf4i4cYpaWU4
LdRSFVh28VYIsD1neGf8AG2Orvoqkyvjs3QATk2xcqMYHasU/Ur3oAruXzxsjYvW
lkrCNLwBotiM8VUYU9tKPpmdZDY0cmhgLW2jSH83v++0KbYtm3Nl233XztFERFZS
9rTQuFrldw1gNHCfCYUmFr1o8lbtOvLUqelXBWwg9eUjZ7FXmhWxzNyw7aadX2YQ
Er0MN2iDHbLVHrRkdJuPcCZDnMvAxg==
=VWYK
-----END PGP SIGNATURE-----

--Sig_/aMLhU40Npbud8+Di1qBqoOL--
