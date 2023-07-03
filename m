Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E4C5C001B3
	for <mm-commits@archiver.kernel.org>; Mon,  3 Jul 2023 17:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjGCRcy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjGCRcy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jul 2023 13:32:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82106E5E
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 10:32:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2062A60FF1
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 17:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7529BC433C8;
        Mon,  3 Jul 2023 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688405572;
        bh=pIhT7wmPwWnPxOlWW6inkafgmdo6NpxLwNTHFYAg6C0=;
        h=Date:To:From:Subject:From;
        b=d/1U2yNUGK3oZuQI1DpGmBqoOjB/9yzOG78MgoJYMx8VOYqu+pfcLv6v4W7zsuufH
         sE4nac4oRVBudr2wv5nY32MivhoxIUkBQGx+OzOO/VWWGtcHI089NfEs7pt8ADJrhP
         j9n9EBshHeHzOXyGEZAkvJRw8KsYRzG3LL4tZRng=
Date:   Mon, 03 Jul 2023 10:32:51 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-convert-wp_page_shared-to-use-folios.patch added to mm-unstable branch
Message-Id: <20230703173252.7529BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory: convert wp_page_shared() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-convert-wp_page_shared-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-convert-wp_page_shared-to-use-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory: convert wp_page_shared() to use folios
Date: Sun, 2 Jul 2023 22:58:48 -0700

Saves five implicit calls to compound_head().

Link: https://lkml.kernel.org/r/20230703055850.227169-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-memory-convert-wp_page_shared-to-use-folios
+++ a/mm/memory.c
@@ -3287,8 +3287,9 @@ static vm_fault_t wp_page_shared(struct
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
+	struct folio *folio = page_folio(vmf->page);
 
-	get_page(vmf->page);
+	folio_get(folio);
 
 	if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 		vm_fault_t tmp;
@@ -3297,21 +3298,21 @@ static vm_fault_t wp_page_shared(struct
 		tmp = do_page_mkwrite(vmf);
 		if (unlikely(!tmp || (tmp &
 				      (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
-			put_page(vmf->page);
+			folio_put(folio);
 			return tmp;
 		}
 		tmp = finish_mkwrite_fault(vmf);
 		if (unlikely(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
-			unlock_page(vmf->page);
-			put_page(vmf->page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return tmp;
 		}
 	} else {
 		wp_page_reuse(vmf);
-		lock_page(vmf->page);
+		folio_lock(folio);
 	}
 	ret |= fault_dirty_shared_page(vmf);
-	put_page(vmf->page);
+	folio_put(folio);
 
 	return ret;
 }
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-increase-usage-of-folio_next_index-helper.patch
mm-memory-convert-do_page_mkwrite-to-use-folios.patch
mm-memory-convert-wp_page_shared-to-use-folios.patch
mm-memory-convert-do_shared_fault-to-folios.patch
mm-memory-convert-do_read_fault-to-use-folios.patch

