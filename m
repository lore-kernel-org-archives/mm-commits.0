Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBFFC6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiILDbT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiILD3a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F161A28702
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99BD4B80C76
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389F8C433D6;
        Mon, 12 Sep 2022 03:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953349;
        bh=nqWBRHB7tFF54mE1QvuGNMqQuLESgxscP+Y0rLTyV18=;
        h=Date:To:From:Subject:From;
        b=OqGzcHmyguXEBVIQCjYR/dyCZ6GXY2iXWQbqhkWFkuIC3CVREOZ09MlTJGf8fUq46
         YBG8+emeUms0lp6/K+j9zDtpxozUG920HTITKTofNMBi1G0qKh7WfSQSbFSwH1329j
         VNPCrx/xW4bBarW2n+yFLEtn6JLPWO1byug9m7yM=
Date:   Sun, 11 Sep 2022 20:29:08 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch removed from -mm tree
Message-Id: <20220912032909.389F8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix WARN_ON(!kobj) in sysfs_create_group()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix WARN_ON(!kobj) in sysfs_create_group()
Date: Tue, 16 Aug 2022 21:05:49 +0800

If sysfs_create_group() fails with hstate_attr_group, hstate_kobjs[hi]
will be set to NULL.  Then it will be passed to sysfs_create_group() if
h->demote_order != 0 thus triggering WARN_ON(!kobj) check.  Fix this by
making sure hstate_kobjs[hi] != NULL when calling sysfs_create_group.

Link: https://lkml.kernel.org/r/20220816130553.31406-3-linmiaohe@huawei.com
Fixes: 79dfc695525f ("hugetlb: add demote hugetlb page sysfs interfaces")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group
+++ a/mm/hugetlb.c
@@ -3846,6 +3846,7 @@ static int hugetlb_sysfs_add_hstate(stru
 	if (retval) {
 		kobject_put(hstate_kobjs[hi]);
 		hstate_kobjs[hi] = NULL;
+		return retval;
 	}
 
 	if (h->demote_order) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

