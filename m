Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7BFC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 11 Nov 2022 23:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiKKXQG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Nov 2022 18:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKKXQF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Nov 2022 18:16:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B87CE04
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 15:16:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13DE3B8280A
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 23:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45B9C433D6;
        Fri, 11 Nov 2022 23:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668208561;
        bh=wst2qJaRjG78zKzu5ciQaj6Rekbi7+24n6rGHcfYGDI=;
        h=Date:To:From:Subject:From;
        b=SNz9I9Fd4nNmEGAP5QLM85lkr3f3aDSkTU9nBucWv8APdfuZ5Nk1fV+I4cuYBP3ml
         PCMTh2bJDUDYQkO4fyGga7+QYyBotdFO1fkNQX+SHDl5toNBGXMIvBtERfI6FnlqvY
         21JACVbB0SyBFFWuyrpNgKONUQ366ZuV1Gea7CSU=
Date:   Fri, 11 Nov 2022 15:16:00 -0800
To:     mm-commits@vger.kernel.org, Chao.Xu9@zeekrlife.com,
        amos.xuchao@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-simplify-the-nr-assignment-logic-for-pages-to-scan.patch added to mm-unstable branch
Message-Id: <20221111231601.A45B9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: simplify the nr assignment logic for pages to scan
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-simplify-the-nr-assignment-logic-for-pages-to-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-simplify-the-nr-assignment-logic-for-pages-to-scan.patch

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
From: Chao Xu <amos.xuchao@gmail.com>
Subject: mm/vmscan: simplify the nr assignment logic for pages to scan
Date: Thu, 10 Nov 2022 19:31:30 +0800

By default the assignment logic of anonymouns or file inactive pages and
active pages to scan using the same duplicated code snippet.  To simplify
the logic, merge the same part.

Link: https://lkml.kernel.org/r/20221110113130.284290-1-Chao.Xu9@zeekrlife.com
Signed-off-by: Chao Xu <Chao.Xu9@zeekrlife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-simplify-the-nr-assignment-logic-for-pages-to-scan
+++ a/mm/vmscan.c
@@ -5950,14 +5950,11 @@ static void shrink_lruvec(struct lruvec
 		 * scan target and the percentage scanning already complete
 		 */
 		lru = (lru == LRU_FILE) ? LRU_BASE : LRU_FILE;
-		nr_scanned = targets[lru] - nr[lru];
-		nr[lru] = targets[lru] * (100 - percentage) / 100;
-		nr[lru] -= min(nr[lru], nr_scanned);
-
-		lru += LRU_ACTIVE;
-		nr_scanned = targets[lru] - nr[lru];
-		nr[lru] = targets[lru] * (100 - percentage) / 100;
-		nr[lru] -= min(nr[lru], nr_scanned);
+		for ( ; lru <= lru + LRU_ACTIVE; lru += LRU_ACTIVE) {
+			nr_scanned = targets[lru] - nr[lru];
+			nr[lru] = targets[lru] * (100 - percentage) / 100;
+			nr[lru] -= min(nr[lru], nr_scanned);
+		}
 
 		scan_adjusted = true;
 	}
_

Patches currently in -mm which might be from amos.xuchao@gmail.com are

mm-vmscan-simplify-the-nr-assignment-logic-for-pages-to-scan.patch

