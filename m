Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DB8C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  7 Nov 2023 15:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbjKGPfT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbjKGPfS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2023 10:35:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA709E
        for <mm-commits@vger.kernel.org>; Tue,  7 Nov 2023 07:35:16 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70268C433C8;
        Tue,  7 Nov 2023 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699371316;
        bh=p5xJr7Hj+1mxiPoYOYAI5K/8uvuLwcIAkHTNeB41HWg=;
        h=Date:To:From:Subject:From;
        b=k4yGsa3C6baJemqxvVFNLs0MIP59u7W3SfiAmQ0UJIVkiZVhKvwFDSxkUkZM1TMv7
         x7pGJqCMYc86Ke3q+nG1RaXJNz/8FDoFm7mr9eVitU2Aj9lBGRRtHDsOao7T2Y000U
         +Ou5uiOz5PoHK01HadUqJd5SUIJvwpWzXE9Ap1Jo=
Date:   Tue, 07 Nov 2023 07:35:15 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, mhocko@suse.com, Jonathan.Cameron@huawei.com,
        jmoyer@redhat.com, fan.ni@samsung.com, david@redhat.com,
        dave.jiang@intel.com, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, aneesh.kumar@linux.ibm.com,
        vishal.l.verma@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-replace-an-open-coded-kmemdup-in-add_memory_resource.patch added to mm-unstable branch
Message-Id: <20231107153516.70268C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: replace an open-coded kmemdup() in add_memory_resource()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-replace-an-open-coded-kmemdup-in-add_memory_resource.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-replace-an-open-coded-kmemdup-in-add_memory_resource.patch

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
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: mm/memory_hotplug: replace an open-coded kmemdup() in add_memory_resource()
Date: Tue, 07 Nov 2023 00:22:41 -0700

Patch series "mm: use memmap_on_memory semantics for dax/kmem", v10.

The dax/kmem driver can potentially hot-add large amounts of memory
originating from CXL memory expanders, or NVDIMMs, or other 'device
memories'.  There is a chance there isn't enough regular system memory
available to fit the memmap for this new memory.  It's therefore
desirable, if all other conditions are met, for the kmem managed memory to
place its memmap on the newly added memory itself.

The main hurdle for accomplishing this for kmem is that memmap_on_memory
can only be done if the memory being added is equal to the size of one
memblock.  To overcome this, allow the hotplug code to split an
add_memory() request into memblock-sized chunks, and try_remove_memory()
to also expect and handle such a scenario.

Patch 1 replaces an open-coded kmemdup()

Patch 2 teaches the memory_hotplug code to allow for splitting
add_memory() and remove_memory() requests over memblock sized chunks.

Patch 3 allows the dax region drivers to request memmap_on_memory
semantics. CXL dax regions default this to 'on', all others default to
off to keep existing behavior unchanged.


This patch (of 3):

A review of the memmap_on_memory modifications to add_memory_resource()
revealed an instance of an open-coded kmemdup().  Replace it with
kmemdup().

Link: https://lkml.kernel.org/r/20231107-vv-kmem_memmap-v10-0-1253ec050ed0@intel.com
Link: https://lkml.kernel.org/r/20231107-vv-kmem_memmap-v10-1-1253ec050ed0@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-replace-an-open-coded-kmemdup-in-add_memory_resource
+++ a/mm/memory_hotplug.c
@@ -1439,13 +1439,13 @@ int __ref add_memory_resource(int nid, s
 	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
 		if (mhp_supports_memmap_on_memory(size)) {
 			mhp_altmap.free = memory_block_memmap_on_memory_pages();
-			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
+			params.altmap = kmemdup(&mhp_altmap,
+						sizeof(struct vmem_altmap),
+						GFP_KERNEL);
 			if (!params.altmap) {
 				ret = -ENOMEM;
 				goto error;
 			}
-
-			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
 		}
 		/* fallback to not using altmap  */
 	}
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are

mm-memory_hotplug-replace-an-open-coded-kmemdup-in-add_memory_resource.patch
mm-memory_hotplug-split-memmap_on_memory-requests-across-memblocks.patch
dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory.patch

