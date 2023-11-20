Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7FFC5AD4C
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjKTSRe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjKTSRc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:17:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64182B9;
        Mon, 20 Nov 2023 10:17:29 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27BAC433C8;
        Mon, 20 Nov 2023 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700504249;
        bh=StLag1w3TR0nt2l8+G7Y2PkKnr+p5/vjxE4UVUTKiy4=;
        h=Date:To:From:Subject:From;
        b=1OwNI9E12sR+iGcPxJfzRv5xJY7hSQyfzNb9Xv9reDgzyiToT8vkzDULz6ib8tG3E
         PjzCqgTnBR2VeVeq3vWjgj/V2PcREWr2ugGLME8WipWDxwcLBXLSTQLJhjT6IMaqVP
         ypEwFCz8UABErfqUJryEB1waJn9tQB2xCp2fc/RQ=
Date:   Mon, 20 Nov 2023 10:17:28 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        osalvador@suse.de, mhocko@suse.com, lkp@intel.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, sumanthk@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch added to mm-hotfixes-unstable branch
Message-Id: <20231120181728.F27BAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix error handling in add_memory_resource()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-memory_hotplug-add-missing-mem_hotplug_lock.patch
mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch
mm-use-vmem_altmap-code-without-config_zone_device.patch

