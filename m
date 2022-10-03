Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474D2C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJCVJt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJCVIK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047B44F199
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9432B611F0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF84C433C1;
        Mon,  3 Oct 2022 21:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831175;
        bh=yuGLtRlowlRykWwpKzUuKwtfrUo8PWgT6nH8MJR4a9g=;
        h=Date:To:From:Subject:From;
        b=KNll9UkZr1C7TnMPYypukXa1AANGl1VZ6kj5gTymSaHdvNejm1yZYx0+utVdWsJWi
         4vaI8MF6jh5uDsIt3i1cz1cJBJLwa57VteYlBeqq+ZmjUqMs8i0HSeF0yUOZdmjObK
         qDhDXYMDgl5crTFYpg/sdLqbf3RLUOwGlz5WzyDo=
Date:   Mon, 03 Oct 2022 14:06:14 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-make-kasan_addr_to_page-static.patch removed from -mm tree
Message-Id: <20221003210614.DBF84C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: make kasan_addr_to_page static
has been removed from the -mm tree.  Its filename was
     kasan-make-kasan_addr_to_page-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: make kasan_addr_to_page static
Date: Mon, 5 Sep 2022 23:05:39 +0200

As kasan_addr_to_page() is only used in report.c, rename it to
addr_to_page() and make it static.

Link: https://lkml.kernel.org/r/66c1267200fe0c16e2ac8847a9315fda041918cb.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    1 -
 mm/kasan/report.c |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/mm/kasan/kasan.h~kasan-make-kasan_addr_to_page-static
+++ a/mm/kasan/kasan.h
@@ -291,7 +291,6 @@ bool kasan_report(unsigned long addr, si
 		bool is_write, unsigned long ip);
 void kasan_report_invalid_free(void *object, unsigned long ip, enum kasan_report_type type);
 
-struct page *kasan_addr_to_page(const void *addr);
 struct slab *kasan_addr_to_slab(const void *addr);
 
 #ifdef CONFIG_KASAN_GENERIC
--- a/mm/kasan/report.c~kasan-make-kasan_addr_to_page-static
+++ a/mm/kasan/report.c
@@ -206,7 +206,7 @@ static void print_track(struct kasan_tra
 		pr_err("(stack is not available)\n");
 }
 
-struct page *kasan_addr_to_page(const void *addr)
+static inline struct page *addr_to_page(const void *addr)
 {
 	if (virt_addr_valid(addr))
 		return virt_to_head_page(addr);
@@ -289,7 +289,7 @@ static inline bool init_task_stack_addr(
 
 static void print_address_description(void *addr, u8 tag)
 {
-	struct page *page = kasan_addr_to_page(addr);
+	struct page *page = addr_to_page(addr);
 	struct slab *slab = kasan_addr_to_slab(addr);
 
 	dump_stack_lvl(KERN_ERR);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

