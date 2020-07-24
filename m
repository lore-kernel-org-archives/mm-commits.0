Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657C2C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FBC920792
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595563619;
	bh=UssriG3wF4Q8V7+vMZ+SCEQ/pYPj+o5EDl4JsbhVTqU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WgUbTwv4MPeF9pzfmv9HB+8mWuw/hvymUJRgEgiRwAhKDaXmetdapU8U9aabbbWSl
	 wUx6bmkndx9+V/59aGN5AKoBgt8mlmelBh1YyhEfqlMXgPsFHk6wqYynZQIVRtEDk2
	 qmVKrpr1DOW4GfD+6uBazfZqNw+0ZFVM+kI3AGRc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgGXEG6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgGXEG6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:06:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDAF120709;
        Fri, 24 Jul 2020 04:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595563618;
        bh=UssriG3wF4Q8V7+vMZ+SCEQ/pYPj+o5EDl4JsbhVTqU=;
        h=Date:From:To:Subject:From;
        b=JvkPsyYLoMSMUhcpxzCwRqyeKUivlMNEkXT2ofEjUNCxjz9Ao2VbhvyzDjInygxai
         ikYeYoJ5DNBxnhLsLCWYn6uqgrN2JNoMjurQ6IqPKx4C1z0gRAELxhyHhHQ9BFkQLJ
         H3lZgJVA+aGLJHSmFKfZaRMzqHaonfg4ulYNsSM8=
Date:   Thu, 23 Jul 2020 21:06:57 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, hannes@cmpxchg.org, hdanton@sina.com,
        hughd@google.com, josef@toxicpanda.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        will.deacon@arm.com, willy@infradead.org, xuyu@linux.alibaba.com,
        yang.shi@linux.alibaba.com
Subject:  [folded-merged]
 mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2.patch
 removed from -mm tree
Message-ID: <20200724040657.3IJBV4e1N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2
has been removed from the -mm tree.  Its filename was
     mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2.patch

This patch was dropped because it was folded into mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault.patch

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2

incorporat comment from Will Deacon, update commit log per discussion

Link: http://lkml.kernel.org/r/1594848990-55657-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: 89b15332af7c ("mm: drop mmap_sem before calling balance_dirty_pages() in write fault")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Xu Yu <xuyu@linux.alibaba.com>
Debugged-by: Xu Yu <xuyu@linux.alibaba.com>
Tested-by: Xu Yu <xuyu@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2
+++ a/mm/memory.c
@@ -4243,11 +4243,12 @@ static vm_fault_t handle_pte_fault(struc
 			return do_wp_page(vmf);
 	}
 
-	if ((vmf->flags & FAULT_FLAG_WRITE) && !(vmf->flags & FAULT_FLAG_TRIED))
-		entry = pte_mkdirty(entry);
-	else if (vmf->flags & FAULT_FLAG_TRIED)
+	if (vmf->flags & FAULT_FLAG_TRIED)
 		goto unlock;
 
+	if (vmf->flags & FAULT_FLAG_WRITE)
+		entry = pte_mkdirty(entry);
+
 	entry = pte_mkyoung(entry);
 	if (ptep_set_access_flags(vmf->vma, vmf->address, vmf->pte, entry,
 				vmf->flags & FAULT_FLAG_WRITE)) {
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault.patch
mm-filemap-clear-idle-flag-for-writes.patch
mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page.patch
mm-thp-remove-debug_cow-switch.patch

