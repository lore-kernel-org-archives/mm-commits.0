Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51034FA3741
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 23:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiJaXYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 19:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJaXYX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 19:24:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1541115E
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 16:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EED8614D0
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 23:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9496C433C1;
        Mon, 31 Oct 2022 23:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667258659;
        bh=rfFVP4yU306LnSeinPUOcdTtrH9cgGOZ4A0S056lOgM=;
        h=Date:To:From:Subject:From;
        b=pVgRNPOgMZpsENtldqkRGPfqxmd/qah6TtMEHn2jsINkhIjFjRMlTd3PhbM1C7wyb
         IQjDhhTg6o9GGvRIwYdn+po8UwvTHPFbQ5DmVAdsv0h/FcFjAtKIW0dE47ODiWC+3F
         GTM80J21X+hw9uMspRZur7Oq7HcCE+DFO1yI6uOU=
Date:   Mon, 31 Oct 2022 16:24:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, zhaoyang.huang@unisoc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3.patch added to mm-unstable branch
Message-Id: <20221031232419.A9496C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3.patch

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
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3.patch

