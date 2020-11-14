Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B64EC63699
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C6B22265
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDB+rIjP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgKNBHx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKNBHx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:07:53 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED66022254;
        Sat, 14 Nov 2020 01:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605316072;
        bh=UjxhkkzaC9XOkepOr94Smxby34ZwxTr7b9MCVpExDwY=;
        h=Date:From:To:Subject:From;
        b=mDB+rIjP8B8mreR60J/M8KSlZr+WN4kXinhaMjP4C00OXhcWig+1IggwBahsE1ZHh
         Cbkf45CfKhGA04ZpqFRDW93s8bNjnr3iBEJ/Ayh6JfrvMoFiab/Iy1B/xJBpN1H+qI
         fZdFsAuZ4oSNpdeeh3UJI9ZrcXfSEJizbTc5U3xs=
Date:   Fri, 13 Nov 2020 17:07:51 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        labbott@kernel.org, mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  +
 mm-page_poison-remove-config_page_poisoning_no_sanity.patch added to -mm
 tree
Message-ID: <20201114010751.XQ44ojhtB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_poison: remove CONFIG_PAGE_POISONING_NO_SANITY
has been added to the -mm tree.  Its filename is
     mm-page_poison-remove-config_page_poisoning_no_sanity.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_poison-remove-config_page_poisoning_no_sanity.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poison-remove-config_page_poisoning_no_sanity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_poison: remove CONFIG_PAGE_POISONING_NO_SANITY

CONFIG_PAGE_POISONING_NO_SANITY skips the check on page alloc whether the
poison pattern was corrupted, suggesting a use-after-free.  The motivation
to introduce it in commit 8823b1dbc05f ("mm/page_poison.c: enable
PAGE_POISONING as a separate option") was to simply sanitize freed pages,
optimally together with CONFIG_PAGE_POISONING_ZERO.

These days we have an init_on_free=1 boot option, which makes this use
case of page poisoning redundant.  For sanitizing, writing zeroes is
sufficient, there is pretty much no benefit from writing the 0xAA poison
pattern to freed pages, without checking it back on alloc.  Thus, remove
this option and suggest init_on_free instead in the main config's help.

Link: https://lkml.kernel.org/r/20201113104033.22907-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@kernel.org>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    4 +---
 mm/Kconfig.debug                |   15 ++++-----------
 mm/page_poison.c                |    3 ---
 3 files changed, 5 insertions(+), 17 deletions(-)

--- a/drivers/virtio/virtio_balloon.c~mm-page_poison-remove-config_page_poisoning_no_sanity
+++ a/drivers/virtio/virtio_balloon.c
@@ -1114,9 +1114,7 @@ static int virtballoon_validate(struct v
 	 * page reporting as it could potentially change the contents
 	 * of our free pages.
 	 */
-	if (!want_init_on_free() &&
-	    (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
-	     !page_poisoning_enabled_static()))
+	if (!want_init_on_free() && !page_poisoning_enabled_static())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
--- a/mm/Kconfig.debug~mm-page_poison-remove-config_page_poisoning_no_sanity
+++ a/mm/Kconfig.debug
@@ -74,18 +74,11 @@ config PAGE_POISONING
 	  Note that "poison" here is not the same thing as the "HWPoison"
 	  for CONFIG_MEMORY_FAILURE. This is software poisoning only.
 
-	  If unsure, say N
-
-config PAGE_POISONING_NO_SANITY
-	depends on PAGE_POISONING
-	bool "Only poison, don't sanity check"
-	help
-	   Skip the sanity checking on alloc, only fill the pages with
-	   poison on free. This reduces some of the overhead of the
-	   poisoning feature.
+	  If you are only interested in sanitization of freed pages without
+	  checking the poison pattern on alloc, you can boot the kernel with
+	  "init_on_free=1" instead of enabling this.
 
-	   If you are only interested in sanitization, say Y. Otherwise
-	   say N.
+	  If unsure, say N
 
 config PAGE_POISONING_ZERO
 	bool "Use zero for poisoning instead of debugging value"
--- a/mm/page_poison.c~mm-page_poison-remove-config_page_poisoning_no_sanity
+++ a/mm/page_poison.c
@@ -51,9 +51,6 @@ static void check_poison_mem(unsigned ch
 	unsigned char *start;
 	unsigned char *end;
 
-	if (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY))
-		return;
-
 	start = memchr_inv(mem, PAGE_POISON, bytes);
 	if (!start)
 		return;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-clean-up-pageset-high-and-batch-update.patch
mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch
mm-page_alloc-remove-setup_pageset.patch
mm-page_alloc-simplify-pageset_update.patch
mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch
mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch
mm-page_alloc-disable-pcplists-during-memory-offline.patch
mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch

