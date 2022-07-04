Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFFACCA481
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiGDBJo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiGDBJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F1562E7
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E660FB80CEE
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9346DC341CB;
        Mon,  4 Jul 2022 01:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896976;
        bh=vy1c6xB55Yiaapo3iVevrJEPt7YBcVNkwsh0qLBEUaU=;
        h=Date:To:From:Subject:From;
        b=Z7L3nVeHDqjmbDiluYKZ8V14wLwYkkoQtCa+eEG9QpQWC9ggEPrL1viNJHyoHU6uN
         6bDiSTnC9n5VvUV2oPFnrwOYlo1qqnR0GWAzoaV29G62NXhaMcCwU9hOPUNrylkOuT
         dgpsYQPPeikKtIHG42lJrtUReAlb9MejJRmeVKu4=
Date:   Sun, 03 Jul 2022 18:09:36 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-clear_highpage_kasan_tagged.patch removed from -mm tree
Message-Id: <20220704010936.9346DC341CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: introduce clear_highpage_kasan_tagged
has been removed from the -mm tree.  Its filename was
     mm-introduce-clear_highpage_kasan_tagged.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: mm: introduce clear_highpage_kasan_tagged
Date: Thu, 9 Jun 2022 20:18:46 +0200

Add a clear_highpage_kasan_tagged() helper that does clear_highpage() on a
page potentially tagged by KASAN.

This helper is used by the following patch.

Link: https://lkml.kernel.org/r/4471979b46b2c487787ddcd08b9dc5fedd1b6ffd.1654798516.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   10 ++++++++++
 mm/page_alloc.c         |    8 ++------
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/include/linux/highmem.h~mm-introduce-clear_highpage_kasan_tagged
+++ a/include/linux/highmem.h
@@ -243,6 +243,16 @@ static inline void clear_highpage(struct
 	kunmap_local(kaddr);
 }
 
+static inline void clear_highpage_kasan_tagged(struct page *page)
+{
+	u8 tag;
+
+	tag = page_kasan_tag(page);
+	page_kasan_tag_reset(page);
+	clear_highpage(page);
+	page_kasan_tag_set(page, tag);
+}
+
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
 
 static inline void tag_clear_highpage(struct page *page)
--- a/mm/page_alloc.c~mm-introduce-clear_highpage_kasan_tagged
+++ a/mm/page_alloc.c
@@ -1302,12 +1302,8 @@ static void kernel_init_pages(struct pag
 
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
-	for (i = 0; i < numpages; i++) {
-		u8 tag = page_kasan_tag(page + i);
-		page_kasan_tag_reset(page + i);
-		clear_highpage(page + i);
-		page_kasan_tag_set(page + i, tag);
-	}
+	for (i = 0; i < numpages; i++)
+		clear_highpage_kasan_tagged(page + i);
 	kasan_enable_current();
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch

