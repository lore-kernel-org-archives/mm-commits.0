Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF44AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383668AbiEMTWU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383777AbiEMTVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B5738794
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40284B83159
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15CEC34113;
        Fri, 13 May 2022 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469688;
        bh=VSzKrvsfCZM9DMCVjNSOqiKMYM8S4ffOvPGOvNZjMTQ=;
        h=Date:To:From:Subject:From;
        b=t01RL65JRIn475yGKLJqTWuxJmXeaiRS7Vybs6xS/IBlL+hF72IlKAG42g2KAlRu+
         W1Q35Z0pWPAbBnqPSWzeMOHxaByaZyH4Sj+YEE3g7vRbyWTJEiMOy36cYanO2OoAMv
         3U7qQoi/qiydRL77bmQ8cmVvZ5Z0TYyd4eBVUhv8=
Date:   Fri, 13 May 2022 12:21:27 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        renzhengeek@gmail.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, lkp@intel.com, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch removed from -mm tree
Message-Id: <20220513192127.E15CEC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drivers: virtio_mem: use pageblock size as the minimum virtio_mem size.
has been removed from the -mm tree.  Its filename was
     drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: drivers: virtio_mem: use pageblock size as the minimum virtio_mem size.

alloc_contig_range() now only needs to be aligned to pageblock_nr_pages,
drop virtio_mem size requirement that it needs to be MAX_ORDER_NR_PAGES.

Link: https://lkml.kernel.org/r/20220425143118.2850746-7-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/virtio/virtio_mem.c~drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size
+++ a/drivers/virtio/virtio_mem.c
@@ -2476,10 +2476,10 @@ static int virtio_mem_init_hotplug(struc
 				      VIRTIO_MEM_DEFAULT_OFFLINE_THRESHOLD);
 
 	/*
-	 * TODO: once alloc_contig_range() works reliably with pageblock
-	 * granularity on ZONE_NORMAL, use pageblock_nr_pages instead.
+	 * alloc_contig_range() works reliably with pageblock
+	 * granularity on ZONE_NORMAL, use pageblock_nr_pages.
 	 */
-	sb_size = PAGE_SIZE * MAX_ORDER_NR_PAGES;
+	sb_size = PAGE_SIZE * pageblock_nr_pages;
 	sb_size = max_t(uint64_t, vm->device_block_size, sb_size);
 
 	if (sb_size < memory_block_size_bytes() && !force_bbm) {
_

Patches currently in -mm which might be from ziy@nvidia.com are


