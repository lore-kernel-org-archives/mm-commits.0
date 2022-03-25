Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F02B3C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbiCYWon (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbiCYWoa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2418720D50E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB528B82A1E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C7DC340ED;
        Fri, 25 Mar 2022 22:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248172;
        bh=96Xc92ZsJwTLi6asy7OBAXme1GeqWGDweonuzZGLawA=;
        h=Date:To:From:Subject:From;
        b=XQFcmtO6KShKuHKvQWvFyy+NEguuK8yPcALQZUIT7lOUOKtRHwhlg4GRPBUdYRdb+
         Twq+m0LWg35Gys0qyHJTpV4m/R4U0HKdECy9zYNfNKjn5MrkcE/1S9uUZLtv1cUueU
         Bz63AybVsArIDHuz1lXP7gzHTT3dq3XdB4bTrgSQ=
Date:   Fri, 25 Mar 2022 15:42:51 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-simplify-kasan_find_first_bad_addr-call-sites.patch removed from -mm tree
Message-Id: <20220325224252.63C7DC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: simplify kasan_find_first_bad_addr call sites
has been removed from the -mm tree.  Its filename was
     kasan-simplify-kasan_find_first_bad_addr-call-sites.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

