Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3A7ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiILDbI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiILD31 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CAA286E8
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 474FA6116D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1F2C433D7;
        Mon, 12 Sep 2022 03:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953342;
        bh=sg7f8csQQOL0tdQWSCSgeQOrNNrEKuLSUznBD9Pmi5M=;
        h=Date:To:From:Subject:From;
        b=QZGCajQqtYBv8vbMZaxHuTRFChUS0ppbFoVZ6mIVlH+7wJ12EWXSTnzXksuV/8B4Z
         fiPpPdwNELGtMCXsQ13Bt/EFleegEIxJGWUodgTLQEG5iGfWVX46XjMDZt6wGsvVJE
         LivHqDbuUGypuc07F57Cs1Xdo/yZEPM9Xb+vNbK8=
Date:   Sun, 11 Sep 2022 20:29:01 -0700
To:     mm-commits@vger.kernel.org, liuyongqiang13@huawei.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-warning-if-__vm_enough_memory-fails.patch removed from -mm tree
Message-Id: <20220912032902.9E1F2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/util.c: add warning if __vm_enough_memory fails
has been removed from the -mm tree.  Its filename was
     mm-add-warning-if-__vm_enough_memory-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/util.c: add warning if __vm_enough_memory fails
Date: Tue, 26 Jul 2022 22:54:28 +0800

If a process has not enough memory to allocate a new virtual mapping, we
may meet verious kinds of error, eg, fork cannot allocate memory, SIGBUS
error in shmem, but it is difficult to confirm them, let's add some debug
information to easily to check this scenario if __vm_enough_memory fails.

Link: https://lkml.kernel.org/r/20220726145428.8030-1-wangkefeng.wang@huawei.com
Reported-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/util.c~mm-add-warning-if-__vm_enough_memory-fails
+++ a/mm/util.c
@@ -1052,6 +1052,8 @@ int __vm_enough_memory(struct mm_struct
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
 error:
+	pr_warn_ratelimited("%s: pid: %d, comm: %s, no enough memory for the allocation\n",
+			    __func__, current->pid, current->comm);
 	vm_unacct_memory(pages);
 
 	return -ENOMEM;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch
kernel-exit-cleanup-release_thread.patch

