Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41C2C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiGDBKQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbiGDBJz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CC4617D
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C14D5B80C73
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E43C341C7;
        Mon,  4 Jul 2022 01:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896992;
        bh=is8OeKVyNZuxGyIc/eKRKKRAdu/odazKZIK7BkcUDBc=;
        h=Date:To:From:Subject:From;
        b=HM9oDYbsNbgSquYAizH0y42BG6ps7aF2d0vr0byu4crUd3BzNBkm2A1x8oiW3pN4F
         FFvDgRQAvzHf+Dyh86+ve4nLvZ+nSvIoGcFweY24XHwNUPsa3qJ0BmMVMYx2v0vT09
         4wPYQ56G6Izl1kIZR3GMU/kMAS8WOrQPsKWjLvI4=
Date:   Sun, 03 Jul 2022 18:09:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmalloc-switch-to-prandom_u32.patch removed from -mm tree
Message-Id: <20220704010952.66E43C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test_vmalloc: switch to prandom_u32()
has been removed from the -mm tree.  Its filename was
     lib-test_vmalloc-switch-to-prandom_u32.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc: switch to prandom_u32()
Date: Tue, 7 Jun 2022 11:34:49 +0200

A get_random_bytes() function can cause a high contention if it is called
across CPUs simultaneously.  Because it shares one lock per all CPUs:

<snip>
   class name     con-bounces  contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
   &crng->lock:   663145       665886        0.05           8.85         261966.66        0.39            7188152       13731279       0.04           11.89        2181582.30       0.16
   -----------
   &crng->lock    307835       [<00000000acba59cd>] _extract_crng+0x48/0x90
   &crng->lock    358051       [<00000000f0075abc>] _crng_backtrack_protect+0x32/0x90
   -----------
   &crng->lock    234241       [<00000000f0075abc>] _crng_backtrack_protect+0x32/0x90
   &crng->lock    431645       [<00000000acba59cd>] _extract_crng+0x48/0x90
<snip>

Switch from the get_random_bytes() to prandom_u32() that does not have any
internal contention when a random value is needed for the tests.

The reason is to minimize CPU cycles introduced by the test-suite itself
from the vmalloc performance metrics.

Link: https://lkml.kernel.org/r/20220607093449.3100-6-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmalloc-switch-to-prandom_u32
+++ a/lib/test_vmalloc.c
@@ -74,12 +74,13 @@ test_report_one_done(void)
 
 static int random_size_align_alloc_test(void)
 {
-	unsigned long size, align, rnd;
+	unsigned long size, align;
+	unsigned int rnd;
 	void *ptr;
 	int i;
 
 	for (i = 0; i < test_loop_count; i++) {
-		get_random_bytes(&rnd, sizeof(rnd));
+		rnd = prandom_u32();
 
 		/*
 		 * Maximum 1024 pages, if PAGE_SIZE is 4096.
@@ -150,7 +151,7 @@ static int random_size_alloc_test(void)
 	int i;
 
 	for (i = 0; i < test_loop_count; i++) {
-		get_random_bytes(&n, sizeof(i));
+		n = prandom_u32();
 		n = (n % 100) + 1;
 
 		p = vmalloc(n * PAGE_SIZE);
@@ -294,14 +295,14 @@ pcpu_alloc_test(void)
 	for (i = 0; i < 35000; i++) {
 		unsigned int r;
 
-		get_random_bytes(&r, sizeof(i));
+		r = prandom_u32();
 		size = (r % (PAGE_SIZE / 4)) + 1;
 
 		/*
 		 * Maximum PAGE_SIZE
 		 */
-		get_random_bytes(&r, sizeof(i));
-		align = 1 << ((i % 11) + 1);
+		r = prandom_u32();
+		align = 1 << ((r % 11) + 1);
 
 		pcpu[i] = __alloc_percpu(size, align);
 		if (!pcpu[i])
@@ -396,7 +397,7 @@ static void shuffle_array(int *arr, int
 	int i, j;
 
 	for (i = n - 1; i > 0; i--)  {
-		get_random_bytes(&rnd, sizeof(rnd));
+		rnd = prandom_u32();
 
 		/* Cut the range. */
 		j = rnd % i;
_

Patches currently in -mm which might be from urezki@gmail.com are


