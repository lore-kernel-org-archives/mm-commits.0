Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3A62F1FD2
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 19:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761160140; cv=none; b=J0o6ECKlUpu5n3Y1c1U8O9Y+ZO6FaUcmiGkORJZIMHgVxKmbxXoSa2lLheycuooLO20wAZLKDhJpJmU2T4BcDD/sEIMl73zB6sjun1XTg8hQMU+3j+CVDJxNXSjafHVZbMFXuwQNQUEGHGeugmLjzx+j3enoOs6mYNsEavo8zYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761160140; c=relaxed/simple;
	bh=Ye3xFcwl/aY1Tx2tAabx3/0+C8DqLaOj8/HUZA4xSDU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PH7UISn654/MXy++936IUo5JXkyHdRXjSNnSvUMvZcpOb17l/5Aeil9ZnZwkoIJUNwBQWqWq97CemtTwYcjki3csMEn1iMKIpnCbEgWg3lkR8ic7CdGSMC2onEtO//vniTJ/znlRBXIBuAP2WkAy5iSWwo76lkXsIWRS45lLsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Dxf60HTH; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Dxf60HTH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1761160132;
	bh=swKbRAMgZ70c5v9E5qs4nA9wFzRQAX/s17d+481Q+p0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Dxf60HTHZknJadAhtlAMRCYGJyI4jkw3pZrzFTVRXATgVtwwJ2RdTKSjts5TDjQRs
	 thF5aNA+5Npb8uDYeV0+pGcnkalp/GyzHUYllUPCI00HiJcPAy+YSUCWdsE5dNZwa7
	 woDULv4HkX3nLZR23Hp0FfvN9+JNPn0i/kqt7fb0+CtUW4L+oherOypJESDFHP0vfy
	 Z1orvcvE4noILVKMaAPFGq9DHX6jdjZ4th3iUNaC99hGqi7mQMjuQxlDgq0CWskeMx
	 EydxKw3LBWfjDYtNqNtU7Sqa44AlqJI5TIk9LB700LHxeMylfzj88OqpvTpAeH+kyj
	 P18o9tnbE6JsA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4csJc44j67z4wCX;
	Thu, 23 Oct 2025 06:08:52 +1100 (AEDT)
Date: Thu, 23 Oct 2025 06:08:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
 broonie@kernel.org
Subject: Re: + maintainers-add-mark-brown-as-a-maintainer.patch added to
 mm-hotfixes-unstable branch
Message-ID: <20251023060850.5cabb20f@canb.auug.org.au>
In-Reply-To: <20251022184001.20F40C4CEE7@smtp.kernel.org>
References: <20251022184001.20F40C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/BYr.7L5ig.x1Uq+rHF6WHez";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/BYr.7L5ig.x1Uq+rHF6WHez
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 22 Oct 2025 11:40:00 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> The patch titled
>      Subject: MAINTAINERS: add Mark Brown as a linux-next maintainer
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      maintainers-add-mark-brown-as-a-maintainer.patch

Thanks for taking this.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Subject: MAINTAINERS: add Mark Brown as a linux-next maintainer
> Date: Wed, 22 Oct 2025 16:36:25 +1100
>=20
> Mark has been kindly helping fill in when I have been unavailable over the
> past several years.  He has has also put his hand up to take over

Small typo above (duplicated "has").

> linux-next maintenance when I finally decide to stop (which may be some
> time yet ;-) ).
>=20
> Link: https://lkml.kernel.org/r/20251022163625.5df7542a@canb.auug.org.au

Given current discussions, that should probably be

Link: https://patch.msgid.link/all/20251022163625.5df7542a@canb.auug.org.au

;-)
--=20
Cheers,
Stephen Rothwell

--Sig_/BYr.7L5ig.x1Uq+rHF6WHez
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmj5K8IACgkQAVBC80lX
0GyWgwf/bjLCoclBV4el1C8TtKbhjmoqSVu5O3hHxuD0+vFhAceNPEfoPn2F9GoI
oC/KJg66n7dfIgHS0Qy0D52CMjNYJHpmFHdbn2c1PTahk8WLt+ZVr77Kg8NSAVB0
kdEd+Ez7BoHoekRtECD9j2P6DpOwrV9DIlhDQLn1Gao8B2B73bTV36q5taPSsfGZ
VaH7yIc5Ll+GHMXgv2kCgonuJUAm9PECHWIu3f3Kj4xZHinDc2536Uub90TX+rNW
9EhKEzsQj5DpMrWHQNBQeTDXkblb/XG6H6QE1g2brkGF2pubmXWlbWCIAUDCIhFm
UAdFzppRES2SHtBm7vvIu+BkozPVPw==
=N78f
-----END PGP SIGNATURE-----

--Sig_/BYr.7L5ig.x1Uq+rHF6WHez--
