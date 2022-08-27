Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8ACECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 21:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiH0V4X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 17:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH0V4X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 17:56:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7614D2714B
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 14:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7BCA60EAE
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 21:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4ABC433C1;
        Sat, 27 Aug 2022 21:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661637381;
        bh=Hiv8FxvIZtZis8k7j0fcfydzyw4M2dVL8veNYs8g3p4=;
        h=Date:To:From:Subject:From;
        b=Bi3XkpL/c2GSIdnYQeB9Rox9fBKCCoZK7+fhuag3WYYY1hzwLF2gmiGkpLUJGt+6U
         FNdwIIXLsvI7i4qKvYoJxsbejD5dSa2g9B2Z35YNjV3URcrG767ey1Q0r/c5c4oEyQ
         PCJub69rErscrvDU8o6GL7QW4Hp2L4d933gf+B0I=
Date:   Sat, 27 Aug 2022 14:56:20 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kill-is_memblock_offlined.patch added to mm-unstable branch
Message-Id: <20220827215621.0B4ABC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kill is_memblock_offlined()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kill-is_memblock_offlined.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kill-is_memblock_offlined.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kill is_memblock_offlined()
Date: Sat, 27 Aug 2022 19:20:43 +0800

Directly check state of struct memory_block, no need a single function.

Link: https://lkml.kernel.org/r/20220827112043.187028-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
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

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch
mm-kill-find_min_pfn_with_active_regions.patch
mm-memory-failure-kill-soft_offline_free_page.patch
mm-memory-failure-kill-__soft_offline_page.patch
mm-kill-is_memblock_offlined.patch
kernel-exit-cleanup-release_thread.patch

