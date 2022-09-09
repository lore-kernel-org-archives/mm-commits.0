Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E35ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 22:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIIWAe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 18:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiIIWAd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 18:00:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B749106365
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 15:00:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09F86620D5
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 22:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4B0C433D6;
        Fri,  9 Sep 2022 22:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662760831;
        bh=Mk3rT9QLQV1o77tp2UDNuBtPWlb3Q3+l0WKPkmxmqsY=;
        h=Date:To:From:Subject:From;
        b=pobhHIaXGok0FHv0iQnKi+ii2heaLA4N1+FG6A/Ccjow4NGy7S0mI3+TOydfzxr3P
         g94Q/uKQlYe5Z2D70kkU4kFnTl0IEk2fX5zE9gTPtWCVBMIhHKOfspj4h8Bl14snoS
         KyIk38fbaqmrY6O5UH5piTWrsUZ9OWawpJ7haPys=
Date:   Fri, 09 Sep 2022 15:00:30 -0700
To:     mm-commits@vger.kernel.org, fmayer@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] add-sicode-to-proc-pid-stat-fix.patch removed from -mm tree
Message-Id: <20220909220031.5B4B0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: add-sicode-to-proc-pid-stat-fix
has been removed from the -mm tree.  Its filename was
     add-sicode-to-proc-pid-stat-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: add-sicode-to-proc-pid-stat-fix
Date: Fri Sep  9 01:23:07 PM PDT 2022

tidy up do_group_exit() prototype

Cc: Florian Mayer <fmayer@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/task.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/sched/task.h~add-sicode-to-proc-pid-stat-fix
+++ a/include/linux/sched/task.h
@@ -82,7 +82,7 @@ static inline void exit_thread(struct ta
 {
 }
 #endif
-extern __noreturn void do_group_exit(int,int);
+extern __noreturn void do_group_exit(int exit_code, int sicode);
 
 extern void exit_files(struct task_struct *);
 extern void exit_itimers(struct task_struct *);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch
fs-uninline-inode_maybe_inc_iversion.patch

