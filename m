Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB1EEE49B1
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjHUUlc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjHUUkn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF26CC9
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DAA061CB0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D32C433C8;
        Mon, 21 Aug 2023 20:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650427;
        bh=sz1bILCgZagrVSaFNNxPJFCqpjVRPrJCkLjS/pPQge8=;
        h=Date:To:From:Subject:From;
        b=N2SRMdg2qCT9RHJpIK99r/mYXHFafELay1jv6PlH1tGN3o2xCrq8Vn6mwACGthNEu
         nGfUOoeQLj/T+OwtindeZKZBykOBnzS18nNQxaN7Xcp0kdlwR+niyhYpRc5fRKPhFS
         9hpdX1B2aJuKDx8qoL1/PytFE/ReV+/hi7bssn3s=
Date:   Mon, 21 Aug 2023 13:40:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        david@redhat.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfilec-use-helper-macro-k.patch removed from -mm tree
Message-Id: <20230821204027.70D32C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swapfile.c: use helper macro K()
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-use-helper-macro-k.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/swapfile.c: use helper macro K()
Date: Fri, 4 Aug 2023 09:25:54 +0800

Use helper macro K() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230804012559.2617515-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-use-helper-macro-k
+++ a/mm/swapfile.c
@@ -46,6 +46,7 @@
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
 #include <linux/swap_cgroup.h>
+#include "internal.h"
 #include "swap.h"
 
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
@@ -2635,8 +2636,8 @@ static int swap_show(struct seq_file *sw
 		return 0;
 	}
 
-	bytes = si->pages << (PAGE_SHIFT - 10);
-	inuse = READ_ONCE(si->inuse_pages) << (PAGE_SHIFT - 10);
+	bytes = K(si->pages);
+	inuse = K(READ_ONCE(si->inuse_pages));
 
 	file = si->swap_file;
 	len = seq_file_path(swap, file, " \t\n\\");
@@ -2861,8 +2862,7 @@ static unsigned long read_swap_header(st
 	}
 	if (last_page > maxpages) {
 		pr_warn("Truncating oversized swap area, only using %luk out of %luk\n",
-			maxpages << (PAGE_SHIFT - 10),
-			last_page << (PAGE_SHIFT - 10));
+			K(maxpages), K(last_page));
 	}
 	if (maxpages > last_page) {
 		maxpages = last_page + 1;
@@ -3184,8 +3184,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 	enable_swap_info(p, prio, swap_map, cluster_info);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
-		p->pages<<(PAGE_SHIFT-10), name->name, p->prio,
-		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
+		K(p->pages), name->name, p->prio, nr_extents,
+		K((unsigned long long)span),
 		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(p->flags & SWP_DISCARDABLE) ? "D" : "",
 		(p->flags & SWP_AREA_DISCARD) ? "s" : "",
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


