Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1393BC4167B
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 20:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiLOU1H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 15:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiLOU1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 15:27:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86B72BB2F
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 12:27:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 824C861F18
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 20:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E93C433D2;
        Thu, 15 Dec 2022 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671136021;
        bh=9M7Qnx304hM0pYEDdZDHG3tNkNlhtahteBZtWVYQxjQ=;
        h=Date:To:From:Subject:From;
        b=v6YfUALyzzmk6EsO0wa2NKDhU6GGTwTyCIqHRPBN85ohpUZWOu+tTOvcdxT88pph6
         j3ZzQgmHpSOLdOdz+D9DN2Smsa6eUX4RZd/871R0Ofc6HdmoLeeyTK9ZVZqto3FQXS
         dWfgCrEeHOHDR+xL+d7YmssgfiCWSjRdnYuaZaWY=
Date:   Thu, 15 Dec 2022 12:27:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3.patch removed from -mm tree
Message-Id: <20221215202701.D0E93C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3
has been removed from the -mm tree.  Its filename was
     mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3.patch

This patch was dropped because it was folded into mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch

------------------------------------------------------
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3
Date: Sun, 30 Oct 2022 11:42:34 +0800

changes of v2: fix bugs of stack_depot_init related issue
changes of v3: have DEBUG_KMEMLEAK select STACK_DEPOT by default
               remove unuse functions

Link: https://lkml.kernel.org/r/1667101354-4669-1-git-send-email-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 mm/kmemleak.c     |   19 ++++++-------------
 2 files changed, 7 insertions(+), 13 deletions(-)

--- a/lib/Kconfig.debug~mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3
+++ a/lib/Kconfig.debug
@@ -726,6 +726,7 @@ config DEBUG_KMEMLEAK
 	select STACKTRACE if STACKTRACE_SUPPORT
 	select KALLSYMS
 	select CRC32
+	select STACKDEPOT
 	help
 	  Say Y here if you want to enable the memory leak
 	  detector. The memory allocation/freeing is traced in a way
--- a/mm/kmemleak.c~mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3
+++ a/mm/kmemleak.c
@@ -343,7 +343,7 @@ static bool unreferenced_object(struct k
  * print_unreferenced function must be called with the object->lock held.
  */
 static void print_unreferenced(struct seq_file *seq,
-			       struct kmemleak_object *object)
+		struct kmemleak_object *object)
 {
 	int i;
 	unsigned long *entries;
@@ -352,10 +352,10 @@ static void print_unreferenced(struct se
 
 	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
 	warn_or_seq_printf(seq, "unreferenced object 0x%08lx (size %zu):\n",
-		   object->pointer, object->size);
+			object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu (age %d.%03ds)\n",
-		   object->comm, object->pid, object->jiffies,
-		   msecs_age / 1000, msecs_age % 1000);
+			object->comm, object->pid, object->jiffies,
+			msecs_age / 1000, msecs_age % 1000);
 	hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace:\n");
 
@@ -373,9 +373,9 @@ static void print_unreferenced(struct se
 static void dump_object_info(struct kmemleak_object *object)
 {
 	pr_notice("Object 0x%08lx (size %zu):\n",
-		  object->pointer, object->size);
+			object->pointer, object->size);
 	pr_notice("  comm \"%s\", pid %d, jiffies %lu\n",
-		  object->comm, object->pid, object->jiffies);
+			object->comm, object->pid, object->jiffies);
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
 	pr_notice("  flags = 0x%x\n", object->flags);
@@ -595,7 +595,6 @@ static struct kmemleak_object *find_and_
 	return object;
 }
 
-#ifdef CONFIG_STACKDEPOT
 static noinline depot_stack_handle_t set_track_prepare(void)
 {
 	depot_stack_handle_t trace_handle;
@@ -609,12 +608,6 @@ static noinline depot_stack_handle_t set
 
 	return trace_handle;
 }
-#else
-static inline depot_stack_handle_t set_track_prepare(void)
-{
-	return 0;
-}
-#endif
 
 /*
  * Create the metadata (struct kmemleak_object) corresponding to an allocated
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch

