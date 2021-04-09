Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECC8C43462
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E0F6113A
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhDIU1w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIU1w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A566F61007;
        Fri,  9 Apr 2021 20:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000059;
        bh=x3HiqR1R25ZlyvBo+3cmSPknexJ1lOMTL7lM9RfdN00=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BpV2XIIsvuzKurtSXZPBUR1Rj7aYekSo25WY41/Qxk7AfIeGfHkJFuoLPehCPKHhZ
         VsQ6qtms0J2Nl3OXkwullBSkZxhsE56I4IApVJ1SOnVuU8vKqL1lS4Wk9hk7v5tmcR
         VZ7cK5dzoZZbAbZfL66cyaLX7Aj2Nxwui1XMWkk8=
Date:   Fri, 09 Apr 2021 13:27:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        elver@google.com, glider@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 13/16] kasan: fix conflict with page poisoning
Message-ID: <20210409202738.zz1hd8EMu%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix conflict with page poisoning

When page poisoning is enabled, it accesses memory that is marked as
poisoned by KASAN, which leas to false-positive KASAN reports.

Suppress the reports by adding KASAN annotations to unpoison_page()
(poison_page() already has them).

Link: https://lkml.kernel.org/r/2dc799014d31ac13fd97bd906bad33e16376fc67.1617118501.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_poison.c~kasan-fix-conflict-with-page-poisoning
+++ a/mm/page_poison.c
@@ -77,12 +77,14 @@ static void unpoison_page(struct page *p
 	void *addr;
 
 	addr = kmap_atomic(page);
+	kasan_disable_current();
 	/*
 	 * Page poisoning when enabled poisons each and every page
 	 * that is freed to buddy. Thus no extra check is done to
 	 * see if a page was poisoned.
 	 */
-	check_poison_mem(addr, PAGE_SIZE);
+	check_poison_mem(kasan_reset_tag(addr), PAGE_SIZE);
+	kasan_enable_current();
 	kunmap_atomic(addr);
 }
 
_
