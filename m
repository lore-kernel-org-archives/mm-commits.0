Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB941C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241959AbiCYBeX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357568AbiCYBdY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392EBBF509
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D72B0B8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE51C340ED;
        Fri, 25 Mar 2022 01:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171909;
        bh=IwPOZ+lQRzwPODf0iLt6rY4oat8WDqDdJsuqSbiPoUE=;
        h=Date:To:From:Subject:From;
        b=j8bl/THwXRoYUrP0BGPUB93VuQMqB1KAeGhfRIPr7INtMila1l6nh13X3ns0aKTT0
         Dh+H+gfzjHCEoS5StvKfhAcGcjKtLi1IERLZFu+h6e1FYK9Wk1lg3hZTDuf/CZs8vo
         0EihIn0G5+t5UAIpnWaroGQJNJ6XpMrQu3pxs4Kg=
Date:   Thu, 24 Mar 2022 18:31:48 -0700
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        tglx@linutronix.de, naoya.horiguchi@nec.com, mingo@redhat.com,
        linmiaohe@huawei.com, hpa@zytor.com, dave.hansen@linux.intel.com,
        bp@alien8.de, luofei@unicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch removed from -mm tree
Message-Id: <20220325013149.7FE51C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: add in-use hugepage hwpoison filter judgement
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: luofei <luofei@unicloud.com>
Subject: mm/hwpoison: add in-use hugepage hwpoison filter judgement

After successfully obtaining the reference count of the huge page, it is
still necessary to call hwpoison_filter() to make a filter judgement,
otherwise the filter hugepage will be unmaped and the related process may
be killed.

Link: https://lkml.kernel.org/r/20220223082254.2769757-1-luofei@unicloud.com
Signed-off-by: luofei <luofei@unicloud.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory-failure.c~mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement
+++ a/mm/memory-failure.c
@@ -1534,6 +1534,14 @@ static int memory_failure_hugetlb(unsign
 	lock_page(head);
 	page_flags = head->flags;
 
+	if (hwpoison_filter(p)) {
+		if (TestClearPageHWPoison(head))
+			num_poisoned_pages_dec();
+		put_page(p);
+		res = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/*
 	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
 	 * simply disable it. In order to make it work properly, we need
_

Patches currently in -mm which might be from luofei@unicloud.com are


