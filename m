Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC8CC77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjDRXjA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjDRXg4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2B6900E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFA196023A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F4AC433EF;
        Tue, 18 Apr 2023 23:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860953;
        bh=7nhPKdF/qa0QKlbG9lPUr+odkf3++9HZGRkiqPWiN3w=;
        h=Date:To:From:Subject:From;
        b=I9VM5IJGVA39TaAzj+QwZ30w5P8LaCKASs5e6Fqn/zgKHHwUanVXx7r8IJx9e7yEM
         YYbPX8cPfHF4+YBtbjObzhOOCyjUkfgwrtjE0CmbR3hKZyg51Ven0Ai5vfaaO4zbMU
         dypm9EfRgwhuMg9AtMwQbrOukR4Zt10cOOnxMLA8=
Date:   Tue, 18 Apr 2023 16:35:52 -0700
To:     mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-workingset-update-description-of-the-source-file.patch removed from -mm tree
Message-Id: <20230418233553.52F4AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: workingset: update description of the source file
has been removed from the -mm tree.  Its filename was
     mm-workingset-update-description-of-the-source-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm: workingset: update description of the source file
Date: Thu, 13 Apr 2023 16:34:49 +0800 (CST)

The calculation of workingset size is the core logic of handling refault,
it had been updated several times[1][2] after workingset.c was created[3].
But the description hadn't been updated accordingly, this mismatch may
confuse the readers.  So we update the description to make it consistent
to the code.

[1] commit 34e58cac6d8f ("mm: workingset: let cache workingset challenge anon")
[2] commit aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")
[3] commit a528910e12ec ("mm: thrash detection-based file cache sizing")

Link: https://lkml.kernel.org/r/202304131634494948454@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/workingset.c~mm-workingset-update-description-of-the-source-file
+++ a/mm/workingset.c
@@ -111,9 +111,20 @@
  *
  *   NR_inactive + (R - E) <= NR_inactive + NR_active
  *
- * which can be further simplified to
+ * If we have swap we should consider about NR_inactive_anon and
+ * NR_active_anon, so for page cache and anonymous respectively:
  *
- *   (R - E) <= NR_active
+ *   NR_inactive_file + (R - E) <= NR_inactive_file + NR_active_file
+ *   + NR_inactive_anon + NR_active_anon
+ *
+ *   NR_inactive_anon + (R - E) <= NR_inactive_anon + NR_active_anon
+ *   + NR_inactive_file + NR_active_file
+ *
+ * Which can be further simplified to:
+ *
+ *   (R - E) <= NR_active_file + NR_inactive_anon + NR_active_anon
+ *
+ *   (R - E) <= NR_active_anon + NR_inactive_file + NR_active_file
  *
  * Put into words, the refault distance (out-of-cache) can be seen as
  * a deficit in inactive list space (in-cache).  If the inactive list
@@ -130,14 +141,14 @@
  * are no longer in active use.
  *
  * So when a refault distance of (R - E) is observed and there are at
- * least (R - E) active pages, the refaulting page is activated
- * optimistically in the hope that (R - E) active pages are actually
+ * least (R - E) pages in the userspace workingset, the refaulting page
+ * is activated optimistically in the hope that (R - E) pages are actually
  * used less frequently than the refaulting page - or even not used at
  * all anymore.
  *
  * That means if inactive cache is refaulting with a suitable refault
  * distance, we assume the cache workingset is transitioning and put
- * pressure on the current active list.
+ * pressure on the current workingset.
  *
  * If this is wrong and demotion kicks in, the pages which are truly
  * used more frequently will be reactivated while the less frequently
@@ -469,7 +480,7 @@ void workingset_refault(struct folio *fo
 	 * don't activate pages that couldn't stay resident even if
 	 * all the memory was available to the workingset. Whether
 	 * workingset competition needs to consider anon or not depends
-	 * on having swap.
+	 * on having free swap space.
 	 */
 	workingset_size = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
 	if (!file) {
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are


