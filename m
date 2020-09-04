Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFC1C43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB0FD208C7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262560;
	bh=qsweA78ZdcuiRQlthDWALdt7wAoXJpkxDQexeRQbdic=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0ji5dofchpQHbuySIihcepttOOOvwL0f0VkDVeOAa5nFtTvpxdQ4lJPNqvhx4O0Ab
	 y1pZUrjQcSkUPAgiRA18+dPRpZNUr6WTt0gwrixu9T52I+wgu1EK0eEHxA/NBppaIG
	 JrLeD/OF5MwsvNx1T9+Tx9ht2D7GZyoUvUsPefwY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgIDXgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXf7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D9FF2084D;
        Fri,  4 Sep 2020 23:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262558;
        bh=qsweA78ZdcuiRQlthDWALdt7wAoXJpkxDQexeRQbdic=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jGeZTtca/by5CTh8ULcQu2FvG0NLuTNQQRnAmNwj0iYjL6tCVdhX47QuFbj6SQ/Q1
         yJRLaoNnfCg9WBMdIPUL/ey57IpJNiCWs9X9t9Lyl+HBG8wBy6xD3hDVi4o//CM2GN
         b39sgH03qF37X2+dJMAzfqqbFtTKnql9OGc1cgtc=
Date:   Fri, 04 Sep 2020 16:35:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alistair@popple.id.au,
        jglisse@redhat.com, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, torvalds@linux-foundation.org
Subject:  [patch 12/19] mm/migrate: fixup setting UFFD_WP flag
Message-ID: <20200904233558.ivUQZ2xpI%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
