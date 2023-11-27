Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A95C0755A
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbjK0RGX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343567AbjK0RFy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:05:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A81219B4
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:00:53 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EED4C433C8;
        Mon, 27 Nov 2023 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701104453;
        bh=AFMlLGoJVmPiS58pCPBL2y60M8xJZdaqabTbUHD56UU=;
        h=Date:To:From:Subject:From;
        b=mcIu0wLayE6YO8i8HWsQiSvMLD5+L5PD4yASieMxeIpmJt7/krMSchlKBy2NV0H6k
         AH9SMzfWF1rlek6umLSySVRyv9CO+S5B2VzsXyT/qHBjBxBADUKtLKIt3sVwPYlptp
         flMpju432wqijed6YhdCRmcx1igLEMYGkVQOoZok=
Date:   Mon, 27 Nov 2023 09:00:52 -0800
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fabio.maria.de.francesco@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-replace-kmap_atomic-with-kmap_local_page.patch added to mm-unstable branch
Message-Id: <20231127170053.0EED4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: replace kmap_atomic() with kmap_local_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-replace-kmap_atomic-with-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-replace-kmap_atomic-with-kmap_local_page.patch

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
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/swapfile: replace kmap_atomic() with kmap_local_page()
Date: Mon, 27 Nov 2023 16:54:37 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page() in swapfile.c.

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

In mm/swapfile.c, the blocks of code between the mappings and un-mappings
do not depend on the above-mentioned side effects of kmap_atomic(), so
that the mere replacements of the old API with the new one is all that is
required (i.e., there is no need to explicitly call pagefault_disable()
and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231127155452.586387-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-replace-kmap_atomic-with-kmap_local_page
+++ a/mm/swapfile.c
@@ -1495,9 +1495,9 @@ int swp_swapcount(swp_entry_t entry)
 
 	do {
 		page = list_next_entry(page, lru);
-		map = kmap_atomic(page);
+		map = kmap_local_page(page);
 		tmp_count = map[offset];
-		kunmap_atomic(map);
+		kunmap_local(map);
 
 		count += (tmp_count & ~COUNT_CONTINUED) * n;
 		n *= (SWAP_CONT_MAX + 1);
@@ -3477,9 +3477,9 @@ int add_swap_count_continuation(swp_entr
 		if (!(count & COUNT_CONTINUED))
 			goto out_unlock_cont;
 
-		map = kmap_atomic(list_page) + offset;
+		map = kmap_local_page(list_page) + offset;
 		count = *map;
-		kunmap_atomic(map);
+		kunmap_local(map);
 
 		/*
 		 * If this continuation count now has some space in it,
@@ -3529,7 +3529,7 @@ static bool swap_count_continued(struct
 	spin_lock(&si->cont_lock);
 	offset &= ~PAGE_MASK;
 	page = list_next_entry(head, lru);
-	map = kmap_atomic(page) + offset;
+	map = kmap_local_page(page) + offset;
 
 	if (count == SWAP_MAP_MAX)	/* initial increment from swap_map */
 		goto init_map;		/* jump over SWAP_CONT_MAX checks */
@@ -3539,27 +3539,27 @@ static bool swap_count_continued(struct
 		 * Think of how you add 1 to 999
 		 */
 		while (*map == (SWAP_CONT_MAX | COUNT_CONTINUED)) {
-			kunmap_atomic(map);
+			kunmap_local(map);
 			page = list_next_entry(page, lru);
 			BUG_ON(page == head);
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 		}
 		if (*map == SWAP_CONT_MAX) {
-			kunmap_atomic(map);
+			kunmap_local(map);
 			page = list_next_entry(page, lru);
 			if (page == head) {
 				ret = false;	/* add count continuation */
 				goto out;
 			}
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 init_map:		*map = 0;		/* we didn't zero the page */
 		}
 		*map += 1;
-		kunmap_atomic(map);
+		kunmap_local(map);
 		while ((page = list_prev_entry(page, lru)) != head) {
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 			*map = COUNT_CONTINUED;
-			kunmap_atomic(map);
+			kunmap_local(map);
 		}
 		ret = true;			/* incremented */
 
@@ -3569,21 +3569,21 @@ init_map:		*map = 0;		/* we didn't zero
 		 */
 		BUG_ON(count != COUNT_CONTINUED);
 		while (*map == COUNT_CONTINUED) {
-			kunmap_atomic(map);
+			kunmap_local(map);
 			page = list_next_entry(page, lru);
 			BUG_ON(page == head);
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 		}
 		BUG_ON(*map == 0);
 		*map -= 1;
 		if (*map == 0)
 			count = 0;
-		kunmap_atomic(map);
+		kunmap_local(map);
 		while ((page = list_prev_entry(page, lru)) != head) {
-			map = kmap_atomic(page) + offset;
+			map = kmap_local_page(page) + offset;
 			*map = SWAP_CONT_MAX | count;
 			count = COUNT_CONTINUED;
-			kunmap_atomic(map);
+			kunmap_local(map);
 		}
 		ret = count == COUNT_CONTINUED;
 	}
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are

mm-util-use-kmap_local_page-in-memcmp_pages.patch
mm-memory-use-kmap_local_page-in-__wp_page_copy_user.patch
mm-mempool-replace-kmap_atomic-with-kmap_local_page.patch
mm-page_poison-replace-kmap_atomic-with-kmap_local_page.patch
mm-zswap-replace-kmap_atomic-with-kmap_local_page.patch
mm-swapfile-replace-kmap_atomic-with-kmap_local_page.patch

