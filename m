Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D3BC6FA8E
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 21:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbjBJVwK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Feb 2023 16:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbjBJVvw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Feb 2023 16:51:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A862729F
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 13:51:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8CCDB825E0
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 21:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A49C4339B;
        Fri, 10 Feb 2023 21:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676065908;
        bh=GdmR9MrLvy6re70rKWMmKTY9OqGmTQ6ypWbDvVbGluI=;
        h=Date:To:From:Subject:From;
        b=sgimP65LgVeSZVACh4FISG1I88V5uiXR+0qJrazZhMWogvfteEf8sy86748FhPuFe
         TQ3lfGYB7D6qPPetTi8YSzAiGYggS9nVbQxJ2HHQREjyGcbUBf6Czlxcb8EOPyQ8kC
         cZpb6bPk28c7Sxpjmakb/IureI7QwkeFjpMBnVg8=
Date:   Fri, 10 Feb 2023 13:51:47 -0800
To:     mm-commits@vger.kernel.org, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-annotate-racy-pool_index-accesses.patch added to mm-nonmm-unstable branch
Message-Id: <20230210215148.79A49C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: annotate racy pool_index accesses
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-annotate-racy-pool_index-accesses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-annotate-racy-pool_index-accesses.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

Link: https://lkml.kernel.org/r/359ac9c13cd0869c56740fb2029f505e41593830.1676063693.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

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
@@ -510,7 +519,7 @@ unsigned int stack_depot_fetch(depot_sta
 	if (!handle)
 		return 0;
 
-	if (parts.pool_index > pool_index) {
+	if (parts.pool_index > pool_index_cached) {
 		WARN(1, "pool index %d out of bounds (%d) for stack id %08x\n",
 			parts.pool_index, pool_index, handle);
 		return 0;
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

