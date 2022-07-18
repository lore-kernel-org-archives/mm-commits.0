Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C6CCCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiGRASP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbiGRARR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C5AE01E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E5F4B80EEC
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0E1C341C0;
        Mon, 18 Jul 2022 00:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103426;
        bh=Q8TfYe81vXtEESZpIg1EyWAoChMarGrqCTuA6r7hd7E=;
        h=Date:To:From:Subject:From;
        b=nBssb63PkIImFrDGs7HN96MX1ZqixwIE79+9J6F5UTxsmH+QNLHA23rO3WzvqG1ET
         m2sjpagCyIoloNtRm2Fq9n6GgbZP8Qk5IqixJTC5mrI1QRieA+ffVniydT0nkdzuBK
         i5Ci8gu9nVWYIqDui+jEPzBEAY/PonHiufmvqMyE=
Date:   Sun, 17 Jul 2022 17:17:06 -0700
To:     mm-commits@vger.kernel.org, yee.lee@mediatek.com,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        matthias.bgg@gmail.com, glider@google.com, dvyukov@google.com,
        chinwen.chang@mediatek.com, andreyknvl@gmail.com,
        andrew.yang@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-separate-double-free-case-from-invalid-free.patch removed from -mm tree
Message-Id: <20220718001706.CF0E1C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: separate double free case from invalid free
has been removed from the -mm tree.  Its filename was
     kasan-separate-double-free-case-from-invalid-free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: kasan: separate double free case from invalid free
Date: Wed, 15 Jun 2022 14:22:18 +0800

Currently, KASAN describes all invalid-free/double-free bugs as
"double-free or invalid-free".  This is ambiguous.

KASAN should report "double-free" when a double-free is a more likely
cause (the address points to the start of an object) and report
"invalid-free" otherwise [1].

[1] https://bugzilla.kernel.org/show_bug.cgi?id=212193

Link: https://lkml.kernel.org/r/20220615062219.22618-1-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Yee Lee <yee.lee@mediatek.com>
Cc: Andrew Yang <andrew.yang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    8 ++++----
 mm/kasan/kasan.h  |    3 ++-
 mm/kasan/report.c |   12 ++++++++----
 3 files changed, 14 insertions(+), 9 deletions(-)

--- a/mm/kasan/common.c~kasan-separate-double-free-case-from-invalid-free
+++ a/mm/kasan/common.c
@@ -343,7 +343,7 @@ static inline bool ____kasan_slab_free(s
 
 	if (unlikely(nearest_obj(cache, virt_to_slab(object), object) !=
 	    object)) {
-		kasan_report_invalid_free(tagged_object, ip);
+		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
 	}
 
@@ -352,7 +352,7 @@ static inline bool ____kasan_slab_free(s
 		return false;
 
 	if (!kasan_byte_accessible(tagged_object)) {
-		kasan_report_invalid_free(tagged_object, ip);
+		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_DOUBLE_FREE);
 		return true;
 	}
 
@@ -377,12 +377,12 @@ bool __kasan_slab_free(struct kmem_cache
 static inline bool ____kasan_kfree_large(void *ptr, unsigned long ip)
 {
 	if (ptr != page_address(virt_to_head_page(ptr))) {
-		kasan_report_invalid_free(ptr, ip);
+		kasan_report_invalid_free(ptr, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
 	}
 
 	if (!kasan_byte_accessible(ptr)) {
-		kasan_report_invalid_free(ptr, ip);
+		kasan_report_invalid_free(ptr, ip, KASAN_REPORT_DOUBLE_FREE);
 		return true;
 	}
 
--- a/mm/kasan/kasan.h~kasan-separate-double-free-case-from-invalid-free
+++ a/mm/kasan/kasan.h
@@ -125,6 +125,7 @@ static inline bool kasan_sync_fault_poss
 enum kasan_report_type {
 	KASAN_REPORT_ACCESS,
 	KASAN_REPORT_INVALID_FREE,
+	KASAN_REPORT_DOUBLE_FREE,
 };
 
 struct kasan_report_info {
@@ -277,7 +278,7 @@ static inline void kasan_print_address_s
 
 bool kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
-void kasan_report_invalid_free(void *object, unsigned long ip);
+void kasan_report_invalid_free(void *object, unsigned long ip, enum kasan_report_type type);
 
 struct page *kasan_addr_to_page(const void *addr);
 struct slab *kasan_addr_to_slab(const void *addr);
--- a/mm/kasan/report.c~kasan-separate-double-free-case-from-invalid-free
+++ a/mm/kasan/report.c
@@ -176,8 +176,12 @@ static void end_report(unsigned long *fl
 static void print_error_description(struct kasan_report_info *info)
 {
 	if (info->type == KASAN_REPORT_INVALID_FREE) {
-		pr_err("BUG: KASAN: double-free or invalid-free in %pS\n",
-		       (void *)info->ip);
+		pr_err("BUG: KASAN: invalid-free in %pS\n", (void *)info->ip);
+		return;
+	}
+
+	if (info->type == KASAN_REPORT_DOUBLE_FREE) {
+		pr_err("BUG: KASAN: double-free in %pS\n", (void *)info->ip);
 		return;
 	}
 
@@ -433,7 +437,7 @@ static void print_report(struct kasan_re
 	}
 }
 
-void kasan_report_invalid_free(void *ptr, unsigned long ip)
+void kasan_report_invalid_free(void *ptr, unsigned long ip, enum kasan_report_type type)
 {
 	unsigned long flags;
 	struct kasan_report_info info;
@@ -448,7 +452,7 @@ void kasan_report_invalid_free(void *ptr
 
 	start_report(&flags, true);
 
-	info.type = KASAN_REPORT_INVALID_FREE;
+	info.type = type;
 	info.access_addr = ptr;
 	info.first_bad_addr = kasan_reset_tag(ptr);
 	info.access_size = 0;
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are


