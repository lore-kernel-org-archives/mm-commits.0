Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5E4CA0EF1
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 17:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbjILRNT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbjILRNQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 13:13:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217C21708
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 10:13:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A81AC433C8;
        Tue, 12 Sep 2023 17:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694538791;
        bh=jOGTEOveC0ctDUd03/RXjpitknO6ly5BnNcu2Amu8W8=;
        h=Date:To:From:Subject:From;
        b=RdDMdPqogD5FBOdKrdic2socbAwmOyob0OVaHJ7D1ccmqgSgbySe2En1OxRj4BaF2
         AI9Ys8zX7368vynBJ4e4jfXe/BzEKn4efFkubQhbXyqumMiBdGxjrfpNvo3FCa43qg
         wFLZ+scVftcDdKGQ0sKF6+u3bw+kwqEzwXN3feO4=
Date:   Tue, 12 Sep 2023 10:13:10 -0700
To:     mm-commits@vger.kernel.org, liujinlong@kylinos.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-modify-an-easily-misunderstood-function-name.patch added to mm-unstable branch
Message-Id: <20230912171311.7A81AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: modify an easily misunderstood function name
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-modify-an-easily-misunderstood-function-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-modify-an-easily-misunderstood-function-name.patch

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
From: liujinlong <liujinlong@kylinos.cn>
Subject: mm: vmscan: modify an easily misunderstood function name
Date: Tue, 12 Sep 2023 16:59:23 +0800

When looking at the code in the memory part, I found that the purpose of
the function prepare_scan_countis very different from the function name. 
It is easy to misunderstand when reading.The function prepare_scan_count
mainly completes the assignment of the scan_control structure.Therefore, I
suggest that the function name can be changed to prepare_scan_control,
which is easier to understand.

Link: https://lkml.kernel.org/r/20230912085923.27238-1-liujinlong@kylinos.cn
Signed-off-by: liujinlong <liujinlong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-modify-an-easily-misunderstood-function-name
+++ a/mm/vmscan.c
@@ -2233,7 +2233,7 @@ enum scan_balance {
 	SCAN_FILE,
 };
 
-static void prepare_scan_count(pg_data_t *pgdat, struct scan_control *sc)
+static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 {
 	unsigned long file;
 	struct lruvec *target_lruvec;
@@ -5859,7 +5859,7 @@ again:
 	nr_reclaimed = sc->nr_reclaimed;
 	nr_scanned = sc->nr_scanned;
 
-	prepare_scan_count(pgdat, sc);
+	prepare_scan_control(pgdat, sc);
 
 	shrink_node_memcgs(pgdat, sc);
 
_

Patches currently in -mm which might be from liujinlong@kylinos.cn are

mm-vmscan-modify-an-easily-misunderstood-function-name.patch

