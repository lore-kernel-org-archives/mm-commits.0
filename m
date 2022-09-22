Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA806C32771
	for <mm-commits@archiver.kernel.org>; Thu, 22 Sep 2022 00:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiIVAwN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiIVAwM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 20:52:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244DA8A1C9
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 17:52:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD89B83303
        for <mm-commits@vger.kernel.org>; Thu, 22 Sep 2022 00:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C17BC433D6;
        Thu, 22 Sep 2022 00:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663807928;
        bh=9nyY0rBNquPppTEZQ0riAyFdXWmCBdvGHbIVW9GnISA=;
        h=Date:To:From:Subject:From;
        b=F2yTfxy4XPUQUOlgLz56Wv4o5qBnlt06uPN3nYyBp1LkB3AUG0pB15YQmngp+swyo
         5IIgbbNPv7oRxhQfCfeY42Q6Wf2DdzaExfIPTDd5x9rSPigqZtOaFuHdi+CJW+zWud
         TLmozHsp1guQ+KQJgWCS75fs+DOxl4ZAzlYBNb2Y=
Date:   Wed, 21 Sep 2022 17:52:06 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        peterz@infradead.org, keescook@chromium.org, jpoimboe@kernel.org,
        dev@der-flo.net, dave.hansen@linux.intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20220922005208.3C17BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix
Date: Wed Sep 21 05:50:47 PM PDT 2022

no instrument_copy_from_user() in my tree...

Cc: Kees Cook <keescook@chromium.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Florian Lehner <dev@der-flo.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Florian Lehner <dev@der-flo.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/x86/lib/usercopy.c~x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix
+++ a/arch/x86/lib/usercopy.c
@@ -44,7 +44,6 @@ copy_from_user_nmi(void *to, const void
 	 * called from other contexts.
 	 */
 	pagefault_disable();
-	instrument_copy_from_user(to, from, n);
 	ret = raw_copy_from_user(to, from, n);
 	pagefault_enable();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmhwpoison-check-mm-when-killing-accessing-process-fix.patch
x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

