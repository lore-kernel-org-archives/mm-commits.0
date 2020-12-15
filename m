Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896A6C47435
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47EE422EBD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgLOX7F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgLOXWG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:06 -0500
Date:   Tue, 15 Dec 2020 15:20:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074418;
        bh=7nWpO0MxQjFIfzHvHrqVal7I6UtHU08hYn1UKf6+nfg=;
        h=From:To:Subject:From;
        b=1dwQf0pOYAhY3fYxbMBrf94h64TQfCjmSlPClmFcU0diD8XW9zo2jCG8BWOl/uoAl
         yT+6waCt5IlVyfltu6EX7YDx8auUrxPbk88w7m2xWEXaMpdQZKpVcXCtXGbt1BuzXg
         bh7YGWxEe0qH2VOHL88vpToQz0ufVg4W0HADFyhA=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com
Subject:  [merged] mm-vmalloc-fix-kasan-shadow-poisoning-size.patch
 removed from -mm tree
Message-ID: <20201215232018.TfhN5CxQw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix kasan shadow poisoning size
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-kasan-shadow-poisoning-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: mm/vmalloc.c: fix kasan shadow poisoning size

The size of vm area can be affected by the presence or not of the guard
page.  In particular when VM_NO_GUARD is present, the actual accessible
size has to be considered like the real size minus the guard page.

Currently kasan does not keep into account this information during the
poison operation and in particular tries to poison the guard page as well.

This approach, even if incorrect, does not cause an issue because the tags
for the guard page are written in the shadow memory.  With the future
introduction of the Tag-Based KASAN, being the guard page inaccessible by
nature, the write tag operation on this page triggers a fault.

Fix kasan shadow poisoning size invoking get_vm_area_size() instead of
accessing directly the field in the data structure to detect the correct
value.

Link: https://lkml.kernel.org/r/20201027160213.32904-1-vincenzo.frascino@arm.com
Fixes: d98c9e83b5e7c ("kasan: fix crashes on access to memory mapped by vm_map_ram()")
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-kasan-shadow-poisoning-size
+++ a/mm/vmalloc.c
@@ -2272,7 +2272,7 @@ static void __vunmap(const void *addr, i
 	debug_check_no_locks_freed(area->addr, get_vm_area_size(area));
 	debug_check_no_obj_freed(area->addr, get_vm_area_size(area));
 
-	kasan_poison_vmalloc(area->addr, area->size);
+	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
 	vm_remove_mappings(area, deallocate_pages);
 
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

arm64-enable-armv85-a-asm-arch-option.patch
arm64-mte-add-in-kernel-mte-helpers.patch
arm64-mte-reset-the-page-tag-in-page-flags.patch
arm64-mte-add-in-kernel-tag-fault-handler.patch
arm64-kasan-allow-enabling-in-kernel-mte.patch
arm64-mte-convert-gcr_user-into-an-exclude-mask.patch
arm64-mte-switch-gcr_el1-in-kernel-entry-and-exit.patch
kasan-mm-untag-page-address-in-free_reserved_area.patch
kselftest-arm64-check-gcr_el1-after-context-switch.patch

