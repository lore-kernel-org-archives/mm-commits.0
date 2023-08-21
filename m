Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BA0EE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjHUUlw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjHUUkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1740CD7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930A7637B0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EFEC433C8;
        Mon, 21 Aug 2023 20:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650433;
        bh=ky6HEROLsCRvVJs82OTrVHxddBYN3gxyDHJ2n/KFEZo=;
        h=Date:To:From:Subject:From;
        b=HWxPPzCDtIC/EueNOQJjH4zEi0qxj+BM6956q3jiCDsNy4A/qPS4bwAAvYjExeBoF
         HZqOapNxQgB8KyD/JCWrQCiGNcfTiEXsl0NS8LRo/5ZqRGxwbNg3rHrG6uTuLXWWtB
         9yL3o313jAQBPUT6afglCGqhPYwQowXnu36iMZo8=
Date:   Mon, 21 Aug 2023 13:40:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        david@redhat.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlbc-use-helper-macro-k.patch removed from -mm tree
Message-Id: <20230821204032.E5EFEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb.c: use helper macro K()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-use-helper-macro-k.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/hugetlb.c: use helper macro K()
Date: Fri, 4 Aug 2023 09:25:59 +0800

Use helper macro K() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230804012559.2617515-8-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlbc-use-helper-macro-k
+++ a/mm/hugetlb.c
@@ -4748,7 +4748,7 @@ void hugetlb_show_meminfo_node(int nid)
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm)
 {
 	seq_printf(m, "HugetlbPages:\t%8lu kB\n",
-		   atomic_long_read(&mm->hugetlb_usage) << (PAGE_SHIFT - 10));
+		   K(atomic_long_read(&mm->hugetlb_usage)));
 }
 
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


