Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D3CC61DA4
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 00:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjAaAY1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Jan 2023 19:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjAaAY0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2023 19:24:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BDF12590
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2023 16:24:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E29FA61314
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 00:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425F4C433A7;
        Tue, 31 Jan 2023 00:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675124664;
        bh=Yn9xVNdUuVg9kNnz3y3xoaxAOuO8roEGBOJ2TsfIrPI=;
        h=Date:To:From:Subject:From;
        b=H9f7xKobNVEK8a2tHkiz550lF6ZwCn/3pf6hESjbRgTcYNmOi8zPcYmBQepH7CEyR
         nUgM/nndjP5hjmpb7fmxvSEQQSxBB96oqBQVVct6bUF5zhyjJoxrTzR5Vs29Woa+Dq
         v4gMcKs3r1JshVBpsVruBk66OI+iBXPR6z07MQXc=
Date:   Mon, 30 Jan 2023 16:24:23 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        eugenis@google.com, elver@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-fix-setting-next_slab_inited-in-init_stack_slab.patch added to mm-nonmm-unstable branch
Message-Id: <20230131002424.425F4C433A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: fix setting next_slab_inited in init_stack_slab
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-fix-setting-next_slab_inited-in-init_stack_slab.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-fix-setting-next_slab_inited-in-init_stack_slab.patch

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
Subject: lib/stackdepot: fix setting next_slab_inited in init_stack_slab
Date: Mon, 30 Jan 2023 21:49:25 +0100

Patch series "lib/stackdepot: fixes and clean-ups".

A set of fixes, comments, and clean-ups I came up with while reading
the stack depot code.


This patch (of 18):

In commit 305e519ce48e ("lib/stackdepot.c: fix global out-of-bounds in
stack_slabs"), init_stack_slab was changed to only use preallocated memory
for the next slab if the slab number limit is not reached.  However,
setting next_slab_inited was not moved together with updating stack_slabs.

Set next_slab_inited only if the preallocated memory was used for the next
slab.

Link: https://lkml.kernel.org/r/cover.1675111415.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/9fbb4d2bf9b2676a29b120980b5ffbda8e2304ee.1675111415.git.andreyknvl@google.com
Fixes: 305e519ce48e ("lib/stackdepot.c: fix global out-of-bounds in stack_slabs")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/stackdepot.c~lib-stackdepot-fix-setting-next_slab_inited-in-init_stack_slab
+++ a/lib/stackdepot.c
@@ -105,12 +105,13 @@ static bool init_stack_slab(void **preal
 		if (depot_index + 1 < STACK_ALLOC_MAX_SLABS) {
 			stack_slabs[depot_index + 1] = *prealloc;
 			*prealloc = NULL;
+			/*
+			 * This smp_store_release pairs with smp_load_acquire()
+			 * from |next_slab_inited| above and in
+			 * stack_depot_save().
+			 */
+			smp_store_release(&next_slab_inited, 1);
 		}
-		/*
-		 * This smp_store_release pairs with smp_load_acquire() from
-		 * |next_slab_inited| above and in stack_depot_save().
-		 */
-		smp_store_release(&next_slab_inited, 1);
 	}
 	return true;
 }
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

