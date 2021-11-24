Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7E8C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 03:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhKXD2z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhKXD2y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 22:28:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD9A160C51;
        Wed, 24 Nov 2021 03:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637724346;
        bh=I349qmJlRhYtOcGiEk36quL1VfImL/1meX9Lz1j+M1Y=;
        h=Date:From:To:Subject:From;
        b=Q2VcZzAxFjSMBZPaUOuqQFSBIow5i+6ZQ+4VwmK7l5GORl+uU2cVwMHf4TIV2URub
         kAR3JuKPFvP7l4S/wn0+z1x+OzTTmulHqFkDjKWvymTWdj9Gq5wKdWzSb5rKyrMzJu
         dY60O2JYol9pP3yuhIHNG8Uuv2gWWmo8ilf81x7c=
Date:   Tue, 23 Nov 2021 19:25:45 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        shy828301@gmail.com, willy@infradead.org
Subject:  +
 filemap-remove-pagehwpoison-check-from-next_uptodate_page.patch added to
 -mm tree
Message-ID: <20211124032545.nE5-W1DRE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: remove PageHWPoison check from next_uptodate_page()
has been added to the -mm tree.  Its filename is
     filemap-remove-pagehwpoison-check-from-next_uptodate_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/filemap-remove-pagehwpoison-check-from-next_uptodate_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/filemap-remove-pagehwpoison-check-from-next_uptodate_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: remove PageHWPoison check from next_uptodate_page()

Pages are individually marked as suffering from hardware poisoning. 
Checking that the head page is not hardware poisoned doesn't make sense;
we might be after a subpage.  We check each page individually before we
use it, so this was an optimisation gone wrong.

Link: https://lkml.kernel.org/r/20211120174429.2596303-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/filemap.c~filemap-remove-pagehwpoison-check-from-next_uptodate_page
+++ a/mm/filemap.c
@@ -3253,8 +3253,6 @@ static struct page *next_uptodate_page(s
 			goto skip;
 		if (!PageUptodate(page) || PageReadahead(page))
 			goto skip;
-		if (PageHWPoison(page))
-			goto skip;
 		if (!trylock_page(page))
 			goto skip;
 		if (page->mapping != mapping)
_

Patches currently in -mm which might be from willy@infradead.org are

filemap-remove-pagehwpoison-check-from-next_uptodate_page.patch
mmfs-split-dump_mapping-out-from-dump_page.patch

