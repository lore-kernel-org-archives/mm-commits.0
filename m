Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22365C00144
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jul 2022 18:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239601AbiGZSi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 14:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiGZSi5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 14:38:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8FE32ED7
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 11:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C21B561490
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 18:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F8FC433D7;
        Tue, 26 Jul 2022 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658860736;
        bh=gcXp1MC464opaR21EIzBZXCpokd3OCLCq/4gOddeiMg=;
        h=Date:To:From:Subject:From;
        b=sN9KnKmTJE5TFwsLVOCa9dQq2AI/UGO3DAnrs+FTAX6PkrJZDR/0ATIHice6r0Rk0
         tWHekElRpIyCwRjrhvcUOZc11xsevNZNbtj33zjYxuulHkObZE8flb3i/NeX8fDAmC
         omrfU8Wi1wUTzpdk4G6SkU0a9O3DRG9XeeCxOyKM=
Date:   Tue, 26 Jul 2022 11:38:55 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-remove-unneeded-header-file.patch added to mm-unstable branch
Message-Id: <20220726183856.23F8FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove unneeded header file
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-remove-unneeded-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-remove-unneeded-header-file.patch

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
Subject: hugetlbfs: remove unneeded header file
Date: Tue, 26 Jul 2022 22:29:16 +0800

The header file signal.h is unneeded now. Remove it.

Link: https://lkml.kernel.org/r/20220726142918.51693-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <songmuchun@bytedance.com>
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

