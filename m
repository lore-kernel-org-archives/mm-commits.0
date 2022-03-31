Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5C1C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 23:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiCaXMi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242850AbiCaXMg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 19:12:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC09116B66
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 16:10:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A32BA611B9
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 23:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF84C340F0;
        Thu, 31 Mar 2022 23:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648768246;
        bh=m1QrNfENOxQobuw988vV/kdm/l6gU5hz91yhQQgO80s=;
        h=Date:To:From:Subject:From;
        b=Ud4G3uyFI8mmvX4P75yW8fdjtbfKPHJbXTlv70asdPcOBXAbRj05WsyrS0eAINjFr
         cg2Hp7ND6L6PyDnlGB8Yfadd+awHgf9wt93Stj/Ye2ACER8kf7dE3vKrMBibIXHStr
         W2TzlWARunBeOPZyJGkuTAK4j+bpzLwtq3c8m98A=
Date:   Thu, 31 Mar 2022 16:10:45 -0700
To:     mm-commits@vger.kernel.org, andreyknvl@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-implement-stack_trace_save_shadow-fix.patch added to -mm tree
Message-Id: <20220331231046.0AF84C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-implement-stack_trace_save_shadow-fix
has been added to the -mm tree.  Its filename is
     arm64-implement-stack_trace_save_shadow-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-implement-stack_trace_save_shadow-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-implement-stack_trace_save_shadow-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
arm64-implement-stack_trace_save_shadow-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
b.patch

