Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DFCC54EED
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 20:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbjAXUq6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 15:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAXUq5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 15:46:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7987D2E0CF
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 12:46:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1425D61336
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 20:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67529C433D2;
        Tue, 24 Jan 2023 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674593215;
        bh=aRK8kEwgr5Pzue7tgunYiRsZk+BCThxr5CmlAOB1crM=;
        h=Date:To:From:Subject:From;
        b=brNJXW67cXSPec4nM8wRsFhoTUXJ/cfqlaVM+ezxcQ8bKPLDAhZZobKmTQcS5P0aJ
         eCIhhFPPeAuxCG5hcMIs/T/MRRZZy2UYd3zsnmeRmQDvNNvrdz4I53xA+xGANasSUF
         29L1GA0w3NL+quFKgOi6VoH/vATqzjVvXsPOIkdY=
Date:   Tue, 24 Jan 2023 12:46:54 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-reset-page-tags-properly-with-sampling.patch added to mm-unstable branch
Message-Id: <20230124204655.67529C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: reset page tags properly with sampling
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-reset-page-tags-properly-with-sampling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-reset-page-tags-properly-with-sampling.patch

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
Subject: kasan: reset page tags properly with sampling
Date: Tue, 24 Jan 2023 21:35:26 +0100

The implementation of page_alloc poisoning sampling assumed that
tag_clear_highpage resets page tags for __GFP_ZEROTAGS allocations. 
However, this is no longer the case since commit 70c248aca9e7 ("mm: kasan:
Skip unpoisoning of user pages").

This leads to kernel crashes when MTE-enabled userspace mappings are used
with Hardware Tag-Based KASAN enabled.

Reset page tags for __GFP_ZEROTAGS allocations in post_alloc_hook().

Also clarify and fix related comments.

Link: https://lkml.kernel.org/r/24ea20c1b19c2b4b56cf9f5b354915f8dbccfc77.1674592496.git.andreyknvl@google.com
Fixes: 44383cef54c0 ("kasan: allow sampling page_alloc allocations for HW_TAGS")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Peter Collingbourne <pcc@google.com>
Tested-by: Peter Collingbourne <pcc@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~kasan-reset-page-tags-properly-with-sampling
+++ a/mm/page_alloc.c
@@ -2476,7 +2476,7 @@ inline void post_alloc_hook(struct page
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
 	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
-	bool reset_tags = !zero_tags;
+	bool reset_tags = true;
 	int i;
 
 	set_page_private(page, 0);
@@ -2503,7 +2503,7 @@ inline void post_alloc_hook(struct page
 	 * (which happens only when memory should be initialized as well).
 	 */
 	if (zero_tags) {
-		/* Initialize both memory and tags. */
+		/* Initialize both memory and memory tags. */
 		for (i = 0; i != 1 << order; ++i)
 			tag_clear_highpage(page + i);
 
@@ -2521,14 +2521,14 @@ inline void post_alloc_hook(struct page
 		} else {
 			/*
 			 * KASAN decided to exclude this allocation from being
-			 * poisoned due to sampling. Skip poisoning as well.
+			 * unpoisoned due to sampling. Skip poisoning as well.
 			 */
 			SetPageSkipKASanPoison(page);
 		}
 	}
 	/*
-	 * If memory tags have not been set, reset the page tags to ensure
-	 * page_address() dereferencing does not fault.
+	 * If memory tags have not been set by KASAN, reset the page tags to
+	 * ensure page_address() dereferencing does not fault.
 	 */
 	if (reset_tags) {
 		for (i = 0; i != 1 << order; ++i)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-reset-page-tags-properly-with-sampling.patch

