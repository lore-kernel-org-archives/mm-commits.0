Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89596C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiCYWoF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiCYWn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D3020A3BF
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F18A061502
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B40C004DD;
        Fri, 25 Mar 2022 22:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248122;
        bh=QNyGXH+9GHUBxYEVMzEB5KSz1o5Icn2LXMHZ1K8qs24=;
        h=Date:To:From:Subject:From;
        b=PjJ1JGV6qttjXei6tmGUXaqGycZi39vgodADhKqbnT8zmxhOilItMuRD7ArofVKxw
         TJ/8Ap8ep3D1YxSAaKutZg1p6xaI1FMjc1RXZssUcQApSB4ak0EIhgwZbwQCRHcEnF
         BRvGoxxOrdcJT/9duRO4JhOq28PIndY+dLS09Dhs=
Date:   Fri, 25 Mar 2022 15:42:01 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-only-apply-__gfp_zerotags-when-memory-is-zeroed.patch removed from -mm tree
Message-Id: <20220325224202.58B40C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: only apply __GFP_ZEROTAGS when memory is zeroed
has been removed from the -mm tree.  Its filename was
     kasan-only-apply-__gfp_zerotags-when-memory-is-zeroed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: only apply __GFP_ZEROTAGS when memory is zeroed

__GFP_ZEROTAGS should only be effective if memory is being zeroed. 
Currently, hardware tag-based KASAN violates this requirement.

Fix by including an initialization check along with checking for
__GFP_ZEROTAGS.

Link: https://lkml.kernel.org/r/f4f4593f7f675262d29d07c1938db5bd0cd5e285.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
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

 mm/kasan/hw_tags.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kasan/hw_tags.c~kasan-only-apply-__gfp_zerotags-when-memory-is-zeroed
+++ a/mm/kasan/hw_tags.c
@@ -199,11 +199,12 @@ void kasan_alloc_pages(struct page *page
 	 * page_alloc.c.
 	 */
 	bool init = !want_init_on_free() && want_init_on_alloc(flags);
+	bool init_tags = init && (flags & __GFP_ZEROTAGS);
 
 	if (flags & __GFP_SKIP_KASAN_POISON)
 		SetPageSkipKASanPoison(page);
 
-	if (flags & __GFP_ZEROTAGS) {
+	if (init_tags) {
 		int i;
 
 		for (i = 0; i != 1 << order; ++i)
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

