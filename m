Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7EDEECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiILDeC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiILDcX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC631EACA
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EB856116F
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52D0C433D6;
        Mon, 12 Sep 2022 03:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953408;
        bh=6djkjJ4XBaTC8O0u3UjX6MkeKOrJJ48/bBTMGuPp7Mo=;
        h=Date:To:From:Subject:From;
        b=0dsWzgqnnnFtt8pOSCe5X3N+tefcGwuajoORn/26AbM2irOk2XYDUUvjgCUFVU18e
         /IWKb0JXu3jkrnlqW0Jl16T+tbR+T4PhK3FGsr01ZpCMGX3MVL0k9GcyGMC2teJRFp
         lCbLLIk7gPrqXmMZoN0K5uEeuv9goEV5EsUJvFnI=
Date:   Sun, 11 Sep 2022 20:30:08 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kill-is_memblock_offlined.patch removed from -mm tree
Message-Id: <20220912033008.D52D0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kill is_memblock_offlined()
has been removed from the -mm tree.  Its filename was
     mm-kill-is_memblock_offlined.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kill is_memblock_offlined()
Date: Sat, 27 Aug 2022 19:20:43 +0800

Directly check state of struct memory_block, no need a single function.

Link: https://lkml.kernel.org/r/20220827112043.187028-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    6 ------
 include/linux/memory_hotplug.h |    2 --
 mm/memory_hotplug.c            |    3 +--
 3 files changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/base/memory.c~mm-kill-is_memblock_offlined
+++ a/drivers/base/memory.c
@@ -869,12 +869,6 @@ void remove_memory_block_devices(unsigne
 	}
 }
 
-/* return true if the memory block is offlined, otherwise, return false */
-bool is_memblock_offlined(struct memory_block *mem)
-{
-	return mem->state == MEM_OFFLINE;
-}
-
 static struct attribute *memory_root_attrs[] = {
 #ifdef CONFIG_ARCH_MEMORY_PROBE
 	&dev_attr_probe.attr,
--- a/include/linux/memory_hotplug.h~mm-kill-is_memblock_offlined
+++ a/include/linux/memory_hotplug.h
@@ -11,7 +11,6 @@ struct page;
 struct zone;
 struct pglist_data;
 struct mem_section;
-struct memory_block;
 struct memory_group;
 struct resource;
 struct vmem_altmap;
@@ -333,7 +332,6 @@ extern void move_pfn_range_to_zone(struc
 extern void remove_pfn_range_from_zone(struct zone *zone,
 				       unsigned long start_pfn,
 				       unsigned long nr_pages);
-extern bool is_memblock_offlined(struct memory_block *mem);
 extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
--- a/mm/memory_hotplug.c~mm-kill-is_memblock_offlined
+++ a/mm/memory_hotplug.c
@@ -1969,11 +1969,10 @@ failed_removal:
 
 static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
 {
-	int ret = !is_memblock_offlined(mem);
 	int *nid = arg;
 
 	*nid = mem->nid;
-	if (unlikely(ret)) {
+	if (unlikely(mem->state != MEM_OFFLINE)) {
 		phys_addr_t beginpa, endpa;
 
 		beginpa = PFN_PHYS(section_nr_to_pfn(mem->start_section_nr));
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch
kernel-exit-cleanup-release_thread.patch

