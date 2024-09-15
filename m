Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5474F347B4
	for <mm-commits@vger.kernel.org>; Sun, 15 Sep 2024 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726421106; cv=none; b=E8JhqZf9JLIksEZF94niaGeKIWNvPs0s1cqVuiaXqvtm1XUhApWELm9qVplgKFO937sMG2m5+1f0Qi7iOKIC8eyTYwdcF5vKkxu+6ZJEUuF+uFDoudfzXJ9wAgXqcMJSWh0Yp7WueAPZK/kAD0vuK9SSD++YNWtIleEaCs4UtyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726421106; c=relaxed/simple;
	bh=BuxJfh/DOgfi9fdn7BR53KIea+LBSa8oZOk89Iaijjk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4+KWGuG0yu14f+RsFV5Z4hRV8TShQV8CT23YX7O6i71Qq2xnV7TacpuaTmdvdsUmAbRboRS7SrgF4SlrmbU0pKZDWVG9FRygyC9tHm1Q9yQX87gs8inZOK7UFuupYRHcsYL0Z78PiYeEEJYvQ1S36inL38wVwO6NPhg1vDEDk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=QjxP4UrV; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="QjxP4UrV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1726421102; x=1726680302;
	bh=BuxJfh/DOgfi9fdn7BR53KIea+LBSa8oZOk89Iaijjk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=QjxP4UrVdTFPfF79+IH46j37ZLJWIbX6I/QLdawziRvxNz0S56SSGpqHBxUJfRqg5
	 3rQmVwQc8ubfsFgY9tz6v0xKGam6eHtsSv3hmNQ+cvPa56uspph47D1s8gbGJ9tjR5
	 7mxV/M6/9tRiN7KdcdM2r/T4EjJ17Y9ts4+Xp2iy8wTZNZOHMV49oDRof8xp2z//xH
	 EBMVVEBOfnizh+nJtrUt7dnW/PcevYRrfpGApz9faqIyrqgeNlZHg/CA0/mENOipHv
	 15uMlT3AabE9Xx2qMp+rDTwERfmJXIaWpvrrWJVwS3UQl5tN0J11k9qyaQcyZ6BFiF
	 O8qW22JR8kHkw==
Date: Sun, 15 Sep 2024 17:24:58 +0000
To: Andrew Morton <akpm@linux-foundation.org>
From: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc: mm-commits@vger.kernel.org, skhan@linuxfoundation.org, keescook@chromium.org, jorgelo@chromium.org, jeffxu@google.com, hughd@google.com, dverkamp@chromium.org, dmitry.torokhov@gmail.com, david@readahead.eu
Subject: Re: [nacked] memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch removed from -mm tree
Message-ID: <t9Q-3_9rKhw6FSGhPgovLCtpDeyrjsLA0E_kwtEjAepE-SLtHww-UtAJDrLYSVBhOmliBCX7wEyHCSIT1mjAeJOqg3a2cTnOCbdL44QP2Vs=@protonmail.com>
In-Reply-To: <4uxF8XTlNc9OXtl00MySnr78ZXcxec_W9IbWt-4R8lG-LWsTC_Z571pCrqnz8TKrWiq16NJuTSiwW8JhVMzdMgvwbB2aXTtX3DP2SZyUDzk=@protonmail.com>
References: <20240614182715.12694C2BD10@smtp.kernel.org> <qdcD-qU2Jfk6ImGOIaV4sWrbTZcHj44hNr454b2pd_SV8t4Bu1mnjsWXfYgW-c7tFW7bQowMRaKysMVcmWvGvUW3O20py_2H1jd7kNGT62Y=@protonmail.com> <20240614165242.f9d89f9a5711cffc5e0b0f77@linux-foundation.org> <4uxF8XTlNc9OXtl00MySnr78ZXcxec_W9IbWt-4R8lG-LWsTC_Z571pCrqnz8TKrWiq16NJuTSiwW8JhVMzdMgvwbB2aXTtX3DP2SZyUDzk=@protonmail.com>
Feedback-ID: 20568564:user:proton
X-Pm-Message-ID: a9cff8acaad0e34805dd894aef35f54ab10280c1
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

2024. j=C3=BAnius 30., vas=C3=A1rnap 20:53 keltez=C3=A9ssel, Barnab=C3=
=A1s P=C5=91cze <pobrn@protonmail.com> =C3=ADrta:

> 2024. j=C3=BAnius 15., szombat 1:52 keltez=C3=A9ssel, Andrew Morton <akpm=
@linux-foundation.org> =C3=ADrta:
>=20
> > On Fri, 14 Jun 2024 20:00:02 +0000 Barnab=C3=A1s P=C5=91cze pobrn@proto=
nmail.com wrote:
> >
> > > 2024. j=C3=BAnius 14., p=C3=A9ntek 20:27 keltez=C3=A9ssel, Andrew Mor=
ton akpm@linux-foundation.org =C3=ADrta:
> > >
> > > > The quilt patch titled
> > > > Subject: memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALI=
NG`
> > > > has been removed from the -mm tree. Its filename was
> > > > memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch
> > > >
> > > > This patch was dropped because it was nacked
> > >
> > > Hi Andrew,
> > >
> > > do I gather it correctly that this is the final decision, and there i=
s not much
> > > willingness to try to remove this quirk of the `memfd_create()`? As f=
ar as I can tell,
> > > the change was in linux-next for some time, did that uncover any prob=
lems? (If so,
> > > I haven't been notified.)
> > >
> > > Anyways, I believe I have laid out my arguments already, so I won't r=
epeat them here,
> > > and if this is final, then I will stop wasting everyone's time with f=
urther emails. :-)
> >
> >
> > We do appear to be stuck.
> >
> > Please feel free to pursue this. Reissue the patch with an updated
> > changelog which addresses the various issues which have been raised
> > thus far and let's reexamine.
>=20
> Done: https://lore.kernel.org/linux-mm/20240630184912.37335-1-pobrn@proto=
nmail.com/
> I believe the commit message now adequately captures my thinking regardin=
g
> backwards compatibility; additionally I have carried out a smoke test by
> booting into an Arch Linux system with the patch.
> [...]

Hi Andrew,

what do you think?


Regards,
Barnab=C3=A1s P=C5=91cze
