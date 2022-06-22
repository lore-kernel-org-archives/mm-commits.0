Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92517C43334
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 00:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiFVAGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 20:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiFVAGl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 20:06:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E486140C3
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 17:06:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEF6061778
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 00:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B161C3411C;
        Wed, 22 Jun 2022 00:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655856400;
        bh=laVUBy2ilU6TRf9PyQgKM3wBXHMuh06WlZutLJflKKc=;
        h=Date:To:From:Subject:From;
        b=gdfMuyDKYTBAhuX/E4jhaEmPESKTgAQkrMpvtSztr2oXj+Qia9Ldafts7cINbVCYF
         eXIzGIOp+YXWKR4hxAT7uyPJ8Q3m5n1aD/s7nqpzEVWdNf6JD3GYZvmTVHkUUrly3P
         BqtY+8f2evSNLMrwNBDO7sMGlsJLfxMOqXuvT/8Q=
Date:   Tue, 21 Jun 2022 17:06:31 -0700
To:     mm-commits@vger.kernel.org, jrdr.linux@gmail.com,
        p76091292@gs.ncku.edu.tw, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-docs-fix-comments-that-mention-mem_hotplug_end.patch added to mm-unstable branch
Message-Id: <20220622000639.0B161C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, docs: fix comments that mention mem_hotplug_end()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-docs-fix-comments-that-mention-mem_hotplug_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-docs-fix-comments-that-mention-mem_hotplug_end.patch

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
From: Yun-Ze Li <p76091292@gs.ncku.edu.tw>
Subject: mm, docs: fix comments that mention mem_hotplug_end()
Date: Mon, 20 Jun 2022 07:15:16 +0000

Comments that mention mem_hotplug_end() are confusing as there is no
function called mem_hotplug_end().  Fix them by replacing all the
occurences of mem_hotplug_end() in the comments with mem_hotplug_done().

Link: https://lkml.kernel.org/r/20220620071516.1286101-1-p76091292@gs.ncku.edu.tw
Signed-off-by: Yun-Ze Li <p76091292@gs.ncku.edu.tw>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 mm/compaction.c        |    2 +-
 mm/vmscan.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mmzone.h~mm-docs-fix-comments-that-mention-mem_hotplug_end
+++ a/include/linux/mmzone.h
@@ -595,7 +595,7 @@ struct zone {
 	 * give them a chance of being in the same cacheline.
 	 *
 	 * Write access to present_pages at runtime should be protected by
-	 * mem_hotplug_begin/end(). Any reader who can't tolerant drift of
+	 * mem_hotplug_begin/done(). Any reader who can't tolerant drift of
 	 * present_pages should get_online_mems() to get a stable value.
 	 */
 	atomic_long_t		managed_pages;
@@ -874,7 +874,7 @@ typedef struct pglist_data {
 	unsigned long nr_reclaim_start;	/* nr pages written while throttled
 					 * when throttling started. */
 	struct task_struct *kswapd;	/* Protected by
-					   mem_hotplug_begin/end() */
+					   mem_hotplug_begin/done() */
 	int kswapd_order;
 	enum zone_type kswapd_highest_zoneidx;
 
--- a/mm/compaction.c~mm-docs-fix-comments-that-mention-mem_hotplug_end
+++ a/mm/compaction.c
@@ -3030,7 +3030,7 @@ void kcompactd_run(int nid)
 
 /*
  * Called by memory hotplug when all memory in a node is offlined. Caller must
- * hold mem_hotplug_begin/end().
+ * be hold mem_hotplug_begin/done().
  */
 void kcompactd_stop(int nid)
 {
--- a/mm/vmscan.c~mm-docs-fix-comments-that-mention-mem_hotplug_end
+++ a/mm/vmscan.c
@@ -4645,7 +4645,7 @@ void kswapd_run(int nid)
 
 /*
  * Called by memory hotplug when all memory in a node is offlined.  Caller must
- * hold mem_hotplug_begin/end().
+ * be hold mem_hotplug_begin/done().
  */
 void kswapd_stop(int nid)
 {
_

Patches currently in -mm which might be from p76091292@gs.ncku.edu.tw are

mm-docs-fix-comments-that-mention-mem_hotplug_end.patch

