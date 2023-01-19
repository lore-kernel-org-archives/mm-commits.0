Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CB3C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjASBUN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjASBS2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FEE6C557
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93C34B81FBC
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F22C433D2;
        Thu, 19 Jan 2023 01:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090952;
        bh=M03FEgw3OYFV70bfSeldTgNGWfWJkBcCy2E5DoswhaQ=;
        h=Date:To:From:Subject:From;
        b=0NF9KZvFJ8e0zurlofDCzH/7wjweqstkouY6mhW0QpMP6SAOv55I/G+YEeSfPFXC6
         tHObmJumm/7Vg0JzJCOkr//0QoG39kgptgupjjyQXn9MbivxCDGNhP5F7y4XEQ5U0I
         yuEtn8P0WrOcXvOauabPgfaTP2xTwXBKVfdnmMCc=
Date:   Wed, 18 Jan 2023 17:15:51 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_idle-convert-page-idle-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230119011552.37F22C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_idle: convert page idle to use a folio
has been removed from the -mm tree.  Its filename was
     mm-page_idle-convert-page-idle-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_idle: convert page idle to use a folio
Date: Fri, 30 Dec 2022 15:08:43 +0800

Firstly, make page_idle_get_page() return a folio, also rename it to
page_idle_get_folio(), then, use it to convert page_idle_bitmap_read() and
page_idle_bitmap_write() functions.

Link: https://lkml.kernel.org/r/20221230070849.63358-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- a/mm/page_idle.c~mm-page_idle-convert-page-idle-to-use-a-folio
+++ a/mm/page_idle.c
@@ -31,19 +31,22 @@
  *
  * This function tries to get a user memory page by pfn as described above.
  */
-static struct page *page_idle_get_page(unsigned long pfn)
+static struct folio *page_idle_get_folio(unsigned long pfn)
 {
 	struct page *page = pfn_to_online_page(pfn);
+	struct folio *folio;
 
-	if (!page || !PageLRU(page) ||
-	    !get_page_unless_zero(page))
+	if (!page || PageTail(page))
 		return NULL;
 
-	if (unlikely(!PageLRU(page))) {
-		put_page(page);
-		page = NULL;
+	folio = page_folio(page);
+	if (!folio_test_lru(folio) || !folio_try_get(folio))
+		return NULL;
+	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
+		folio_put(folio);
+		folio = NULL;
 	}
-	return page;
+	return folio;
 }
 
 static bool page_idle_clear_pte_refs_one(struct folio *folio,
@@ -83,10 +86,8 @@ static bool page_idle_clear_pte_refs_one
 	return true;
 }
 
-static void page_idle_clear_pte_refs(struct page *page)
+static void page_idle_clear_pte_refs(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
-
 	/*
 	 * Since rwc.try_lock is unused, rwc is effectively immutable, so we
 	 * can make it static to save some cycles and stack.
@@ -115,7 +116,7 @@ static ssize_t page_idle_bitmap_read(str
 				     loff_t pos, size_t count)
 {
 	u64 *out = (u64 *)buf;
-	struct page *page;
+	struct folio *folio;
 	unsigned long pfn, end_pfn;
 	int bit;
 
@@ -134,19 +135,19 @@ static ssize_t page_idle_bitmap_read(str
 		bit = pfn % BITMAP_CHUNK_BITS;
 		if (!bit)
 			*out = 0ULL;
-		page = page_idle_get_page(pfn);
-		if (page) {
-			if (page_is_idle(page)) {
+		folio = page_idle_get_folio(pfn);
+		if (folio) {
+			if (folio_test_idle(folio)) {
 				/*
 				 * The page might have been referenced via a
 				 * pte, in which case it is not idle. Clear
 				 * refs and recheck.
 				 */
-				page_idle_clear_pte_refs(page);
-				if (page_is_idle(page))
+				page_idle_clear_pte_refs(folio);
+				if (folio_test_idle(folio))
 					*out |= 1ULL << bit;
 			}
-			put_page(page);
+			folio_put(folio);
 		}
 		if (bit == BITMAP_CHUNK_BITS - 1)
 			out++;
@@ -160,7 +161,7 @@ static ssize_t page_idle_bitmap_write(st
 				      loff_t pos, size_t count)
 {
 	const u64 *in = (u64 *)buf;
-	struct page *page;
+	struct folio *folio;
 	unsigned long pfn, end_pfn;
 	int bit;
 
@@ -178,11 +179,11 @@ static ssize_t page_idle_bitmap_write(st
 	for (; pfn < end_pfn; pfn++) {
 		bit = pfn % BITMAP_CHUNK_BITS;
 		if ((*in >> bit) & 1) {
-			page = page_idle_get_page(pfn);
-			if (page) {
-				page_idle_clear_pte_refs(page);
-				set_page_idle(page);
-				put_page(page);
+			folio = page_idle_get_folio(pfn);
+			if (folio) {
+				page_idle_clear_pte_refs(folio);
+				folio_set_idle(folio);
+				folio_put(folio);
 			}
 		}
 		if (bit == BITMAP_CHUNK_BITS - 1)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

