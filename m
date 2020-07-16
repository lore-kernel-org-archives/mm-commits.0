Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91763C433E3
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 00:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EBD32072E
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 00:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594860067;
	bh=A3gwm6BK9JnUR/bUBB4CY297uauJWlm1IYABhVsyw+k=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bZbUtCumbNBwrNGvUwOH1ZRf3FxXYsBl+DFSLay/SAYecucaHvv4ZuQW0i2m2Qvoe
	 JFQsuJdHoBx5aPtUmqjfVQOD7KxGPJoPbEfsjrjoihMTokdggElXIndQ0t8ZXUh5te
	 EuplxEQVP2/H0hDc9amoO3hKZCuzIHo0OIy4ayuU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgGPAlH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jul 2020 20:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgGPAlG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Jul 2020 20:41:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB4020714;
        Thu, 16 Jul 2020 00:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594860066;
        bh=A3gwm6BK9JnUR/bUBB4CY297uauJWlm1IYABhVsyw+k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GaP81cX+R1Zb/cllHWLc0np3bYinc6iGz/18JF2JeOqRqD4SR5o2sXeM4JYXc0rsb
         Hzu5NgK4vQraqiYHvIAGhcuf3sxp6PcCNv8GYqtAL0acE+Hhd/iSW4ufulrRWNOCWl
         B84x0ou9VpI+/krlWPAiggiTK/XvR1/qUrfYCMt8=
Date:   Wed, 15 Jul 2020 17:41:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     catalin.marinas@arm.com, hannes@cmpxchg.org, hdanton@sina.com,
        hughd@google.com, josef@toxicpanda.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        will.deacon@arm.com, willy@infradead.org, xuyu@linux.alibaba.com,
        yang.shi@linux.alibaba.com
Subject:  +
 mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2.patch added
 to -mm tree
Message-ID: <20200716004105.WQf42kMyq%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2
has been added to the -mm tree.  Its filename is
     mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-avoid-access-flag-update-tlb-flush-for-retried-page-fault-v2.patch
mm-filemap-clear-idle-flag-for-writes.patch
mm-filemap-add-missing-fgp_-flags-in-kerneldoc-comment-for-pagecache_get_page.patch
mm-thp-remove-debug_cow-switch.patch

