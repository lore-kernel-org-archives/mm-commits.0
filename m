Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2A7C46CA0
	for <mm-commits@archiver.kernel.org>; Tue, 28 Nov 2023 23:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376640AbjK1X7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Nov 2023 18:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376662AbjK1X67 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2023 18:58:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3ED198D
        for <mm-commits@vger.kernel.org>; Tue, 28 Nov 2023 15:59:05 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD329C433C7;
        Tue, 28 Nov 2023 23:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701215945;
        bh=FiV+9VDzgsXd4+6oInddmRhFDuKAtbA1acUFfDr8zXM=;
        h=Date:To:From:Subject:From;
        b=K9fGD3iJiNfVNaV0TnFDpmFYfMB/CDysO2UV0AqzmJl9TDmKOUgrIcoCgG0f57Mek
         s70+INyIyqWSZdzycs2ClKgH6FY+EnptSxIkv3RXWjLALf/+v1veTWjgpoz0zJ1nW8
         5gzmqZn42rbbgh1FWhswP71NrbBcIGozs+HCAqTU=
Date:   Tue, 28 Nov 2023 15:59:04 -0800
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, sumanthk@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch added to mm-unstable branch
Message-Id: <20231128235904.DD329C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: implement MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
has been added to the -mm mm-unstable branch.  Its filename is
     s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch

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
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: s390/mm: implement MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
Date: Tue, 28 Nov 2023 16:52:26 +0100

MEM_PREPARE_ONLINE memory notifier makes memory block physical accessible
via sclp assign command.  The notifier ensures self-contained memory maps
are accessible and hence enabling the "memmap on memory" on s390.

MEM_FINISH_OFFLINE memory notifier shifts the memory block to an
inaccessible state via sclp unassign command.

Implementation considerations:
* When MHP_MEMMAP_ON_MEMORY is disabled, the system retains the old
  behavior. This means the memory map is allocated from default memory.
* If MACHINE_HAS_EDAT1 is unavailable, MHP_MEMMAP_ON_MEMORY is
  automatically disabled. This ensures that vmemmap pagetables do not
  consume additional memory from the default memory allocator.
* The MEM_GOING_ONLINE notifier has been modified to perform no
  operation, as MEM_PREPARE_ONLINE already executes the sclp assign
  command.
* The MEM_CANCEL_ONLINE/MEM_OFFLINE notifier now performs no operation, as
  MEM_FINISH_OFFLINE already executes the sclp unassign command.

Link: https://lkml.kernel.org/r/20231128155227.1315063-5-sumanthk@linux.ibm.com
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_cmd.c |   41 ++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 6 deletions(-)

--- a/drivers/s390/char/sclp_cmd.c~s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers
+++ a/drivers/s390/char/sclp_cmd.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/memory.h>
+#include <linux/memory_hotplug.h>
 #include <linux/module.h>
 #include <asm/ctlreg.h>
 #include <asm/chpid.h>
@@ -26,6 +27,7 @@
 #include <asm/sclp.h>
 #include <asm/numa.h>
 #include <asm/facility.h>
+#include <asm/page-states.h>
 
 #include "sclp.h"
 
@@ -340,13 +342,38 @@ static int sclp_mem_notifier(struct noti
 		if (contains_standby_increment(start, start + size))
 			rc = -EPERM;
 		break;
-	case MEM_GOING_ONLINE:
+	case MEM_PREPARE_ONLINE:
+		/*
+		 * Access the altmap_start_pfn and altmap_nr_pages fields
+		 * within the struct memory_notify specifically when dealing
+		 * with only MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers.
+		 *
+		 * When altmap is in use, take the specified memory range
+		 * online, which includes the altmap.
+		 */
+		if (arg->altmap_nr_pages) {
+			start = PFN_PHYS(arg->altmap_start_pfn);
+			size += PFN_PHYS(arg->altmap_nr_pages);
+		}
 		rc = sclp_mem_change_state(start, size, 1);
+		if (rc || !arg->altmap_nr_pages)
+			break;
+		/*
+		 * Set CMMA state to nodat here, since the struct page memory
+		 * at the beginning of the memory block will not go through the
+		 * buddy allocator later.
+		 */
+		__arch_set_page_nodat((void *)__va(start), arg->altmap_nr_pages);
 		break;
-	case MEM_CANCEL_ONLINE:
-		sclp_mem_change_state(start, size, 0);
-		break;
-	case MEM_OFFLINE:
+	case MEM_FINISH_OFFLINE:
+		/*
+		 * When altmap is in use, take the specified memory range
+		 * offline, which includes the altmap.
+		 */
+		if (arg->altmap_nr_pages) {
+			start = PFN_PHYS(arg->altmap_start_pfn);
+			size += PFN_PHYS(arg->altmap_nr_pages);
+		}
 		sclp_mem_change_state(start, size, 0);
 		break;
 	default:
@@ -397,7 +424,9 @@ static void __init add_memory_merged(u16
 	if (!size)
 		goto skip_add;
 	for (addr = start; addr < start + size; addr += block_size)
-		add_memory(0, addr, block_size, MHP_NONE);
+		add_memory(0, addr, block_size,
+			   MACHINE_HAS_EDAT1 ?
+			   MHP_MEMMAP_ON_MEMORY | MHP_OFFLINE_INACCESSIBLE : MHP_NONE);
 skip_add:
 	first_rn = rn;
 	num = 1;
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-memory_hotplug-add-missing-mem_hotplug_lock.patch
mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch
mm-use-vmem_altmap-code-without-config_zone_device.patch
mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch
s390-sclp-remove-unhandled-memory-notifier-type.patch
s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-enable-mhp_memmap_on_memory.patch

