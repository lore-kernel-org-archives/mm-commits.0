Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B24AC3F6B0
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jul 2022 18:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbiGZSi6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 14:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239496AbiGZSiz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 14:38:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5106C32D96
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 11:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0A31614C5
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 18:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303FAC433C1;
        Tue, 26 Jul 2022 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658860733;
        bh=y7J2wS6Nk2oRce5GQb4JSOJsiMDinBPukF91x8UMbEE=;
        h=Date:To:From:Subject:From;
        b=T/5Qeiw7aFoF3jNGRFq3WfgGlYYblPNuwx1RVlu7BqXadDJ8Zv/ulRH5Q1Rpmij77
         1ReOpA6GJAY76TJjIyTawCEJfvS6l/hiSSmIJzg0Z/XZJatQGgRXdZNLizLuTmqsgu
         YP0VIy9v0RsnL5eNf8y4A9GvXLUy/p6XvQnQkGqw=
Date:   Tue, 26 Jul 2022 11:38:52 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-use-helper-macro-sz_1km.patch added to mm-unstable branch
Message-Id: <20220726183853.303FAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: use helper macro SZ_1{K,M}
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-use-helper-macro-sz_1km.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-use-helper-macro-sz_1km.patch

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
Subject: hugetlbfs: use helper macro SZ_1{K,M}
Date: Tue, 26 Jul 2022 22:29:14 +0800

Patch series "A few cleanup and fixup patches for hugetlbfs", v2.

This series contains a few cleaup patches to remove unneeded forward
declaration, use helper macro and so on.  More details can be found in the
respective changelogs.


This patch (of 5):

Use helper macro SZ_1K and SZ_1M to do the size conversion.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220726142918.51693-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220726142918.51693-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-use-helper-macro-sz_1km
+++ a/fs/hugetlbfs/inode.c
@@ -1320,7 +1320,7 @@ static int hugetlbfs_parse_param(struct
 		ps = memparse(param->string, &rest);
 		ctx->hstate = size_to_hstate(ps);
 		if (!ctx->hstate) {
-			pr_err("Unsupported page size %lu MB\n", ps >> 20);
+			pr_err("Unsupported page size %lu MB\n", ps / SZ_1M);
 			return -EINVAL;
 		}
 		return 0;
@@ -1566,7 +1566,7 @@ static struct vfsmount *__init mount_one
 	}
 	if (IS_ERR(mnt))
 		pr_err("Cannot mount internal hugetlbfs for page size %luK",
-		       huge_page_size(h) >> 10);
+		       huge_page_size(h) / SZ_1K);
 	return mnt;
 }
 
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

