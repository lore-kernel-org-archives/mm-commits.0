Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7547C43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiKIBkJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiKIBiw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABC5663D3
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB7CC61803
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5B8C433B5;
        Wed,  9 Nov 2022 01:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957927;
        bh=0I3/0HoF+UW7OogYZYNnv7TO5oJmJtFjQJrgdIiTzHY=;
        h=Date:To:From:Subject:From;
        b=ZcCn+m2sfZdyUk4jYqh7kZRiUyDmsz/pqUG4GkXkVj2C+Cjy2cBtXANJbAyz4ZwbB
         wpszxuOdEjl1npO1hT1UWrEr4EwzkguvQQuRZat3VEkjIITpcDTHnr5GYqNTskIb5/
         vmlsr5P1uWmLd+zrOte7fajV0EMuhJnxcVwVCy5I=
Date:   Tue, 08 Nov 2022 17:38:46 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-use-hotplug_memory_notifier-directly.patch removed from -mm tree
Message-Id: <20221109013847.3E5B8C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: use hotplug_memory_notifier() directly
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-use-hotplug_memory_notifier-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/mm_init.c: use hotplug_memory_notifier() directly
Date: Fri, 23 Sep 2022 11:33:44 +0800

Commit 76ae847497bc52 ("Documentation: raise minimum supported version of
GCC to 5.1") updated the minimum gcc version to 5.1.  So the problem
mentioned in f02c69680088 ("include/linux/memory.h: implement
register_hotmemory_notifier()") no longer exist.  So we can now switch to
use hotplug_memory_notifier() directly rather than
register_hotmemory_notifier().

Link: https://lkml.kernel.org/r/20220923033347.3935160-6-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-use-hotplug_memory_notifier-directly
+++ a/mm/mm_init.c
@@ -178,16 +178,10 @@ static int __meminit mm_compute_batch_no
 	return NOTIFY_OK;
 }
 
-static struct notifier_block compute_batch_nb __meminitdata = {
-	.notifier_call = mm_compute_batch_notifier,
-	.priority = IPC_CALLBACK_PRI, /* use lowest priority */
-};
-
 static int __init mm_compute_batch_init(void)
 {
 	mm_compute_batch(sysctl_overcommit_memory);
-	register_hotmemory_notifier(&compute_batch_nb);
-
+	hotplug_memory_notifier(mm_compute_batch_notifier, IPC_CALLBACK_PRI);
 	return 0;
 }
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are


