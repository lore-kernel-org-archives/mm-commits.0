Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605CCC636D6
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjAaAZK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjAaAY5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC342193F4
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9000B818BF
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBFEC433EF;
        Tue, 31 Jan 2023 00:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124692;
        bh=A0lFb252iD9dFfTq7xMmVLzhEvd6Ho0LtGoNTV1QwFI=;
        h=Date:To:From:Subject:From;
        b=1BdfYnc8S8KsWPTpw6CQzygqZ7Rq5sIlONZ7mZslFNv3HPu2VCAoAJIWa/xmvLUzx
         UheI8QbQHb9B3kp7/zCaKi6AisOCi9M4JnzNGBLfvciwJ8ZqBklu4ZuVk+PnwRptDC
         U9oXT/phBpWRiGGUrhbGx+BOXxDAR8ZONuWQiMwE=
Date:   Mon, 30 Jan 2023 16:24:51 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-annotate-racy-slab_index-accesses.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002452.4BBFEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: annotate racy slab_index accesses
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-annotate-racy-slab_index-accesses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-annotate-racy-slab_index-accesses.patch

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
Subject: lib/stackdepot: annotate racy slab_index accesses
Date: Mon, 30 Jan 2023 21:49:40 +0100

Accesses to slab_index are protected by slab_lock everywhere except in a
sanity check in stack_depot_fetch.  The read access there can race with
the write access in depot_alloc_stack.

Use WRITE/READ_ONCE() to annotate the racy accesses.

As the sanity check is only used to print a warning in case of a violation
of the stack depot interface usage, it does not make a lot of sense to use
proper synchronization.

Link: https://lkml.kernel.org/r/19512bb03eed27ced5abeb5bd03f9a8381742cb1.1675111415.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-annotate-racy-slab_index-accesses
+++ a/lib/stackdepot.c
@@ -269,8 +269,11 @@ depot_alloc_stack(unsigned long *entries
 			return NULL;
 		}
 
-		/* Move on to the next slab. */
-		slab_index++;
+		/*
+		 * Move on to the next slab.
+		 * WRITE_ONCE annotates a race with stack_depot_fetch.
+		 */
+		WRITE_ONCE(slab_index, slab_index + 1);
 		slab_offset = 0;
 		/*
 		 * smp_store_release() here pairs with smp_load_acquire() in
@@ -492,6 +495,8 @@ unsigned int stack_depot_fetch(depot_sta
 			       unsigned long **entries)
 {
 	union handle_parts parts = { .handle = handle };
+	/* READ_ONCE annotates a race with depot_alloc_stack. */
+	int slab_index_cached = READ_ONCE(slab_index);
 	void *slab;
 	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
@@ -500,9 +505,9 @@ unsigned int stack_depot_fetch(depot_sta
 	if (!handle)
 		return 0;
 
-	if (parts.slab_index > slab_index) {
+	if (parts.slab_index > slab_index_cached) {
 		WARN(1, "slab index %d out of bounds (%d) for stack id %08x\n",
-			parts.slab_index, slab_index, handle);
+			parts.slab_index, slab_index_cached, handle);
 		return 0;
 	}
 	slab = stack_slabs[parts.slab_index];
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-reset-page-tags-properly-with-sampling.patch
kasan-reset-page-tags-properly-with-sampling-v2.patch
lib-stackdepot-fix-setting-next_slab_inited-in-init_stack_slab.patch
lib-stackdepot-put-functions-in-logical-order.patch
lib-stackdepot-use-pr_fmt-to-define-message-format.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init.patch
lib-stackdepot-rename-stack_depot_disable.patch
lib-stackdepot-annotate-init-and-early-init-functions.patch
lib-stackdepot-lower-the-indentation-in-stack_depot_init.patch
lib-stackdepot-reorder-and-annotate-global-variables.patch
lib-stackdepot-rename-hash-table-constants-and-variables.patch
lib-stackdepot-rename-init_stack_slab.patch
lib-stackdepot-rename-slab-variables.patch
lib-stackdepot-rename-handle-and-slab-constants.patch
lib-stacktrace-drop-impossible-warn_on-for-depot_init_slab.patch
lib-stackdepot-annotate-depot_init_slab-and-depot_alloc_stack.patch
lib-stacktrace-kasan-kmsan-rework-extra_bits-interface.patch
lib-stackdepot-annotate-racy-slab_index-accesses.patch
lib-stackdepot-various-comments-clean-ups.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth.patch

