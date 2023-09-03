Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B85C83F2D
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 23:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbjICXr1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Sep 2023 19:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjICXr1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Sep 2023 19:47:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA009C
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 16:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A054CE094F
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 23:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E587C433C7;
        Sun,  3 Sep 2023 23:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693784840;
        bh=Q82LglxgpALjPHJJEsC1Nc5CX9F3k2lngVi0eyMI0Mc=;
        h=Date:To:From:Subject:From;
        b=N0Wds5Ii3tpSjug4EExFhNkJ4EhC+cn+qoNz07M47VVNSEotPxdgNBZYX8aZgUM7j
         pP802oRuwoaTvhh1i42czHrhvpbTWcy0oaGLEhoIwi6ivA0ss/FKa8Jwckjuxg89+q
         0w+likxkvt4aUG50eQx7XZqfkcxjs2HgDuv6goXQ=
Date:   Sun, 03 Sep 2023 16:47:18 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        hughd@google.com, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-si_mem_available.patch added to mm-unstable branch
Message-Id: <20230903234720.4E587C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor si_mem_available()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-refactor-si_mem_available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-si_mem_available.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: refactor si_mem_available()
Date: Sun, 27 Aug 2023 12:08:48 +0100

si_mem_available() needlessly places LRU statistics into an array before
retrieving only two of them, simply access those directly.

In addition, refactor the code so that the blocks of code which calculate
the page cache and reclaimable components each resemble one another to
clearly indicate we cap both against wmark_low in the same fashion.

Link: https://lkml.kernel.org/r/20230827110848.43510-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/show_mem.c~mm-refactor-si_mem_available
+++ a/mm/show_mem.c
@@ -34,13 +34,8 @@ long si_mem_available(void)
 	long available;
 	unsigned long pagecache;
 	unsigned long wmark_low = 0;
-	unsigned long pages[NR_LRU_LISTS];
 	unsigned long reclaimable;
 	struct zone *zone;
-	int lru;
-
-	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
-		pages[lru] = global_node_page_state(NR_LRU_BASE + lru);
 
 	for_each_zone(zone)
 		wmark_low += low_wmark_pages(zone);
@@ -56,7 +51,8 @@ long si_mem_available(void)
 	 * start swapping or thrashing. Assume at least half of the page
 	 * cache, or the low watermark worth of cache, needs to stay.
 	 */
-	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
+	pagecache = global_node_page_state(NR_ACTIVE_FILE) +
+		global_node_page_state(NR_INACTIVE_FILE);
 	pagecache -= min(pagecache / 2, wmark_low);
 	available += pagecache;
 
@@ -67,7 +63,8 @@ long si_mem_available(void)
 	 */
 	reclaimable = global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B) +
 		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE);
-	available += reclaimable - min(reclaimable / 2, wmark_low);
+	reclaimable -= min(reclaimable / 2, wmark_low);
+	available += reclaimable;
 
 	if (available < 0)
 		available = 0;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-refactor-si_mem_available.patch

