Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C932C5519F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Nov 2020 07:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FB86221EB
	for <mm-commits@archiver.kernel.org>; Tue, 17 Nov 2020 07:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="YKl+cbRd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKQHMw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgKQHMw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2020 02:12:52 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD97C0613CF;
        Mon, 16 Nov 2020 23:12:52 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CZxwc2nzXz9sPB;
        Tue, 17 Nov 2020 18:12:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1605597168;
        bh=9MqRUSnkpO3SeeLB+V4BrXp6RQvKtXmson5+puyyqo4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKl+cbRdEx0lrmIMDAaJcszpvAajgtGUZgqp7tXaFcXv2Viz8idFaxAVGZUZYdWLi
         mpXTuXfp97pTiGsdfywpEQSUu7U9kuEHG8f87XB+AeB5klW3sEtSOfUB8cHU6NkwNZ
         lGEHSOGeVU5xy8IS2YwQPHs6kLwjuvVVngEAAV3vphbRhweLsiik0UzUVcmqgUs0hL
         W1qAIUdRbuhaCx2LYCx4nIXph2vKP5E6bsCSnFWHrJ5awVOIDB6razqykn2RvS7kps
         PDyeLAPhRVflykkjlcEYVbcBd0NRjIqugL1nD32FRZx+Hf+NVuHEy0jJ+/FL+ar4j0
         6vrd7KM2bmitw==
Date:   Tue, 17 Nov 2020 18:12:46 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, sh_def@163.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: + mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
 added to -mm tree
Message-ID: <20201117181246.5f29f9ca@canb.auug.org.au>
In-Reply-To: <alpine.LSU.2.11.2011162149210.1082@eggly.anvils>
References: <20201116230526.NkEfmeDCH%akpm@linux-foundation.org>
        <alpine.LSU.2.11.2011162149210.1082@eggly.anvils>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lJf.D2B5rRqG2sSnrpSxtMC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/lJf.D2B5rRqG2sSnrpSxtMC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Hugh,

On Mon, 16 Nov 2020 22:17:20 -0800 (PST) Hugh Dickins <hughd@google.com> wr=
ote:
>
> On Mon, 16 Nov 2020, akpm@linux-foundation.org wrote:
> >=20
> > The patch titled
> >      Subject: mm/shmem: use kmem_cache_zalloc in shmem_alloc_inode()
> > has been added to the -mm tree.  Its filename is
> >      mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
> >=20
> > This patch should soon appear at
> >     https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-use-kmem_cache_z=
alloc-in-shmem_alloc_inode.patch
> > and later at
> >     https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-use-kmem_cache_z=
alloc-in-shmem_alloc_inode.patch
> >=20
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >=20
> > *** Remember to use Documentation/process/submit-checklist.rst when tes=
ting your code ***
> >=20
> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> >=20
> > ------------------------------------------------------
> > From: Hui Su <sh_def@163.com>
> > Subject: mm/shmem: use kmem_cache_zalloc in shmem_alloc_inode() =20
>=20
> Andrew, Stephen, please revert this untested "cleanup" from your
> trees a.s.a.p: it's a disaster for anyone using shmem/tmpfs.

Thanks for that.  I have also bisected my boot failures to that commit
and so have reverted it from linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/lJf.D2B5rRqG2sSnrpSxtMC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+zd+4ACgkQAVBC80lX
0Gx1Ugf8C5haoqlz+b6RB9D3i2I3sOqleXM0COjh+nSBcJMbFZZO+v2ID+/1zl9y
PGT3uF5GCkNFqMVY2+thFkAy0Lwjdcc/nmTAEyHFgFK9Ae9ATSgMn+vv40OHsDo4
+uHoMonPqctxhHzLEs6CJV3f39dxBVUdHExEISDZCltpXpOBDohp5c2heMHmwbis
nwd4cgx209btXBNImSGtPNRsYa94nuR+DZZ1BEFLC5pkI2v/jDJf2H0N+g6wqwCf
IOGCaSnyPInTnJy/nVC0SOWIeDwnNohgDsaCAAhNbKUFJdpEVtlLcNMxxV1LA+8Q
3pkjSqFse94Pz1sWm1sMv5QaYdq8Sg==
=LNUE
-----END PGP SIGNATURE-----

--Sig_/lJf.D2B5rRqG2sSnrpSxtMC--
