Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D439FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357199AbiCYBOg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357242AbiCYBO0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED980BD885
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 894F761857
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E099DC340ED;
        Fri, 25 Mar 2022 01:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170767;
        bh=Pj7hruJwztHMQZ1mKwF/mJfZ6Lv6QyXGVkerKId+sIA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=mqBlQG3YBs+42gRv8TZORdPTsEU59PdVRp9RMmmm09HoEMo0W5CqM6VcxfAhaIyQL
         eol9ZodvW/9/yp6NLQEtZmpuLa1rXn4hulxae1nu4uutO34Mqnz2i8PFS1E6LGKERF
         KG+zdHB8o78HTwG7CGf1KntHUnHHMyOdQe0XM5/M=
Date:   Thu, 24 Mar 2022 18:12:46 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 084/114] kasan: simplify kasan_find_first_bad_addr call sites
Message-Id: <20220325011246.E099DC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: simplify kasan_find_first_bad_addr call sites

Move the addr_has_metadata() check into kasan_find_first_bad_addr().

Link: https://lkml.kernel.org/r/a49576f7a23283d786ba61579cb0c5057e8f0b9b.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c         |    5 +----
 mm/kasan/report_generic.c |    4 ++++
 mm/kasan/report_hw_tags.c |    1 +
 mm/kasan/report_sw_tags.c |    4 ++++
 4 files changed, 10 insertions(+), 4 deletions(-)

--- a/mm/kasan/report.c~kasan-simplify-kasan_find_first_bad_addr-call-sites
+++ a/mm/kasan/report.c
@@ -444,10 +444,7 @@ static void __kasan_report(void *addr, s
 	start_report(&flags, true);
 
 	info.access_addr = addr;
-	if (addr_has_metadata(addr))
-		info.first_bad_addr = kasan_find_first_bad_addr(addr, size);
-	else
-		info.first_bad_addr = addr;
+	info.first_bad_addr = kasan_find_first_bad_addr(addr, size);
 	info.access_size = size;
 	info.is_write = is_write;
 	info.ip = ip;
--- a/mm/kasan/report_generic.c~kasan-simplify-kasan_find_first_bad_addr-call-sites
+++ a/mm/kasan/report_generic.c
@@ -34,8 +34,12 @@ void *kasan_find_first_bad_addr(void *ad
 {
 	void *p = addr;
 
+	if (!addr_has_metadata(p))
+		return p;
+
 	while (p < addr + size && !(*(u8 *)kasan_mem_to_shadow(p)))
 		p += KASAN_GRANULE_SIZE;
+
 	return p;
 }
 
--- a/mm/kasan/report_hw_tags.c~kasan-simplify-kasan_find_first_bad_addr-call-sites
+++ a/mm/kasan/report_hw_tags.c
@@ -17,6 +17,7 @@
 
 void *kasan_find_first_bad_addr(void *addr, size_t size)
 {
+	/* Return the same value regardless of whether addr_has_metadata(). */
 	return kasan_reset_tag(addr);
 }
 
--- a/mm/kasan/report_sw_tags.c~kasan-simplify-kasan_find_first_bad_addr-call-sites
+++ a/mm/kasan/report_sw_tags.c
@@ -36,8 +36,12 @@ void *kasan_find_first_bad_addr(void *ad
 	void *p = kasan_reset_tag(addr);
 	void *end = p + size;
 
+	if (!addr_has_metadata(p))
+		return p;
+
 	while (p < end && tag == *(u8 *)kasan_mem_to_shadow(p))
 		p += KASAN_GRANULE_SIZE;
+
 	return p;
 }
 
_
