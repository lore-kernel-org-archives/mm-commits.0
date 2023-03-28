Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4A4C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjC1XMS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjC1XMR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:12:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344C32109
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77221619D3
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E41C433EF;
        Tue, 28 Mar 2023 23:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045134;
        bh=lHGCVYiYvRl7zS27nlBgVE+dU86jGSuhsSqnewrOXdI=;
        h=Date:To:From:Subject:From;
        b=yjKjsqph85WXEHheNtrcOomK5THRmSOEn2nmLX6Y0cqTU4nd/32LbFXOKtRDHs+YB
         3uL1+6pzZVYwXUKrhz7gen3tZ88LLd71HwUW+MeCpUMK6MKNW/TF3W9DF3SzEaiZCd
         h5PODS2HI6WdOL6p4qXmJT1Dr6ST7ExOARjguk0M=
Date:   Tue, 28 Mar 2023 16:12:14 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, lkp@intel.com, keescook@chromium.org,
        halbuer@sra.uni-hannover.de, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch removed from -mm tree
Message-Id: <20230328231214.C5E41C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch

This patch was dropped because it was folded into mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix
Date: Sat Feb 25 01:00:30 PM PST 2023

make check_pages_enabled static

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lkml.kernel.org/r/63fa411f.ZvVOisJt5OlLzGYF%25lkp@intel.com
Cc: Alexander Halbuer <halbuer@sra.uni-hannover.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix
+++ a/mm/page_alloc.c
@@ -254,7 +254,7 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_F
 EXPORT_SYMBOL(init_on_free);
 
 /* perform sanity checks on struct pages being allocated or freed */
-DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
+static DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
 static bool _init_on_alloc_enabled_early __read_mostly
 				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

