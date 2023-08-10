Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171F0C04A6A
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 17:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbjHJRNE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbjHJRNE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 13:13:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D86526AE
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 10:13:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1276A66473
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 17:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8B3C433C7;
        Thu, 10 Aug 2023 17:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691687582;
        bh=Q8SuG59zy6kJyqDHMOeZCd+ABtbKQN56UJkuNk5cKfY=;
        h=Date:To:From:Subject:From;
        b=J7Od2Tbj9Y40Z0J9mj+MrbxKcYe2mJ7aC2EfsCc/avaJUCM9zsLEXX0dcZ+0qwqmb
         BCPml1ETSskkHWtKS9JqN8O+FY/SDIYTq7x16MZ4Xo7o7R+hZX57OIpD2Z9lSFL5Qu
         i/1mcY524ZTWsHb5jHBTWFQQF2n8XWe1iBdTtEQ8=
Date:   Thu, 10 Aug 2023 10:13:01 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        david@redhat.com, aneesh.kumar@linux.ibm.com,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block-fix.patch added to mm-unstable branch
Message-Id: <20230810171302.5D8B3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix error return code in add_memory_resource()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block-fix.patch

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

mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block-fix.patch

