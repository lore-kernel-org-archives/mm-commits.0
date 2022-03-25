Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36CBC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbiCYBOh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357224AbiCYBO1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6399BD89E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 521C96187F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EC5C340ED;
        Fri, 25 Mar 2022 01:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170772;
        bh=qiwxu019qFYoxeCaO4BXlQi/rPgeDjWTWAoExj2JVOQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=JVMH7c6kIZY36BbAkMv0HrL9HRWhrWdMH/SpIL7e7PMrg4m9kmuIG+3rT81z2WnRZ
         nhhJD+uH9O85XrB9r8UOoJdm2toWfh5Ug7M3C8C6kA14QKRsxahgeqJnssAf0192F3
         H7beQ2niFs+xJcaHYvSRq91l8v6Q1E8V3xypFSZ4=
Date:   Thu, 24 Mar 2022 18:12:52 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 086/114] kasan: merge __kasan_report into kasan_report
Message-Id: <20220325011252.A8EC5C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: merge __kasan_report into kasan_report

Merge __kasan_report() into kasan_report().  The code is simple enough to
be readable without the __kasan_report() helper.

Link: https://lkml.kernel.org/r/c8a125497ef82f7042b3795918dffb81a85a878e.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

--- a/mm/kasan/report.c~kasan-merge-__kasan_report-into-kasan_report
+++ a/mm/kasan/report.c
@@ -435,37 +435,31 @@ static void print_report(struct kasan_ac
 	}
 }
 
-static void __kasan_report(void *addr, size_t size, bool is_write,
-				unsigned long ip)
-{
-	struct kasan_access_info info;
-	unsigned long flags;
-
-	start_report(&flags, true);
-
-	info.access_addr = addr;
-	info.first_bad_addr = kasan_find_first_bad_addr(addr, size);
-	info.access_size = size;
-	info.is_write = is_write;
-	info.ip = ip;
-
-	print_report(&info);
-
-	end_report(&flags, addr);
-}
-
 bool kasan_report(unsigned long addr, size_t size, bool is_write,
 			unsigned long ip)
 {
-	unsigned long ua_flags = user_access_save();
 	bool ret = true;
+	void *ptr = (void *)addr;
+	unsigned long ua_flags = user_access_save();
+	unsigned long irq_flags;
+	struct kasan_access_info info;
 
 	if (unlikely(!report_enabled())) {
 		ret = false;
 		goto out;
 	}
 
-	__kasan_report((void *)addr, size, is_write, ip);
+	start_report(&irq_flags, true);
+
+	info.access_addr = ptr;
+	info.first_bad_addr = kasan_find_first_bad_addr(ptr, size);
+	info.access_size = size;
+	info.is_write = is_write;
+	info.ip = ip;
+
+	print_report(&info);
+
+	end_report(&irq_flags, ptr);
 
 out:
 	user_access_restore(ua_flags);
_
