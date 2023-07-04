Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE466EB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 05:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjGDFjP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 01:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGDFjO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 01:39:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DF6BE
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 22:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E841260B23
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 05:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9DBC433C8;
        Tue,  4 Jul 2023 05:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688449152;
        bh=KliI4lsUxffivlJGyhmJ9qNYn4FhrO58czLCIYzEaas=;
        h=Date:To:From:Subject:From;
        b=YmM5UD+ab4dYxf7osS2LK46cvRN2AgNxtxgwnwPoonx8PNUxBA/+9MPREbB2QJGpk
         g7bduwUa9q03C+8Lz7Vu93YdSblNLAFWHlb/rCOWVVKbUyqU+mkknJrJxTSi1wSEJR
         3+3cTO0WGax8ObP44FI5HU3hpnBBxU+lFCcHtPzI=
Date:   Mon, 03 Jul 2023 22:39:11 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-convert-do_page_mkwrite-to-use-folios.patch removed from -mm tree
Message-Id: <20230704053912.4B9DBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: convert do_page_mkwrite() to use folios
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-do_page_mkwrite-to-use-folios.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: convert do_page_mkwrite() to use folios
Date: Sun, 2 Jul 2023 22:58:47 -0700

Saves one implicit call to compound_head();

Link: https://lkml.kernel.org/r/20230703055850.227169-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-memory-convert-do_page_mkwrite-to-use-folios
+++ a/mm/memory.c
@@ -2933,7 +2933,7 @@ static gfp_t __get_fault_gfp_mask(struct
 static vm_fault_t do_page_mkwrite(struct vm_fault *vmf)
 {
 	vm_fault_t ret;
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	unsigned int old_flags = vmf->flags;
 
 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
@@ -2948,14 +2948,14 @@ static vm_fault_t do_page_mkwrite(struct
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
 	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
-		lock_page(page);
-		if (!page->mapping) {
-			unlock_page(page);
+		folio_lock(folio);
+		if (!folio_mapping(folio)) {
+			folio_unlock(folio);
 			return 0; /* retry */
 		}
 		ret |= VM_FAULT_LOCKED;
 	} else
-		VM_BUG_ON_PAGE(!PageLocked(page), page);
+		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	return ret;
 }
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-increase-usage-of-folio_next_index-helper.patch
mm-memory-convert-wp_page_shared-to-use-folios.patch
mm-memory-convert-do_shared_fault-to-folios.patch
mm-memory-convert-do_read_fault-to-use-folios.patch

