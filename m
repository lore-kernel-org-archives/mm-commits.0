Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0BA524C
	for <mm-commits@vger.kernel.org>; Sat, 23 Mar 2024 06:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711174575; cv=none; b=EQtsHwF9oNwFgGCra8qe0pPtTHbB0WRdwyLjUJ3vjOPiL6EXKLvrfGXRr8BHKnsUS3uB/UmXlAKyK9xDiNz9sjYx5TP6jqYZTGrT6JXOikg7Dcc2XXYibe0McDsN8v7E0IsUEaavAw3lc6C79k7JlQW2+SzTI+YejRSdecaY6i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711174575; c=relaxed/simple;
	bh=ga5mO43i+RgXxn1jeIZl3Q0BtI5akNvzqcSp91ACtEI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RLZc0yE20Vkwav7BEsoVzN3rX/yPL5pFF2cvaQ+W2j3mhyys4Kl2dgOg43qvMi/MCyF7cyh2is27zxL8v7EO86YXzCK5mbeTj6exxb3Tbnqnt0qsyWT70SLT4f+Lf+Enjw+bG9ij7M+bu5lNFrElmhLEHXUixU1aMhgBIq35dwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02DEAC174A;
	Sat, 23 Mar 2024 06:16:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf01.hostedemail.com (Postfix) with ESMTPA id 5C9676000C;
	Sat, 23 Mar 2024 06:16:06 +0000 (UTC)
Message-ID: <b92d6a4f17a17cc8586fea9fa72396c22d748d35.camel@perches.com>
Subject: Re: +
 scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch
 added to mm-nonmm-unstable branch
From: Joe Perches <joe@perches.com>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, apw@canonical.com, broonie@kernel.org, 
 chenhuacai@loongson.cn, chris@zankel.net, corbet@lwn.net,
 dwaipayanray1@gmail.com,  herbert@gondor.apana.org.au, jcmvbkbc@gmail.com,
 linux@roeck-us.net,  lukas.bulwahn@gmail.com, ma.xxn@outlook.com,
 mm-commits@vger.kernel.org,  sfr@canb.auug.org.au, v-songbaohua@oppo.com
Date: Fri, 22 Mar 2024 23:16:05 -0700
In-Reply-To: <20240323041401.6335-1-21cnbao@gmail.com>
References: <ea9e38e6f49786ecb88f810a45c65238a2ec5641.camel@perches.com>
	 <20240323041401.6335-1-21cnbao@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 5C9676000C
X-Stat-Signature: xpmp3sh6o9ut4oaaswqod31h79afbbe9
X-Rspamd-Server: rspamout05
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/pLkyxYAKj3DJ6WgjLbjcmfJDW/iMQVs4=
X-HE-Tag: 1711174566-849789
X-HE-Meta: U2FsdGVkX19Tp+GXrpBXcCv9mjAxXw2gjH3f9hD4P5Gc7SSCHz8Kxlh4op0uRYX72ZKzKRdHVoER/uHUMYYUVH9oP5DBv2E9ApSYe9/R4W02b1pVJSjwl5fFJ66hL0nfYjnviQyNLxxeGMyfIcUHGzlcM8cBVUXxqT7lpqeWgzRak0s1XCZdaPxWQmcwkXBsP0reLdGE+B/PN+pvzlq1YvihgMdO1gjPyNzeLo/fCLlfbU1qh0TqZXrpDFLAld+EF9gYTwV5n+FGuwDAuchCHn2/9bvvDr+72RVVE/kBHhTOuE/tKCBNB2lUl4qlxLgt

On Sat, 2024-03-23 at 17:14 +1300, Barry Song wrote:
> > > The patch titled
> > > =A0=A0=A0=A0=A0Subject: scripts: checkpatch: check unused parameters =
for function-like macro
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > > =A0=A0=A0=A0=A0scripts-checkpatch-check-unused-parameters-for-functio=
n-like-macro.patch
> >=20
> > Conceptually I don't disagree but I wonder what the false
> > positive rate is.
>=20
> Hi Joe,
>=20
> If your concern is whether this script might produce inaccurate reports, =
I'm confident that
> the false positive rate is 0%. Xining, please correct me if I'm mistaken.

I presume it's low but non-zero.

I think the false positives are going to be
in some cases where a type is used as a macro
argument in #ifdef/#else blocks

#ifdef CONFIG_<FOO>

#define foo(bar, baz, ...)		\
static inline func##bar(baz, ...)	\
{					\
	bar baz =3D ...			\
	...				\
}

#else

#define foo(bar, baz, ...)

#endif

where it's not reasonably possible to use a
static inline.

