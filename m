Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C48C433ED
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B4B9610E9
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 22:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhDKWgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 18:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235229AbhDKWgF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 11 Apr 2021 18:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A56AC611AD;
        Sun, 11 Apr 2021 22:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618180548;
        bh=IP48dCEonhr85A25DZZ5Nd9IiQQJOAyy/fsK23EbMsY=;
        h=Date:From:To:Subject:From;
        b=DDZVlRg5PBRwAOUbiGWk0Hh3YJlg1I/EjCLJsxHgSHsARShLIGrNxWT0BSewfo1Ff
         ro6Zm0ZPWM8ZifWiIl9qyjxHo2gLHDxwl/IiAKqSTSfm5oGY9cwfdPJuNP2dkFw3o4
         JEclfvewo7ld4Y/poo0bkikaRNJtQhrHJX8qRiNI=
Date:   Sun, 11 Apr 2021 15:35:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, thomas_os@shipmail.org,
        zackr@vmware.com
Subject:  + mm-mapping_dirty_helpers-guard-hugepage-puds-usage.patch
 added to -mm tree
Message-ID: <20210411223548.nI_XO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mapping_dirty_helpers: guard hugepage pud's usage
has been added to the -mm tree.  Its filename is
     mm-mapping_dirty_helpers-guard-hugepage-puds-usage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mapping_dirty_helpers-guar=
d-hugepage-puds-usage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mapping_dirty_helpers-guar=
d-hugepage-puds-usage.patch

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
From: Zack Rusin <zackr@vmware.com>
Subject: mm/mapping_dirty_helpers: guard hugepage pud's usage

Mapping dirty helpers have, so far, been only used on X86, but a port of
vmwgfx to ARM64 exposed a problem which results in a compilation error on
ARM64 systems:

mm/mapping_dirty_helpers.c: In function `wp_clean_pud_entry':
mm/mapping_dirty_helpers.c:172:32: error: implicit declaration of function =
`pud_dirty'; did you mean `pmd_dirty'? [-Werror=3Dimplicit-function-declara=
tion]

This is due to the fact that mapping_dirty_helpers code assumes that
pud_dirty is always defined, which is not the case for architectures that
don't define CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.

ARM64 arch is a little inconsistent when it comes to PUD hugepage helpers,
e.g.  it defines pud_young but not pud_dirty but regardless of that the
core kernel code shouldn't assume that any of the PUD hugepage helpers are
available unless CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is defined.=20
This prevents compilation errors whenever one of the drivers is ported to
new architectures.

Link: https://lkml.kernel.org/r/20210409165151.694574-1-zackr@vmware.com
Signed-off-by: Zack Rusin <zackr@vmware.com>
Cc: Thomas Hellstr=C3=B6m (Intel) <thomas_os@shipmail.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mapping_dirty_helpers.c~mm-mapping_dirty_helpers-guard-hugepage-pu=
ds-usage
+++ a/mm/mapping_dirty_helpers.c
@@ -165,10 +165,12 @@ static int wp_clean_pud_entry(pud_t *pud
 		return 0;
 	}
=20
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 	/* Huge pud */
 	walk->action =3D ACTION_CONTINUE;
 	if (pud_trans_huge(pudval) || pud_devmap(pudval))
 		WARN_ON(pud_write(pudval) || pud_dirty(pudval));
+#endif
=20
 	return 0;
 }
_

Patches currently in -mm which might be from zackr@vmware.com are

mm-mapping_dirty_helpers-guard-hugepage-puds-usage.patch

