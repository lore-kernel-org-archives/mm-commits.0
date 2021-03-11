Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FADC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2C9364F86
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 21:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhCKV2g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 16:28:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhCKV2E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 16:28:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD40164F9F;
        Thu, 11 Mar 2021 21:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615498084;
        bh=np/xVaML3/Aie3Hu0WPd7l+keMdnBN1dWi06YsuxogI=;
        h=Date:From:To:Subject:From;
        b=lojCg3ZcSaVrZCbC78jaWCWJXIy3Ap41xNgvGwcJuS6fIJEFadGXWYFjGwxYbknNK
         Lz18TeATrB0PFG0ZQLswlYpjMLLumg+TtZiyynrZbSfav9mVP/ESfQmUJkJoMPOL7v
         QO3dnWTMXtyqVAAWCEtf+SDmoPaNQefhBmTRAp9U=
Date:   Thu, 11 Mar 2021 13:28:03 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        songqiang@uniontech.com
Subject:  + mm-highmemc-fix-coding-style-issue.patch added to -mm
 tree
Message-ID: <20210311212803.zmu_PoDUE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem.c: fix coding style issue
has been added to the -mm tree.  Its filename is
     mm-highmemc-fix-coding-style-issue.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmemc-fix-coding-style-issue.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmemc-fix-coding-style-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: songqiang <songqiang@uniontech.com>
Subject: mm/highmem.c: fix coding style issue

Delete/add some blank lines and some blank spaces

Link: https://lkml.kernel.org/r/20210311095015.14277-1-songqiang@uniontech.com
Signed-off-by: songqiang <songqiang@uniontech.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/highmem.c~mm-highmemc-fix-coding-style-issue
+++ a/mm/highmem.c
@@ -104,7 +104,7 @@ static inline wait_queue_head_t *get_pkm
 atomic_long_t _totalhigh_pages __read_mostly;
 EXPORT_SYMBOL(_totalhigh_pages);
 
-unsigned int __nr_free_highpages (void)
+unsigned int __nr_free_highpages(void)
 {
 	struct zone *zone;
 	unsigned int pages = 0;
@@ -120,7 +120,7 @@ unsigned int __nr_free_highpages (void)
 static int pkmap_count[LAST_PKMAP];
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
 
-pte_t * pkmap_page_table;
+pte_t *pkmap_page_table;
 
 /*
  * Most architectures have no use for kmap_high_get(), so let's abstract
@@ -147,6 +147,7 @@ struct page *__kmap_to_page(void *vaddr)
 
 	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
 		int i = PKMAP_NR(addr);
+
 		return pte_page(pkmap_page_table[i]);
 	}
 
@@ -278,9 +279,8 @@ void *kmap_high(struct page *page)
 	pkmap_count[PKMAP_NR(vaddr)]++;
 	BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 2);
 	unlock_kmap();
-	return (void*) vaddr;
+	return (void *) vaddr;
 }
-
 EXPORT_SYMBOL(kmap_high);
 
 #ifdef ARCH_NEEDS_KMAP_HIGH_GET
@@ -305,7 +305,7 @@ void *kmap_high_get(struct page *page)
 		pkmap_count[PKMAP_NR(vaddr)]++;
 	}
 	unlock_kmap_any(flags);
-	return (void*) vaddr;
+	return (void *) vaddr;
 }
 #endif
 
@@ -737,7 +737,6 @@ done:
 	spin_unlock_irqrestore(&pas->lock, flags);
 	return ret;
 }
-
 EXPORT_SYMBOL(page_address);
 
 /**
_

Patches currently in -mm which might be from songqiang@uniontech.com are

mm-highmemc-fix-coding-style-issue.patch

