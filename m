Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03095C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADC2E221EB
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927867;
	bh=iRammIm7t00VPPnpK0FdtozEmSrj9pLLAdi/2VVw13o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=G5OjWaubp1izT5qr/4RW83X6hyPMCuh78RXTDqLVja939tSFBuT4XguxE79Pph52s
	 dp0bXLqmAvStdmuILk4zwv4zQdWKJzCFywVQy8iitqcaFrQHnuPDn5FMsjma+ZUKIM
	 6YboAO8ut6qpCYV1OuaBst7qgBrOQ7X8+MHLV4Tg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgILQYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgILQYD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:24:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 842A921D7E;
        Sat, 12 Sep 2020 16:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927839;
        bh=iRammIm7t00VPPnpK0FdtozEmSrj9pLLAdi/2VVw13o=;
        h=Date:From:To:Subject:From;
        b=JahGTA44A8h25pj02bMVIHJ3U4nxTx0Kpy3+N7vUheEYnQcNBbfkO21kQUeF6lij9
         gCGTlwo0KkSH0Dqnyk3Y/3UWKqPd6fscW5AztPVhRfqDBoUbrsyWp9mCMqYMyzFGEB
         Ebg1KU78y9cHAFiENamFeM8FLGSNvkUD7ZoA02Fw=
Date:   Sat, 12 Sep 2020 09:23:59 -0700
From:   akpm@linux-foundation.org
To:     alistair@popple.id.au, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, rcampbell@nvidia.com
Subject:  [merged] mm-migrate-fixup-setting-uffd_wp-flag.patch
 removed from -mm tree
Message-ID: <20200912162359.2w1E68d8N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fixup setting UFFD_WP flag
has been removed from the -mm tree.  Its filename was
     mm-migrate-fixup-setting-uffd_wp-flag.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Alistair Popple <alistair@popple.id.au>
Subject: mm/migrate: fixup setting UFFD_WP flag

Commit f45ec5ff16a75 ("userfaultfd: wp: support swap and page migration")
introduced support for tracking the uffd wp bit during page migration.=20
However the non-swap PTE variant was used to set the flag for zone device
private pages which are a type of swap page.

This leads to corruption of the swap offset if the original PTE has the
uffd_wp flag set.

Link: https://lkml.kernel.org/r/20200825064232.10023-1-alistair@popple.id.au
Fixes: f45ec5ff16a75 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Alistair Popple <alistair@popple.id.au>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fixup-setting-uffd_wp-flag
+++ a/mm/migrate.c
@@ -251,7 +251,7 @@ static bool remove_migration_pte(struct
 				entry =3D make_device_private_entry(new, pte_write(pte));
 				pte =3D swp_entry_to_pte(entry);
 				if (pte_swp_uffd_wp(*pvmw.pte))
-					pte =3D pte_mkuffd_wp(pte);
+					pte =3D pte_swp_mkuffd_wp(pte);
 			}
 		}
=20
_

Patches currently in -mm which might be from alistair@popple.id.au are


