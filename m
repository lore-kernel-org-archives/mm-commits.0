Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17C9C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350275AbiCYBOi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiCYBO3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0583BD2FB
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B2206187F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9357DC340EC;
        Fri, 25 Mar 2022 01:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170775;
        bh=8hbp5Xbna/iF/1tvl2xvCZrxYuPyIyObNyl3UK4gSg8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=tR3ES3Lctf/N7CxPoeNdf3E6NRy41JUzDIqh3Z9frzYLPqfKJDfkCUJZIvCJuYMwt
         2X2PQoDg3Hws+Z/Cx6R3oYK0eeZnvq9wjJBxe5DR3IHf0AH9IAdRIedmN5p2cLSX5d
         p0p1sKX1ZxZyKKYwvgCvyAmukiopRMAO2w+j6H3Y=
Date:   Thu, 24 Mar 2022 18:12:55 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 087/114] kasan: call print_report from kasan_report_invalid_free
Message-Id: <20220325011255.9357DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: call print_report from kasan_report_invalid_free

Call print_report() in kasan_report_invalid_free() instead of calling
printing functions directly.  Compared to the existing implementation of
kasan_report_invalid_free(), print_report() makes sure that the buggy
address has metadata before printing it.

The change requires adding a report type field into kasan_access_info and
using it accordingly.

kasan_report_async() is left as is, as using print_report() will only
complicate the code.

Link: https://lkml.kernel.org/r/9ea6f0604c5d2e1fb28d93dc6c44232c1f8017fe.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    6 ++++++
 mm/kasan/report.c |   42 ++++++++++++++++++++++++++----------------
 2 files changed, 32 insertions(+), 16 deletions(-)

--- a/mm/kasan/kasan.h~kasan-call-print_report-from-kasan_report_invalid_free
+++ a/mm/kasan/kasan.h
@@ -127,7 +127,13 @@ static inline bool kasan_sync_fault_poss
 #define META_MEM_BYTES_PER_ROW (META_BYTES_PER_ROW * KASAN_GRANULE_SIZE)
 #define META_ROWS_AROUND_ADDR 2
 
+enum kasan_report_type {
+	KASAN_REPORT_ACCESS,
+	KASAN_REPORT_INVALID_FREE,
+};
+
 struct kasan_access_info {
+	enum kasan_report_type type;
 	void *access_addr;
 	void *first_bad_addr;
 	size_t access_size;
--- a/mm/kasan/report.c~kasan-call-print_report-from-kasan_report_invalid_free
+++ a/mm/kasan/report.c
@@ -86,6 +86,12 @@ __setup("kasan_multi_shot", kasan_set_mu
 
 static void print_error_description(struct kasan_access_info *info)
 {
+	if (info->type == KASAN_REPORT_INVALID_FREE) {
+		pr_err("BUG: KASAN: double-free or invalid-free in %pS\n",
+		       (void *)info->ip);
+		return;
+	}
+
 	pr_err("BUG: KASAN: %s in %pS\n",
 		kasan_get_bug_type(info), (void *)info->ip);
 	if (info->access_size)
@@ -386,22 +392,6 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-void kasan_report_invalid_free(void *object, unsigned long ip)
-{
-	unsigned long flags;
-	u8 tag = get_tag(object);
-
-	object = kasan_reset_tag(object);
-
-	start_report(&flags, true);
-	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
-	kasan_print_tags(tag, object);
-	pr_err("\n");
-	print_address_description(object, tag);
-	print_memory_metadata(object);
-	end_report(&flags, object);
-}
-
 #ifdef CONFIG_KASAN_HW_TAGS
 void kasan_report_async(void)
 {
@@ -435,6 +425,25 @@ static void print_report(struct kasan_ac
 	}
 }
 
+void kasan_report_invalid_free(void *ptr, unsigned long ip)
+{
+	unsigned long flags;
+	struct kasan_access_info info;
+
+	start_report(&flags, true);
+
+	info.type = KASAN_REPORT_INVALID_FREE;
+	info.access_addr = ptr;
+	info.first_bad_addr = kasan_reset_tag(ptr);
+	info.access_size = 0;
+	info.is_write = false;
+	info.ip = ip;
+
+	print_report(&info);
+
+	end_report(&flags, ptr);
+}
+
 bool kasan_report(unsigned long addr, size_t size, bool is_write,
 			unsigned long ip)
 {
@@ -451,6 +460,7 @@ bool kasan_report(unsigned long addr, si
 
 	start_report(&irq_flags, true);
 
+	info.type = KASAN_REPORT_ACCESS;
 	info.access_addr = ptr;
 	info.first_bad_addr = kasan_find_first_bad_addr(ptr, size);
 	info.access_size = size;
_
