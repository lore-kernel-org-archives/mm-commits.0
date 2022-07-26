Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFC4C04A68
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jul 2022 18:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbiGZSi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 14:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbiGZSi4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 14:38:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9470240B1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 11:38:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5604561490
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 18:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB13FC433D6;
        Tue, 26 Jul 2022 18:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658860734;
        bh=AXmBA0H9lakj8qRMrUTDLB1RkztVaGLxk25Tl0oPNM0=;
        h=Date:To:From:Subject:From;
        b=HOsuMBEzkWKMRfRmtQxqlq5VcQtaFjy5XTeTnNLeflQnTmL1fwiYRJqg8s5kEJBvJ
         qKpREUUU2OCDiJ+FiNNcmm1qvN9UsjKjWhFl7LZ+QjM2jRsZN66owkTiS5CQN7s8ZZ
         klGx9r3MgCM+AQjPAmyzYc3APuUn8kqOE/W5gXlA=
Date:   Tue, 26 Jul 2022 11:38:54 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-remove-unneeded-hugetlbfs_ops-forward-declaration.patch added to mm-unstable branch
Message-Id: <20220726183854.AB13FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove unneeded hugetlbfs_ops forward declaration
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-remove-unneeded-hugetlbfs_ops-forward-declaration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-remove-unneeded-hugetlbfs_ops-forward-declaration.patch

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
Subject: hugetlbfs: remove unneeded hugetlbfs_ops forward declaration
Date: Tue, 26 Jul 2022 22:29:15 +0800

The forward declaration for hugetlbfs_ops is unnecessary.  Remove it.

Link: https://lkml.kernel.org/r/20220726142918.51693-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <songmuchun@bytedance.com>
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
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch
mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch
mm-mempolicy-remove-unneeded-out-label.patch
hugetlb_cgroup-fix-wrong-hugetlb-cgroup-numa-stat.patch
hugetlbfs-use-helper-macro-sz_1km.patch
hugetlbfs-remove-unneeded-hugetlbfs_ops-forward-declaration.patch
hugetlbfs-remove-unneeded-header-file.patch
hugetlbfs-cleanup-some-comments-in-inodec.patch
hugetlbfs-fix-inaccurate-comment-in-hugetlbfs_statfs.patch

