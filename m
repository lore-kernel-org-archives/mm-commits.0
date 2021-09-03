Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF56CC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B96866112F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350063AbhICU7t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346630AbhICU7s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E22461107;
        Fri,  3 Sep 2021 20:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702727;
        bh=JJElt903fXfbG/GfIbSlPIZ3gbDh0nZONejsQi777zI=;
        h=Date:From:To:Subject:From;
        b=g+pS63yfhnXEmc+k4O7x2bXsPvKqT1+xgBDgAhcrnOl7gq3fWSWJmwR/HG5ybEHuw
         6pr948vmKK6GAACpk3wW+BY1IwTodTgaLk4J7wO06KlFKhls/mYzFgM3iITxu/KOtW
         zSPvTjdtLWSksidKy0u4V+iM/ep3nvLAc5Ju+TD0=
Date:   Fri, 03 Sep 2021 13:58:47 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, ohoono.kwon@samsung.com,
        rppt@linux.ibm.com
Subject:  [merged]
 mm-sparse-pass-section_nr-to-find_memory_block.patch removed from -mm tree
Message-ID: <20210903205847.mSSoSc7pP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sparse: pass section_nr to find_memory_block
has been removed from the -mm tree.  Its filename was
     mm-sparse-pass-section_nr-to-find_memory_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ohhoon Kwon <ohoono.kwon@samsung.com>
Subject: mm: sparse: pass section_nr to find_memory_block

With CONFIG_SPARSEMEM_EXTREME enabled, __section_nr() which converts
mem_section to section_nr could be costly since it iterates all section
roots to check if the given mem_section is in its range.

On the other hand, __nr_to_section() which converts section_nr to
mem_section can be done in O(1).

Let's pass section_nr instead of mem_section ptr to find_memory_block() in
order to reduce needless iterations.

Link: https://lkml.kernel.org/r/20210707150212.855-3-ohoono.kwon@samsung.com
Signed-off-by: Ohhoon Kwon <ohoono.kwon@samsung.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |    4 +---
 drivers/base/memory.c                           |    4 ++--
 include/linux/memory.h                          |    2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~mm-sparse-pass-section_nr-to-find_memory_block
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -211,13 +211,11 @@ static int update_lmb_associativity_inde
 static struct memory_block *lmb_to_memblock(struct drmem_lmb *lmb)
 {
 	unsigned long section_nr;
-	struct mem_section *mem_sect;
 	struct memory_block *mem_block;
 
 	section_nr = pfn_to_section_nr(PFN_DOWN(lmb->base_addr));
-	mem_sect = __nr_to_section(section_nr);
 
-	mem_block = find_memory_block(mem_sect);
+	mem_block = find_memory_block(section_nr);
 	return mem_block;
 }
 
--- a/drivers/base/memory.c~mm-sparse-pass-section_nr-to-find_memory_block
+++ a/drivers/base/memory.c
@@ -578,9 +578,9 @@ static struct memory_block *find_memory_
 /*
  * Called under device_hotplug_lock.
  */
-struct memory_block *find_memory_block(struct mem_section *section)
+struct memory_block *find_memory_block(unsigned long section_nr)
 {
-	unsigned long block_id = memory_block_id(__section_nr(section));
+	unsigned long block_id = memory_block_id(section_nr);
 
 	return find_memory_block_by_id(block_id);
 }
--- a/include/linux/memory.h~mm-sparse-pass-section_nr-to-find_memory_block
+++ a/include/linux/memory.h
@@ -90,7 +90,7 @@ int create_memory_block_devices(unsigned
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
-extern struct memory_block *find_memory_block(struct mem_section *);
+extern struct memory_block *find_memory_block(unsigned long section_nr);
 typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
 			      void *arg, walk_memory_blocks_func_t func);
_

Patches currently in -mm which might be from ohoono.kwon@samsung.com are

connector-send-event-on-write-to-proc-comm.patch

