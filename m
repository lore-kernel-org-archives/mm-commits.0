Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDACFC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 00:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242906AbiDAAZy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 20:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239649AbiDAAZy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 20:25:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D632E187BBF
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 17:24:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 730D061767
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 00:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD02C340EE;
        Fri,  1 Apr 2022 00:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648772644;
        bh=9kEI+XnN3jWRqgsl2/AZNmToFokOB5fmhyBhf4q8sPQ=;
        h=Date:To:From:Subject:From;
        b=Ki5zfxNNvM6AWn3XkdGWinTPet5v8CFAKmBa1sLFj6rfbF64yeOsVZArwZuJLDKmb
         AcTPvWczkZ3W3xAanffxu85doC8CoYukrBy0Aip33Pt0a4LsNkbL3pZU2xDgt81VLa
         9XiRik7HK55+yv6pJ/FRLhjNGWB5IZPNsTsUf6fs=
Date:   Thu, 31 Mar 2022 17:24:04 -0700
To:     mm-commits@vger.kernel.org, andreyknvl@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm64-implement-stack_trace_save_shadow-fix.patch removed from -mm tree
Message-Id: <20220401002404.CCD02C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-implement-stack_trace_save_shadow-fix
has been removed from the -mm tree.  Its filename was
     arm64-implement-stack_trace_save_shadow-fix.patch

This patch was dropped because it was folded into arm64-implement-stack_trace_save_shadow.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arm64-implement-stack_trace_save_shadow-fix

add ifdefs to arch/arm64/kernel/stacktrace.c

Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/stacktrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/stacktrace.c~arm64-implement-stack_trace_save_shadow-fix
+++ a/arch/arm64/kernel/stacktrace.c
@@ -213,6 +213,7 @@ noinline notrace void arch_stack_walk(st
 	walk_stackframe(task, &frame, consume_entry, cookie);
 }
 
+#ifdef CONFIG_SHADOW_CALL_STACK
 static const struct {
 	unsigned long ** __percpu saved;
 	unsigned long ** __percpu base;
@@ -293,3 +294,4 @@ out:
 	preempt_enable();
 	return len;
 }
+#endif		/* CONFIG_SHADOW_CALL_STACK */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
arm64-implement-stack_trace_save_shadow.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
b.patch

