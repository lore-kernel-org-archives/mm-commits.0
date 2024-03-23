Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59182CA4
	for <mm-commits@vger.kernel.org>; Sat, 23 Mar 2024 23:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711235106; cv=none; b=AGD9MOifvwcxBxkOQ9B7hFSRiWpOYzFt6x65jZVsR5zquqVFViP3NtE5+3iNFPzHyhMisVKQRsOiGcjYum/fuJq+BvadQmB9tiGZdirQ18gK4ArMgHy8VRrQgBR5nAymQzj5rSpVJUYTYO+esKcFGLFljseOOoA6eLctFa4qrlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711235106; c=relaxed/simple;
	bh=k1MURoYuSesZFx1Wm3k/ejffb0XbJnYABHH72fAxdqs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GUNCny5ZHDw9jaA25sdWXEYUmSrlKtETuHrLGgDVus2NGYwk1Pzdh7mFFxlq7ELgSuU52qP9O3YaPgZep+5jbJyZEAioiDIkTRB29uQl8mhIVX8LrbxWf9+zBazXVxudoaAXXRviJxRs0xxjiuIhPN4Drd7yPkh1TbxgE+Nt5Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 540B5160404;
	Sat, 23 Mar 2024 22:59:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf17.hostedemail.com (Postfix) with ESMTPA id F1BFD18;
	Sat, 23 Mar 2024 22:59:41 +0000 (UTC)
Message-ID: <cbd117f445dfc92fd0bf2e0d200c32f628fe1c46.camel@perches.com>
Subject: Re: +
 scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch
 added to mm-nonmm-unstable branch
From: Joe Perches <joe@perches.com>
To: Barry Song <21cnbao@gmail.com>, mac.xxn@outlook.com
Cc: akpm@linux-foundation.org, apw@canonical.com, broonie@kernel.org, 
 chenhuacai@loongson.cn, chris@zankel.net, corbet@lwn.net,
 dwaipayanray1@gmail.com,  herbert@gondor.apana.org.au, jcmvbkbc@gmail.com,
 linux@roeck-us.net,  lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
 sfr@canb.auug.org.au,  v-songbaohua@oppo.com
Date: Sat, 23 Mar 2024 15:59:40 -0700
In-Reply-To: <CAGsJ_4x+je5Tg9a92WXonaGqULQY56-KcijnWdO720qaefuWzw@mail.gmail.com>
References: <ea9e38e6f49786ecb88f810a45c65238a2ec5641.camel@perches.com>
	 <20240323041401.6335-1-21cnbao@gmail.com>
	 <b92d6a4f17a17cc8586fea9fa72396c22d748d35.camel@perches.com>
	 <CAGsJ_4x+je5Tg9a92WXonaGqULQY56-KcijnWdO720qaefuWzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: F1BFD18
X-Stat-Signature: 5383e9zhq3bs1cwcf1myya98eoukg9cd
X-Rspamd-Server: rspamout04
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19dioa3Z3V4IVF22rWeSMP83q9153eadcg=
X-HE-Tag: 1711234781-722417
X-HE-Meta: U2FsdGVkX1+NJfeYjHhB7k/MVFYgYrUoM+vuxX1+mdENGPO7eTawL4gtRtMQD6ZIgDoKpHEqdal06czsZt2k2UdaYz2bkTcFiVOND2wX1MF8uPuGsTJuAwpj8HJ0juc5YANpEKoRZceZQhfOs7JXdzo3QcGQqatOq5+gkkO9RPqTw12pAqQfYlcRrpJvY6TmdvBEiMhEDGVtNQwJ0CzRfzKXkhGrTNqxmELY0/4ywMWK3cyQ9hkU1PmI09bejIy/kkfR3N8RHKxw+i0U8+Xno6tIkYW+N32Fade549ugP8Wjs5ehkG5EqK/rqVphjvSQs2jMoIJUREV1v0o13ZCeqeTuuRaPRmSpjDgDSnp1MkE2JbLW8ogdSNoM1n2+mqVN

On Sun, 2024-03-24 at 11:40 +1300, Barry Song wrote:
> On Sat, Mar 23, 2024 at 7:16=E2=80=AFPM Joe Perches <joe@perches.com> wro=
te:
> >=20
> > On Sat, 2024-03-23 at 17:14 +1300, Barry Song wrote:
> > > > > The patch titled
> > > > >      Subject: scripts: checkpatch: check unused parameters for fu=
nction-like macro
> > > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename=
 is
> > > > >      scripts-checkpatch-check-unused-parameters-for-function-like=
-macro.patch
> > > >=20
> > > > Conceptually I don't disagree but I wonder what the false
> > > > positive rate is.
> > >=20
> > > Hi Joe,
> > >=20
> > > If your concern is whether this script might produce inaccurate repor=
ts, I'm confident that
> > > the false positive rate is 0%. Xining, please correct me if I'm mista=
ken.
> >=20
> > I presume it's low but non-zero.
> >=20
> > I think the false positives are going to be
> > in some cases where a type is used as a macro
> > argument in #ifdef/#else blocks
> >=20
> > #ifdef CONFIG_<FOO>
> >=20
> > #define foo(bar, baz, ...)              \
> > static inline func##bar(baz, ...)       \
> > {                                       \
> >         bar baz =3D ...                   \
> >         ...                             \
> > }
> >=20
> > #else
> >=20
> > #define foo(bar, baz, ...)
> >=20
> > #endif
> >=20
> > where it's not reasonably possible to use a
> > static inline.
>=20
> I do find some exceptions such as include/uapi/linux/const.h
>=20
> #ifdef __ASSEMBLY__
> #define _AC(X,Y)        X
> #define _AT(T,X)        X
> #else
> #define __AC(X,Y)       (X##Y)
> #define _AC(X,Y)        __AC(X,Y)
> #define _AT(T,X)        ((T)(X))
> #endif
[]
> I'll check if Xining has some approach to detect this kind of ifdef/else/=
endif,
> and remove those false positives.

checkpatch isn't expected to be perfect.

So I wouldn't worry about it, I just wondered if
the exception rate is near the warning rate.

I expect it's not, but if it is, then perhaps
the warning isn't useful.

Do you know how many existing cases there are in
the kernel that might trip this warning?

