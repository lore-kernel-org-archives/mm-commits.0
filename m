Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8176C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357158AbiCYBMK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352182AbiCYBMH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F45D7C154
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFEF561857
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E03C340ED;
        Fri, 25 Mar 2022 01:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170626;
        bh=V5z8XG7cnJZXzUe4q6SthEHoGkaz3Zlgp/+W+Cq1vUY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=BZZzy/fq4kzy1gYypPcxSC/R62veOedpMYpX5hYaFVZ8e67BpeuJbo2zSAtDGC9Wv
         l7PYdPsip6mk4KHxWGbtO4hc8CMo7BWuTGK4mU9LIhw3WdQhjCxo02cbectIapxGYl
         5h6Lg0Fl6Bnk37r7CYRFQhGEICEPdMzUxlwjqi9s=
Date:   Thu, 24 Mar 2022 18:10:25 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 037/114] kasan: only apply __GFP_ZEROTAGS when memory is zeroed
Message-Id: <20220325011026.16E03C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
