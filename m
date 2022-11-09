Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9B9C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiKIBkE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiKIBiw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649ACB493
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12D67B81CD6
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2B8C433C1;
        Wed,  9 Nov 2022 01:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957924;
        bh=hxoYXvSW/l8O/w+gVH/TZZJTsciKHHuXySiq2+uQIFw=;
        h=Date:To:From:Subject:From;
        b=if1ApZfmPpYMV5bavWeNmnTQKfjWpWndF3s7z2Goh6GE3DskhbN2TWxbpLfhNYZMX
         Ktxwvchm+H4uXeRVtnO+ISsMl5+i+0yotWfw14uSXExDUc0UspwxRgZA3QJ4483SrE
         j7rM6fMTGS7horxexOwVo+lK3IpTpm2e+jy0kWho=
Date:   Tue, 08 Nov 2022 17:38:44 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slubc-use-hotplug_memory_notifier-directly.patch removed from -mm tree
Message-Id: <20221109013844.AF2B8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/slub.c: use hotplug_memory_notifier() directly
has been removed from the -mm tree.  Its filename was
     mm-slubc-use-hotplug_memory_notifier-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/slub.c: use hotplug_memory_notifier() directly
Date: Fri, 23 Sep 2022 11:33:42 +0800

Commit 76ae847497bc52 ("Documentation: raise minimum supported version of
GCC to 5.1") updated the minimum gcc version to 5.1.  So the problem
mentioned in f02c69680088 ("include/linux/memory.h: implement
register_hotmemory_notifier()") no longer exist.  So we can now switch to
use hotplug_memory_notifier() directly rather than
register_hotmemory_notifier().

Link: https://lkml.kernel.org/r/20220923033347.3935160-4-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/slub.c~mm-slubc-use-hotplug_memory_notifier-directly
+++ a/mm/slub.c
@@ -4771,11 +4771,6 @@ static int slab_memory_callback(struct n
 	return ret;
 }
 
-static struct notifier_block slab_memory_callback_nb = {
-	.notifier_call = slab_memory_callback,
-	.priority = SLAB_CALLBACK_PRI,
-};
-
 /********************************************************************
  *			Basic setup of slabs
  *******************************************************************/
@@ -4841,7 +4836,7 @@ void __init kmem_cache_init(void)
 	create_boot_cache(kmem_cache_node, "kmem_cache_node",
 		sizeof(struct kmem_cache_node), SLAB_HWCACHE_ALIGN, 0, 0);
 
-	register_hotmemory_notifier(&slab_memory_callback_nb);
+	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 
 	/* Able to allocate the per node structures */
 	slab_state = PARTIAL;
_

Patches currently in -mm which might be from liushixin2@huawei.com are


