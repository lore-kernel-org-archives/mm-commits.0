Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A52ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiILDbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiILD3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D029328709
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D7BF6116D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D82C433D6;
        Mon, 12 Sep 2022 03:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953352;
        bh=ItpXn9CQZxB4/VLauUIb6KijIq9w54DLjTYExX9C0oM=;
        h=Date:To:From:Subject:From;
        b=KjBb8cOt7PPKadbDEWHKSDh+69HEtKqY+m2dIMN84wULLTSK6byk+WGnlqyroX5TJ
         QUcsTlRDhvebMUfoWhXzpzKkqoOEgIaSMHHz2ZmnQAreuk/0Gr1h1NmKUu7WvIVe3F
         gcq37h6MtkD7KKxP/1U1YB4nbrarDbcbs0CiUFog=
Date:   Sun, 11 Sep 2022 20:29:12 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, fengwei.yin@intel.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch removed from -mm tree
Message-Id: <20220912032912.C9D82C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix sysfs group leak in hugetlb_unregister_node()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix sysfs group leak in hugetlb_unregister_node()
Date: Tue, 16 Aug 2022 21:05:52 +0800

The sysfs group per_node_hstate_attr_group and hstate_demote_attr_group
when h->demote_order != 0 are created in hugetlb_register_node().  But
these sysfs groups are not removed when unregister the node, thus sysfs
group is leaked.  Using sysfs_remove_group() to fix this issue.

Link: https://lkml.kernel.org/r/20220816130553.31406-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Fengwei Yin <fengwei.yin@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node
+++ a/mm/hugetlb.c
@@ -3850,12 +3850,18 @@ static int hugetlb_sysfs_add_hstate(stru
 	}
 
 	if (h->demote_order) {
-		if (sysfs_create_group(hstate_kobjs[hi],
-					&hstate_demote_attr_group))
+		retval = sysfs_create_group(hstate_kobjs[hi],
+					    &hstate_demote_attr_group);
+		if (retval) {
 			pr_warn("HugeTLB unable to create demote interfaces for %s\n", h->name);
+			sysfs_remove_group(hstate_kobjs[hi], hstate_attr_group);
+			kobject_put(hstate_kobjs[hi]);
+			hstate_kobjs[hi] = NULL;
+			return retval;
+		}
 	}
 
-	return retval;
+	return 0;
 }
 
 static void __init hugetlb_sysfs_init(void)
@@ -3941,10 +3947,15 @@ static void hugetlb_unregister_node(stru
 
 	for_each_hstate(h) {
 		int idx = hstate_index(h);
-		if (nhs->hstate_kobjs[idx]) {
-			kobject_put(nhs->hstate_kobjs[idx]);
-			nhs->hstate_kobjs[idx] = NULL;
-		}
+		struct kobject *hstate_kobj = nhs->hstate_kobjs[idx];
+
+		if (!hstate_kobj)
+			continue;
+		if (h->demote_order)
+			sysfs_remove_group(hstate_kobj, &hstate_demote_attr_group);
+		sysfs_remove_group(hstate_kobj, &per_node_hstate_attr_group);
+		kobject_put(hstate_kobj);
+		nhs->hstate_kobjs[idx] = NULL;
 	}
 
 	kobject_put(nhs->hugepages_kobj);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

