Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA22C43467
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2F3822203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633146;
	bh=DDV/xN4wMxUVkbu+J5+fQ+RZjdfuRpBhQgYPuDbvoEE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=AaV+I13k2NatCrpKSEtSqBrovIfhQQb2s0PGYAfwxHLpSXZwy29pXVRt/ODCcZi7B
	 ToAT3GzqDzNigPNxgWaWTzuxeORM211gpePpF4YLHnyYxE24AxkdK4P0vPP3t09H+D
	 8k/9zw+JMst6Ro32Gup1WAuEdH3zCNez+5UuRUHw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgJMXw0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbgJMXva (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F4C2222C;
        Tue, 13 Oct 2020 23:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633089;
        bh=DDV/xN4wMxUVkbu+J5+fQ+RZjdfuRpBhQgYPuDbvoEE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RmFN8WadGS6W8PAR96Niv9bF/1kDbjclJpkQzAYXiBphhcplMO4egwpCWj/y+MwM/
         bIJ550OEohWgRXELcy7Rp5imVG/EgxgYmo1eVUYi20BF1hCEGXbdHuXvdOuexFVcvG
         XCXdA2kUEijkAB3D60b9WmlVe3wQHXESYqPsJyaI=
Date:   Tue, 13 Oct 2020 16:51:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        chris@chris-wilson.co.uk, hannes@cmpxchg.org, hughd@google.com,
        jani.nikula@linux.intel.com, linux-mm@kvack.org,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 057/181] proc: optimise smaps for shmem entries
Message-ID: <20201013235128._17ynTigl%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: optimise smaps for shmem entries

Avoid bumping the refcount on pages when we're only interested in the
swap entries.

Link: https://lkml.kernel.org/r/20200910183318.20139-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/fs/proc/task_mmu.c~proc-optimise-smaps-for-shmem-entries
+++ a/fs/proc/task_mmu.c
@@ -520,16 +520,10 @@ static void smaps_pte_entry(pte_t *pte,
 			page = device_private_entry_to_page(swpent);
 	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
 							&& pte_none(*pte))) {
-		page = find_get_entry(vma->vm_file->f_mapping,
+		page = xa_load(&vma->vm_file->f_mapping->i_pages,
 						linear_page_index(vma, addr));
-		if (!page)
-			return;
-
 		if (xa_is_value(page))
 			mss->swap += PAGE_SIZE;
-		else
-			put_page(page);
-
 		return;
 	}
 
_
