Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA19C19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239744AbiG3BJn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239743AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0971987F7C
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A0661BB6
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99FBC433D7;
        Sat, 30 Jul 2022 01:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143332;
        bh=b0RpMbujAbsBOYSznN0SwanrmkWkmivsdO2jiJL5yBE=;
        h=Date:To:From:Subject:From;
        b=PPPFZRobH9aho8XKvlLF+eWql5IASYpHrUnTe1emyRMcshQdDl9hz0jJeflPMjEOP
         jV00UjKZaLOcJnxuqVtqKZ23l74rDZmBg7HqPAFcgwrrNhPo9q/VqjTEdI6eQzeFl3
         bLchFZSysXzyXhnm0XIXLu7BDlBGsTdUjtTL135g=
Date:   Fri, 29 Jul 2022 18:08:51 -0700
To:     mm-commits@vger.kernel.org, pankaj.gupta@amd.com,
        jasowang@redhat.com, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-is_zone_movable_page-helper.patch removed from -mm tree
Message-Id: <20220730010851.E99FBC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use is_zone_movable_page() helper
has been removed from the -mm tree.  Its filename was
     mm-use-is_zone_movable_page-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use is_zone_movable_page() helper
Date: Tue, 26 Jul 2022 21:11:35 +0800

Use is_zone_movable_page() helper to simplify code.

Link: https://lkml.kernel.org/r/20220726131135.146912-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |    6 ++----
 mm/memory_hotplug.c         |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/virtio/virtio_mem.c~mm-use-is_zone_movable_page-helper
+++ a/drivers/virtio/virtio_mem.c
@@ -862,8 +862,7 @@ static void virtio_mem_sbm_notify_online
 					 unsigned long mb_id,
 					 unsigned long start_pfn)
 {
-	const bool is_movable = page_zonenum(pfn_to_page(start_pfn)) ==
-				ZONE_MOVABLE;
+	const bool is_movable = is_zone_movable_page(pfn_to_page(start_pfn));
 	int new_state;
 
 	switch (virtio_mem_sbm_get_mb_state(vm, mb_id)) {
@@ -1158,8 +1157,7 @@ static void virtio_mem_fake_online(unsig
  */
 static int virtio_mem_fake_offline(unsigned long pfn, unsigned long nr_pages)
 {
-	const bool is_movable = page_zonenum(pfn_to_page(pfn)) ==
-				ZONE_MOVABLE;
+	const bool is_movable = is_zone_movable_page(pfn_to_page(pfn));
 	int rc, retry_count;
 
 	/*
--- a/mm/memory_hotplug.c~mm-use-is_zone_movable_page-helper
+++ a/mm/memory_hotplug.c
@@ -932,7 +932,7 @@ static struct zone *auto_movable_zone_fo
 			if (!page)
 				continue;
 			/* If anything is !MOVABLE online the rest !MOVABLE. */
-			if (page_zonenum(page) != ZONE_MOVABLE)
+			if (!is_zone_movable_page(page))
 				goto kernel_zone;
 			online_pages += PAGES_PER_SECTION;
 		}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


