Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F93BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 06:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244197AbiAYGZH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:25:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34642 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343509AbiAYGWl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 01:22:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A3DD60A28
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 06:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77FFC340E0;
        Tue, 25 Jan 2022 06:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643091752;
        bh=OSLWJh0VfX1zHR9sDxRCUTw7HFLArts6wW0VeDoXLc8=;
        h=Date:From:To:Subject:From;
        b=t9z/1S46Nu2rvAWnsBgOKUHi2/Gd23paEmvWXYO2wvbZLVFdw0TaqwHjv7TMN4nOn
         3nXTSsNhScH3Oj0RTNNnIjzx0kVX/ihAYbFsCn5eU0LUXRvTQF22qjXIvCnRzxw4Ic
         oVyPddK6hMfSckoUGKBNubevQsqdT/Tfz0Dl1+vA=
Date:   Mon, 24 Jan 2022 22:22:32 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, mgorman@suse.de, mm-commits@vger.kernel.org,
        pcc@google.com, peterz@infradead.org
Subject:  +
 mm-mmzonec-use-try_cmpxchg-in-page_cpupid_xchg_last.patch added to -mm tree
Message-ID: <20220125062232.n-Oeqr36F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmzone.c: use try_cmpxchg() in page_cpupid_xchg_last()
has been added to the -mm tree.  Its filename is
     mm-mmzonec-use-try_cmpxchg-in-page_cpupid_xchg_last.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmzonec-use-try_cmpxchg-in-page_cpupid_xchg_last.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmzonec-use-try_cmpxchg-in-page_cpupid_xchg_last.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: mm/mmzone.c: use try_cmpxchg() in page_cpupid_xchg_last()

This will let us avoid an additional read from page->flags when retrying
the compare-exchange on some architectures.

Link: https://lkml.kernel.org/r/20220120011200.1322836-1-pcc@google.com
Link: https://linux-review.googlesource.com/id/I2e1f5b5b080ac9c4e0eb7f98768dba6fd7821693
Signed-off-by: Peter Collingbourne <pcc@google.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmzone.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/mmzone.c~mm-mmzonec-use-try_cmpxchg-in-page_cpupid_xchg_last
+++ a/mm/mmzone.c
@@ -89,13 +89,14 @@ int page_cpupid_xchg_last(struct page *p
 	unsigned long old_flags, flags;
 	int last_cpupid;
 
+	old_flags = READ_ONCE(page->flags);
 	do {
-		old_flags = flags = page->flags;
-		last_cpupid = page_cpupid_last(page);
+		flags = old_flags;
+		last_cpupid = (flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
 
 		flags &= ~(LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
 		flags |= (cpupid & LAST_CPUPID_MASK) << LAST_CPUPID_PGSHIFT;
-	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
+	} while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)));
 
 	return last_cpupid;
 }
_

Patches currently in -mm which might be from pcc@google.com are

mm-use-compare-exchange-operation-to-set-kasan-page-tag.patch
mm-mmzonec-use-try_cmpxchg-in-page_cpupid_xchg_last.patch

