Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07FBC25B06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 00:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiHOAUM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 20:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiHOAUL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 20:20:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9175011A3D
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 17:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C349B80B3C
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 00:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E37DC433D7;
        Mon, 15 Aug 2022 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660522806;
        bh=L/4Vn3CdRdA/umTEpdbgnradHh09wLVbaEpqItNbryc=;
        h=Date:To:From:Subject:From;
        b=iwubb2AaPP0L5KRK1YPcVCrUeCBH5FpYx7MLBZi7YG8XnOqIReb4hhZE700wPxVnB
         xDWZh2gbZKqqfXHD+vqhDBaYxlPjjRnbPGu+p7inO6d17BbCOK3kykUUDdXXQoC+5N
         S/VT7YnVapMbGqkPunXZNpl/R1p2LOv+QOLl61do=
Date:   Sun, 14 Aug 2022 17:20:05 -0700
To:     mm-commits@vger.kernel.org, liuyongqiang13@huawei.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-warning-if-__vm_enough_memory-fails.patch added to mm-unstable branch
Message-Id: <20220815002006.8E37DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util.c: add warning if __vm_enough_memory fails
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-warning-if-__vm_enough_memory-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-warning-if-__vm_enough_memory-fails.patch

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

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch

