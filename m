Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89244C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiCVVrI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbiCVVrB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF545FF1E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47C34B81DAF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC679C340EC;
        Tue, 22 Mar 2022 21:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985530;
        bh=4St+tgtH1Jiny/9gcE5NZiAuSuxhgUqN6h/sMNCrcOo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=S1uAoqi///NFwCX24MtkGNPepHOZfwW155zP4chrh2hVdkY79uJtB1qbqmlgPDDe/
         d0Rx+TLhOzr/fyOYkooGv0iUnvRciVPcpK2PWshewPCpaciNPI3ZRJ6eXIEQdi1+00
         Dpa0wpWzmZjRNqAoSery7cvJ8qtZtXdlvyi4mbag=
Date:   Tue, 22 Mar 2022 14:45:29 -0700
To:     anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 137/227] mm: remove unneeded local variable follflags
Message-Id: <20220322214529.DC679C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove unneeded local variable follflags

We can pass FOLL_GET | FOLL_DUMP to follow_page directly to simplify the
code a bit in add_page_for_migration and split_huge_pages_pid.

Link: https://lkml.kernel.org/r/20220311072002.35575-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +---
 mm/migrate.c     |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-remove-unneeded-local-variable-follflags-v2
+++ a/mm/huge_memory.c
@@ -2953,7 +2953,6 @@ static int split_huge_pages_pid(int pid,
 	 */
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = find_vma(mm, addr);
-		unsigned int follflags;
 		struct page *page;
 
 		if (!vma || addr < vma->vm_start)
@@ -2966,8 +2965,7 @@ static int split_huge_pages_pid(int pid,
 		}
 
 		/* FOLL_DUMP to ignore special (like zero) pages */
-		follflags = FOLL_GET | FOLL_DUMP;
-		page = follow_page(vma, addr, follflags);
+		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 
 		if (IS_ERR(page))
 			continue;
--- a/mm/migrate.c~mm-remove-unneeded-local-variable-follflags-v2
+++ a/mm/migrate.c
@@ -1611,7 +1611,6 @@ static int add_page_for_migration(struct
 {
 	struct vm_area_struct *vma;
 	struct page *page;
-	unsigned int follflags;
 	int err;
 
 	mmap_read_lock(mm);
@@ -1621,8 +1620,7 @@ static int add_page_for_migration(struct
 		goto out;
 
 	/* FOLL_DUMP to ignore special (like zero) pages */
-	follflags = FOLL_GET | FOLL_DUMP;
-	page = follow_page(vma, addr, follflags);
+	page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
 
 	err = PTR_ERR(page);
 	if (IS_ERR(page))
_
