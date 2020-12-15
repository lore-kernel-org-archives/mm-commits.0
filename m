Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AECC47435
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 497A122DA9
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgLOX7y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:32826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729881AbgLOX0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:08 -0500
Date:   Tue, 15 Dec 2020 15:18:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074314;
        bh=uUTkZ+Ysvq9vrx54l0aNPldzVMHq2/v7QFOOtNUxoS4=;
        h=From:To:Subject:From;
        b=Wpa5SD73OgbGgFbh4X0Jeh+1ppV8oyD83NfU6Y9rzczJIWs+FSxQCiprGUxFVspQS
         g5kWOwOW0pYMkJgjCCr041vkUCmetxB8MmFh27SSzYuKE1AgIUm56Q0eR+JTQLWmBN
         YM7dv7AutsKjs7poE3X1gOouLEe/pJoo1pzLPv1A=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pankaj.gupta@cloud.ionos.com,
        sh_def@163.com
Subject:  [merged]
 mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch removed
 from -mm tree
Message-ID: <20201215231834.X9DoSIoi9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_counter: use page_counter_read in page_counter_set_max
has been removed from the -mm tree.  Its filename was
     mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/page_counter: use page_counter_read in page_counter_set_max

Use page_counter_read() in page_counter_set_max().

Link: https://lkml.kernel.org/r/20201113141048.GA178922@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-use-page_counter_read-in-page_counter_set_max
+++ a/mm/page_counter.c
@@ -183,14 +183,14 @@ int page_counter_set_max(struct page_cou
 		 * the limit, so if it sees the old limit, we see the
 		 * modified counter and retry.
 		 */
-		usage = atomic_long_read(&counter->usage);
+		usage = page_counter_read(counter);
 
 		if (usage > nr_pages)
 			return -EBUSY;
 
 		old = xchg(&counter->max, nr_pages);
 
-		if (atomic_long_read(&counter->usage) <= usage)
+		if (page_counter_read(counter) <= usage)
 			return 0;
 
 		counter->max = old;
_

Patches currently in -mm which might be from sh_def@163.com are

fs-proc-make-pde_get-return-nothing.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

