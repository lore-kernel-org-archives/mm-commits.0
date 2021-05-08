Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FFCC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C64B66101D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhEHWuz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhEHWuy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9286B6100C;
        Sat,  8 May 2021 22:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514192;
        bh=vV8GT+Z0cmYNk2eyiI6c2l81cUCqPcuFtzRgTilEDck=;
        h=Date:From:To:Subject:From;
        b=qhAr2gMLdtHk++6tLJY11ZhUvsgh8Q37tINorAjJL1XAIstGFEj0C7PJsirTfZqNm
         eJrLkvyoNSHf6ZE+jgvyOauffXYO6DgYk9/P5s7Mv6wPh4zHOYaufQEH+hh7jnZAah
         dHt5KSbGVm0p8GpPGeyx/Aps5MaT/JYCJ3rL8PYc=
Date:   Sat, 08 May 2021 15:49:52 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hannes@cmpxchg.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, saravanand@fb.com, tj@kernel.org
Subject:  [merged]
 x86-mm-tracking-linear-mapping-split-events.patch removed from -mm tree
Message-ID: <20210508224952.6MXpGF-Hl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm: track linear mapping split events
has been removed from the -mm tree.  Its filename was
     x86-mm-tracking-linear-mapping-split-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Saravanan D <saravanand@fb.com>
Subject: x86/mm: track linear mapping split events

To help with debugging the sluggishness caused by TLB miss/reload, we
introduce monotonic hugepage [direct mapped] split event counts since
system state: SYSTEM_RUNNING to be displayed as part of /proc/vmstat in
x86 servers

The lifetime split event information will be displayed at the bottom of
/proc/vmstat
....
swap_ra 0
swap_ra_hit 0
direct_map_level2_splits 94
direct_map_level3_splits 4
nr_unstable 0
....

One of the many lasting sources of direct hugepage splits is kernel
tracing (kprobes, tracepoints).

Note that the kernel's code segment [512 MB] points to the same physical
addresses that have been already mapped in the kernel's direct mapping
range.

Source : Documentation/x86/x86_64/mm.rst

When we enable kernel tracing, the kernel has to modify
attributes/permissions of the text segment hugepages that are direct
mapped causing them to split.

Kernel's direct mapped hugepages do not coalesce back after split and
remain in place for the remainder of the lifetime.

An instance of direct page splits when we turn on dynamic kernel tracing
....
cat /proc/vmstat | grep -i direct_map_level
direct_map_level2_splits 784
direct_map_level3_splits 12
bpftrace -e 'tracepoint:raw_syscalls:sys_enter { @ [pid, comm] =
count(); }'
cat /proc/vmstat | grep -i
direct_map_level
direct_map_level2_splits 789
direct_map_level3_splits 12
....

Link: https://lkml.kernel.org/r/20210218235744.1040634-1-saravanand@fb.com
Signed-off-by: Saravanan D <saravanand@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/set_memory.c  |    8 ++++++++
 include/linux/vm_event_item.h |    4 ++++
 mm/vmstat.c                   |    4 ++++
 3 files changed, 16 insertions(+)

--- a/arch/x86/mm/pat/set_memory.c~x86-mm-tracking-linear-mapping-split-events
+++ a/arch/x86/mm/pat/set_memory.c
@@ -16,6 +16,8 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/libnvdimm.h>
+#include <linux/vmstat.h>
+#include <linux/kernel.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -91,6 +93,12 @@ static void split_page_count(int level)
 		return;
 
 	direct_pages_count[level]--;
+	if (system_state == SYSTEM_RUNNING) {
+		if (level == PG_LEVEL_2M)
+			count_vm_event(DIRECT_MAP_LEVEL2_SPLIT);
+		else if (level == PG_LEVEL_1G)
+			count_vm_event(DIRECT_MAP_LEVEL3_SPLIT);
+	}
 	direct_pages_count[level - 1] += PTRS_PER_PTE;
 }
 
--- a/include/linux/vm_event_item.h~x86-mm-tracking-linear-mapping-split-events
+++ a/include/linux/vm_event_item.h
@@ -125,6 +125,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		SWAP_RA,
 		SWAP_RA_HIT,
 #endif
+#ifdef CONFIG_X86
+		DIRECT_MAP_LEVEL2_SPLIT,
+		DIRECT_MAP_LEVEL3_SPLIT,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
--- a/mm/vmstat.c~x86-mm-tracking-linear-mapping-split-events
+++ a/mm/vmstat.c
@@ -1369,6 +1369,10 @@ const char * const vmstat_text[] = {
 	"swap_ra",
 	"swap_ra_hit",
 #endif
+#ifdef CONFIG_X86
+	"direct_map_level2_splits",
+	"direct_map_level3_splits",
+#endif
 #endif /* CONFIG_VM_EVENT_COUNTERS || CONFIG_MEMCG */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
_

Patches currently in -mm which might be from saravanand@fb.com are


