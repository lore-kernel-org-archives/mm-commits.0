Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51002C19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbiG3BJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239738AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE4187C3C
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49B14B82926
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1995C433D6;
        Sat, 30 Jul 2022 01:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143328;
        bh=zZ5SMuivlHQlP0eZBUwmQwFJIAyS3r9p9UhyQE3giHU=;
        h=Date:To:From:Subject:From;
        b=A3l8qyCI86IAFfjryCaxtqraB/DOC3Rz+f/deZG/JFGyDilZMfgHFyTFOaY9VjUus
         L+qs4VYlFn3DW3XjAsHFk4a0S5esjbZL1SVvmfzg5TrqnvH2dSUUZduwAZ9ZOhAjDa
         /ZNVsko5RViYmqgwMJWrCLBCL3O3AKU3Z3KMV7fw=
Date:   Fri, 29 Jul 2022 18:08:47 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-remove-unneeded-hugetlbfs_ops-forward-declaration.patch removed from -mm tree
Message-Id: <20220730010847.E1995C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: remove unneeded hugetlbfs_ops forward declaration
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-unneeded-hugetlbfs_ops-forward-declaration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: remove unneeded hugetlbfs_ops forward declaration
Date: Tue, 26 Jul 2022 22:29:15 +0800

The forward declaration for hugetlbfs_ops is unnecessary.  Remove it.

Link: https://lkml.kernel.org/r/20220726142918.51693-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-remove-unneeded-hugetlbfs_ops-forward-declaration
+++ a/fs/hugetlbfs/inode.c
@@ -40,7 +40,6 @@
 #include <linux/uaccess.h>
 #include <linux/sched/mm.h>
 
-static const struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
 const struct file_operations hugetlbfs_file_operations;
 static const struct inode_operations hugetlbfs_dir_inode_operations;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

