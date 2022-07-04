Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4FFC43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiGDAEF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGDAEE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785CB38B0
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160B16128E
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A741C341C6;
        Mon,  4 Jul 2022 00:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656893042;
        bh=TeZuoZrIVyaZu9IKb+lfvm71MaRBst8C4butKBxe2s0=;
        h=Date:To:From:Subject:From;
        b=oufzLSg5pp0hNEN3MTBK77461g5u1ly/FctesRk9iU3TxcG+lnHhSHqzb6vBfEG8j
         m+2I98aGwO1vzkJRIRVCdrm+oskn1pmHeiQg116aCDOzs770tJNpBvNOzRo9iqY3+V
         2O/hzN599JCN+NGTY+r/Zjg9XDwVexo901EBF0dg=
Date:   Sun, 03 Jul 2022 17:04:01 -0700
To:     mm-commits@vger.kernel.org, p76091292@gs.ncku.edu.tw,
        jrdr.linux@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch removed from -mm tree
Message-Id: <20220704000402.6A741C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-docs-fix-comments-that-mention-mem_hotplug_end-fix
has been removed from the -mm tree.  Its filename was
     mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch

This patch was dropped because it was folded into mm-docs-fix-comments-that-mention-mem_hotplug_end.patch

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
@@ -592,7 +592,7 @@ struct zone {
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

mm-docs-fix-comments-that-mention-mem_hotplug_end.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-remove-the-vma-linked-list-fix-2-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
x86-mm-move-protection_map-inside-the-platform-fix.patch

