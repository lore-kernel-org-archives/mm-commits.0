Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8BBECAAA3
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 04:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243543AbiHZEYW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 00:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiHZEYV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 00:24:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14026C6FD6
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 21:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BF7060C8A
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 04:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E98C433D6;
        Fri, 26 Aug 2022 04:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661487860;
        bh=SguABkCVdo2Nsfkpy2DSrfGMNj+FsXGZYyxGBbZB/Fk=;
        h=Date:To:From:Subject:From;
        b=jbO+ytWUGRLLsDneygViNTilZ3e2bPGvVdZpY7pmy4/uGS8cNelBWqV8A2pYzW61U
         LiubLqqYCnfl56IXsaHv5JSLHgb7f5lFg1pAF56b7LWpe3on374+jxadaULTao5GRZ
         j4IEeZYGbqYggxmHV57B4QR4IwI3fwYSTyckal2M=
Date:   Thu, 25 Aug 2022 21:24:19 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rostedt@goodmis.org,
        mhocko@suse.com, mhiramat@kernel.org, mark-pk.tsai@mediatek.com,
        lizhe.67@bytedance.com, keescook@chromium.org, Jason@zx2c4.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + page_ext-introduce-boot-parameter-early_page_ext-fix.patch added to mm-unstable branch
Message-Id: <20220826042419.E0E98C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: page_ext-introduce-boot-parameter-early_page_ext-fix
has been added to the -mm mm-unstable branch.  Its filename is
     page_ext-introduce-boot-parameter-early_page_ext-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/page_ext-introduce-boot-parameter-early_page_ext-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: page_ext-introduce-boot-parameter-early_page_ext-fix
Date: Thu Aug 25 09:17:22 PM PDT 2022

fix section issue by removing __meminitdata

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_ext.c~page_ext-introduce-boot-parameter-early_page_ext-fix
+++ a/mm/page_ext.c
@@ -91,7 +91,7 @@ unsigned long page_ext_size = sizeof(str
 static unsigned long total_usage;
 static struct page_ext *lookup_page_ext(const struct page *page);
 
-bool early_page_ext __meminitdata;
+bool early_page_ext;
 static int __init setup_early_page_ext(char *str)
 {
 	early_page_ext = true;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

