Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3115C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJCVJp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiJCVIJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27E14F197
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E5FA6118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E53C433C1;
        Mon,  3 Oct 2022 21:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831173;
        bh=Cte+RB7+9uhrgxZ6I2qq5UiuUyoTQ5U4W13ZtDlNGJM=;
        h=Date:To:From:Subject:From;
        b=vDBkt5X+ucICN0C1M0XydKDW6SFSy6Ts+S678v48EE+VKupJ55SlICpETuwSK6cTF
         h52kqvLFvrHC1B8pXkZ/Vz3O5wuUzgOamn2oHqxV6PIxR/43qZja9WF6NasJceaWqU
         y/zXE98Nf6+eufFnJDk159i4eEzkrxBQCPwESdsQ=
Date:   Mon, 03 Oct 2022 14:06:13 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-use-kasan_addr_to_slab-in-print_address_description.patch removed from -mm tree
Message-Id: <20221003210613.A4E53C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: use kasan_addr_to_slab in print_address_description
has been removed from the -mm tree.  Its filename was
     kasan-use-kasan_addr_to_slab-in-print_address_description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: use kasan_addr_to_slab in print_address_description
Date: Mon, 5 Sep 2022 23:05:38 +0200

Use the kasan_addr_to_slab() helper in print_address_description() instead
of separately invoking PageSlab() and page_slab().

Link: https://lkml.kernel.org/r/8b744fbf8c3c7fc5d34329ec70b60ee5c8dba66c.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    7 +++++++
 mm/kasan/report.c |   11 ++---------
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/mm/kasan/common.c~kasan-use-kasan_addr_to_slab-in-print_address_description
+++ a/mm/kasan/common.c
@@ -30,6 +30,13 @@
 #include "kasan.h"
 #include "../slab.h"
 
+struct slab *kasan_addr_to_slab(const void *addr)
+{
+	if (virt_addr_valid(addr))
+		return virt_to_slab(addr);
+	return NULL;
+}
+
 depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc)
 {
 	unsigned long entries[KASAN_STACK_DEPTH];
--- a/mm/kasan/report.c~kasan-use-kasan_addr_to_slab-in-print_address_description
+++ a/mm/kasan/report.c
@@ -213,13 +213,6 @@ struct page *kasan_addr_to_page(const vo
 	return NULL;
 }
 
-struct slab *kasan_addr_to_slab(const void *addr)
-{
-	if (virt_addr_valid(addr))
-		return virt_to_slab(addr);
-	return NULL;
-}
-
 static void describe_object_addr(struct kmem_cache *cache, void *object,
 				const void *addr)
 {
@@ -297,12 +290,12 @@ static inline bool init_task_stack_addr(
 static void print_address_description(void *addr, u8 tag)
 {
 	struct page *page = kasan_addr_to_page(addr);
+	struct slab *slab = kasan_addr_to_slab(addr);
 
 	dump_stack_lvl(KERN_ERR);
 	pr_err("\n");
 
-	if (page && PageSlab(page)) {
-		struct slab *slab = page_slab(page);
+	if (slab) {
 		struct kmem_cache *cache = slab->slab_cache;
 		void *object = nearest_obj(cache, slab,	addr);
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

