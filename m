Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBC339FCF
	for <mm-commits@vger.kernel.org>; Sun, 30 Jun 2024 18:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719773614; cv=none; b=JRwKjhdTYuzUYhqv339GChidNap9lmtjzJIsOs5ZgAoG2nfqgxECgq7CY0eoIJyj4qVgMKxgFfnBG2wFoflK9V/rPdMZbA9UaiX8sbQbZQM+H1ph5M8ELNptL2eE88zSYB4qz+mpVPPlU7HV0T0lh/tmfCO94J3YRVk7f9gWKQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719773614; c=relaxed/simple;
	bh=HzPoSzp0dX8wTHgSDt6bd+YUWyinQTgcojRWK3b0BYE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YshoRzUxBDwadciUstUkiuDGm+N+mIWWUwoCn4X8u0eIpY6o9BuIFrcJjWKcNiJh7J4wjKSwAOTSD89a7ds87CHi9PvMojtHX0BHfB32xPSLsgM0rTnAQHvGLMMUanpkP+r743YxjbZmOcxc+A+vBuXCgsqSsExkDjmLRmv+CNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=mc3MWpxY; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="mc3MWpxY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1719773610; x=1720032810;
	bh=HzPoSzp0dX8wTHgSDt6bd+YUWyinQTgcojRWK3b0BYE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=mc3MWpxYy1OXQFhzwOI3x4UEJTQvqqWjYhcHUBf0RXYqKr+Tfg6vIde32DDnNVwGY
	 itG0tedqplQ0YR774kNxhC8BdhJvG6kEBqI4xjzVRK6Cyh4MgRgqfsU98rawCCE7HL
	 2tNjme+6oB5cKX4jkzR1ppyTwGcgbOMdcbWn8tdcFRDzcneHd0Zetn3P8MXF6ZSCEm
	 V8iL/9os8prs34P8MNZsPjcEbq9zDOlNGsk6fH9d9whq+hn5ytdgLmgPwEg26HefpK
	 a+CCYcCLbY4q1L1Eupsug5r3kzqu5rVQ3uvCCFBCpmkElk40ZezqRT6YnFhpgSlUFb
	 qBXl18BLpzJvw==
Date: Sun, 30 Jun 2024 18:53:26 +0000
To: Andrew Morton <akpm@linux-foundation.org>
From: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc: mm-commits@vger.kernel.org, skhan@linuxfoundation.org, keescook@chromium.org, jorgelo@chromium.org, jeffxu@google.com, hughd@google.com, dverkamp@chromium.org, dmitry.torokhov@gmail.com, david@readahead.eu
Subject: Re: [nacked] memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch removed from -mm tree
Message-ID: <4uxF8XTlNc9OXtl00MySnr78ZXcxec_W9IbWt-4R8lG-LWsTC_Z571pCrqnz8TKrWiq16NJuTSiwW8JhVMzdMgvwbB2aXTtX3DP2SZyUDzk=@protonmail.com>
In-Reply-To: <20240614165242.f9d89f9a5711cffc5e0b0f77@linux-foundation.org>
References: <20240614182715.12694C2BD10@smtp.kernel.org> <qdcD-qU2Jfk6ImGOIaV4sWrbTZcHj44hNr454b2pd_SV8t4Bu1mnjsWXfYgW-c7tFW7bQowMRaKysMVcmWvGvUW3O20py_2H1jd7kNGT62Y=@protonmail.com> <20240614165242.f9d89f9a5711cffc5e0b0f77@linux-foundation.org>
Feedback-ID: 20568564:user:proton
X-Pm-Message-ID: 40376c395c48910c7fbd75c28014cb46e919039b
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

2024. j=C3=BAnius 15., szombat 1:52 keltez=C3=A9ssel, Andrew Morton <akpm@l=
inux-foundation.org> =C3=ADrta:

> On Fri, 14 Jun 2024 20:00:02 +0000 Barnab=C3=A1s P=C5=91cze pobrn@protonm=
ail.com wrote:
>=20
> > 2024. j=C3=BAnius 14., p=C3=A9ntek 20:27 keltez=C3=A9ssel, Andrew Morto=
n akpm@linux-foundation.org =C3=ADrta:
> >=20
> > > The quilt patch titled
> > > Subject: memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING=
`
> > > has been removed from the -mm tree. Its filename was
> > > memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch
> > >=20
> > > This patch was dropped because it was nacked
> >=20
> > Hi Andrew,
> >=20
> > do I gather it correctly that this is the final decision, and there is =
not much
> > willingness to try to remove this quirk of the `memfd_create()`? As far=
 as I can tell,
> > the change was in linux-next for some time, did that uncover any proble=
ms? (If so,
> > I haven't been notified.)
> >=20
> > Anyways, I believe I have laid out my arguments already, so I won't rep=
eat them here,
> > and if this is final, then I will stop wasting everyone's time with fur=
ther emails. :-)
>=20
>=20
> We do appear to be stuck.
>=20
> Please feel free to pursue this. Reissue the patch with an updated
> changelog which addresses the various issues which have been raised
> thus far and let's reexamine.

Done: https://lore.kernel.org/linux-mm/20240630184912.37335-1-pobrn@protonm=
ail.com/
I believe the commit message now adequately captures my thinking regarding
backwards compatibility; additionally I have carried out a smoke test by
booting into an Arch Linux system with the patch.


Regards,
Barnab=C3=A1s P=C5=91cze
