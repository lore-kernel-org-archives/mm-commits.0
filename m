Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C987C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2908622475
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgLODUG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727886AbgLODLg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:11:36 -0500
Date:   Mon, 14 Dec 2020 19:09:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001747;
        bh=KCXGm6WQcmsGj0inb1EAGJACQ97EMHfErDk246CPB40=;
        h=From:To:Subject:In-Reply-To:From;
        b=KvfHveWOqNU4hwrMqmnsotF/hhjrz/kPYX2dfIgeDYvoKLJ4lo2i5SlSb+11IT1G9
         aQHuN16zXqKrSnpbNJrMrenLJMPDq5gmQiXZuwPHIm59tdF7ZFsifUis3jjX0pZLos
         ZCCZaaffMRSN90bMymzBdSqcE5JfnVSNeYVoMuUI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com
Subject:  [patch 100/200] mm/vmalloc.c: fix kasan shadow poisoning
 size
Message-ID: <20201215030906.Qsu0vQnb_%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
