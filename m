Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C3DC2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 17 Nov 2020 04:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6035024692
	for <mm-commits@archiver.kernel.org>; Tue, 17 Nov 2020 04:29:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="ozMzpEC8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgKQE3l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 23:29:41 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:44903 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgKQE3k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 23:29:40 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CZtJK1qJPz9sPB;
        Tue, 17 Nov 2020 15:29:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1605587378;
        bh=ImjDN5NvGz7wblCoL2s/XWWxwSic8aSCysujXk7XdZE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ozMzpEC8SY+VplDwGALTvE3/0MbR9LtIBm3O78UE6r7pYaxZcvsHLhSFLFb6g0blR
         zZ+oZ/5nY2P7pIMRQX7S32LPhc3zS/wGlHjXZA+xBNa4PRLDrNdmcTY0s8InRg8Tjj
         L5xc5dIBgstwThZZdnxkIdSccad7nAfSZ+2VCCE0sNjdyw96OKGXVp7LpzqgC4nNbZ
         trbnjiLSjQU/Oa68DegI8M9mxfZhaXwEzO1xN9ZjBLF/idDf/IhtKa0nF7kAWqtBYz
         do9t7Ix2WaoHEyi40DllrDn7iD5Ub/HcY3UMAZrBC+T7uzG9RT98oerOFuXhAyie/E
         BZ5g3iC22JqgA==
Date:   Tue, 17 Nov 2020 15:29:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, Mike Rapoport <rppt@kernel.org>
Subject: Re: mmotm 2020-11-16-16-47 uploaded (m/secretmem.c)
Message-ID: <20201117152936.4bad2b74@canb.auug.org.au>
In-Reply-To: <e7cc79ce-2448-98bc-6ae9-306f6991986f@infradead.org>
References: <20201117004837.VMxSd_ozW%akpm@linux-foundation.org>
        <e7cc79ce-2448-98bc-6ae9-306f6991986f@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wVV9CRWE5LCHOT4y+AlfTZY";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/wVV9CRWE5LCHOT4y+AlfTZY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 16 Nov 2020 20:20:12 -0800 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on x86_64:
>=20
> as reported on 2020-11-12:
>=20
> when CONFIG_MEMCG is not set:
>=20
> ../mm/secretmem.c: In function =E2=80=98secretmem_memcg_charge=E2=80=99:
> ../mm/secretmem.c:72:4: error: =E2=80=98struct page=E2=80=99 has no membe=
r named =E2=80=98memcg_data=E2=80=99
>    p->memcg_data =3D page->memcg_data;
>     ^~
> ../mm/secretmem.c:72:23: error: =E2=80=98struct page=E2=80=99 has no memb=
er named =E2=80=98memcg_data=E2=80=99
>    p->memcg_data =3D page->memcg_data;
>                        ^~
> ../mm/secretmem.c: In function =E2=80=98secretmem_memcg_uncharge=E2=80=99:
> ../mm/secretmem.c:86:4: error: =E2=80=98struct page=E2=80=99 has no membe=
r named =E2=80=98memcg_data=E2=80=99
>    p->memcg_data =3D 0;
>     ^~

(As I said earlier today,) I will apply the following to linux-next today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 16 Nov 2020 16:55:10 +1100
Subject: [PATCH] secretmem-add-memcg-accounting-fix2

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/secretmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 5ed6b2070136..c7a37b2d01ed 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -59,6 +59,7 @@ bool secretmem_active(void)
=20
 static int secretmem_memcg_charge(struct page *page, gfp_t gfp, int order)
 {
+#ifdef CONFIG_MEMCG
 	unsigned long nr_pages =3D (1 << order);
 	int i, err;
=20
@@ -72,11 +73,13 @@ static int secretmem_memcg_charge(struct page *page, gf=
p_t gfp, int order)
 		p->memcg_data =3D page->memcg_data;
 	}
=20
+#endif
 	return 0;
 }
=20
 static void secretmem_memcg_uncharge(struct page *page, int order)
 {
+#ifdef CONFIG_MEMCG
 	unsigned long nr_pages =3D (1 << order);
 	int i;
=20
@@ -87,6 +90,7 @@ static void secretmem_memcg_uncharge(struct page *page, i=
nt order)
 	}
=20
 	memcg_kmem_uncharge_page(page, PMD_PAGE_ORDER);
+#endif
 }
=20
 static int secretmem_pool_increase(struct secretmem_ctx *ctx, gfp_t gfp)
--=20
2.29.2

--=20
Cheers,
Stephen Rothwell

--Sig_/wVV9CRWE5LCHOT4y+AlfTZY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+zUbAACgkQAVBC80lX
0GwR1AgAlvTptd4g+UnCn+Gckha4GEgqfh8tJPIK8i4E8FgjKwtdl25Z57It1n92
BGB6igVN0JEMBW59i0dBr7kCs0xz15x9vQFqo9ysW4J2evtd0y2IUMxgSbxUcS68
FQKcxSuayPRQgoeUwDyBm+9k8Kcgm3DS9mxQllwaZjonakXXRR64c0gpiu8fvLIp
d7jmxJJF21xIx5tAGe58/AbZAPwERhWk2QXBgqE8uyPfE6MkMORpntec5VE29hKM
plP+cgDKJgkTHPPf0w4EhYq5jga9IF/KRf4PfwMUSkcOzfyqpW5qXWtu/bG0eMIc
ihA+DyM/dDCQjekWdmHNZwIcUVNpvw==
=gUYS
-----END PGP SIGNATURE-----

--Sig_/wVV9CRWE5LCHOT4y+AlfTZY--
