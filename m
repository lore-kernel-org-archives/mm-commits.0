Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70949CCA473
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiGDBMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiGDBLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253AF6316
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEF6D6129E
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A90AC341C7;
        Mon,  4 Jul 2022 01:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897051;
        bh=Ok6Q4yoGlL02+nVQ6AHI8WFNJH55Nam+1IeJwlSrt9w=;
        h=Date:To:From:Subject:From;
        b=NjEcP+hnAJsgYf5lXFRoTtfTR5H1oy4NaC4qXdxYnVvUMqhAPupKAOIY3zFrLQbmD
         ZNt2kZV+E1phUFRHvJHHLVe5QN1o3hIBPuBwzcJGUduWIZ417xblarwcKHaTtf6suI
         wTeMKrbu3NgA2w8On9goFJxn0+ejXe0ylZyXnqcI=
Date:   Sun, 03 Jul 2022 18:10:50 -0700
To:     mm-commits@vger.kernel.org, jrdr.linux@gmail.com,
        p76091292@gs.ncku.edu.tw, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-docs-fix-comments-that-mention-mem_hotplug_end.patch removed from -mm tree
Message-Id: <20220704011051.0A90AC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, docs: fix comments that mention mem_hotplug_end()
has been removed from the -mm tree.  Its filename was
     mm-docs-fix-comments-that-mention-mem_hotplug_end.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yun-Ze Li <p76091292@gs.ncku.edu.tw>
Subject: mm, docs: fix comments that mention mem_hotplug_end()
Date: Mon, 20 Jun 2022 07:15:16 +0000

Comments that mention mem_hotplug_end() are confusing as there is no
function called mem_hotplug_end().  Fix them by replacing all the
occurences of mem_hotplug_end() in the comments with mem_hotplug_done().

[akpm@linux-foundation.org: grammatical fixes]
Link: https://lkml.kernel.org/r/20220620071516.1286101-1-p76091292@gs.ncku.edu.tw
Signed-off-by: Yun-Ze Li <p76091292@gs.ncku.edu.tw>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++---
 mm/compaction.c        |    2 +-
 mm/vmscan.c            |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mmzone.h~mm-docs-fix-comments-that-mention-mem_hotplug_end
+++ a/include/linux/mmzone.h
@@ -591,8 +591,8 @@ struct zone {
 	 * give them a chance of being in the same cacheline.
 	 *
 	 * Write access to present_pages at runtime should be protected by
-	 * mem_hotplug_begin/end(). Any reader who can't tolerant drift of
-	 * present_pages should get_online_mems() to get a stable value.
+	 * mem_hotplug_begin/done(). Any reader who can't tolerant drift of
+	 * present_pages should use get_online_mems() to get a stable value.
 	 */
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
@@ -870,7 +870,7 @@ typedef struct pglist_data {
 	unsigned long nr_reclaim_start;	/* nr pages written while throttled
 					 * when throttling started. */
 	struct task_struct *kswapd;	/* Protected by
-					   mem_hotplug_begin/end() */
+					   mem_hotplug_begin/done() */
 	int kswapd_order;
 	enum zone_type kswapd_highest_zoneidx;
 
--- a/mm/compaction.c~mm-docs-fix-comments-that-mention-mem_hotplug_end
+++ a/mm/compaction.c
@@ -3011,7 +3011,7 @@ void kcompactd_run(int nid)
 
 /*
  * Called by memory hotplug when all memory in a node is offlined. Caller must
- * hold mem_hotplug_begin/end().
+ * be holding mem_hotplug_begin/done().
  */
 void kcompactd_stop(int nid)
 {
--- a/mm/vmscan.c~mm-docs-fix-comments-that-mention-mem_hotplug_end
+++ a/mm/vmscan.c
@@ -4645,7 +4645,7 @@ void kswapd_run(int nid)
 
 /*
  * Called by memory hotplug when all memory in a node is offlined.  Caller must
- * hold mem_hotplug_begin/end().
+ * be holding mem_hotplug_begin/done().
  */
 void kswapd_stop(int nid)
 {
_

Patches currently in -mm which might be from p76091292@gs.ncku.edu.tw are


