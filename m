Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8A3C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0917B22260
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708984;
	bh=ZoXnAgjRZSOD5YP4CKhvulzWbb4ah43DDtxnF9SjEh4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cjT4ASF+nruhhdKtf1K8V2vx9Lq99JxgJzMMvsb6mB7EYcAcGcKKRzIHFck0eVR/z
	 UulvrL4lJrfNLWzuFxC5e8B0rCV7Ryxh3MtgWI7r+aWssyHviEQWrDTPpP/HkkYw/q
	 johoKaLDuZa0vpR1erM6+TUyGLVhRaVkjLA21pBA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388732AbgJNU4X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU4X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B49F82224E;
        Wed, 14 Oct 2020 20:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708983;
        bh=ZoXnAgjRZSOD5YP4CKhvulzWbb4ah43DDtxnF9SjEh4=;
        h=Date:From:To:Subject:From;
        b=OWbIlXTpQVBvTX+h+TWCIw955LRHoOEo5ibyNhAWqUniDjsgR/UJDWN6aQkD9CI/v
         SF6vvbhuiDh2yGUdtXDglQohz6y7QPkfDo7DUuNLPBSYoMxrPkj1IIsBZ9pr826jDQ
         Tg+GZZoSMnBrEv/9rqdVu19xcsz5a65CEI2aXshA=
Date:   Wed, 14 Oct 2020 13:56:22 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, hewenliang4@huawei.com, hushiyuan@huawei.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, wuyun.wu@huawei.com
Subject:  [merged]
 mm-slub-branch-optimization-in-free-slowpath.patch removed from -mm tree
Message-ID: <20201014205622.ZShH5-ns4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: branch optimization in free slowpath
has been removed from the -mm tree.  Its filename was
     mm-slub-branch-optimization-in-free-slowpath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Abel Wu <wuyun.wu@huawei.com>
Subject: mm/slub.c: branch optimization in free slowpath

The two conditions are mutually exclusive and gcc compiler will optimise
this into if-else-like pattern.  Given that the majority of free_slowpath
is free_frozen, let's provide some hint to the compilers.

Tests (perf bench sched messaging -g 20 -l 400000, executed 10x
after reboot) are done and the summarized result:

	un-patched	patched
max.	192.316		189.851
min.	187.267		186.252
avg.	189.154		188.086
stdev.	1.37		0.99

Link: http://lkml.kernel.org/r/20200813101812.1617-1-wuyun.wu@huawei.com
Signed-off-by: Abel Wu <wuyun.wu@huawei.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hewenliang <hewenliang4@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/slub.c~mm-slub-branch-optimization-in-free-slowpath
+++ a/mm/slub.c
@@ -3019,20 +3019,21 @@ static void __slab_free(struct kmem_cach
 
 	if (likely(!n)) {
 
-		/*
-		 * If we just froze the page then put it onto the
-		 * per cpu partial list.
-		 */
-		if (new.frozen && !was_frozen) {
+		if (likely(was_frozen)) {
+			/*
+			 * The list lock was not taken therefore no list
+			 * activity can be necessary.
+			 */
+			stat(s, FREE_FROZEN);
+		} else if (new.frozen) {
+			/*
+			 * If we just froze the page then put it onto the
+			 * per cpu partial list.
+			 */
 			put_cpu_partial(s, page, 1);
 			stat(s, CPU_PARTIAL_FREE);
 		}
-		/*
-		 * The list lock was not taken therefore no list
-		 * activity can be necessary.
-		 */
-		if (was_frozen)
-			stat(s, FREE_FROZEN);
+
 		return;
 	}
 
_

Patches currently in -mm which might be from wuyun.wu@huawei.com are


