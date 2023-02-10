Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC23C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjBJAyV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjBJAxp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:53:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E126F8DA
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C49B82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7896C433EF;
        Fri, 10 Feb 2023 00:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990385;
        bh=jyta8UDYADcyjCXWluhZ5E8lyYKjzKuyGZxg5jdf/1o=;
        h=Date:To:From:Subject:From;
        b=j8vBWM3MW+JbdIHAC+Cj/sHOuvYMzHEFIhPrpbsRLdTcGxbyvBNp6xIXQNQ2hU40M
         84mXu9WWoG2dHKJpKtWOUJCRzU1Ks/m5idLfG+98Lx31PlwGN8o6BJXlA0sWUo7sZr
         j6AgiF0qUAf1MJzPwvmpSakhZspSR1/oSg0kpma4=
Date:   Thu, 09 Feb 2023 16:53:05 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, lkp@intel.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch removed from -mm tree
Message-Id: <20230210005305.D7896C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr-test.h: stop using vma_mas_store() for maple tree store
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/damon/vaddr-test.h: stop using vma_mas_store() for maple tree store
Date: Fri, 20 Jan 2023 11:26:31 -0500

Prepare for the removal of the vma_mas_store() function by open coding the
maple tree store in this test code.  Set the range of the maple state and
call the store function directly.

Link: https://lkml.kernel.org/r/20230120162650.984577-31-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/mm/damon/vaddr-test.h~mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store
+++ a/mm/damon/vaddr-test.h
@@ -14,19 +14,26 @@
 
 #include <kunit/test.h>
 
-static void __link_vmas(struct maple_tree *mt, struct vm_area_struct *vmas,
+static int __link_vmas(struct maple_tree *mt, struct vm_area_struct *vmas,
 			ssize_t nr_vmas)
 {
-	int i;
+	int i, ret = -ENOMEM;
 	MA_STATE(mas, mt, 0, 0);
 
 	if (!nr_vmas)
-		return;
+		return 0;
 
 	mas_lock(&mas);
-	for (i = 0; i < nr_vmas; i++)
-		vma_mas_store(&vmas[i], &mas);
+	for (i = 0; i < nr_vmas; i++) {
+		mas_set_range(&mas, vmas[i].vm_start, vmas[i].vm_end - 1);
+		if (mas_store_gfp(&mas, &vmas[i], GFP_KERNEL))
+			goto failed;
+	}
+
+	ret = 0;
+failed:
 	mas_unlock(&mas);
+	return ret;
 }
 
 /*
@@ -71,7 +78,8 @@ static void damon_test_three_regions_in_
 	};
 
 	mt_init_flags(&mm.mm_mt, MM_MT_FLAGS);
-	__link_vmas(&mm.mm_mt, vmas, ARRAY_SIZE(vmas));
+	if (__link_vmas(&mm.mm_mt, vmas, ARRAY_SIZE(vmas)))
+		kunit_skip(test, "Failed to create VMA tree");
 
 	__damon_va_three_regions(&mm, regions);
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


