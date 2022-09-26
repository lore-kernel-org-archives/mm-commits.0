Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376FBC07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 18:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIZS32 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 14:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiIZS31 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 14:29:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CF12A9
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 11:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57627B80D3C
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 18:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2360C433C1;
        Mon, 26 Sep 2022 18:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664216964;
        bh=y9nXLnnW9QmSVR2IXn0GW+LqDyhsca4F5IAtsRwPqdM=;
        h=Date:To:From:Subject:From;
        b=S1iQPoqzaBJbFJkIB20Y/oXBCYsy03Cr4E8M11tbsE653vpr8SXS5NMdEeMezfALU
         MDExD65graLlQz/SNm9CuXy1PdFQ3ZVjyzQz4d8vYQOx1AeRcTb2Vu4Wf6tE0tfumT
         WZ+5qQz1iV7SgJr/PRst6Gk/AnmFXK94aA1+NJiU=
Date:   Mon, 26 Sep 2022 11:29:23 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        peterz@infradead.org, keescook@chromium.org, jpoimboe@kernel.org,
        dev@der-flo.net, dave.hansen@linux.intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix.patch removed from -mm tree
Message-Id: <20220926182923.F2360C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix
has been removed from the -mm tree.  Its filename was
     x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi-fix.patch

This patch was dropped because it was folded into x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi.patch

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
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/usercopy.c |    1 -
 1 file changed, 1 deletion(-)

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

x86-uaccess-avoid-check_object_size-in-copy_from_user_nmi.patch
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

