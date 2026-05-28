Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A475D3E1227
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 11:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779967403; cv=none; b=tC9K/ztCurTClQfWCSRvSX99YSp7Jp2VsaTtFMkSTVXdjlV5jT1DXzlJlibuERIX6IP5anL+vNObw1OWOru37b8A/VvzMG2OBg2RmdUGxTFLEwPyJGpf+OxOJWm2/eInOJy8PBWz658MAoN7OYWJWRoJLF8a/TTWqIqiqrFQQCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779967403; c=relaxed/simple;
	bh=YudU7u5DNSANXQ+Ik0SvhNuBPdxtuaWorFnsyimTN+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oIQmH8SJxDsAzuMvHLOxWZDKkXA7ZCo1/pPEmsql1xBXEjVLoES/94d7gbaJ5X+Ii2NY2m4QRbLSZ1LaX+jZFEgj+dKMzF0Ph+SxRU3Id3F8Uwbngz5UHqhF3/0pPGxFvZ3QemRfWvzHZAkn7FmadYT3hgatt5ZmF07AihT0XmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NUNH5swE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NUNH5swE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0934E1F000E9;
	Thu, 28 May 2026 11:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779967402;
	bh=0BLxN5GXNXMyMxV0/6XSe2RcNthOX1DfF54HLNnUtzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NUNH5swEJYTriQUVBCS3ojXpQO3G58LeQak/uS0e5A+55lqDGPYW4rXUppFDxhKD0
	 +fLMUo2F9D1nEiaPJ1FYUD8CYAel1iAqTyYOWmrpbeVlTkQ14DcgXO8ahIhNyJNHY8
	 4imsFi634EhyxJxYOZGTaR3ldIzvpCrwYtIAti+QHhF7yNHGFr9/NAdKtJtS37mAsQ
	 3raXmvDCslYVm0AxgPxrjrnUYnQeT3TRpz7+p1agm5yL9YatV/rB/3uSR1cftI2u9D
	 KGA6LL9FcpAdWeuEiQoaT6uYgqExvSnQH8p1h6QOm31u293Q+ao+kKvazJ3wAMOg6y
	 ZA8fdNlsczgow==
Date: Thu, 28 May 2026 12:23:18 +0100
From: Mark Brown <broonie@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	roman.gushchin@linux.dev, rientjes@google.com, harry@kernel.org
Subject: Re: +
 maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch added
 to mm-hotfixes-unstable branch
Message-ID: <a4b11bf6-ab93-4531-bc0e-9762483bfd2a@sirena.org.uk>
References: <20260525174125.746121F000E9@smtp.kernel.org>
 <5c340177-548e-4c9d-aaaa-d28b30b0903a@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cfxNpRDGvA5G+Qxn"
Content-Disposition: inline
In-Reply-To: <5c340177-548e-4c9d-aaaa-d28b30b0903a@kernel.org>
X-Cookie: Someone is speaking well of you.


--cfxNpRDGvA5G+Qxn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 28, 2026 at 11:44:20AM +0200, Vlastimil Babka (SUSE) wrote:

> So I see next-20260527 now has that both from mm and slab trees (with
> different sha1 hashes), but can't see any heads-up mail about that like in
> the past? Did anything change, Mark?

As mentioned on IRC the reporting here is manual so can be laggy, and I
need to do something about the trees like drm that just routinely have
enormous numbers of cherry picks.  FWIW the current set of things I have
in slab is:

  0317d2ff0cbdc ("tools/mm/slabinfo: remove redundant slab->partial assignment")
  9fc57929420fa ("MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR")
  a47d084532859 ("tools/mm/slabinfo: Fix trace disable logic inversion")
  f132df576e9a6 ("tools/mm/slabinfo: remove dead assignment in get_obj_and_str()")

--cfxNpRDGvA5G+Qxn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoYJaUACgkQJNaLcl1U
h9CZvAf/QfzHUNSCDzDq1ryzFjV4YceJym6HILZ5b1iKLG+uhNAY5RlKto2hBp9A
OyQEDGaDFfa9oFMbjLUe+a7QDFDMpg8QpaWdfEoGcfytCikfDeezgK3RnIaqqZYy
ZcqKwJEsps4sGgJKPZJnt1ZdLpQAykSg/mZz6FmAS68YexRyCYTgs0a6A8cte0Sv
3x1W+NArUmD2E3RqBwwjDBXWpgYQp8dnOI8NuVckx1a/3TrQhmJ1zB3S0TakWXp+
7SKiKEdjna+jYtWcquWIjyZl+A0apyvnwzxUPjylb9/0tBnPjtgsIJCqhoMlHqdB
Uziy+wFKr5fXTBKx+7/HVpTGZGAZhg==
=NJOT
-----END PGP SIGNATURE-----

--cfxNpRDGvA5G+Qxn--
