Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95402C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 17:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243208AbiEaRwR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 13:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345064AbiEaRwQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 13:52:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFDA5A09C
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 10:52:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 528DE610A5
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 17:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07CBC385A9;
        Tue, 31 May 2022 17:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654019533;
        bh=HShJTrLeaQlUD2HA0zhCQS9k5gFI/aU6q6swVTmoRc4=;
        h=Date:To:From:Subject:From;
        b=k6ag41JOznElhhuV2+uwG03P7WX2tU2N3J7arusJOaAfknfGv/a+uYT806vdS+uib
         XSgxu/ah4SSPAHpkge8FMBaaLHOCa0lnHXaoQiK/d7wudWqy0Da9DQTrbotJh/MjHm
         +bo79Yl0Y+sSV8oYXqAYV0cy5WYiZ05R8r6iC7b8=
Date:   Tue, 31 May 2022 10:52:13 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-clear_highpage_tagged.patch added to mm-unstable branch
Message-Id: <20220531175213.A07CBC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce clear_highpage_kasan_tagged
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-clear_highpage_tagged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-clear_highpage_tagged.patch

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
Date: Tue, 31 May 2022 17:43:49 +0200

Add a clear_highpage_kasan_tagged() helper that does clear_highpage() on a page
potentially tagged by KASAN.

This helper is used by the following patch.

Link: https://lkml.kernel.org/r/d6ba060f18999a00052180c2c10536226b50438a.1654011120.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   11 +++++++++++
 mm/page_alloc.c         |    8 ++------
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/include/linux/highmem.h~mm-introduce-clear_highpage_tagged
+++ a/include/linux/highmem.h
@@ -243,6 +243,17 @@ static inline void clear_highpage(struct
 	kunmap_local(kaddr);
 }
 
+static inline void clear_highpage_tagged(struct page *page)
+{
+	u8 tag;
+
+	tag = page_kasan_tag(page);
+	page_kasan_tag_reset(page);
+	clear_highpage(page);
+	page_kasan_tag_set(page, tag);
+
+}
+
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
 
 static inline void tag_clear_highpage(struct page *page)
--- a/mm/page_alloc.c~mm-introduce-clear_highpage_tagged
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
+		clear_highpage_tagged(page + i);
 	kasan_enable_current();
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

mm-rename-kernel_init_free_pages-to-kernel_init_pages.patch
mm-introduce-clear_highpage_tagged.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags.patch

