Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE23C25B0E
	for <mm-commits@archiver.kernel.org>; Tue, 16 Aug 2022 22:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbiHPWzd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Aug 2022 18:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237705AbiHPWzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2022 18:55:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15C463F0A
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 15:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9201B81B72
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 22:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E111C433C1;
        Tue, 16 Aug 2022 22:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660690519;
        bh=wtLRc+kgAcMD82tq0QFi7y9gcTFkYJ6ywobczqj/SCU=;
        h=Date:To:From:Subject:From;
        b=ujtzrBrFIMmdLU/nhE3YAjUfMErliHjNj0BzvqWtySJ9tViBL3CcAmb815sFXgF6P
         mhwvC+wdRrUw4IFWlksJ98fXi7f+EA9t0spEcy/XdtVmAL2fZT/NCnFYSqCOQ7A2ED
         dqLLrMNANUGuFbpAAqVZR0trP/b1D1Y46qj/hKsc=
Date:   Tue, 16 Aug 2022 15:55:18 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch added to mm-unstable branch
Message-Id: <20220816225519.5E111C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix sysfs group leak in hugetlb_unregister_node()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch
mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch
mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch

