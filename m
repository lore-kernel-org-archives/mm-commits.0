Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEA7C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJCVO2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJCVMm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:12:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4AB5280D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42D2FB81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA90C433D6;
        Mon,  3 Oct 2022 21:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831268;
        bh=f8O90ltYkR4sf6xQgL65cep5GNs2ZgV3f+nEdxh/GEA=;
        h=Date:To:From:Subject:From;
        b=XIbiopZQhyhn2Pqd1DpeawRy7kgoZgmu/SeKFpm128kRb5EC0qtrrELiafaWU8ZXX
         /QBfOa3/eCQzjNGfu+YKC1rXK+RoQr8lcdewvY5qZuYxRich+o5Mvd9TPOakTDhzRI
         KghzWLcpCs2YP7a6fT6aN1XKL6bFz8jkoMKqXa28=
Date:   Mon, 03 Oct 2022 14:07:47 -0700
To:     mm-commits@vger.kernel.org, kernel-bot@kylinos.cn,
        sunke@kylinos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-make-folio_put_wait_locked-static.patch removed from -mm tree
Message-Id: <20221003210747.EFA90C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/filemap: make folio_put_wait_locked static
has been removed from the -mm tree.  Its filename was
     mm-filemap-make-folio_put_wait_locked-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


