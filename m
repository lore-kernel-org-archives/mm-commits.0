Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC18CC6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 05:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjBZFhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 00:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBZFhF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 00:37:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350A412852
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 21:37:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C40A560C07
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 05:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D4FC433EF;
        Sun, 26 Feb 2023 05:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677389823;
        bh=bvvUk8L2SxB3eOhriWll3rBVabporGCw53XbHI6/rDM=;
        h=Date:To:From:Subject:From;
        b=U0+LYuzSy6VTkJ1NBmn4Oo/9jCWk1ByoaquHji48MSpKCz3NVRokv86PZZz1atraT
         9IFy7iZOzgL3U7Z3llyQY0JE+0HatQmK1bipPrqqxz0KDwi+ZmvffNy722c0/a+Vrs
         bS6AuU18Pf8/oXcqSkSavMZJeEWRfHby7i9+xoII=
Date:   Sat, 25 Feb 2023 21:37:02 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-tracepoints-to-ksm.patch added to mm-unstable branch
Message-Id: <20230226053703.17D4FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add tracepoints to ksm
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-tracepoints-to-ksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-tracepoints-to-ksm.patch

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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: add tracepoints to ksm
Date: Fri, 10 Feb 2023 13:46:45 -0800

This adds the following tracepoints to ksm:
- start / stop scan
- ksm enter / exit
- merge a page
- merge a page with ksm
- remove a page
- remove a rmap item

This patch has been split off from the RFC patch series "mm:
process/cgroup ksm support".

Link: https://lkml.kernel.org/r/20230210214645.2720847-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


new file mode 100644
--- /dev/null
+++ b/include/trace/events/ksm.h
@@ -0,0 +1,251 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ksm
+
+#if !defined(_TRACE_KSM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KSM_H
+
+#include <linux/tracepoint.h>
+
+/**
+ * ksm_scan_template - called for start / stop scan
+ *
+ * @seq:		sequence number of scan
+ * @rmap_entries:	actual number of rmap entries
+ *
+ * Allows to trace the start / stop of a ksm scan.
+ */
+DECLARE_EVENT_CLASS(ksm_scan_template,
+
+	TP_PROTO(int seq, u32 rmap_entries),
+
+	TP_ARGS(seq, rmap_entries),
+
+	TP_STRUCT__entry(
+		__field(int,	seq)
+		__field(u32,	rmap_entries)
+	),
+
+	TP_fast_assign(
+		__entry->seq		= seq;
+		__entry->rmap_entries	= rmap_entries;
+	),
+
+	TP_printk("seq %d rmap size %d",
+			__entry->seq, __entry->rmap_entries)
+);
+
+/**
+ * ksm_start_scan - called after a new ksm scan is started
+ *
+ * @seq:		sequence number of scan
+ * @rmap_entries:	actual number of rmap entries
+ *
+ * Allows to trace the start of a ksm scan.
+ */
+DEFINE_EVENT(ksm_scan_template, ksm_start_scan,
+
+	TP_PROTO(int seq, u32 rmap_entries),
+
+	TP_ARGS(seq, rmap_entries)
+);
+
+/**
+ * ksm_stop_scan - called after a new ksm scan has completed
+ *
+ * @seq:		sequence number of scan
+ * @rmap_entries:	actual number of rmap entries
+ *
+ * Allows to trace the completion of a ksm scan.
+ */
+DEFINE_EVENT(ksm_scan_template, ksm_stop_scan,
+
+	TP_PROTO(int seq, u32 rmap_entries),
+
+	TP_ARGS(seq, rmap_entries)
+);
+
+/**
+ * ksm_enter - called after a new process has been added / removed from ksm
+ *
+ * @mm:			address of the mm object of the process
+ *
+ * Allows to trace the when a process has been added or removed from ksm.
+ */
+DECLARE_EVENT_CLASS(ksm_enter_exit_template,
+
+	TP_PROTO(void *mm),
+
+	TP_ARGS(mm),
+
+	TP_STRUCT__entry(
+		__field(void *,		mm)
+	),
+
+	TP_fast_assign(
+		__entry->mm	= mm;
+	),
+
+	TP_printk("mm %p", __entry->mm)
+);
+
+/**
+ * ksm_enter - called after a new process has been added to ksm
+ *
+ * @mm:			address of the mm object of the process
+ *
+ * Allows to trace the when a process has been added to ksm.
+ */
+DEFINE_EVENT(ksm_enter_exit_template, ksm_enter,
+
+	TP_PROTO(void *mm),
+
+	TP_ARGS(mm)
+);
+
+/**
+ * ksm_exit - called after a new process has been removed from ksm
+ *
+ * @mm:			address of the mm object of the process
+ *
+ * Allows to trace the when a process has been removed from ksm.
+ */
+DEFINE_EVENT(ksm_enter_exit_template, ksm_exit,
+
+	TP_PROTO(void *mm),
+
+	TP_ARGS(mm)
+);
+
+/**
+ * ksm_merge_one_page - called after a page has been merged
+ *
+ * @pfn:		page frame number of ksm page
+ * @rmap_item:		address of rmap_item  object
+ * @mm:			address of the process mm struct
+ * @err:		success
+ *
+ * Allows to trace the ksm merging of individual pages.
+ */
+TRACE_EVENT(ksm_merge_one_page,
+
+	TP_PROTO(unsigned long pfn, void *rmap_item, void *mm, int err),
+
+	TP_ARGS(pfn, rmap_item, mm, err),
+
+	TP_STRUCT__entry(
+		__field(unsigned long,	pfn)
+		__field(void *,		rmap_item)
+		__field(void *,		mm)
+		__field(int,		err)
+	),
+
+	TP_fast_assign(
+		__entry->pfn		= pfn;
+		__entry->rmap_item	= rmap_item;
+		__entry->mm		= mm;
+		__entry->err		= err;
+	),
+
+	TP_printk("ksm pfn %lu rmap_item %p mm %p error %d",
+			__entry->pfn, __entry->rmap_item, __entry->mm, __entry->err)
+);
+
+/**
+ * ksm_merge_with_ksm_page - called after a page has been merged with a ksm page
+ *
+ * @ksm_page:		address ksm page
+ * @pfn:		page frame number of ksm page
+ * @rmap_item:		address of rmap_item  object
+ * @mm:			address of the mm object of the process
+ * @err:		success
+ *
+ * Allows to trace the merging of a page with a ksm page.
+ */
+TRACE_EVENT(ksm_merge_with_ksm_page,
+
+	TP_PROTO(void *ksm_page, unsigned long pfn, void *rmap_item, void *mm, int err),
+
+	TP_ARGS(ksm_page, pfn, rmap_item, mm, err),
+
+	TP_STRUCT__entry(
+		__field(void *,		ksm_page)
+		__field(unsigned long,	pfn)
+		__field(void *,		rmap_item)
+		__field(void *,		mm)
+		__field(int,		err)
+	),
+
+	TP_fast_assign(
+		__entry->ksm_page	= ksm_page;
+		__entry->pfn		= pfn;
+		__entry->rmap_item	= rmap_item;
+		__entry->mm		= mm;
+		__entry->err		= err;
+	),
+
+	TP_printk("%spfn %lu rmap_item %p mm %p error %d",
+		  (__entry->ksm_page ? "ksm " : ""),
+		  __entry->pfn, __entry->rmap_item, __entry->mm, __entry->err)
+);
+
+/**
+ * ksm_remove_ksm_page - called after a ksm page has been removed
+ *
+ * @pfn:		page frame number of ksm page
+ *
+ * Allows to trace the removing of stable ksm pages.
+ */
+TRACE_EVENT(ksm_remove_ksm_page,
+
+	TP_PROTO(unsigned long pfn),
+
+	TP_ARGS(pfn),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("pfn %lu", __entry->pfn)
+);
+
+/**
+ * ksm_remove_rmap_item - called after a rmap_item has been removed from the
+ *                        stable tree
+ *
+ * @pfn:		page frame number of ksm page
+ * @rmap_item:		address of rmap_item  object
+ * @mm:			address of the process mm struct
+ *
+ * Allows to trace the removal of pages from the stable tree list.
+ */
+TRACE_EVENT(ksm_remove_rmap_item,
+
+	TP_PROTO(unsigned long pfn, void *rmap_item, void *mm),
+
+	TP_ARGS(pfn, rmap_item, mm),
+
+	TP_STRUCT__entry(
+		__field(unsigned long,	pfn)
+		__field(void *,		rmap_item)
+		__field(void *,		mm)
+	),
+
+	TP_fast_assign(
+		__entry->pfn		= pfn;
+		__entry->rmap_item	= rmap_item;
+		__entry->mm		= mm;
+	),
+
+	TP_printk("pfn %lu rmap_item %p mm %p",
+			__entry->pfn, __entry->rmap_item, __entry->mm)
+);
+
+#endif /* _TRACE_KSM_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/MAINTAINERS~mm-add-tracepoints-to-ksm
+++ b/MAINTAINERS
@@ -13415,6 +13415,7 @@ F:	include/linux/memory_hotplug.h
 F:	include/linux/mm.h
 F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
+F:	include/trace/events/ksm.h
 F:	mm/
 F:	tools/mm/
 F:	tools/testing/selftests/mm/
--- a/mm/ksm.c~mm-add-tracepoints-to-ksm
+++ b/mm/ksm.c
@@ -45,6 +45,9 @@
 #include "internal.h"
 #include "mm_slot.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ksm.h>
+
 #ifdef CONFIG_NUMA
 #define NUMA(x)		(x)
 #define DO_NUMA(x)	do { (x); } while (0)
@@ -655,10 +658,12 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
 	BUG_ON(stable_node->rmap_hlist_len < 0);
 
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
-		if (rmap_item->hlist.next)
+		if (rmap_item->hlist.next) {
 			ksm_pages_sharing--;
-		else
+			trace_ksm_remove_rmap_item(stable_node->kpfn, rmap_item, rmap_item->mm);
+		} else {
 			ksm_pages_shared--;
+		}
 
 		rmap_item->mm->ksm_merging_pages--;
 
@@ -679,6 +684,7 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
 	BUILD_BUG_ON(STABLE_NODE_DUP_HEAD <= &migrate_nodes);
 	BUILD_BUG_ON(STABLE_NODE_DUP_HEAD >= &migrate_nodes + 1);
 
+	trace_ksm_remove_ksm_page(stable_node->kpfn);
 	if (stable_node->head == &migrate_nodes)
 		list_del(&stable_node->list);
 	else
@@ -1367,6 +1373,8 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
+	trace_ksm_merge_with_ksm_page(kpage, page_to_pfn(kpage ? kpage : page),
+				rmap_item, mm, err);
 	return err;
 }
 
@@ -2114,6 +2122,9 @@ static int try_to_merge_with_kernel_zero_page(struct ksm_rmap_item *rmap_item,
 		if (vma) {
 			err = try_to_merge_one_page(vma, page,
 						ZERO_PAGE(rmap_item->address));
+			trace_ksm_merge_one_page(
+				page_to_pfn(ZERO_PAGE(rmap_item->address)),
+				rmap_item, mm, err);
 			if (!err) {
 				rmap_item->address |= ZERO_PAGE_FLAG;
 				ksm_zero_pages_sharing++;
@@ -2346,6 +2357,8 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 
 	mm_slot = ksm_scan.mm_slot;
 	if (mm_slot == &ksm_mm_head) {
+		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
+
 		/*
 		 * A number of pages can hang around indefinitely on per-cpu
 		 * pagevecs, raised page count preventing write_protect_page
@@ -2512,6 +2525,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 	if (mm_slot != &ksm_mm_head)
 		goto next_mm;
 
+	trace_ksm_stop_scan(ksm_scan.seqnr, ksm_rmap_items);
 	ksm_scan.seqnr++;
 	return NULL;
 }
@@ -2663,6 +2677,7 @@ int __ksm_enter(struct mm_struct *mm)
 	if (needs_wakeup)
 		wake_up_interruptible(&ksm_thread_wait);
 
+	trace_ksm_enter(mm);
 	return 0;
 }
 
@@ -2704,6 +2719,8 @@ void __ksm_exit(struct mm_struct *mm)
 		mmap_write_lock(mm);
 		mmap_write_unlock(mm);
 	}
+
+	trace_ksm_exit(mm);
 }
 
 struct page *ksm_might_need_to_copy(struct page *page,
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-add-new-ksm-process-and-sysfs-knobs.patch
selftests-mm-add-new-selftests-for-ksm.patch
mm-add-tracepoints-to-ksm.patch

