Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BFCEE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjIMT3S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjIMT3I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:29:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5921BE6
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:29:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83D5C433C7;
        Wed, 13 Sep 2023 19:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694633343;
        bh=rlLJjOLZaF54yYakLZVUi2c/2DBa/NxhirlV203LvO4=;
        h=Date:To:From:Subject:From;
        b=lFZZvugdST+yELxtyM7BqUIeKqgd+gj6xD+vT8/swRV2pgMF+dPhF9PzlE+SGMPLZ
         V95nCnttt/u4jnWcn5gSsCC+9IyugWElWssCPB6T0FE7vS6ILSF+K88R8v3+Tbk4zg
         GbuPBzuOy9SJpfOMzer0n5Z3RH203Wa+9v7AfkWA=
Date:   Wed, 13 Sep 2023 12:29:03 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch added to mm-unstable branch
Message-Id: <20230913192903.C83D5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: use stack_depot_save instead of __stack_depot_save
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kmsan: use stack_depot_save instead of __stack_depot_save
Date: Wed, 13 Sep 2023 19:14:38 +0200

Make KMSAN use stack_depot_save instead of __stack_depot_save, as it
always passes true to __stack_depot_save as the last argument.

Link: https://lkml.kernel.org/r/7f6b58fda637238ffc0c240e7fd3b3a6673d9d91.1694625260.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/kmsan/core.c~kmsan-use-stack_depot_save-instead-of-__stack_depot_save
+++ a/mm/kmsan/core.c
@@ -76,7 +76,7 @@ depot_stack_handle_t kmsan_save_stack_wi
 	/* Don't sleep. */
 	flags &= ~(__GFP_DIRECT_RECLAIM | __GFP_KSWAPD_RECLAIM);
 
-	handle = __stack_depot_save(entries, nr_entries, flags, true);
+	handle = stack_depot_save(entries, nr_entries, flags);
 	return stack_depot_set_extra_bits(handle, extra);
 }
 
@@ -185,11 +185,10 @@ depot_stack_handle_t kmsan_internal_chai
 	/*
 	 * @entries is a local var in non-instrumented code, so KMSAN does not
 	 * know it is initialized. Explicitly unpoison it to avoid false
-	 * positives when __stack_depot_save() passes it to instrumented code.
+	 * positives when stack_depot_save() passes it to instrumented code.
 	 */
 	kmsan_internal_unpoison_memory(entries, sizeof(entries), false);
-	handle = __stack_depot_save(entries, ARRAY_SIZE(entries), __GFP_HIGH,
-				    true);
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), __GFP_HIGH);
 	return stack_depot_set_extra_bits(handle, extra_bits);
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-check-disabled-flag-when-fetching.patch
lib-stackdepot-simplify-__stack_depot_save.patch
lib-stackdepot-drop-valid-bit-from-handles.patch
lib-stackdepot-add-depot_fetch_stack-helper.patch
lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch
lib-stackdepot-fix-and-clean-up-atomic-annotations.patch
lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch
lib-stackdepot-rename-next_pool_required-to-new_pool_required.patch
lib-stackdepot-store-next-pool-pointer-in-new_pool.patch
lib-stackdepot-store-free-stack-records-in-a-freelist.patch
lib-stackdepot-use-read-write-lock.patch
lib-stackdepot-use-list_head-for-stack-record-links.patch
kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch
lib-stackdepot-kasan-add-flags-to-__stack_depot_save-and-rename.patch
lib-stackdepot-add-refcount-for-records.patch
lib-stackdepot-allow-users-to-evict-stack-traces.patch
kasan-remove-atomic-accesses-to-stack-ring-entries.patch
kasan-check-object_size-in-kasan_complete_mode_report_info.patch
kasan-use-stack_depot_put-for-tag-based-modes.patch

