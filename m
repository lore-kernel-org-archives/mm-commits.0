Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B4DEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjHUU3X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjHUU3X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:29:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BDD13E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63FC0649EF
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37A7C433C7;
        Mon, 21 Aug 2023 20:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692649753;
        bh=bE2In3VLNmNl3l6TI3N44WwcHzabEW0S3MrMLsVnMmk=;
        h=Date:To:From:Subject:From;
        b=mGTJR6O2pARxLJsD0sS+YoW/X23C/Wrm8SWCriYX69cVlMyrxFVINyE40dA8Yjq3m
         jZMbfUxCvlgSAuJoa6qTGIEK6kmmr8NWhRH9qWBnEk8VL55TTW1V4r7166sIVjgNdA
         Aq9SgRK+vKRbew5STAPR1AuFRdvrE+99doEwpjTw=
Date:   Mon, 21 Aug 2023 13:29:13 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        david@redhat.com, aneesh.kumar@linux.ibm.com,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block-fix.patch removed from -mm tree
Message-Id: <20230821202913.B37A7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: fix error return code in add_memory_resource()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

------------------------------------------------------
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: mm/memory_hotplug: fix error return code in add_memory_resource()
Date: Wed, 9 Aug 2023 16:15:52 +0800

Set error return code to -ENOMEM, when kmalloc() fails.

Link: https://lkml.kernel.org/r/20230809081552.1351184-1-yangyingliang@huawei.com
Fixes: ad3232df3e41 ("mm/memory_hotplug: embed vmem_altmap details in memory block")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block-fix
+++ a/mm/memory_hotplug.c
@@ -1440,8 +1440,10 @@ int __ref add_memory_resource(int nid, s
 		if (mhp_supports_memmap_on_memory(size)) {
 			mhp_altmap.free = memory_block_memmap_on_memory_pages();
 			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
-			if (!params.altmap)
+			if (!params.altmap) {
+				ret = -ENOMEM;
 				goto error;
+			}
 
 			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
 		}
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

