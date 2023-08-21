Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6F7EE49B0
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjHUUoR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjHUUn3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD24ECE3
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE20764B15
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBD9C433C7;
        Mon, 21 Aug 2023 20:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650526;
        bh=WgJyoVRtN+KkvWngvyFiwqQr/S+7/HhtMO0wLURfUIs=;
        h=Date:To:From:Subject:From;
        b=ZrfIhnz7uua2OirxhaSEo5UxU1fjAdftSEyNTZPm79iFUFmLvG5FeczGIh0lLkoc7
         ZDWbvQ13RAz7SuTteEhwZcwfy8McNb61ZrmkUT5DaJwZKbJBSQYlQtj9kOu6zs2zwu
         eyZAW2YZ9E6op+hxzyiA+5xUb3wbgJXBvAWooePE=
Date:   Mon, 21 Aug 2023 13:42:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        david@redhat.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-secretmem-use-a-folio-in-secretmem_fault.patch removed from -mm tree
Message-Id: <20230821204206.1DBD9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/secretmem: use a folio in secretmem_fault()
has been removed from the -mm tree.  Its filename was
     mm-secretmem-use-a-folio-in-secretmem_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/secretmem: use a folio in secretmem_fault()
Date: Sat, 12 Aug 2023 14:26:12 +0800

Saves four implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230812062612.3184990-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/secretmem.c~mm-secretmem-use-a-folio-in-secretmem_fault
+++ a/mm/secretmem.c
@@ -55,6 +55,7 @@ static vm_fault_t secretmem_fault(struct
 	gfp_t gfp = vmf->gfp_mask;
 	unsigned long addr;
 	struct page *page;
+	struct folio *folio;
 	vm_fault_t ret;
 	int err;
 
@@ -66,23 +67,24 @@ static vm_fault_t secretmem_fault(struct
 retry:
 	page = find_lock_page(mapping, offset);
 	if (!page) {
-		page = alloc_page(gfp | __GFP_ZERO);
-		if (!page) {
+		folio = folio_alloc(gfp | __GFP_ZERO, 0);
+		if (!folio) {
 			ret = VM_FAULT_OOM;
 			goto out;
 		}
 
+		page = &folio->page;
 		err = set_direct_map_invalid_noflush(page);
 		if (err) {
-			put_page(page);
+			folio_put(folio);
 			ret = vmf_error(err);
 			goto out;
 		}
 
-		__SetPageUptodate(page);
-		err = add_to_page_cache_lru(page, mapping, offset, gfp);
+		__folio_mark_uptodate(folio);
+		err = filemap_add_folio(mapping, folio, offset, gfp);
 		if (unlikely(err)) {
-			put_page(page);
+			folio_put(folio);
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


