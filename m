Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4501EC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJCVJy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJCVIP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC184F1A2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C945CB8160E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E18C433D6;
        Mon,  3 Oct 2022 21:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831178;
        bh=dKQe7VbDOkNAk9UBxKUCkcgyb16mSCt6Dh6/WtG2jfg=;
        h=Date:To:From:Subject:From;
        b=0QppOsGFOtk71nqzfJtT2ews/cjkXGXu+IXiThUMCrjNFe/SDn1Q4uhIB+IE2EO8F
         FDnhNR5+NBmceqoZyEh4PzsSYpS+CKpQNPfixIXLGpF6kwG/RZq6ngYGYmBshvvINe
         3igEpaLr3GnXmnXuUfXbh2wgf10pqpaX8y6zCfBQ=
Date:   Mon, 03 Oct 2022 14:06:17 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-fill-in-cache-and-object-in-complete_report_info.patch removed from -mm tree
Message-Id: <20221003210618.63E18C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: fill in cache and object in complete_report_info
has been removed from the -mm tree.  Its filename was
     kasan-fill-in-cache-and-object-in-complete_report_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fill in cache and object in complete_report_info
Date: Mon, 5 Sep 2022 23:05:42 +0200

Add cache and object fields to kasan_report_info and fill them in in
complete_report_info() instead of fetching them in the middle of the
report printing code.

This allows the reporting code to get access to the object information
before starting printing the report.  One of the following patches uses
this information to determine the bug type with the tag-based modes.

Link: https://lkml.kernel.org/r/23264572cb2cbb8f0efbb51509b6757eb3cc1fc9.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h  |    2 ++
 mm/kasan/report.c |   21 +++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/mm/kasan/kasan.h~kasan-fill-in-cache-and-object-in-complete_report_info
+++ a/mm/kasan/kasan.h
@@ -162,6 +162,8 @@ struct kasan_report_info {
 
 	/* Filled in by the common reporting code. */
 	void *first_bad_addr;
+	struct kmem_cache *cache;
+	void *object;
 };
 
 /* Do not change the struct layout: compiler ABI. */
--- a/mm/kasan/report.c~kasan-fill-in-cache-and-object-in-complete_report_info
+++ a/mm/kasan/report.c
@@ -287,19 +287,16 @@ static inline bool init_task_stack_addr(
 			sizeof(init_thread_union.stack));
 }
 
-static void print_address_description(void *addr, u8 tag)
+static void print_address_description(void *addr, u8 tag,
+				      struct kasan_report_info *info)
 {
 	struct page *page = addr_to_page(addr);
-	struct slab *slab = kasan_addr_to_slab(addr);
 
 	dump_stack_lvl(KERN_ERR);
 	pr_err("\n");
 
-	if (slab) {
-		struct kmem_cache *cache = slab->slab_cache;
-		void *object = nearest_obj(cache, slab,	addr);
-
-		describe_object(cache, object, addr, tag);
+	if (info->cache && info->object) {
+		describe_object(info->cache, info->object, addr, tag);
 		pr_err("\n");
 	}
 
@@ -406,7 +403,7 @@ static void print_report(struct kasan_re
 	pr_err("\n");
 
 	if (addr_has_metadata(addr)) {
-		print_address_description(addr, tag);
+		print_address_description(addr, tag, info);
 		print_memory_metadata(info->first_bad_addr);
 	} else {
 		dump_stack_lvl(KERN_ERR);
@@ -416,12 +413,20 @@ static void print_report(struct kasan_re
 static void complete_report_info(struct kasan_report_info *info)
 {
 	void *addr = kasan_reset_tag(info->access_addr);
+	struct slab *slab;
 
 	if (info->type == KASAN_REPORT_ACCESS)
 		info->first_bad_addr = kasan_find_first_bad_addr(
 					info->access_addr, info->access_size);
 	else
 		info->first_bad_addr = addr;
+
+	slab = kasan_addr_to_slab(addr);
+	if (slab) {
+		info->cache = slab->slab_cache;
+		info->object = nearest_obj(info->cache, slab, addr);
+	} else
+		info->cache = info->object = NULL;
 }
 
 void kasan_report_invalid_free(void *ptr, unsigned long ip, enum kasan_report_type type)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

