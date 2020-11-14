Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7E1C63697
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 00:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA30022252
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 00:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0tww4Vn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgKNAUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:20:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgKNAUU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 19:20:20 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3EC12224D;
        Sat, 14 Nov 2020 00:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605313219;
        bh=qoEFZLsUlBep8/g62sJIIF6Sk1dujPciMnPZKVA+/CU=;
        h=Date:From:To:Subject:From;
        b=K0tww4VnxXMwXt+mxPwvatwC26S5LUOWq83/tBOsJH7WOWwIXfbzeJ0dYiGK0w3yd
         5nZEdLjuVYAObqbOPPt7IoshbEK4K0/LImWJeNEU1qMdLSsfKJbh9n/FzIdeXQRViH
         rcxjQOa7gltEKp0AgG5AGv7NCk9GU8NTJZJR189I=
Date:   Fri, 13 Nov 2020 16:20:19 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pankaj.gupta@cloud.ionos.com,
        sh_def@163.com
Subject:  +
 mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch added
 to -mm tree
Message-ID: <20201114002019.3py_vkIk5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_counter: use page_counter_read in page_counter_set_max
has been added to the -mm tree.  Its filename is
     mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

