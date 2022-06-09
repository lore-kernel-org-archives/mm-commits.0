Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEC9C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 18:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344870AbiFISp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 14:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344842AbiFISpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 14:45:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74677228713
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 11:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B8EEB82FB3
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 18:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5B7C34114;
        Thu,  9 Jun 2022 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654800350;
        bh=IZQzol0QJp2ArOc4amYDCySvsBM74onLi8SZG4P/lmY=;
        h=Date:To:From:Subject:From;
        b=Ayvf5UBfinxKoPZ2ui11pCPtWE3JJa7mcYr5KoEYG6dDcvuOr7lrmZ7VctslUjex5
         73VWmy9bpnoMZ6TqA5hWF4Cf/AmkOundHCc5z17BRUvlC0rILMhIBpBdnBL6bPO39U
         ac5+rcnkEGkBCw0iV25js7P4eK6dAdJxz7h8g0HM=
Date:   Thu, 09 Jun 2022 11:45:50 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-clear_highpage_kasan_tagged.patch added to mm-unstable branch
Message-Id: <20220609184550.CB5B7C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce clear_highpage_kasan_tagged
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-clear_highpage_kasan_tagged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-clear_highpage_kasan_tagged.patch

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
@@ -1310,12 +1310,8 @@ static void kernel_init_pages(struct pag
 
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

mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch
mm-introduce-clear_highpage_kasan_tagged.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch

