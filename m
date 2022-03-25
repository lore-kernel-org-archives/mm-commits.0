Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1DFC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357389AbiCYBdz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357457AbiCYBdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1D2BF50F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A356618F6
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E3BC340EC;
        Fri, 25 Mar 2022 01:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171876;
        bh=Mmrc8+0QfbS4ie9WQxkhqxqOstNPLZ9P6n0NDU6MHZk=;
        h=Date:To:From:Subject:From;
        b=nWXe6VDMRAcWOwUtPc1xLFIgRKL2b5BEaoJXFaEM3jDzvKxFxOhTHXG64blWG1FGp
         rHeht7eNzr3AaLTyys18B8G+de6OId5a7IESnphSqvqQMyvFnLL9rRCuUGKoHYHVJ6
         vlepBaryVOF5sar8AkHrwGbQ6x6akcf1/Rxqz118=
Date:   Thu, 24 Mar 2022 18:31:16 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org, mgorman@suse.de,
        andreyknvl@gmail.com, pcc@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mmzonec-use-try_cmpxchg-in-page_cpupid_xchg_last.patch removed from -mm tree
Message-Id: <20220325013116.B4E3BC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmzone.c: use try_cmpxchg() in page_cpupid_xchg_last()
has been removed from the -mm tree.  Its filename was
     mm-mmzonec-use-try_cmpxchg-in-page_cpupid_xchg_last.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kasan-update-function-name-in-comments.patch

