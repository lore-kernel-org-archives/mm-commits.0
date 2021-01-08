Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D8FC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jan 2021 03:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE0323601
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jan 2021 03:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbhAHD44 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 22:56:56 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:39831 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbhAHD44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 22:56:56 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DBq5l6jNgz9sSs;
        Fri,  8 Jan 2021 14:56:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1610078174;
        bh=x+FjGi0/txJy6XnOoE2gOKpcYNPeDYaHWy/ZJX5ggC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FQhJl4rXj4HYiDKnph7jXT1QTtiUkODkPEnFSsqKnpEi65Z+L9vEwwRJuIezEEryO
         WOs48hjeO1tWJKaDFPi2024LD0GWBbpq3WB8L02DHTnL8PTkK9C+o7WbczLH7o4gsn
         rLCLrcK+RZf4pxvlVRoK/5urDnbc8WRq5XuXx0ct8IO8XOR3Ce/dl4Ihuvv3jDXaOd
         N+Bfo8LiGweVq//6kdKhRitQuiCy+j2UaF8uIJeHMTaiR8fdiEE08KVMgyL7CYQhjv
         rJKKPbauuO/PWzq2++3l1EO5gb+aLVPmseg+e+GrklxcZqiwN6lAi/jJDVDPQ7jZw/
         kq30e0f30AG6A==
Date:   Fri, 8 Jan 2021 14:56:10 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>, arnd@arndb.de, elver@google.com,
        georgepope@android.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Subject: Re: [folded-merged]
 ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
 removed from -mm tree
Message-ID: <20210108145610.21496a92@canb.auug.org.au>
In-Reply-To: <20210107150637.e95a8c6173a7febeb02564cd@linux-foundation.org>
References: <20210107003426.Bqzd_O7Lf%akpm@linux-foundation.org>
        <202101071308.8854B1428B@keescook>
        <20210107150637.e95a8c6173a7febeb02564cd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4xwBQPP=fNhz7tLy_wmsxal";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/4xwBQPP=fNhz7tLy_wmsxal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 7 Jan 2021 15:06:37 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Thu, 7 Jan 2021 13:09:29 -0800 Kees Cook <keescook@chromium.org> wrote:
>=20
> > > --- a/lib/Kconfig.ubsan~ubsan-disable-unsigned-integer-overflow-sanit=
izer-with-clang-fix
> > > +++ a/lib/Kconfig.ubsan
> > > @@ -122,7 +122,7 @@ config UBSAN_SIGNED_OVERFLOW
> > > =20
> > >  config UBSAN_UNSIGNED_OVERFLOW
> > >  	bool "Perform checking for unsigned arithmetic overflow"
> > > -	# clang hugely expands stack usage with -fsanitize=3Dobject-size
> > > +	# clang hugely expands stack usage with -fsanitize=3Dunsigned-integ=
er-overflow
> > >  	depends on !CC_IS_CLANG =20
> >=20
> > The above "!CC_IS_CLANG" needs to be dropped. I makes it impossible to =
use at
> > all (unsigned UBSAN overflow is only implemented for Clang). =20
>=20
> It isn't clear to me that this patch remains valid anyway - I'll drop
> it.

I have dropped it from linux-next as well.

--=20
Cheers,
Stephen Rothwell

--Sig_/4xwBQPP=fNhz7tLy_wmsxal
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/319sACgkQAVBC80lX
0Gx+oQf8DbXS6XOul3VjEXp9EqkGhD7QkdWlR2FxjhZVb2+ubrqhefhAMMSAVX61
AnkLQJ8nGAIoIWyMH7hHQy6CU9ngGVoeCbua46iVFTx8Fp674mKm8pmEBAf3r5By
Q+mXkO6A3YuFH7j2lZBbyJAbGWmA06oV2i+rucn8A824e6KmZXJLkBpe1BYw/3jD
af+JbOiZKZ2FGU4MEGlNW4yaRyx83vpFjyG1vXfVm2Fc83JYasC+N+a2QI8d1w5b
IpTPzP7V98OOm/TOv0U520SOrh+vaiH0DbOqGK2jzM+F7N02RFBmOd29bHHsnmd0
yTEsuOvDwD3Ui8RNBGDBlK6YK7CquA==
=vXh6
-----END PGP SIGNATURE-----

--Sig_/4xwBQPP=fNhz7tLy_wmsxal--
