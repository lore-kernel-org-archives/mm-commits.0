Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A800AC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbjHKXAv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbjHKW7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1BE2694
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEFCA65772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B08C433C7;
        Fri, 11 Aug 2023 22:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794781;
        bh=cx9bndWfkD8OaHDTMjabdVU7pnHznj3zVL13+dI7Oqo=;
        h=Date:To:From:Subject:From;
        b=lCktOu/GjXIWheTU9rb5fkNQl1DLR4WNH7J/jA404eyBRrK+X9oYgHDutUVS/9j0o
         rRqZB8q9tKOYqj3zoFnPLk3NgXT6QsPgFRYTzbZ5gzDfQ7ablNe+ly5PYqQB255GSJ
         33Nx1ghUW/F9gtSzF/MstWSg0a7iAmj4k6lDZMsg=
Date:   Fri, 11 Aug 2023 15:59:40 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-convert-do_page_mkwrite-to-use-folios.patch removed from -mm tree
Message-Id: <20230811225941.35B08C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory: convert do_page_mkwrite() to use folios
has been removed from the -mm tree.  Its filename was
     mm-memory-convert-do_page_mkwrite-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: convert do_page_mkwrite() to use folios
Date: Thu, 6 Jul 2023 09:38:44 -0700

Saves one implicit call to compound_head().

Link: https://lkml.kernel.org/r/20230706163847.403202-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: ZhangPeng <zhangpeng362@huawei.com>
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
+		if (!folio->mapping) {
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


