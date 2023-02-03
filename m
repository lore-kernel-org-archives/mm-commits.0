Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB5DC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjBCFq3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjBCFq2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:46:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1876560CA3
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:46:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C423CB828B2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74574C433EF;
        Fri,  3 Feb 2023 05:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675403185;
        bh=cFPR841MeXaRm5WpcsLu7FjeIrwGF2OsDf1fgc1Oizk=;
        h=Date:To:From:Subject:From;
        b=Dt/XcECIpWI5C5Tx6O2IEHwce04oDFN8T6lK/MAugbxy1rB6NHNwjpuTE+irqmNBm
         zUYRyaoWnVFREMhjRUECk2kf6ekesav0aXUcg6kCOBx6P9USrlYYajZaMJXdnmfTCT
         VRDh6TlD7AT3blYyYvEgnEWDnCH4eK5T8z3682f4=
Date:   Thu, 02 Feb 2023 21:46:24 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-reset-page-tags-properly-with-sampling-v2.patch removed from -mm tree
Message-Id: <20230203054625.74574C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan-reset-page-tags-properly-with-sampling-v2
has been removed from the -mm tree.  Its filename was
     kasan-reset-page-tags-properly-with-sampling-v2.patch

This patch was dropped because it was folded into kasan-reset-page-tags-properly-with-sampling.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan-reset-page-tags-properly-with-sampling-v2
Date: Tue, 24 Jan 2023 21:40:09 +0100

update comment

Link: https://lkml.kernel.org/r/5dbd866714b4839069e2d8469ac45b60953db290.1674592780.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~kasan-reset-page-tags-properly-with-sampling-v2
+++ a/mm/page_alloc.c
@@ -2521,7 +2521,8 @@ inline void post_alloc_hook(struct page
 		} else {
 			/*
 			 * KASAN decided to exclude this allocation from being
-			 * unpoisoned due to sampling. Skip poisoning as well.
+			 * (un)poisoned due to sampling. Make KASAN skip
+			 * poisoning when the allocation is freed.
 			 */
 			SetPageSkipKASanPoison(page);
 		}
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-reset-page-tags-properly-with-sampling.patch
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

