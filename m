Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477EDC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 01:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiFHByr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351766AbiFHBtJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 21:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26DA1A8E06
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 15:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 265ED614B8
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 22:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1D5C3411C;
        Tue,  7 Jun 2022 22:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654641729;
        bh=wgwab8D0pRg0rUwGb8zN6AG8SBB0Chf0XWLE5OihmoA=;
        h=Date:To:From:Subject:From;
        b=JzjbZKMBrHieFrndKKicMFcBdiPZihv6Co8Xq4vLH25tfkjaJiPzGmJHKf4rP9/zR
         dkFM9/ZujOUWwsETWv0njBL4aNCMXlN1eIFGLUUcFCkimkfAjInmMyz/D5UDlbVRVQ
         1TlPSArYbS/JoKFrPWAXyEdTbs1Sa2IR7v96iqfs=
Date:   Tue, 07 Jun 2022 15:42:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmalloc-switch-to-prandom_u32.patch added to mm-unstable branch
Message-Id: <20220607224209.7C1D5C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc: switch to prandom_u32()
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_vmalloc-switch-to-prandom_u32.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmalloc-switch-to-prandom_u32.patch

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

mm-vmalloc-make-link_va-unlink_va-common-to-different-rb_root.patch
mm-vmalloc-extend-__alloc_vmap_area-with-extra-arguments.patch
mm-vmalloc-initialize-vas-list-node-after-unlink.patch
mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch
lib-test_vmalloc-switch-to-prandom_u32.patch

