Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28025C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E34AA22D04
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgLPEsI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:48:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgLPEsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:48:08 -0500
Date:   Tue, 15 Dec 2020 20:47:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094047;
        bh=mCFpj21BL/AT2FstOTTskh81yYuCJyg6Wetm6J5hHHI=;
        h=From:To:Subject:In-Reply-To:From;
        b=xlFZiXlSyWQNFpC8qz5iRTLJv+ctn/y9gkgtO0L4Ul7qWWomMZShd1fBdeNDErdKL
         58pc4sfuVniVTuXJDWd9MUyPNu2uxnJpKgfDT1N8qhDNn59U0FOX+LpY0wHDP4PhnA
         jXfcTAJ4IEj3deyE6FV5BILTcxl+hI4caDRrDud8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jrdr.linux@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        shihaitao1@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 93/95] mm: fix some spelling mistakes in comments
Message-ID: <20201216044726.Q6qwN7xUB%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Haitao Shi <shihaitao1@huawei.com>
Subject: mm: fix some spelling mistakes in comments

Fix some spelling mistakes in comments:
	udpate ==> update
	succesful ==> successful
	exmaple ==> example
	unneccessary ==> unnecessary
	stoping ==> stopping
	uknown ==> unknown

Link: https://lkml.kernel.org/r/20201127011747.86005-1-shihaitao1@huawei.com
Signed-off-by: Haitao Shi <shihaitao1@huawei.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c     |    2 +-
 mm/huge_memory.c |    2 +-
 mm/khugepaged.c  |    2 +-
 mm/memblock.c    |    2 +-
 mm/migrate.c     |    2 +-
 mm/page_ext.c    |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/filemap.c
@@ -1359,7 +1359,7 @@ static int __wait_on_page_locked_async(s
 	else
 		ret = PageLocked(page);
 	/*
-	 * If we were succesful now, we know we're still on the
+	 * If we were successful now, we know we're still on the
 	 * waitqueue as we're still under the lock. This means it's
 	 * safe to remove and return success, we know the callback
 	 * isn't going to trigger.
--- a/mm/huge_memory.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/huge_memory.c
@@ -2391,7 +2391,7 @@ static void __split_huge_page_tail(struc
 	 * Clone page flags before unfreezing refcount.
 	 *
 	 * After successful get_page_unless_zero() might follow flags change,
-	 * for exmaple lock_page() which set PG_waiters.
+	 * for example lock_page() which set PG_waiters.
 	 */
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
--- a/mm/khugepaged.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/khugepaged.c
@@ -1275,7 +1275,7 @@ static int khugepaged_scan_pmd(struct mm
 			 * PTEs are armed with uffd write protection.
 			 * Here we can also mark the new huge pmd as
 			 * write protected if any of the small ones is
-			 * marked but that could bring uknown
+			 * marked but that could bring unknown
 			 * userfault messages that falls outside of
 			 * the registered range.  So, just be simple.
 			 */
--- a/mm/memblock.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/memblock.c
@@ -871,7 +871,7 @@ int __init_memblock memblock_physmem_add
  * @base: base address of the region
  * @size: size of the region
  * @set: set or clear the flag
- * @flag: the flag to udpate
+ * @flag: the flag to update
  *
  * This function isolates region [@base, @base + @size), and sets/clears flag
  *
--- a/mm/migrate.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/migrate.c
@@ -2594,7 +2594,7 @@ static bool migrate_vma_check_page(struc
 		 * will bump the page reference count. Sadly there is no way to
 		 * differentiate a regular pin from migration wait. Hence to
 		 * avoid 2 racing thread trying to migrate back to CPU to enter
-		 * infinite loop (one stoping migration because the other is
+		 * infinite loop (one stopping migration because the other is
 		 * waiting on pte migration entry). We always return true here.
 		 *
 		 * FIXME proper solution is to rework migration_entry_wait() so
--- a/mm/page_ext.c~mm-fix-some-spelling-mistakes-in-comments
+++ a/mm/page_ext.c
@@ -34,7 +34,7 @@
  *
  * The need callback is used to decide whether extended memory allocation is
  * needed or not. Sometimes users want to deactivate some features in this
- * boot and extra memory would be unneccessary. In this case, to avoid
+ * boot and extra memory would be unnecessary. In this case, to avoid
  * allocating huge chunk of memory, each clients represent their need of
  * extra memory through the need callback. If one of the need callbacks
  * returns true, it means that someone needs extra memory so that
_
