Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC31C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiCYWoH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiCYWn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB84420A3BD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 814D7B82A33
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FE6C004DD;
        Fri, 25 Mar 2022 22:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248120;
        bh=XzblvwzdK9iCpyESGIikGL7eAophWC0WtZPfj0SSrHY=;
        h=Date:To:From:Subject:From;
        b=f+qfmgMNgRKS2nWFWfD4J0LCBVLrSWpNJgyOHmcPu75BkwgSZKuZEwyvpfLaeNE7C
         5xnE1fG+Tl2BMnere8Dwwe9VDZhchboKa52pj5gkZKdFjFdMHbwZNNX+5EXV8M28EB
         Dtj2qhfGbOxm1nhBSlbdFhP3aQip/d9mL+7JZPfs=
Date:   Fri, 25 Mar 2022 15:41:59 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch removed from -mm tree
Message-Id: <20220325224200.25FE6C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: drop skip_kasan_poison variable in free_pages_prepare
has been removed from the -mm tree.  Its filename was
     kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: drop skip_kasan_poison variable in free_pages_prepare

skip_kasan_poison is only used in a single place.  Call
should_skip_kasan_poison() directly for simplicity.

Link: https://lkml.kernel.org/r/1d33212e79bc9ef0b4d3863f903875823e89046f.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~kasan-drop-skip_kasan_poison-variable-in-free_pages_prepare
+++ a/mm/page_alloc.c
@@ -1297,7 +1297,6 @@ static __always_inline bool free_pages_p
 			unsigned int order, bool check_free, fpi_t fpi_flags)
 {
 	int bad = 0;
-	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
 	bool init = want_init_on_free();
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
@@ -1371,7 +1370,7 @@ static __always_inline bool free_pages_p
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	if (!skip_kasan_poison) {
+	if (!should_skip_kasan_poison(page, fpi_flags)) {
 		kasan_poison_pages(page, order, init);
 
 		/* Memory is already initialized if KASAN did it internally. */
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

