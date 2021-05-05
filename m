Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2433C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9478261182
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhEEBjA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhEEBi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED882610A1;
        Wed,  5 May 2021 01:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178684;
        bh=8dfa4FqJ8vSoj9OpnAB2hCEDxr36SinU6HyULD/ygks=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=peuy8IaoS2rAu+0qfvqYPRvar6YR5YuoYxNpCz/mtervscCncUg1IY6R4eJDQ4kRo
         IC5HdIZtUrP6cFRsnQ0q5Di6xjDz3Jvdzwstab3+1/Ba0CQITRToaZ+3yYye7+p2Bi
         D07S/vaTUm2OlJ68k5VtPUcp+JPjBzpPYBhxT2Lw=
Date:   Tue, 04 May 2021 18:38:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, saravanand@fb.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 100/143] x86/mm: track linear mapping split events
Message-ID: <20210505013803.HxtQZRqih%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
