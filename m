Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A13FE94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbjJFVsd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbjJFVsc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E5FBE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ACAC433C7;
        Fri,  6 Oct 2023 21:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628911;
        bh=/Y4wMDJKF5hc/bAl/AzQRAl3U15PToa+kYUaM99sK9k=;
        h=Date:To:From:Subject:From;
        b=k4vx3WXY892t1uGkKdbFQmEyFJfLMPgrvyOpO2/F5hKZ0SY+wZBfmIy9wC3JhjiqY
         unAoapPFQfnvW0DYpHZQnDGhfJ0wxGd7IHU2J2m/aNZvt9arvVqdBebYVYpfi+weLW
         IbIVLH0F3bkMcCL1A7wd5Vw76ZleeNI1xxIog4PM=
Date:   Fri, 06 Oct 2023 14:48:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        usama.arif@bytedance.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-replace-page_ref_freeze-with-folio_ref_freeze-in-hugetlb_folio_init_vmemmap.patch removed from -mm tree
Message-Id: <20231006214830.D7ACAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: replace page_ref_freeze() with folio_ref_freeze() in hugetlb_folio_init_vmemmap()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-replace-page_ref_freeze-with-folio_ref_freeze-in-hugetlb_folio_init_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: replace page_ref_freeze() with folio_ref_freeze() in hugetlb_folio_init_vmemmap()
Date: Tue, 26 Sep 2023 10:44:33 -0700

No functional difference, folio_ref_freeze() is currently a wrapper for
page_ref_freeze().

Link: https://lkml.kernel.org/r/20230926174433.81241-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com> 
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-replace-page_ref_freeze-with-folio_ref_freeze-in-hugetlb_folio_init_vmemmap
+++ a/mm/hugetlb.c
@@ -3191,7 +3191,7 @@ static void __init hugetlb_folio_init_vm
 	/* Prepare folio head */
 	__folio_clear_reserved(folio);
 	__folio_set_head(folio);
-	ret = page_ref_freeze(&folio->page, 1);
+	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
 	/* Initialize the necessary tail struct pages */
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


