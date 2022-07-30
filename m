Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0121EC19F29
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbiG3BJh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239667AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BAB87C34
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95C9261BF4
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39B6C433C1;
        Sat, 30 Jul 2022 01:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143329;
        bh=ZxrtjeeuRsUs8AVVpE5zuWo46m6f1xPA62r2+V5Hqgs=;
        h=Date:To:From:Subject:From;
        b=dLXAJ0wPrbK8pfVHqrUK/aCScLiD1Yv18JyoA7iyVUIJgVS1Cf3WyAQLvwB/v/+V2
         jgtewN6TI6Hq4cHIWRp8ShE9iN28lzTnNwt9YAAN32viRpiL0bPCaDWtpaDA9WdTs7
         +Y7IJkykTYWo8ezeVRQhXsJOAevp38l299SGtFE4=
Date:   Fri, 29 Jul 2022 18:08:48 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-remove-unneeded-header-file.patch removed from -mm tree
Message-Id: <20220730010848.E39B6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: remove unneeded header file
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-unneeded-header-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: remove unneeded header file
Date: Tue, 26 Jul 2022 22:29:16 +0800

The header file signal.h is unneeded now. Remove it.

Link: https://lkml.kernel.org/r/20220726142918.51693-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-remove-unneeded-header-file
+++ a/fs/hugetlbfs/inode.c
@@ -11,7 +11,6 @@
 
 #include <linux/thread_info.h>
 #include <asm/current.h>
-#include <linux/sched/signal.h>		/* remove ASAP */
 #include <linux/falloc.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

