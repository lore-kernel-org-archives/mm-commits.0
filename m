Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72B6FA3744
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiJ0Uyt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiJ0UyM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:54:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E57D98C96
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F29EBB82638
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C437C433D6;
        Thu, 27 Oct 2022 20:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666903557;
        bh=Yr1ZQ92Sam4WzfyAXrarISnK8VhfY7BD+EpQxJ1EvGI=;
        h=Date:To:From:Subject:From;
        b=ic+XLtgWtfxjjh5bK8Zeq2Oizpt+2WEFp9MggZXJB1Hpb7jX+8c266fvOHObQ07BQ
         /9MirRB7BJNln29oA/zzs3ZBBo4ATqJn4+pJDnAJ8tnFJVILvuhvipQTfuV1kCckIO
         zOsneF2ktT3cv4ovzkduRS0Ab7dYaC5HugX47Nqc=
Date:   Thu, 27 Oct 2022 13:45:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch added to mm-unstable branch
Message-Id: <20221027204557.7C437C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use stack_depot for recording kmemleak's backtrace
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch

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
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm: use stack_depot for recording kmemleak's backtrace
Date: Thu, 27 Oct 2022 17:50:24 +0800

Using stack_depot to record kmemleak's backtrace which has been
implemented on slub for reducing redundant information.

Link: https://lkml.kernel.org/r/1666864224-27541-1-git-send-email-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmemleak.c~mm-use-stack_depot-for-recording-kmemleaks-backtrace
+++ a/mm/kmemleak.c
@@ -79,6 +79,7 @@
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
 #include <linux/stacktrace.h>
+#include <linux/stackdepot.h>
 #include <linux/cache.h>
 #include <linux/percpu.h>
 #include <linux/memblock.h>
@@ -159,8 +160,7 @@ struct kmemleak_object {
 	u32 checksum;
 	/* memory ranges to be scanned inside an object (empty for all) */
 	struct hlist_head area_list;
-	unsigned long trace[MAX_TRACE];
-	unsigned int trace_len;
+	depot_stack_handle_t trace_handle;
 	unsigned long jiffies;		/* creation timestamp */
 	pid_t pid;			/* pid of the current task */
 	char comm[TASK_COMM_LEN];	/* executable name */
@@ -346,8 +346,11 @@ static void print_unreferenced(struct se
 			       struct kmemleak_object *object)
 {
 	int i;
+	unsigned long *entries;
+	unsigned int nr_entries;
 	unsigned int msecs_age = jiffies_to_msecs(jiffies - object->jiffies);
 
+	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
 	warn_or_seq_printf(seq, "unreferenced object 0x%08lx (size %zu):\n",
 		   object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu (age %d.%03ds)\n",
@@ -356,10 +359,10 @@ static void print_unreferenced(struct se
 	hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace:\n");
 
-	for (i = 0; i < object->trace_len; i++) {
-		void *ptr = (void *)object->trace[i];
-		warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
-	}
+       for (i = 0; i < nr_entries; i++) {
+               void *ptr = (void *)entries[i];
+               warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
+       }
 }
 
 /*
@@ -378,7 +381,8 @@ static void dump_object_info(struct kmem
 	pr_notice("  flags = 0x%x\n", object->flags);
 	pr_notice("  checksum = %u\n", object->checksum);
 	pr_notice("  backtrace:\n");
-	stack_trace_print(object->trace, object->trace_len, 4);
+	if(object->trace_handle)
+		stack_depot_print(object->trace_handle);
 }
 
 /*
@@ -591,6 +595,27 @@ static struct kmemleak_object *find_and_
 	return object;
 }
 
+#ifdef CONFIG_STACKDEPOT
+static noinline depot_stack_handle_t set_track_prepare(void)
+{
+	depot_stack_handle_t trace_handle;
+	unsigned long entries[MAX_TRACE];
+	unsigned int nr_entries;
+
+	if (!kmemleak_initialized)
+		return 0;
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
+	trace_handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
+
+	return trace_handle;
+}
+#else
+static inline depot_stack_handle_t set_track_prepare(void)
+{
+	return 0;
+}
+#endif
+
 /*
  * Save stack trace to the given array of MAX_TRACE size.
  */
@@ -653,7 +678,7 @@ static void __create_object(unsigned lon
 	}
 
 	/* kernel backtrace */
-	object->trace_len = __save_stack_trace(object->trace);
+	object->trace_handle = set_track_prepare();
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 
@@ -692,7 +717,6 @@ static void __create_object(unsigned lon
 	rb_link_node(&object->rb_node, rb_parent, link);
 	rb_insert_color(&object->rb_node, is_phys ? &object_phys_tree_root :
 					  &object_tree_root);
-
 	list_add_tail_rcu(&object->object_list, &object_list);
 out:
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
@@ -1091,7 +1115,7 @@ void __ref kmemleak_update_trace(const v
 	}
 
 	raw_spin_lock_irqsave(&object->lock, flags);
-	object->trace_len = __save_stack_trace(object->trace);
+	object->trace_handle = set_track_prepare();
 	raw_spin_unlock_irqrestore(&object->lock, flags);
 
 	put_object(object);
@@ -2084,6 +2108,7 @@ void __init kmemleak_init(void)
 	if (kmemleak_error)
 		return;
 
+	stack_depot_init();
 	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch

