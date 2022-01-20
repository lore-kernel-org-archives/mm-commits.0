Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FD9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377836AbiATVZP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347688AbiATVZO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:25:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D98C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F059FB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90360C340E0;
        Thu, 20 Jan 2022 21:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713911;
        bh=10dSTDlAGlDB9JEofv3JFhwBSG/8ixZj7zL+HDYQltU=;
        h=Date:From:To:Subject:From;
        b=s2p4V+flmOZ9oHpKe+rHDyVZawmtCXuCJkHWp3pVpayWjHsA2Osy8kTZQYgmXyngG
         ZiMN2zudRxK7K9zU18svmDVkkZyJU+KdHOaZEOzsWqOYjv126sFPeh0b74ZL2C1NqF
         mTnMBRuR+m7EJ4b+7bjhP3045a3epX3kdcqxlXSM=
Date:   Thu, 20 Jan 2022 13:25:11 -0800
From:   akpm@linux-foundation.org
To:     chi.minghao@zte.com.cn, mm-commits@vger.kernel.org,
        zealci@zte.com.cn
Subject:  [merged] selftests-vm-use-swap-to-make-code-cleaner.patch
 removed from -mm tree
Message-ID: <20220120212511.s_JnMIkzE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner
has been removed from the -mm tree.  Its filename was
     selftests-vm-use-swap-to-make-code-cleaner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: chiminghao <chi.minghao@zte.com.cn>
Subject: tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner

Fix the following coccicheck REVIEW:
./tools/testing/selftests/vm/userfaultfd.c:1531:21-22:use swap() to make
code cleaner

Link: https://lkml.kernel.org/r/20211124031632.35317-1-chi.minghao@zte.com.cn
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~selftests-vm-use-swap-to-make-code-cleaner
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1417,7 +1417,6 @@ static void userfaultfd_pagemap_test(uns
 static int userfaultfd_stress(void)
 {
 	void *area;
-	char *tmp_area;
 	unsigned long nr;
 	struct uffdio_register uffdio_register;
 	struct uffd_stats uffd_stats[nr_cpus];
@@ -1528,13 +1527,9 @@ static int userfaultfd_stress(void)
 					    count_verify[nr], nr);
 
 		/* prepare next bounce */
-		tmp_area = area_src;
-		area_src = area_dst;
-		area_dst = tmp_area;
-
-		tmp_area = area_src_alias;
-		area_src_alias = area_dst_alias;
-		area_dst_alias = tmp_area;
+		swap(area_src, area_dst);
+
+		swap(area_src_alias, area_dst_alias);
 
 		uffd_stats_report(uffd_stats, nr_cpus);
 	}
_

Patches currently in -mm which might be from chi.minghao@zte.com.cn are

ipc-sem-do-not-sleep-with-a-spin-lock-held.patch

