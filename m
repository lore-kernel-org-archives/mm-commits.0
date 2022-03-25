Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23798C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357197AbiCYBOf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357237AbiCYBO0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D8CBD7FB
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A68D96187F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AC5C340EE;
        Fri, 25 Mar 2022 01:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170764;
        bh=RzBlSdC420vJJd7gcAad/iyH11bhqmQDcy85CMRPu10=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Qje3niBDT5hCwtX8QPAmkiueERy98Y2d3TS0viscUusADUs2DXT1nQitNuJ28DPsA
         lcojJkaaF+SWi1D4K0+jAj7SodfqS37LkMqC7ZgP1sPb42xgVqnMlQVTojToFn09Be
         e6524XOrX/y0Mmb41XSCNN1X9V9xZ/KBrJfuJgsE=
Date:   Thu, 24 Mar 2022 18:12:43 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 083/114] kasan: split out print_report from __kasan_report
Message-Id: <20220325011244.06AC5C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: split out print_report from __kasan_report

Split out the part of __kasan_report() that prints things into
print_report().  One of the subsequent patches makes another error handler
use print_report() as well.

Includes lower-level changes:

- Allow addr_has_metadata() accepting a tagged address.
- Drop the const qualifier from the fields of kasan_access_info to avoid
  excessive type casts.
- Change the type of the address argument of __kasan_report() and
  end_report() to void * to reduce the number of type casts.

Link: https://lkml.kernel.org/r/9be3ed99dd24b9c4e1c4a848b69a0c6ecefd845e.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    7 +++--
 mm/kasan/report.c |   58 +++++++++++++++++++++++---------------------
 2 files changed, 35 insertions(+), 30 deletions(-)

--- a/mm/kasan/kasan.h~kasan-split-out-print_report-from-__kasan_report
+++ a/mm/kasan/kasan.h
@@ -128,8 +128,8 @@ static inline bool kasan_sync_fault_poss
 #define META_ROWS_AROUND_ADDR 2
 
 struct kasan_access_info {
-	const void *access_addr;
-	const void *first_bad_addr;
+	void *access_addr;
+	void *first_bad_addr;
 	size_t access_size;
 	bool is_write;
 	unsigned long ip;
@@ -239,7 +239,8 @@ static inline const void *kasan_shadow_t
 
 static inline bool addr_has_metadata(const void *addr)
 {
-	return (addr >= kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
+	return (kasan_reset_tag(addr) >=
+		kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
 }
 
 /**
--- a/mm/kasan/report.c~kasan-split-out-print_report-from-__kasan_report
+++ a/mm/kasan/report.c
@@ -139,10 +139,11 @@ static void start_report(unsigned long *
 	pr_err("==================================================================\n");
 }
 
-static void end_report(unsigned long *flags, unsigned long addr)
+static void end_report(unsigned long *flags, void *addr)
 {
 	if (addr)
-		trace_error_report_end(ERROR_DETECTOR_KASAN, addr);
+		trace_error_report_end(ERROR_DETECTOR_KASAN,
+				       (unsigned long)addr);
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
@@ -398,7 +399,7 @@ void kasan_report_invalid_free(void *obj
 	pr_err("\n");
 	print_address_description(object, tag);
 	print_memory_metadata(object);
-	end_report(&flags, (unsigned long)object);
+	end_report(&flags, object);
 }
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -411,44 +412,47 @@ void kasan_report_async(void)
 	pr_err("Asynchronous mode enabled: no access details available\n");
 	pr_err("\n");
 	dump_stack_lvl(KERN_ERR);
-	end_report(&flags, 0);
+	end_report(&flags, NULL);
 }
 #endif /* CONFIG_KASAN_HW_TAGS */
 
-static void __kasan_report(unsigned long addr, size_t size, bool is_write,
+static void print_report(struct kasan_access_info *info)
+{
+	void *tagged_addr = info->access_addr;
+	void *untagged_addr = kasan_reset_tag(tagged_addr);
+	u8 tag = get_tag(tagged_addr);
+
+	print_error_description(info);
+	if (addr_has_metadata(untagged_addr))
+		kasan_print_tags(tag, info->first_bad_addr);
+	pr_err("\n");
+
+	if (addr_has_metadata(untagged_addr)) {
+		print_address_description(untagged_addr, tag);
+		print_memory_metadata(info->first_bad_addr);
+	} else {
+		dump_stack_lvl(KERN_ERR);
+	}
+}
+
+static void __kasan_report(void *addr, size_t size, bool is_write,
 				unsigned long ip)
 {
 	struct kasan_access_info info;
-	void *tagged_addr;
-	void *untagged_addr;
 	unsigned long flags;
 
 	start_report(&flags, true);
 
-	tagged_addr = (void *)addr;
-	untagged_addr = kasan_reset_tag(tagged_addr);
-
-	info.access_addr = tagged_addr;
-	if (addr_has_metadata(untagged_addr))
-		info.first_bad_addr =
-			kasan_find_first_bad_addr(tagged_addr, size);
+	info.access_addr = addr;
+	if (addr_has_metadata(addr))
+		info.first_bad_addr = kasan_find_first_bad_addr(addr, size);
 	else
-		info.first_bad_addr = untagged_addr;
+		info.first_bad_addr = addr;
 	info.access_size = size;
 	info.is_write = is_write;
 	info.ip = ip;
 
-	print_error_description(&info);
-	if (addr_has_metadata(untagged_addr))
-		kasan_print_tags(get_tag(tagged_addr), info.first_bad_addr);
-	pr_err("\n");
-
-	if (addr_has_metadata(untagged_addr)) {
-		print_address_description(untagged_addr, get_tag(tagged_addr));
-		print_memory_metadata(info.first_bad_addr);
-	} else {
-		dump_stack_lvl(KERN_ERR);
-	}
+	print_report(&info);
 
 	end_report(&flags, addr);
 }
@@ -460,7 +464,7 @@ bool kasan_report(unsigned long addr, si
 	bool ret = false;
 
 	if (likely(report_enabled())) {
-		__kasan_report(addr, size, is_write, ip);
+		__kasan_report((void *)addr, size, is_write, ip);
 		ret = true;
 	}
 
_
