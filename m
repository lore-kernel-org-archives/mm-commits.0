Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A081CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 00:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbiFVAGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 20:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiFVAGy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 20:06:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BEE14D37
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 17:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 577CFB81B80
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 00:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E843C3411C;
        Wed, 22 Jun 2022 00:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655856410;
        bh=4CE5kqWuVeWNTpu5D1XmG/fKjcniiTXzAINS/7MP4N0=;
        h=Date:To:From:Subject:From;
        b=GdsDNU7S5p++3EZEQHUt8QiHWtPsfJiGizFuXdV3phI7Na8hh1XF3eSbUCFuU1IMF
         ELGJ23JqUlUzYmjIPvcnf3H640j+Jm0jxQIM/Y926GlkZ5oyxoYqiPG2n9diihqQMp
         maiRp/o2c4F8zG5sIu1238Ug26HOoL+QqwI9XDl8=
Date:   Tue, 21 Jun 2022 17:06:42 -0700
To:     mm-commits@vger.kernel.org, p76091292@gs.ncku.edu.tw,
        jrdr.linux@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch added to mm-unstable branch
Message-Id: <20220622000649.2E843C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-docs-fix-comments-that-mention-mem_hotplug_end-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch

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
Subject: mm-docs-fix-comments-that-mention-mem_hotplug_end-fix
Date: Tue Jun 21 05:05:38 PM PDT 2022

grammatical fixes

Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Yun-Ze Li <p76091292@gs.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/compaction.c        |    2 +-
 mm/vmscan.c            |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-docs-fix-comments-that-mention-mem_hotplug_end-fix
+++ a/include/linux/mmzone.h
@@ -596,7 +596,7 @@ struct zone {
 	 *
 	 * Write access to present_pages at runtime should be protected by
 	 * mem_hotplug_begin/done(). Any reader who can't tolerant drift of
-	 * present_pages should get_online_mems() to get a stable value.
+	 * present_pages should use get_online_mems() to get a stable value.
 	 */
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
--- a/mm/compaction.c~mm-docs-fix-comments-that-mention-mem_hotplug_end-fix
+++ a/mm/compaction.c
@@ -3030,7 +3030,7 @@ void kcompactd_run(int nid)
 
 /*
  * Called by memory hotplug when all memory in a node is offlined. Caller must
- * be hold mem_hotplug_begin/done().
+ * be holding mem_hotplug_begin/done().
  */
 void kcompactd_stop(int nid)
 {
--- a/mm/vmscan.c~mm-docs-fix-comments-that-mention-mem_hotplug_end-fix
+++ a/mm/vmscan.c
@@ -4645,7 +4645,7 @@ void kswapd_run(int nid)
 
 /*
  * Called by memory hotplug when all memory in a node is offlined.  Caller must
- * be hold mem_hotplug_begin/done().
+ * be holding mem_hotplug_begin/done().
  */
 void kswapd_stop(int nid)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock-fix.patch
mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch
mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch

