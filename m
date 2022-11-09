Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33279C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiKIBkJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiKIBiw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C264663D4
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21A19B81CD8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3783C433D6;
        Wed,  9 Nov 2022 01:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957925;
        bh=td75X9barhBOj/0CY6r3Y61t0S1HbLAZwXF+KQ60dG0=;
        h=Date:To:From:Subject:From;
        b=CxnBi98ETrfrZaXsHO0535y/dzxnnz4zFkWHvl6cN2AWihVbzYUdc/o7nAjlK7DaP
         V4yKt32G/um1bWu4TVlsZU60kQtrtHyecmCCqA2ki1RhsLMS2Y8N4InjjPOUXrflkl
         k0vsjL8Fs7MCNEyGeJINV663113Zuk40bwZgyscc=
Date:   Tue, 08 Nov 2022 17:38:45 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        longman@redhat.com, lizefan.x@bytedance.com, david@redhat.com,
        cl@linux.com, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-use-hotplug_memory_notifier-directly.patch removed from -mm tree
Message-Id: <20221109013845.C3783C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: use hotplug_memory_notifier() directly
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-hotplug_memory_notifier-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3749,13 +3749,9 @@ static int reserve_mem_notifier(struct n
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


