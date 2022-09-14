Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9F0ECAAD3
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 22:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiINWxY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiINWxX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 18:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633F97823D
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 15:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DFEF61F6B
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 22:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE144C433D6;
        Wed, 14 Sep 2022 22:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663196000;
        bh=13TpO+44bmvXZWIwNvwHr8QXAT/fw+6YpPDAtmCUopU=;
        h=Date:To:From:Subject:From;
        b=QuYBx0AuBO4/aIdDf2ZHzTTbG0pBYBdfWxM6AIpJ86sMIAsDrULTFiYU6Es0BQG4Y
         toA5gCUUu7iPF/+f3Nfl7o6ZyK+0maNhWOKmmt5qGIsD/Yt0Up9LAMGnGWGeV8c8f2
         9TdOY4Fs1zy4phKfnganweuYIz//2Y0mr6+UtOlY=
Date:   Wed, 14 Sep 2022 15:53:19 -0700
To:     mm-commits@vger.kernel.org, kernel-bot@kylinos.cn,
        sunke@kylinos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-make-folio_put_wait_locked-static.patch added to mm-unstable branch
Message-Id: <20220914225320.AE144C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: make folio_put_wait_locked static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-make-folio_put_wait_locked-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-make-folio_put_wait_locked-static.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ke Sun <sunke@kylinos.cn>
Subject: mm/filemap: make folio_put_wait_locked static
Date: Wed, 14 Sep 2022 10:17:38 +0800

It's only used in mm/filemap.c, since commit <ffa65753c431>
("mm/migrate.c: rework migration_entry_wait() to not take a pageref").

Make it static.

Link: https://lkml.kernel.org/r/20220914021738.3228011-1-sunke@kylinos.cn
Signed-off-by: Ke Sun <sunke@kylinos.cn>
Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 mm/filemap.c            |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/pagemap.h~mm-filemap-make-folio_put_wait_locked-static
+++ a/include/linux/pagemap.h
@@ -1039,7 +1039,6 @@ static inline int wait_on_page_locked_ki
 	return folio_wait_locked_killable(page_folio(page));
 }
 
-int folio_put_wait_locked(struct folio *folio, int state);
 void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
--- a/mm/filemap.c~mm-filemap-make-folio_put_wait_locked-static
+++ a/mm/filemap.c
@@ -1460,7 +1460,7 @@ EXPORT_SYMBOL(folio_wait_bit_killable);
  *
  * Return: 0 if the folio was unlocked or -EINTR if interrupted by a signal.
  */
-int folio_put_wait_locked(struct folio *folio, int state)
+static int folio_put_wait_locked(struct folio *folio, int state)
 {
 	return folio_wait_bit_common(folio, PG_locked, state, DROP);
 }
_

Patches currently in -mm which might be from sunke@kylinos.cn are

mm-filemap-make-folio_put_wait_locked-static.patch

