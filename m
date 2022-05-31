Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7084C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 17:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346683AbiEaRwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 13:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345064AbiEaRwT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 13:52:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6D35BE65
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 10:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FC65B8116B
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 17:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCA7C385A9;
        Tue, 31 May 2022 17:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654019535;
        bh=6tf1ETyLCqiXYq4vlyWl9QnPAp98bO+oqQx17S1h9yw=;
        h=Date:To:From:Subject:From;
        b=BDIGq9MpEKxhvXYVmZs0+T+oK2p/9/m8nt9NhRfMb6yL4YWixA0nglB4+VWSJ/OXo
         CbqWhRTErWuyudLrqy5K2ZZ70Hjb87xQotfLSV43TvW4L2WDnBpcbDbyGm+2wD3Kao
         do0hi/kbEmlR+wuS5UGCZ/g3ilwLTf9RFPf3L9oU=
Date:   Tue, 31 May 2022 10:52:15 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-clear_highpage_tagged-fix.patch added to mm-unstable branch
Message-Id: <20220531175215.BCCA7C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-clear_highpage_tagged-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-clear_highpage_tagged-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-clear_highpage_tagged-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-clear_highpage_tagged-fix
Date: Tue May 31 10:47:50 AM PDT 2022

s/clear_highpage_tagged/clear_highpage_kasan_tagged/

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 mm/page_alloc.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/highmem.h~mm-introduce-clear_highpage_tagged-fix
+++ a/include/linux/highmem.h
@@ -243,7 +243,7 @@ static inline void clear_highpage(struct
 	kunmap_local(kaddr);
 }
 
-static inline void clear_highpage_tagged(struct page *page)
+static inline void clear_highpage_kasan_tagged(struct page *page)
 {
 	u8 tag;
 
--- a/mm/page_alloc.c~mm-introduce-clear_highpage_tagged-fix
+++ a/mm/page_alloc.c
@@ -1311,7 +1311,7 @@ static void kernel_init_pages(struct pag
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
 	for (i = 0; i < numpages; i++)
-		clear_highpage_tagged(page + i);
+		clear_highpage_kasan_tagged(page + i);
 	kasan_enable_current();
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

