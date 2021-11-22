Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE424C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 22 Nov 2021 21:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbhKVWCW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Nov 2021 17:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236649AbhKVWCT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Nov 2021 17:02:19 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03288C061574
        for <mm-commits@vger.kernel.org>; Mon, 22 Nov 2021 13:59:12 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hyh4Y3F0yz4xbM;
        Tue, 23 Nov 2021 08:59:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637618350;
        bh=Sp4r97IBBts9HCxrVGJWTEwKujbc2hv/h5JWR5+zWco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K9C7lUBpVYP5YOXpc/ge47E19WsjeGMx7uEkCSsGQFpW9GyfZ8nYcHztmyj8zNopM
         XVEDZratBoRr3n+DtgIzXxf0QbqR0j6n8I54wuF4iQZakamO/aLwGYPCANlFNXvtRJ
         R9IznPUKNV62IWQkJ/mEc4FmomkcSAI8n0AcyN0J9pYWmvwl/PCvGIstA8f0WswL5w
         LoSjchbTNFBW0WSlkNB/+u37TsE8fgcfYtA8WW+APQ3io6OUBm4cGtMkpHmufTb+L1
         VgAIGnyowdta1MY7culTmzx2FMjlXYi1dsy7Goz2r78YfIUoVQt0NroU/wfZwg5dQQ
         2iIn5BIE1bX5A==
Date:   Tue, 23 Nov 2021 08:59:08 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject: Re: + locking-rwlocks-introduce-write_lock_nested-fix.patch added
 to -mm tree
Message-ID: <20211123085908.7c8cf475@canb.auug.org.au>
In-Reply-To: <20211119225126.3ilU1Uv6x%akpm@linux-foundation.org>
References: <20211119225126.3ilU1Uv6x%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EAImV_h0Q4encKHlnhEV_SP";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/EAImV_h0Q4encKHlnhEV_SP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 19 Nov 2021 14:51:26 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: locking/rwlocks: fix write_lock_nested for RT
> has been added to the -mm tree.  Its filename is
>      locking-rwlocks-introduce-write_lock_nested-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/EAImV_h0Q4encKHlnhEV_SP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGcEqwACgkQAVBC80lX
0GwvNgf/RuEUFgv1sX8zOa623ZTQrXYJlP0M6BgGk0Uhbgjuvju/Nm60zVJuxyEm
gYUoGNyRqruWZxVTeOLviXMLsNCCsm1gYkPv72fjV+32SAQ4hmawiuzgn8r775o3
WsRLa6HC5D7GtgIAUN4TWtNp9t8MvM9uZjY5HbvYoo3TfWu6bQY3S93VSvK+IwTy
y5M3acJ7xn4dw4k6hny69oDqyg+pCMMEk4q+twEBlq3sWMrBeybV3E/Op+KmA13l
981+h9IXAFikrUCNk7VGLX7rWrHVY/MMGoTTKNjpJ34PLFrN5acGBkVAQ4/R2/Jn
M6qIFeiK8Yr2vTOQtsB4se4UBz/jHQ==
=PxpW
-----END PGP SIGNATURE-----

--Sig_/EAImV_h0Q4encKHlnhEV_SP--
