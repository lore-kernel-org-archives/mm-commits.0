Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0373C197A0
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbjKTSEP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbjKTSEO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:04:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53624C9
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:04:08 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57C8C433C8;
        Mon, 20 Nov 2023 18:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700503448;
        bh=Q72LziUTRUU+9bDhParFtIjBncsNRfWDXG6upJ2Ggj0=;
        h=Date:To:From:Subject:From;
        b=EfaEjkaWTxSdYq0IMVQNxjEXneoW73VozaymG/RxchOGj1qGvgF19Fo1bsWO6c1TT
         BYKzAoK4oLbFUZJ9d4UlI3IlsoDSyFpMBO/4JEJOqT+329xCg/rwouNEzkfsIurV46
         AmxP1qyWA5IzY7QT8fUFTOcZPiycGGUyb2sLTAhY=
Date:   Mon, 20 Nov 2023 10:04:07 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-check-object_size-in-kasan_complete_mode_report_info.patch added to mm-unstable branch
Message-Id: <20231120180407.E57C8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: check object_size in kasan_complete_mode_report_info
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-check-object_size-in-kasan_complete_mode_report_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-check-object_size-in-kasan_complete_mode_report_info.patch

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
Subject: kasan: check object_size in kasan_complete_mode_report_info
Date: Mon, 20 Nov 2023 18:47:17 +0100

Check the object size when looking up entries in the stack ring.

If the size of the object for which a report is being printed does not
match the size of the object for which a stack trace has been saved in the
stack ring, the saved stack trace is irrelevant.

Link: https://lkml.kernel.org/r/68c6948175aadd7e7e7deea61725103d64a4528f.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report_tags.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/kasan/report_tags.c~kasan-check-object_size-in-kasan_complete_mode_report_info
+++ a/mm/kasan/report_tags.c
@@ -7,6 +7,7 @@
 #include <linux/atomic.h>
 
 #include "kasan.h"
+#include "../slab.h"
 
 extern struct kasan_stack_ring stack_ring;
 
@@ -58,7 +59,8 @@ void kasan_complete_mode_report_info(str
 		entry = &stack_ring.entries[i % stack_ring.size];
 
 		if (kasan_reset_tag(entry->ptr) != info->object ||
-		    get_tag(entry->ptr) != get_tag(info->access_addr))
+		    get_tag(entry->ptr) != get_tag(info->access_addr) ||
+		    info->cache->object_size != entry->size)
 			continue;
 
 		if (entry->is_free) {
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-print-disabled-message-only-if-truly-disabled.patch
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
kasan-use-stack_depot_put-for-generic-mode.patch
lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch

