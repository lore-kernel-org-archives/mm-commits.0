Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0338AC77B75
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 20:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjECU1r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 May 2023 16:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjECU1q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2023 16:27:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A48E0;
        Wed,  3 May 2023 13:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 537B562FA3;
        Wed,  3 May 2023 20:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9872AC433D2;
        Wed,  3 May 2023 20:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683145663;
        bh=ikHfYgwvwtS5A3DdcNFKhNwsgU1MufILjjxDE1n9Lo0=;
        h=Date:To:From:Subject:From;
        b=YNUQhSpz4Rz1ANMFbf2B8kq7g8xZsDSZq1AnN6lknBQxjmrcXEwtabk6wAdACRjrW
         VV/ADU5G/EL5ojQ8RV/xB6TKy//SdSLmNnIi52H+1mYThoOK1mJ2SgDsyzHNokV5kl
         Jq1fgHPnHaTa3jp8zpFOZ1Ux2qHTD/kZtWywlQZI=
Date:   Wed, 03 May 2023 13:27:42 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        stable@vger.kernel.org, sjenning@redhat.com, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        cerasuolodomenico@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-zswap-writeback-race-condition.patch added to mm-hotfixes-unstable branch
Message-Id: <20230503202743.9872AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix zswap writeback race condition
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-zswap-writeback-race-condition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-zswap-writeback-race-condition.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Subject: mm: fix zswap writeback race condition
Date: Wed, 3 May 2023 17:12:00 +0200

The zswap writeback mechanism can cause a race condition resulting in
memory corruption, where a swapped out page gets swapped in with data that
was written to a different page.

The race unfolds like this:
1. a page with data A and swap offset X is stored in zswap
2. page A is removed off the LRU by zpool driver for writeback in
   zswap-shrink work, data for A is mapped by zpool driver
3. user space program faults and invalidates page entry A, offset X is
   considered free
4. kswapd stores page B at offset X in zswap (zswap could also be
   full, if so, page B would then be IOed to X, then skip step 5.)
5. entry A is replaced by B in tree->rbroot, this doesn't affect the
   local reference held by zswap-shrink work
6. zswap-shrink work writes back A at X, and frees zswap entry A
7. swapin of slot X brings A in memory instead of B

The fix:
Once the swap page cache has been allocated (case ZSWAP_SWAPCACHE_NEW),
zswap-shrink work just checks that the local zswap_entry reference is
still the same as the one in the tree.  If it's not the same it means that
it's either been invalidated or replaced, in both cases the writeback is
aborted because the local entry contains stale data.

Reproducer:
I originally found this by running `stress` overnight to validate my work
on the zswap writeback mechanism, it manifested after hours on my test
machine.  The key to make it happen is having zswap writebacks, so
whatever setup pumps /sys/kernel/debug/zswap/written_back_pages should do
the trick.

In order to reproduce this faster on a vm, I setup a system with ~100M of
available memory and a 500M swap file, then running `stress --vm 1
--vm-bytes 300000000 --vm-stride 4000` makes it happen in matter of tens
of minutes.  One can speed things up even more by swinging
/sys/module/zswap/parameters/max_pool_percent up and down between, say, 20
and 1; this makes it reproduce in tens of seconds.  It's crucial to set
`--vm-stride` to something other than 4096 otherwise `stress` won't
realize that memory has been corrupted because all pages would have the
same data.

Link: https://lkml.kernel.org/r/20230503151200.19707-1-cerasuolodomenico@gmail.com
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/zswap.c~mm-fix-zswap-writeback-race-condition
+++ a/mm/zswap.c
@@ -1020,6 +1020,22 @@ static int zswap_writeback_entry(struct
 		goto fail;
 
 	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
+		/*
+		 * Having a local reference to the zswap entry doesn't exclude
+		 * swapping from invalidating and recycling the swap slot. Once
+		 * the swapcache is secured against concurrent swapping to and
+		 * from the slot, recheck that the entry is still current before
+		 * writing.
+		 */
+		spin_lock(&tree->lock);
+		if (zswap_rb_search(&tree->rbroot, entry->offset) != entry) {
+			spin_unlock(&tree->lock);
+			delete_from_swap_cache(page_folio(page));
+			ret = -ENOMEM;
+			goto fail;
+		}
+		spin_unlock(&tree->lock);
+
 		/* decompress */
 		acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
 		dlen = PAGE_SIZE;
_

Patches currently in -mm which might be from cerasuolodomenico@gmail.com are

mm-fix-zswap-writeback-race-condition.patch

