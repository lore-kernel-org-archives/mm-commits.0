Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4942CC19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiHKVwK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiHKVwJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:52:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869B4175A5
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 061B9CE23E9
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64911C433D6;
        Thu, 11 Aug 2022 21:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660254724;
        bh=j0ehTZ+xzZC/8yaXJbRwSVHWBZz+6HUvKrqiUum6yRQ=;
        h=Date:To:From:Subject:From;
        b=pGxTiYlxXOiatksomlj0yFwIOE1LKZ/wsI2egxGS7RP5ES/XGDSsvSqk/XIeHFBL/
         x3lkcFNkH0pu0OyAb6G1qM1acV/xrT+28iEaWKAc/6tcDxUOAQofuSPLJJ6a0SX1JE
         vVcN5UemhXmJdYw4dE1am/ogW8YLL07mknPyZ9hc=
Date:   Thu, 11 Aug 2022 14:52:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        iamjoonsoo.kim@lge.com, david@redhat.com, corbet@lwn.net,
        cgel.zte@gmail.com, bsingharora@gmail.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-make-the-accounting-of-thrashing-more-consistent.patch added to mm-unstable branch
Message-Id: <20220811215204.64911C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: make the accounting of thrashing more consistent
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-make-the-accounting-of-thrashing-more-consistent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-make-the-accounting-of-thrashing-more-consistent.patch

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
Subject: filemap: make the accounting of thrashing more consistent
Date: Fri, 5 Aug 2022 03:38:39 +0000

Once upon a time, we only support accounting thrashing of page cache. 
Then Joonsoo introduced workingset detection for anonymous pages and we
gained the ability to account thrashing of them[1].

So let delayacct account both the thrashing of page cache and anonymous
pages, this could make the codes more consistent and simpler.

[1] commit aae466b0052e ("mm/swap: implement workingset detection for anonymous LRU")

Link: https://lkml.kernel.org/r/20220805033838.1714674-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |    2 -
 mm/filemap.c                                  |   18 +++-------------
 2 files changed, 5 insertions(+), 15 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst~filemap-make-the-accounting-of-thrashing-more-consistent
+++ a/Documentation/accounting/delay-accounting.rst
@@ -13,7 +13,7 @@ a) waiting for a CPU (while being runnab
 b) completion of synchronous block I/O initiated by the task
 c) swapping in pages
 d) memory reclaim
-e) thrashing page cache
+e) thrashing
 f) direct compact
 g) write-protect copy
 
--- a/mm/filemap.c~filemap-make-the-accounting-of-thrashing-more-consistent
+++ a/mm/filemap.c
@@ -1221,15 +1221,11 @@ static inline int folio_wait_bit_common(
 	struct wait_page_queue wait_page;
 	wait_queue_entry_t *wait = &wait_page.wait;
 	bool thrashing = false;
-	bool delayacct = false;
 	unsigned long pflags;
 
 	if (bit_nr == PG_locked &&
 	    !folio_test_uptodate(folio) && folio_test_workingset(folio)) {
-		if (!folio_test_swapbacked(folio)) {
-			delayacct_thrashing_start();
-			delayacct = true;
-		}
+		delayacct_thrashing_start();
 		psi_memstall_enter(&pflags);
 		thrashing = true;
 	}
@@ -1329,8 +1325,7 @@ repeat:
 	finish_wait(q, wait);
 
 	if (thrashing) {
-		if (delayacct)
-			delayacct_thrashing_end();
+		delayacct_thrashing_end();
 		psi_memstall_leave(&pflags);
 	}
 
@@ -1378,17 +1373,13 @@ void migration_entry_wait_on_locked(swp_
 	struct wait_page_queue wait_page;
 	wait_queue_entry_t *wait = &wait_page.wait;
 	bool thrashing = false;
-	bool delayacct = false;
 	unsigned long pflags;
 	wait_queue_head_t *q;
 	struct folio *folio = page_folio(pfn_swap_entry_to_page(entry));
 
 	q = folio_waitqueue(folio);
 	if (!folio_test_uptodate(folio) && folio_test_workingset(folio)) {
-		if (!folio_test_swapbacked(folio)) {
-			delayacct_thrashing_start();
-			delayacct = true;
-		}
+		delayacct_thrashing_start();
 		psi_memstall_enter(&pflags);
 		thrashing = true;
 	}
@@ -1435,8 +1426,7 @@ void migration_entry_wait_on_locked(swp_
 	finish_wait(q, wait);
 
 	if (thrashing) {
-		if (delayacct)
-			delayacct_thrashing_end();
+		delayacct_thrashing_end();
 		psi_memstall_leave(&pflags);
 	}
 }
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

mm-vmscan-define-macros-for-refaults-in-struct-lruvec.patch
filemap-make-the-accounting-of-thrashing-more-consistent.patch

