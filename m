Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B281CC001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbjHKXBv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236964AbjHKXA2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3D13C04
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8FB767B6B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBD0C433C8;
        Fri, 11 Aug 2023 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794808;
        bh=5rh52zVAo2ZkVSRNEV1vKffFe9enXAipxvJvxEp9WFQ=;
        h=Date:To:From:Subject:From;
        b=O53Dcs8a0GolLXgIufEH/38m+ILvrUa7EIPs8jLr5r4JWVud15OPtpWg+rA1E6J3G
         rx2o3iYDUTWq2MUBLFakl3eyMjlGoeToFrkjyzgJUWbZnvTnZzVuucfqKknteZHkb8
         6Ix2HTB68FAjldfw5Zv4PaY0Tu+p+jctD1uyMjmY=
Date:   Fri, 11 Aug 2023 16:00:07 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-dont-account-hwpoison_filter-filtered-pages.patch removed from -mm tree
Message-Id: <20230811230008.1CBD0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: don't account hwpoison_filter() filtered pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-dont-account-hwpoison_filter-filtered-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memory-failure: don't account hwpoison_filter() filtered pages
Date: Tue, 11 Jul 2023 13:50:11 +0800

mf_generic_kill_procs() will return -EOPNOTSUPP when hwpoison_filter()
filtered dax page.  In that case, action_result() isn't expected to be
called to update mf_stats.  This will results in inaccurate but benign
memory failure handling statistics.

Link: https://lkml.kernel.org/r/20230711055016.2286677-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-dont-account-hwpoison_filter-filtered-pages
+++ a/mm/memory-failure.c
@@ -2098,7 +2098,8 @@ static int memory_failure_dev_pagemap(un
 out:
 	/* drop pgmap ref acquired in caller */
 	put_dev_pagemap(pgmap);
-	action_result(pfn, MF_MSG_DAX, rc ? MF_FAILED : MF_RECOVERED);
+	if (rc != -EOPNOTSUPP)
+		action_result(pfn, MF_MSG_DAX, rc ? MF_FAILED : MF_RECOVERED);
 	return rc;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

