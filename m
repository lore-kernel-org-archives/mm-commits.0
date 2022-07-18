Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EA2CCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiGRAc2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiGRAcZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A59913CE2
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F88B80EE3
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81087C341CD;
        Mon, 18 Jul 2022 00:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104340;
        bh=r9CjI9SpeFQahoGl1XZE6TjwGcfLk+8dlVVmfxmE05g=;
        h=Date:To:From:Subject:From;
        b=mZJoUAbkcEM0aorMA2t5luKzhRinDKvkp9n3qNt1BF0xMEzQmrkKZwoJc1AfeYDJS
         I20jRlrqnKajVbKbRX21nzDDdMJjteeMRKXGY3PVKs9HPC/szT2Zd02yR97MQN/glB
         3uRT+53XUsaEM7vysMnXcbqxbE/SuoVSC8rrTfX8=
Date:   Sun, 17 Jul 2022 17:32:19 -0700
To:     mm-commits@vger.kernel.org, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-lru_cache-fix-error-free-handing-in-lc_create.patch removed from -mm tree
Message-Id: <20220718003220.81087C341CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/lru_cache: fix error free handing in lc_create
has been removed from the -mm tree.  Its filename was
     lib-lru_cache-fix-error-free-handing-in-lc_create.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/lru_cache: fix error free handing in lc_create
Date: Sat, 18 Jun 2022 16:25:21 +0800

When kmem_cache_alloc in function lc_create returns null, we will
free the memory already allocated. The loop of kmem_cache_free
is wrong, especially:
  i = 0  ==> do wrong loop
  i > 0  ==> do not free element[0]

Link: https://lkml.kernel.org/r/20220618082521.7082-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Christoph Bhmwalder <christoph.boehmwalder@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lru_cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/lru_cache.c~lib-lru_cache-fix-error-free-handing-in-lc_create
+++ a/lib/lru_cache.c
@@ -147,8 +147,8 @@ struct lru_cache *lc_create(const char *
 		return lc;
 
 	/* else: could not allocate all elements, give up */
-	for (i--; i; i--) {
-		void *p = element[i];
+	while (i) {
+		void *p = element[--i];
 		kmem_cache_free(cache, p - e_off);
 	}
 	kfree(lc);
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

