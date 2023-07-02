Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9609C04FE1
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 17:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjGBRnS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 13:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjGBRnE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 13:43:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02E7E6D
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 10:43:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 431E960C5A
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E9FC116AD;
        Sun,  2 Jul 2023 17:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688319781;
        bh=G1V5wKdVJnDLkcP2SeGfo20+0nCpIpgeIbB7dSqMUkQ=;
        h=Date:To:From:Subject:From;
        b=cqCuwU0WjYyDvyP3tc9JbM4a7ZXjb4XIM5Gz0vUUWla/s0veCWeUmMR4ieVrJyfF9
         VMZuo3OEnciPDlEj8negDYPTL67W2V/FXCIQQTKEdan3YQG3vXqPB174BF4aXrI6ao
         xAc90gQsA5LgHkM/Lo6MnP3aYaYJxBDErIqD+OQw=
Date:   Sun, 02 Jul 2023 10:42:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-a-folio-in-fault_dirty_shared_page.patch added to mm-unstable branch
Message-Id: <20230702174301.02E9FC116AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use a folio in fault_dirty_shared_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-a-folio-in-fault_dirty_shared_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-a-folio-in-fault_dirty_shared_page.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: use a folio in fault_dirty_shared_page()
Date: Sat, 1 Jul 2023 11:28:52 +0800

We can replace four implicit calls to compound_head() with one by using
folio.

Link: https://lkml.kernel.org/r/20230701032853.258697-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-use-a-folio-in-fault_dirty_shared_page
+++ a/mm/memory.c
@@ -2968,20 +2968,20 @@ static vm_fault_t fault_dirty_shared_pag
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping;
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	bool dirtied;
 	bool page_mkwrite = vma->vm_ops && vma->vm_ops->page_mkwrite;
 
-	dirtied = set_page_dirty(page);
-	VM_BUG_ON_PAGE(PageAnon(page), page);
+	dirtied = folio_mark_dirty(folio);
+	VM_BUG_ON_FOLIO(folio_test_anon(folio), folio);
 	/*
-	 * Take a local copy of the address_space - page.mapping may be zeroed
-	 * by truncate after unlock_page().   The address_space itself remains
-	 * pinned by vma->vm_file's reference.  We rely on unlock_page()'s
+	 * Take a local copy of the address_space - folio.mapping may be zeroed
+	 * by truncate after folio_unlock().   The address_space itself remains
+	 * pinned by vma->vm_file's reference.  We rely on folio_unlock()'s
 	 * release semantics to prevent the compiler from undoing this copying.
 	 */
-	mapping = page_rmapping(page);
-	unlock_page(page);
+	mapping = folio_raw_mapping(folio);
+	folio_unlock(folio);
 
 	if (!page_mkwrite)
 		file_update_time(vma->vm_file);
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch

