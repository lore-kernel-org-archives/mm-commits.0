Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A209C77B61
	for <mm-commits@archiver.kernel.org>; Thu, 13 Apr 2023 21:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDMVxX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Apr 2023 17:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjDMVxV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2023 17:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6710B5BA2
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 14:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFD8961578
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 21:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D8BC433D2;
        Thu, 13 Apr 2023 21:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681422799;
        bh=RmkdNa92mMfXdXzbHbsVfoqGZWd3FkYFfch+18R1pYk=;
        h=Date:To:From:Subject:From;
        b=H3+QIVU3bfwbehUjwk2X0EqkpourkvIx/E7qIl+LBdAGJZR62sMFscLcpaH1tzpjk
         o6GI8d/1ELfUMPI5Y9usvidw85TiFp/bMIhZ5qLCfCj3zqYbietwWRwkfRmK6OPYhJ
         0EVhPNVCUC6fDnb0SzIp2069neywkfGrF653pL/o=
Date:   Thu, 13 Apr 2023 14:53:18 -0700
To:     mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-workingset-update-description-of-the-source-file.patch added to mm-unstable branch
Message-Id: <20230413215319.36D8BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: update description of the source file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-workingset-update-description-of-the-source-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-workingset-update-description-of-the-source-file.patch

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

mm-workingset-update-description-of-the-source-file.patch

