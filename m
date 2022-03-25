Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5492DC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357368AbiCYBeE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357384AbiCYBcw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD76ABD8B9
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 796CEB826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C436C340EC;
        Fri, 25 Mar 2022 01:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171857;
        bh=Zx3wo81JKFWwk00UtZwirulgnaIijzlsw0k9Vj369aU=;
        h=Date:To:From:Subject:From;
        b=upQvWl8Syllnz6QOKfwybuPFufGxhZR3t+a1Cs+FZ1Ztsn0wlrRIUyFHe0/XzTdxV
         Nns0gYaWhWi1bylTY8V4VGScj47XUGJ6/WOPtW0GUGQpsqQedXhAiFxYfCi3/zM3gm
         W70dhdAT3//jqcEogyDFfV4Av96ZGYtDX8LRHdjg=
Date:   Thu, 24 Mar 2022 18:30:56 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, rientjes@google.com,
        peterx@redhat.com, mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch removed from -mm tree
Message-Id: <20220325013057.1C436C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace multiple dcache flush with flush_dcache_folio()
has been removed from the -mm tree.  Its filename was
     mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: replace multiple dcache flush with flush_dcache_folio()

Simplify the code by using flush_dcache_folio().

Link: https://lkml.kernel.org/r/20220210123058.79206-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-replace-multiple-dcache-flush-with-flush_dcache_folio
+++ a/mm/migrate.c
@@ -916,12 +916,8 @@ static int move_to_new_page(struct page
 		if (!PageMappingFlags(page))
 			page->mapping = NULL;
 
-		if (likely(!is_zone_device_page(newpage))) {
-			int i, nr = compound_nr(newpage);
-
-			for (i = 0; i < nr; i++)
-				flush_dcache_page(newpage + i);
-		}
+		if (likely(!is_zone_device_page(newpage)))
+			flush_dcache_folio(page_folio(newpage));
 	}
 out:
 	return rc;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


