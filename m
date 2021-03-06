Return-Path: <SRS0=v6Vt=IE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2939FC433DB
	for <mm-commits@archiver.kernel.org>; Sat,  6 Mar 2021 00:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D06246507C
	for <mm-commits@archiver.kernel.org>; Sat,  6 Mar 2021 00:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhCFA70 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Mar 2021 19:59:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229976AbhCFA7E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Mar 2021 19:59:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C466F64FCF;
        Sat,  6 Mar 2021 00:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614992344;
        bh=MpEk3l37A53eDnuvMGFyyxESns2RsrjVvFRj6LFwjac=;
        h=Date:From:To:Subject:From;
        b=vCWSN9fXY2OjY6xtNZdMsJGha56JFLLvniM5oEzsuXOv9Z60D24PoAeBjAofrRTSs
         7zCIF6DchCMyAq5cWZTNk5UGNP5IITFEYY5sAdp1DWHFaH5Mb2WXN66ACyXoMS1Ezk
         sSY9lHBrZemEXYm4Z9uUYLcOP34l9ruEHJ8igWAM=
Date:   Fri, 05 Mar 2021 16:59:03 -0800
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hannes@cmpxchg.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, saravanand@fb.com, tj@kernel.org
Subject:  + x86-mm-tracking-linear-mapping-split-events.patch added
 to -mm tree
Message-ID: <20210306005903.gfH_h8jk7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm: track linear mapping split events
has been added to the -mm tree.  Its filename is
     x86-mm-tracking-linear-mapping-split-events.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-mm-tracking-linear-mapping-split-events.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-tracking-linear-mapping-split-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

x86-mm-tracking-linear-mapping-split-events.patch

