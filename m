Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0F6C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiCVVox (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiCVVol (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4ED12771
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:43:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA80CB81DAD
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FC5C340EC;
        Tue, 22 Mar 2022 21:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985389;
        bh=2fw4V34BMaBWwfa8lGQogtWOuNUo51fHy2VVhad5FVo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=D7QK0v64JEml4OOpBVivrX3z4qSiP2SDe5UdQuX3UlhEiMIHfQPkkgU4uAJB8jteg
         sZ4NAuP5Um3Dm43Lb3SkTtv57rTWTycCqbYmn8JFKuny/gNuIXoRX/ep8FiUsc/plw
         gYt3rdYhPPhssQf7sBV2MS9moa43MVB9DbfnMhpk=
Date:   Tue, 22 Mar 2022 14:43:08 -0700
To:     peterz@infradead.org, mgorman@suse.de, andreyknvl@gmail.com,
        pcc@google.com, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 091/227] mm/mmzone.c: use try_cmpxchg() in page_cpupid_xchg_last()
Message-Id: <20220322214309.62FC5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
