Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D06BC43334
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 21:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349938AbiFOVR6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 17:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349932AbiFOVR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 17:17:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0068E47074
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 14:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA34FB82182
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 21:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DC6C3411A;
        Wed, 15 Jun 2022 21:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655327873;
        bh=eX5kxakhuQIHaiSjiKiIhBoQXzYnc2ECWXDsiJZUvYI=;
        h=Date:To:From:Subject:From;
        b=0qM6x+H+QQVI0rCpB2XgJ2Nm/Bls+m6ff8rylp96TVGQspy3/f0NZQIyhm6IouDY4
         NsFDRzqBci8Tq4Z3R6YE0huxWtfFgf61b7qtKOfkYexFXqiT+Ayy0qkuTSz6WdiGt/
         PihFPyBIuXTo/lzaXcIiIGyQB26ghFLHRkNsHQsc=
Date:   Wed, 15 Jun 2022 14:17:52 -0700
To:     mm-commits@vger.kernel.org, yee.lee@mediatek.com,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        matthias.bgg@gmail.com, glider@google.com, dvyukov@google.com,
        chinwen.chang@mediatek.com, andreyknvl@gmail.com,
        andrew.yang@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-separate-double-free-case-from-invalid-free.patch added to mm-unstable branch
Message-Id: <20220615211753.07DC6C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: separate double free case from invalid free
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-separate-double-free-case-from-invalid-free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-separate-double-free-case-from-invalid-free.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
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

kasan-separate-double-free-case-from-invalid-free.patch

