Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A98BECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 22:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIIW1R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 18:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIIW1Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 18:27:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92BEB24A0
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 15:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C0C4B82628
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 22:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3614C433C1;
        Fri,  9 Sep 2022 22:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662762430;
        bh=wP7QBLQarOMKck+PyHTo9OU5z8einZD9CwHKdpvVTA8=;
        h=Date:To:From:Subject:From;
        b=G8shUFjZBH9kVs2IjoCZidjyJNvDSOA3I0KPJiSHiJ5CFdlZ8bbKMq7ob6PJn85XY
         qClaqu4SLRI0hodtibgcd/5hZoz7kRm46K9FzgbBfRwOVZjd1GcQd+1ipd7udOtf48
         cnYBHtsy5Tx90a4VlFqM2SDiTO2SAvg08IjIsCZo=
Date:   Fri, 09 Sep 2022 15:27:10 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vbabka@suse.cz, mike.kravetz@oracle.com,
        kirill.shutemov@linux.intel.com, glider@google.com,
        aarcange@redhat.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch added to mm-unstable branch
Message-Id: <20220909222710.D3614C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: prevent THP_ZERO_PAGE_ALLOC increased twice
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch

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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/huge_memory: prevent THP_ZERO_PAGE_ALLOC increased twice
Date: Fri, 9 Sep 2022 10:16:53 +0800

A user who reads THP_ZERO_PAGE_ALLOC may be more concerned about the huge
zero pages that are really allocated for thp.  It is misleading to
increase THP_ZERO_PAGE_ALLOC twice if two threads call get_huge_zero_page
concurrently.  Don't increase the value if the huge page is not really
used.

Update Documentation/admin-guide/mm/transhuge.rst to suit.

Link: https://lkml.kernel.org/r/20220909021653.3371879-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    7 +++----
 mm/huge_memory.c                           |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -366,10 +366,9 @@ thp_split_pmd
 	page table entry.
 
 thp_zero_page_alloc
-	is incremented every time a huge zero page is
-	successfully allocated. It includes allocations which where
-	dropped due race with other allocation. Note, it doesn't count
-	every map of the huge zero page, only its allocation.
+	is incremented every time a huge zero page used for thp is
+	successfully allocated. Note, it doesn't count every map of
+	the huge zero page, only its allocation.
 
 thp_zero_page_alloc_failed
 	is incremented if kernel fails to allocate
--- a/mm/huge_memory.c~mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice
+++ a/mm/huge_memory.c
@@ -163,7 +163,6 @@ retry:
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
 		return false;
 	}
-	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	preempt_disable();
 	if (cmpxchg(&huge_zero_page, NULL, zero_page)) {
 		preempt_enable();
@@ -175,6 +174,7 @@ retry:
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
 	preempt_enable();
+	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	return true;
 }
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch
mm-thp-remove-redundant-config_transparent_hugepage.patch
mm-kmemleak-make-create_object-return-void.patch
mm-shuffle-convert-module_param_call-to-module_param_cb.patch
mm-kfence-convert-to-define_seq_attribute.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch

