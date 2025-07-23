Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB661C863B;
	Wed, 23 Jul 2025 22:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753310423; cv=none; b=P2LIGRpIbyGyX9n0n27HYJHgzZsu2s2Mo8RC7UEi4e6/F6N+jVSwUSjUvpRD3Gxy8/V8qYr00c0LkXy26+zzJiQb6Fi6iboFYYkFdl5ofvN/UiFpu07RpwLYtQhaSd6J7HrO4FLQXeeryyjQLetuPp6xCjubT8PkK7e3BBYkriI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753310423; c=relaxed/simple;
	bh=qPt1t5YC/lIa/8UTL/q+3h6YL6/f0oD4nfi9f6O0SOU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHjaGe3tQseVwv+7oHdz4IyJbYrX0y/6tQcKbIic5iw9/3/VzztEQKVvknapztDntAxHjxgQBu46FXikEpHGc3KkRtSRfJVQzNrQQBf3QrGmU1OSSI2mChK5BxTgIgL+3RJVoOUJSwQNoIRgEUt2+jpQCb0yYW8tDbFhRPsPKVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=YtKIaGCw; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="YtKIaGCw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1753310243;
	bh=O8vGPj42JXQgPWGzEXGzW+BZBP+2Ptm+BwM8qMFX2TU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YtKIaGCw0H2VnP2J2DcpiOxH2B8MLcmjxs7MhYp/UrG5A15IYmygtl7ZSaphJXKg2
	 CwmWmKiOkg2lczl2mqPbJ5hemxiZIaAl9IhHpJVJiJsXsNkMPPydgBvBdv5hOI6xSV
	 INm5m3bSNaIVzlI0Dgm9e0+h6WupOKzxMEkk5IaYD77d8fD7FTV3ozmU26/2IOJQPm
	 IUH+hUPMH09hMBB4A6J0xt+Jq9+ag1RqqFwSIDs/zIcSXwT/wu06BkdKetX/MfYTz7
	 ph2iEVAMKb2/Uu47jP2Ul0l3Wvnke+AI3QZujipXvOzfR/0uVoTIfbXuOJ7DigkaY3
	 Ni/5PD2wUQr5g==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4bnTXf5Zjjz4wcg;
	Thu, 24 Jul 2025 08:37:22 +1000 (AEST)
Date: Thu, 24 Jul 2025 08:40:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 stable@vger.kernel.org, senozhatsky@chromium.org, rostedt@goodmis.org,
 pmladek@suse.com, linux@rasmusvillemoes.dk, herbert@gondor.apana.org.au
Subject: Re: + sprintfh-requires-stdargh.patch added to mm-hotfixes-unstable
 branch
Message-ID: <20250724084012.5d7bbc47@canb.auug.org.au>
In-Reply-To: <aID_3hHxWXd1LC5F@smile.fi.intel.com>
References: <20250721211353.41334C4CEED@smtp.kernel.org>
	<aID_3hHxWXd1LC5F@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Qs/fAjh=599rO=8v+9Ri.ud";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/Qs/fAjh=599rO=8v+9Ri.ud
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Wed, 23 Jul 2025 18:29:34 +0300 Andy Shevchenko <andriy.shevchenko@linux=
.intel.com> wrote:
>
> On Mon, Jul 21, 2025 at 02:13:52PM -0700, Andrew Morton wrote:
>=20
> > ------------------------------------------------------
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Subject: sprintf.h requires stdarg.h
> > Date: Mon, 21 Jul 2025 16:15:57 +1000
> >=20
> > In file included from drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_=
utils.c:4:
> > include/linux/sprintf.h:11:54: error: unknown type name 'va_list'
> >    11 | __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
> >       |                                                      ^~~~~~~
> > include/linux/sprintf.h:1:1: note: 'va_list' is defined in header '<std=
arg.h>'; this is probably fixable by adding '#include <stdarg.h>' =20
>=20
> ...
>=20
> >  #include <linux/compiler_attributes.h>
> >  #include <linux/types.h>
> > +#include <linux/stdarg.h> =20
>=20
> Can we prevent the ordering?

I am not sure what you mean by this.  Do you want alphabetical, reverse
christmas tree, or something else?  Or are you concerned with something
completely different?
--=20
Cheers,
Stephen Rothwell

--Sig_/Qs/fAjh=599rO=8v+9Ri.ud
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmiBZMwACgkQAVBC80lX
0GxQpAf8DjwIOehxdYkJ7ovgC9HZmEz7t8kYnx//4wgJ6BdZY40E29yRSNPB2P9d
2io5gFFHlQL96V5cbKN0XIKupGcJfzR2FdEhRk6f+oEkNFsqIGE0UemBMxO3imFw
P3OBDRVzOi4BuDifacKml5q6nmvoDy4W+OK5BaDyXQxwyHxsFS05uSLIyuGY0uD4
liJQcPKnjORfz/tWZwUJ5vXW4sTX/8m+UyJFkohX70zJhPa0RM24PKlUD4ORxYti
R2/SOPCPmff23XdvIQwZC/1iq3DA6Gcq6pluMtsgPxP457rkfvDbE+i5EIxNduO9
beta7ZPwF3USK9F486nerr3jg+f7tQ==
=y9eI
-----END PGP SIGNATURE-----

--Sig_/Qs/fAjh=599rO=8v+9Ri.ud--
