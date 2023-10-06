Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA70CE94107
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbjJFTSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjJFTSC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:18:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389F195
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:17:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D300C433CA;
        Fri,  6 Oct 2023 19:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619876;
        bh=vcOlzmbSAmT3JiVULiR0SsV+RZiXRXdUIFl4snJ9ms4=;
        h=Date:To:From:Subject:From;
        b=EtBJpFq1sqbjUsMu3ujIY6HKVKZV7BRSgyMWfZDzt93Jl+OvnBIGlcSRVd9ySUTVM
         e00xZs3wiQUyf1+NKEOwQOnGnMByvPmW+irpYZx9OPKK8af9yh8okNtAe2OqtzsUZS
         bdN/3XLbnQ5OUtIc+l3CaUM//kahan4zu5mE0Nhk=
Date:   Fri, 06 Oct 2023 12:17:54 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-use-unchecked-__memset-internally.patch added to mm-unstable branch
Message-Id: <20231006191756.5D300C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use unchecked __memset internally
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-use-unchecked-__memset-internally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-use-unchecked-__memset-internally.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: use unchecked __memset internally
Date: Fri, 6 Oct 2023 17:18:44 +0200

KASAN code is supposed to use the unchecked __memset implementation when
accessing its metadata.

Change uses of memset to __memset in mm/kasan/.

Link: https://lkml.kernel.org/r/6f621966c6f52241b5aaa7220c348be90c075371.1696605143.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Marco Elver <elver@google.com>
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

arm64-kasan-update-comment-in-kasan_init.patch
kasan-unify-printk-prefixes.patch
kasan-use-unchecked-__memset-internally.patch
kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch
documentation-san-drop-the-from-article-titles.patch

