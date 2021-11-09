Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5CDC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 01:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2525D61A7B
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 01:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbhKIBGy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbhKIBEx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2021 20:04:53 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2C0C061570
        for <mm-commits@vger.kernel.org>; Mon,  8 Nov 2021 17:01:16 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hp8n22WCCz4xdq;
        Tue,  9 Nov 2021 12:01:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1636419671;
        bh=ys/cHutDselQc/BnPzmrrlXS6mKmtZzVJ7vqxH8uB+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s5+ODVGqyxu6Xsco5ZDjws5KEBGFLQtu4rjRt6JWqICZTncCqxOmb9zWylgOs5ZDo
         5iRC1gsvtSpPeZpQkL5TpI2/okPCzfLgqThYzQPDe9+P4ioosa4Mq6NFr5D3IIxJoi
         6XUD4lMeLmpNrk4WVuGJRzbmHfNFFA/GUBhQLpch4tjLfr964XUl5wReQKucw10/RR
         0XyoxgSd3dfKcCmaqN4gpwHGqCfKPr81CRYVz6cY0cbtcpOW22Vr33KghKyRFWaWFf
         FAOdID9vnwY6A5a3wY00PbtnnR97/eOghIXITszUlAT+xnIxP93jJz92JBBOB82cAf
         df7h7EPBcxm3Q==
Date:   Tue, 9 Nov 2021 12:01:08 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     andriy.shevchenko@linux.intel.com, linux@roeck-us.net,
        mm-commits@vger.kernel.org, palmer@dabbelt.com
Subject: Re: +
 delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch added
 to -mm tree
Message-ID: <20211109120108.6b917ea5@canb.auug.org.au>
In-Reply-To: <20211108232623.VGlgyna4s%akpm@linux-foundation.org>
References: <20211108232623.VGlgyna4s%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9WDvLHV5+XkB8clkAZZ008x";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/9WDvLHV5+XkB8clkAZZ008x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 08 Nov 2021 15:26:23 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: delay-replace-kernelh-with-the-necessary-inclusions-fix-2-f=
ix
> has been added to the -mm tree.  Its filename is
>      delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix.patch
>=20
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/delay-replace-kernelh-with-=
the-necessary-inclusions-fix-2-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/delay-replace-kernelh-with-=
the-necessary-inclusions-fix-2-fix.patch
>=20
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>=20
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>=20
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: delay-replace-kernelh-with-the-necessary-inclusions-fix-2-fix
>=20
> include/linux/fwnode.h needs bits.h for BIT()
>=20
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  include/linux/fwnode.h |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- a/include/linux/fwnode.h~delay-replace-kernelh-with-the-necessary-inc=
lusions-fix-2-fix
> +++ a/include/linux/fwnode.h
> @@ -11,6 +11,7 @@
> =20
>  #include <linux/types.h>
>  #include <linux/list.h>
> +#include <linux/bits.h>
>  #include <linux/err.h>
> =20
>  struct fwnode_operations;

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/9WDvLHV5+XkB8clkAZZ008x
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGJyFQACgkQAVBC80lX
0Gz7fQf+LV2Wb7qj3bstFoRMu07S95Cvwhqccf1mwEh84dPvoXV8PxrHfwVFrnyl
TTTf0khxTRSW0UPlTU4ZTQoBnx6J+rOwuXN9zuQBqDvjKX3kqJidZ3YWxEQJy5il
KYMOJJWcV42dub/3MB427MCKMBHRljiSRBI5NRh/eifwov6QaX5beyWYd91iC+a0
Y9sI+wlYOOojk5bcSaTsJdfw4ME93lMa1uNBaOE8ZGo5MfyBVa5tabvsToB8DuvZ
obFFjl2Jw4iMQDcQa4ekg/1AYQwXGnY/1Pb9rci9hq2GtRZhyPIPRsGzamyYOIsZ
nPfXFJMxGSW7gIz8wUED5vXpBmqPqw==
=BoWp
-----END PGP SIGNATURE-----

--Sig_/9WDvLHV5+XkB8clkAZZ008x--
