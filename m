Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C53EC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441863AbjLGANb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441946AbjLGANY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AB3137
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:30 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D93CC433C7;
        Thu,  7 Dec 2023 00:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908010;
        bh=pO9+JQ+bQlQ8aPFwm3Xwya4kqfy+SdnqC70+XjRq51E=;
        h=Date:To:From:Subject:From;
        b=SJuVX+6A5JcWqPJa/nVLDe7BQ65LajY8Vytt+mlUmFjUaLtcdtizoxzIh80BhE0ej
         sxkyiZKiYtsyvCf0MkyqAfyzQniG2ybhRL0z4Bgcoj8+Boh6Z/ulTycGfn66H/JqhY
         wtX1Ga+Uul1pMiFxhHeiEVB6z04JmOdorpLXg+fg=
Date:   Wed, 06 Dec 2023 16:13:29 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        osalvador@suse.de, mhocko@suse.com, lkp@intel.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, sumanthk@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch removed from -mm tree
Message-Id: <20231207001330.2D93CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: fix error handling in add_memory_resource()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: mm/memory_hotplug: fix error handling in add_memory_resource()
Date: Mon, 20 Nov 2023 15:53:53 +0100

In add_memory_resource(), creation of memory block devices occurs after
successful call to arch_add_memory().  However, creation of memory block
devices could fail.  In that case, arch_remove_memory() is called to
perform necessary cleanup.

Currently with or without altmap support, arch_remove_memory() is always
passed with altmap set to NULL during error handling.  This leads to
freeing of struct pages using free_pages(), eventhough the allocation
might have been performed with altmap support via
altmap_alloc_block_buf().

Fix the error handling by passing altmap in arch_remove_memory(). This
ensures the following:
* When altmap is disabled, deallocation of the struct pages array occurs
  via free_pages().
* When altmap is enabled, deallocation occurs via vmem_altmap_free().

Link: https://lkml.kernel.org/r/20231120145354.308999-3-sumanthk@linux.ibm.com
Fixes: a08a2ae34613 ("mm,memory_hotplug: allocate memmap from the added memory range")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-error-handling-in-add_memory_resource
+++ a/mm/memory_hotplug.c
@@ -1458,7 +1458,7 @@ int __ref add_memory_resource(int nid, s
 	/* create memory block devices after memory was added */
 	ret = create_memory_block_devices(start, size, params.altmap, group);
 	if (ret) {
-		arch_remove_memory(start, size, NULL);
+		arch_remove_memory(start, size, params.altmap);
 		goto error_free;
 	}
 
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-use-vmem_altmap-code-without-config_zone_device.patch

