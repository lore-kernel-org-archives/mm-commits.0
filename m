Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8D8C636CC
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 02:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjBQCSK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 21:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBQCSJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 21:18:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D242E0C6
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 18:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2605B82AA2
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 02:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C58C433EF;
        Fri, 17 Feb 2023 02:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676600285;
        bh=5e8DDLih8Sv7VR7ft+XNv/LITD7pkc19iErHWVw3a70=;
        h=Date:To:From:Subject:From;
        b=zEWcppI+rOEiY6LwtScv3Bv7Jm263Ug/wdYkrffG3DGd1WXIrlLrwH/EcFlZ7y0qx
         rBcGd1ezSbLoLhveQZiN3tiRfOlTwyaB6sr3JZLaaB7ux4keldKd9cxBfH+ury8vUH
         5IJ+xU6nwPzOqUAGMoIh+f5JktQu8Yr89198qtlk=
Date:   Thu, 16 Feb 2023 18:18:04 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-stackdepot-annotate-racy-pool_index-accesses-fix.patch removed from -mm tree
Message-Id: <20230217021805.96C58C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/stackdepot: fix for "annotate racy pool_index accesses"
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-annotate-racy-pool_index-accesses-fix.patch

This patch was dropped because it was folded into lib-stackdepot-annotate-racy-pool_index-accesses.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: fix for "annotate racy pool_index accesses"
Date: Sat, 11 Feb 2023 16:48:42 +0100

Change the remaining reference to pool_index in stack_depot_fetch to
pool_index_cached.

Link: https://lkml.kernel.org/r/95cf53f0da2c112aa2cc54456cbcd6975c3ff343.1676129911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-annotate-racy-pool_index-accesses-fix
+++ a/lib/stackdepot.c
@@ -521,7 +521,7 @@ unsigned int stack_depot_fetch(depot_sta
 
 	if (parts.pool_index > pool_index_cached) {
 		WARN(1, "pool index %d out of bounds (%d) for stack id %08x\n",
-			parts.pool_index, pool_index, handle);
+			parts.pool_index, pool_index_cached, handle);
 		return 0;
 	}
 	pool = stack_pools[parts.pool_index];
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-put-functions-in-logical-order.patch
lib-stackdepot-use-pr_fmt-to-define-message-format.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init.patch
lib-stackdepot-rename-stack_depot_disable.patch
lib-stackdepot-annotate-init-and-early-init-functions.patch
lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch
lib-stackdepot-reorder-and-annotate-global-variables.patch
lib-stackdepot-rename-hash-table-constants-and-variables.patch
lib-stackdepot-rename-slab-to-pool.patch
lib-stackdepot-rename-handle-and-pool-constants.patch
lib-stackdepot-rename-init_stack_pool.patch
lib-stacktrace-drop-impossible-warn_on-for-depot_init_pool.patch
lib-stackdepot-annotate-depot_init_pool-and-depot_alloc_stack.patch
lib-stackdepot-rename-next_pool_inited-to-next_pool_required.patch
lib-stacktrace-kasan-kmsan-rework-extra_bits-interface.patch
lib-stackdepot-annotate-racy-pool_index-accesses.patch
lib-stackdepot-various-comments-clean-ups.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth.patch

