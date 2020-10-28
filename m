Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A5E0C55179
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 21:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F15246CD
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 21:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603921588;
	bh=AcFuMobjm5JFrNRdDOGx924ARz0LmfP0ImPmCOL8HGg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=w1Ig9zySKB0jdgpdq38ucGvcLCVdyxYJfVpgfpjje9mjI2ltxONn9yLAsoRPJutBP
	 qNUvyydc1zcbGhwhcJQtJfqy3zLsk9bWIiBu7/G5787bArrDX76Rl/w+ayrU+YBsmJ
	 3OA6YIgbo1zfekd0GXlVKsOiko5Aq47OT6ZqlnP0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgJ1VqY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbgJ1VqW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 17:46:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B91246CD;
        Wed, 28 Oct 2020 21:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603921582;
        bh=AcFuMobjm5JFrNRdDOGx924ARz0LmfP0ImPmCOL8HGg=;
        h=Date:From:To:Subject:From;
        b=1DSgtSooseOjCxbWF5YAbAZUslSTAsl38DwE32RUv38PHaB1xUr6Mr+TxCI4Hcw3n
         SSixEpuIHFALf0wRXZGOmM4kwATmMJwueKr9P9e4kfgL+qY3TXevaDGWK4vQOvHG3X
         yA9Le2a+zybxAsoqEFf3jV6cgFC9Z7tvA8CMfjow=
Date:   Wed, 28 Oct 2020 14:46:20 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com
Subject:  + mm-vmalloc-fix-kasan-shadow-poisoning-size.patch added
 to -mm tree
Message-ID: <20201028214620.wB2DadcBH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix kasan shadow poisoning size
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-kasan-shadow-poisoning-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-kasan-shadow-poisoning-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-kasan-shadow-poisoning-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2256,7 +2256,7 @@ static void __vunmap(const void *addr, i
 	debug_check_no_locks_freed(area->addr, get_vm_area_size(area));
 	debug_check_no_obj_freed(area->addr, get_vm_area_size(area));
 
-	kasan_poison_vmalloc(area->addr, area->size);
+	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
 	vm_remove_mappings(area, deallocate_pages);
 
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

mm-vmalloc-fix-kasan-shadow-poisoning-size.patch

