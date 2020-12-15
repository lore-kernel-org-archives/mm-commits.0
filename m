Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B549C3526B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C0422CAE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgLPAAX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbgLOX1s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:48 -0500
Date:   Tue, 15 Dec 2020 15:23:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074632;
        bh=E9iklCcge1mquXi1gZjklgsQM1UiaTQZWIR7jAbaARE=;
        h=From:To:Subject:From;
        b=CS62wFL8lKSkSLU1vtlPIbUV2iv8NZleMdgV/xpBOIMBOSCN0eZuejogoI6IxFS9m
         ksTKdP7b2y2QBgmT7qNEZykwKWlyjbR24vVnetKHM6BNU9yzpukSo1sRVME24xFMRw
         aMtToWin1pyWssI+Uw1V/n9PItJOwI6LgpJjvjho=
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        labbott@kernel.org, mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [merged]
 mm-page_poison-remove-config_page_poisoning_no_sanity.patch removed from
 -mm tree
Message-ID: <20201215232351.m1moOaCr7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_poison: remove CONFIG_PAGE_POISONING_NO_SANITY
has been removed from the -mm tree.  Its filename was
     mm-page_poison-remove-config_page_poisoning_no_sanity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


