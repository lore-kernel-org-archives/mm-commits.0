Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42337C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239810AbiG3BJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239736AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FAC87C31
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EE7261BF4
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C01C433D7;
        Sat, 30 Jul 2022 01:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143327;
        bh=7qaBwvtkUsOYZX2U3JONl3c8gWFnVRs12eQt35yvvDc=;
        h=Date:To:From:Subject:From;
        b=X2OeVaEH+tzKsfmTlsaNJIUfOMkcgl593910STY6eSJu8F7k+JuMh64NI2osos5MW
         Id6+wAMgcwimcXqeyy5DkKPUEOfcn5Byt/numc3XruXRvOb5rQ3qMJwV7l61hR4HDg
         JIGQFxNNjaG9yWOF0z4L+w7Qc3rV9U9rwesdYTcs=
Date:   Fri, 29 Jul 2022 18:08:46 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-use-helper-macro-sz_1km.patch removed from -mm tree
Message-Id: <20220730010846.E0C01C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: use helper macro SZ_1{K,M}
has been removed from the -mm tree.  Its filename was
     hugetlbfs-use-helper-macro-sz_1km.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
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

