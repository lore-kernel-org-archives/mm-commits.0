Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE28C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiJRBku (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJRBkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:40:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4751E10E8
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E19BEB81C53
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B74CC433D7;
        Tue, 18 Oct 2022 01:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666057236;
        bh=v0InhUtmdrtupyd8isrBEuQOVerjh6hQMotw6WKW3XI=;
        h=Date:To:From:Subject:From;
        b=zxBH+1LsSffoiUTSiyIZyTGNqXTiu3hIttU0YtOezh/YCdisQKOlpiFFoOOtqY3JS
         QRsiMV28Z4IunkPOTr45cgeB8EPrx6Zd/YTCNxgylxfCVcdy7Uzpg99CBOr85i33sV
         WZDsTAsrSnZ4cL6pl/7XB+3Pr1npyPE48QTpWf7A=
Date:   Mon, 17 Oct 2022 18:40:35 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-hotplug_memory_notifier-directly.patch added to mm-unstable branch
Message-Id: <20221018014036.8B74CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: use hotplug_memory_notifier() directly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-hotplug_memory_notifier-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-hotplug_memory_notifier-directly.patch

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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/mmap: use hotplug_memory_notifier() directly
Date: Fri, 23 Sep 2022 11:33:43 +0800

Commit 76ae847497bc52 ("Documentation: raise minimum supported version of
GCC to 5.1") updated the minimum gcc version to 5.1.  So the problem
mentioned in f02c69680088 ("include/linux/memory.h: implement
register_hotmemory_notifier()") no longer exist.  So we can now switch to
use hotplug_memory_notifier() directly rather than
register_hotmemory_notifier().

Link: https://lkml.kernel.org/r/20220923033347.3935160-5-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-hotplug_memory_notifier-directly
+++ a/mm/mmap.c
@@ -3746,13 +3746,9 @@ static int reserve_mem_notifier(struct n
 	return NOTIFY_OK;
 }
 
-static struct notifier_block reserve_mem_nb = {
-	.notifier_call = reserve_mem_notifier,
-};
-
 static int __meminit init_reserve_notifier(void)
 {
-	if (register_hotmemory_notifier(&reserve_mem_nb))
+	if (hotplug_memory_notifier(reserve_mem_notifier, 0))
 		pr_err("Failed registering memory add/remove notifier for admin reserve\n");
 
 	return 0;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

cgroup-cpuset-use-hotplug_memory_notifier-directly.patch
fs-proc-kcorec-use-hotplug_memory_notifier-directly.patch
mm-slubc-use-hotplug_memory_notifier-directly.patch
mm-mmap-use-hotplug_memory_notifier-directly.patch
mm-mm_initc-use-hotplug_memory_notifier-directly.patch
acpi-hmat-use-hotplug_memory_notifier-directly.patch
memory-remove-unused-register_hotmemory_notifier.patch
memory-move-hotplug-memory-notifier-priority-to-same-file-for-easy-sorting.patch

