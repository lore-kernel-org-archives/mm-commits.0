Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D99C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjC1XMR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjC1XMQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:12:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EFE10F8
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3454B81EEB
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636F5C433D2;
        Tue, 28 Mar 2023 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045133;
        bh=AjunrewCyImdWKf5OwbqIxxUhx8zFje3pbG+iW7nKsA=;
        h=Date:To:From:Subject:From;
        b=1W0NGOzJoyBqn0qt+m9pIE7w5nRv3KUFMT7Qut0ftwa+I/rq26G9UGOodQAwH6FZi
         IkcHc2CgfyzDYTPrIh1Dem3sGhjY9JkEiYu+DXZ84ztSoeq0czJ5nGE+tIpY9Yikly
         rrRNXidbpUAqEUnWxYDbp/ElzRwF/7kLZhDXLd64=
Date:   Tue, 28 Mar 2023 16:12:12 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20230328231213.636F5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes
Date: Thu Feb 23 01:48:48 PM PST 2023

WARNING: braces {} are not necessary for single statement blocks
#152: FILE: mm/page_alloc.c:956:
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages) {
+		static_branch_enable(&check_pages_enabled);
+	}

total: 3 errors, 2 warnings, 307 lines checked

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -953,9 +953,8 @@ void __init init_mem_debugging_and_harde
 	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
 	 * enabled already.
 	 */
-	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages) {
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
 		static_branch_enable(&check_pages_enabled);
-	}
 }
 
 static inline void set_buddy_order(struct page *page, unsigned int order)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

