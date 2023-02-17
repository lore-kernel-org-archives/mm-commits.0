Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712A3C636D4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBQEos (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBQEoj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701625034A
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E8C2B829AB
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E59C433EF;
        Fri, 17 Feb 2023 04:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609075;
        bh=O/e51wiSrYdufQ9MJWF7BESq4w0YggVGgyXXmXZp9RY=;
        h=Date:To:From:Subject:From;
        b=PLZk8sxIVlsgLA4XAYiUKMKGmEIdrZJT1IRX7YTwsN6pgmPKtCmQi9QZ4p78gbcYu
         moXD32mo9xRJmjzJM7J/94eNmHxQeOJOClKXloLdJPLxeRHFLLtihzKBgT06sJ5mgi
         L54SXD/agY7cs18BjU9HF/uB8agUDojwvNRq5NsI=
Date:   Thu, 16 Feb 2023 20:44:35 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-annotate-racy-pool_index-accesses.patch removed from -mm tree
Message-Id: <20230217044435.D6E59C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: annotate racy pool_index accesses
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-annotate-racy-pool_index-accesses.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: annotate racy pool_index accesses
Date: Fri, 10 Feb 2023 22:16:04 +0100

Accesses to pool_index are protected by pool_lock everywhere except
in a sanity check in stack_depot_fetch. The read access there can race
with the write access in depot_alloc_stack.

Use WRITE/READ_ONCE() to annotate the racy accesses.

As the sanity check is only used to print a warning in case of a
violation of the stack depot interface usage, it does not make a lot
of sense to use proper synchronization.

[andreyknvl@google.com: s/pool_index/pool_index_cached/ in stack_depot_fetch()]
  Link: https://lkml.kernel.org/r/95cf53f0da2c112aa2cc54456cbcd6975c3ff343.1676129911.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/359ac9c13cd0869c56740fb2029f505e41593830.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-annotate-racy-pool_index-accesses
+++ a/lib/stackdepot.c
@@ -278,8 +278,12 @@ depot_alloc_stack(unsigned long *entries
 			return NULL;
 		}
 
-		/* Move on to the next pool. */
-		pool_index++;
+		/*
+		 * Move on to the next pool.
+		 * WRITE_ONCE pairs with potential concurrent read in
+		 * stack_depot_fetch().
+		 */
+		WRITE_ONCE(pool_index, pool_index + 1);
 		pool_offset = 0;
 		/*
 		 * If the maximum number of pools is not reached, take note
@@ -502,6 +506,11 @@ unsigned int stack_depot_fetch(depot_sta
 			       unsigned long **entries)
 {
 	union handle_parts parts = { .handle = handle };
+	/*
+	 * READ_ONCE pairs with potential concurrent write in
+	 * depot_alloc_stack.
+	 */
+	int pool_index_cached = READ_ONCE(pool_index);
 	void *pool;
 	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
@@ -510,9 +519,9 @@ unsigned int stack_depot_fetch(depot_sta
 	if (!handle)
 		return 0;
 
-	if (parts.pool_index > pool_index) {
+	if (parts.pool_index > pool_index_cached) {
 		WARN(1, "pool index %d out of bounds (%d) for stack id %08x\n",
-			parts.pool_index, pool_index, handle);
+			parts.pool_index, pool_index_cached, handle);
 		return 0;
 	}
 	pool = stack_pools[parts.pool_index];
_

Patches currently in -mm which might be from andreyknvl@google.com are


