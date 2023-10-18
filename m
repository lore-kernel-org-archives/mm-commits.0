Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA057CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbjJRVhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235265AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F90A18C
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A70C4160E;
        Wed, 18 Oct 2023 21:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664926;
        bh=J9hzTlzaolcrT1qrlmwNou8R32UBn3DBc9MfYVWuGDc=;
        h=Date:To:From:Subject:From;
        b=tDRa9qOmC4slreeaL1VTU4bte5rO1IkYh8O6jt5K6jo9vKYsYqT1EBUjYKKcxSShV
         Avi0jenJETXXgcQ5OR7R2LzjcqykVmsRACBswfbeq0460YG/tedZ12owPtsC7WE0Fg
         sbDyc1z5yoziPk1lDOyeIKr1g3cPXlEyTuluadJc=
Date:   Wed, 18 Oct 2023 14:35:26 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-use-unchecked-__memset-internally.patch removed from -mm tree
Message-Id: <20231018213526.B1A70C4160E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: use unchecked __memset internally
has been removed from the -mm tree.  Its filename was
     kasan-use-unchecked-__memset-internally.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: use unchecked __memset internally
Date: Fri, 6 Oct 2023 17:18:44 +0200

KASAN code is supposed to use the unchecked __memset implementation when
accessing its metadata.

Change uses of memset to __memset in mm/kasan/.

Link: https://lkml.kernel.org/r/6f621966c6f52241b5aaa7220c348be90c075371.1696605143.git.andreyknvl@google.com
Fixes: 59e6e098d1c1 ("kasan: introduce kasan_complete_mode_report_info")
Fixes: 3c5c3cfb9ef4 ("kasan: support backing vmalloc space with real shadow memory")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    4 ++--
 mm/kasan/shadow.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kasan/report.c~kasan-use-unchecked-__memset-internally
+++ a/mm/kasan/report.c
@@ -538,7 +538,7 @@ void kasan_report_invalid_free(void *ptr
 
 	start_report(&flags, true);
 
-	memset(&info, 0, sizeof(info));
+	__memset(&info, 0, sizeof(info));
 	info.type = type;
 	info.access_addr = ptr;
 	info.access_size = 0;
@@ -576,7 +576,7 @@ bool kasan_report(const void *addr, size
 
 	start_report(&irq_flags, true);
 
-	memset(&info, 0, sizeof(info));
+	__memset(&info, 0, sizeof(info));
 	info.type = KASAN_REPORT_ACCESS;
 	info.access_addr = addr;
 	info.access_size = size;
--- a/mm/kasan/shadow.c~kasan-use-unchecked-__memset-internally
+++ a/mm/kasan/shadow.c
@@ -324,7 +324,7 @@ static int kasan_populate_vmalloc_pte(pt
 	if (!page)
 		return -ENOMEM;
 
-	memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
+	__memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
 	pte = pfn_pte(PFN_DOWN(__pa(page)), PAGE_KERNEL);
 
 	spin_lock(&init_mm.page_table_lock);
_

Patches currently in -mm which might be from andreyknvl@google.com are


