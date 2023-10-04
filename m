Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BABE936E7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243807AbjJDUc1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244757AbjJDUU5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:20:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6875510D
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:20:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A794FC433C9;
        Wed,  4 Oct 2023 20:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450852;
        bh=wlt32fyqxVrqAdIl3O02mT7dYK0HNFz5W7TlekkuI0E=;
        h=Date:To:From:Subject:From;
        b=M2sepvtpOeMAPpdTq48ox40ELkvN5CTKGLXJJikNKuEWyV0zvME8fuJ9rwUjYy+aH
         BG85raEgWg89KNlLMPfqQ9wk6hMUOVFSNhCYjTMg/1XI1kbF8Gc05REddcBOKbtrIy
         OEj+MeAbldOIo6fKdCfUiGxGJbr3CCpUJ8gOw3v0=
Date:   Wed, 04 Oct 2023 13:20:51 -0700
To:     mm-commits@vger.kernel.org, liujinlong@kylinos.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-modify-an-easily-misunderstood-function-name.patch removed from -mm tree
Message-Id: <20231004202052.A794FC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: modify an easily misunderstood function name
has been removed from the -mm tree.  Its filename was
     mm-vmscan-modify-an-easily-misunderstood-function-name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2208,7 +2208,7 @@ enum scan_balance {
 	SCAN_FILE,
 };
 
-static void prepare_scan_count(pg_data_t *pgdat, struct scan_control *sc)
+static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 {
 	unsigned long file;
 	struct lruvec *target_lruvec;
@@ -5834,7 +5834,7 @@ again:
 	nr_reclaimed = sc->nr_reclaimed;
 	nr_scanned = sc->nr_scanned;
 
-	prepare_scan_count(pgdat, sc);
+	prepare_scan_control(pgdat, sc);
 
 	shrink_node_memcgs(pgdat, sc);
 
_

Patches currently in -mm which might be from liujinlong@kylinos.cn are


