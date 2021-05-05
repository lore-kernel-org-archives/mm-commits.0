Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F6FC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57498611AB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhEEBlH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232220AbhEEBlG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545806142C;
        Wed,  5 May 2021 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178810;
        bh=Jdt7yGIN6EUq6gGE3JlziyBfeh5NGp/i7QEbRZohDb4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VrBkpFU0Nqjd4Ec6VrKAEfGEtzB+jEPwnT2Ir5ynQuQyuBfx4HdfGRZPlLyJWrbQ8
         gYJ6YMpfEpf7/Xtbw4hKN99SHcugg0qQvP9ZzLyWw9FAKCjpYCBH7OlhXYvL+CH1Vf
         0wMb6topFFbLkWxvh4vOlQOjlAFUSYqVQUbs+auc=
Date:   Tue, 04 May 2021 18:40:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, songqiang@uniontech.com,
        torvalds@linux-foundation.org
Subject:  [patch 137/143] mm/highmem.c: fix coding style issue
Message-ID: <20210505014009.fJJf39FCQ%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
