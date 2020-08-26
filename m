Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056A9C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAC6020737
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598402317;
	bh=8Z9a+WbukkBQcYd76u+i0Ciw0aOZNlq2FBMIrWYUTl4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ce5UXStoHHDvDi3GvmLQaun8hfvrMplp+VXI8yBGioaaySV2jFOmCMXvdsP7B4fPw
	 mf8gd9M0xoJ6UXoXYQmuHGIZEbLYIB/GNFLR9mRpcY1YOdIGFg4XDaMnLFLiXm37vu
	 FFpaAOg+JgHiWepQbGcSUojuOnXDthmlZIFzL0D4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHZAih (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgHZAig (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:38:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E446420707;
        Wed, 26 Aug 2020 00:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598402316;
        bh=8Z9a+WbukkBQcYd76u+i0Ciw0aOZNlq2FBMIrWYUTl4=;
        h=Date:From:To:Subject:From;
        b=YZk45cRXcG4aNQ9YnxwZXKZ40EeW0osTW6Nth43pevmedw8e/c4ETNYae8uqjqde7
         bXzuKRsorvYqyoebZJnHuGRQK9W72Q2BJCh7BzpiJ/DbCA/Kx7I/opthusz+ypmNM4
         GfRVg76bzW7Kw5N8JGTuA2OcnBxbHigMaBxcKLPk=
Date:   Tue, 25 Aug 2020 17:38:35 -0700
From:   akpm@linux-foundation.org
To:     alistair@popple.id.au, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, rcampbell@nvidia.com
Subject:  + mm-migrate-fixup-setting-uffd_wp-flag.patch added to
 -mm tree
Message-ID: <20200826003835.1ROAQKh-p%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     mm-migrate-fixup-setting-uffd_wp-flag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fixup-setting-uffd=
_wp-flag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fixup-setting-uffd=
_wp-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-migrate-fixup-setting-uffd_wp-flag.patch
mm-rmap-fixup-copying-of-soft-dirty-and-uffd-ptes.patch

