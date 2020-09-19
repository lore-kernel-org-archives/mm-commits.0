Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3ADC43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38ED621D7B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475078;
	bh=l3eTSc495DvB41fqmqsQ5gDU9vp3Z4Sb0C4NDe0R6n0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IYn9VqX2wLPha9wZc/dXhdh2oyN7N11BS2ywz4Os60DimNV/tXgdOBfjm9ajD2cvd
	 9c3bKzF7rNcoElra6WH4rIQbmOGL1klF0l+0vw8M2/83IvkRxu3EMMyTOtjZ35DUkJ
	 b49fulqq7uUn/R9yzzTT4AsP1XEkhBY1tcx783V8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgISAYh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:37 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1639421D20;
        Sat, 19 Sep 2020 00:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475077;
        bh=l3eTSc495DvB41fqmqsQ5gDU9vp3Z4Sb0C4NDe0R6n0=;
        h=Date:From:To:Subject:From;
        b=RIFZX1txQWL1j8InEg4HZlwdk40F0jq3T9OOdGMtHkV39kjExxH3G54WQDSDrwgCm
         +TaKaG2jxMG9StDoKMFCfbOsMnKRmsyFlOfKkYxEjAd+R2oiCkGW+jmg6b5uMcOSU+
         wkmjSE4AY9NtS/cWflP/4ogQKauvTXm9INlvgnyw=
Date:   Fri, 18 Sep 2020 17:24:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, osalvador@suse.de,
        naoya.horiguchi@nec.com, dan.j.williams@intel.com, cai@lca.pw,
        songmuchun@bytedance.com
Subject:  [to-be-updated]
 mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch
 removed from -mm tree
Message-ID: <20200919002436.kuYCG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: fix return wrong value when isolate page fail
has been removed from the -mm tree.  Its filename was
     mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memory-failure: fix return wrong value when isolate page fail

When we isolate page fail, we should not return 0, because we do not
set page HWPoison on any page.

Link: https://lore.kernel.org/lkml/20200811220643.GB39857@lca.pw/
Link: http://lkml.kernel.org/r/20200830081053.64981-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Qian Cai <cai@lca.pw>
Reviewed-by: Qian Cai <cai@lca.pw>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2
+++ a/mm/memory-failure.c
@@ -1845,6 +1845,7 @@ static int __soft_offline_page(struct pa
 	} else {
 		pr_info("soft offline: %#lx: %s isolation failed: %d, page count %d, type %lx (%pGp)\n",
 			pfn, msg_page[huge], ret, page_count(page), page->flags, &page->flags);
+		ret = -EBUSY;
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch
mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch
mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch

