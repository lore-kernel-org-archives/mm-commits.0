Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858DEC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJCVNK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA31619C33
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52934B8160F
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4D5C433D6;
        Mon,  3 Oct 2022 21:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831225;
        bh=HaVpr665HHn09t8IvPrhb0jh7VRFwXKCg496IPEW0y0=;
        h=Date:To:From:Subject:From;
        b=1Xg6+WJWg9rlEH/PKhXBQR3noHhUa9MCHGSo4mWJ8sosqPFY9v2rrV0QSnPBd87aJ
         FZ0T/aShJOSlFIeehcf6f9BjmoK+rAJfx/FA6a4UknrMAGfnzhddKWvQ0BHRiTry5i
         WfRh16OXN8rEWrT8YhTeYmwWGgvLwRdrW8e7ulwI=
Date:   Mon, 03 Oct 2022 14:07:04 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vbabka@suse.cz, mike.kravetz@oracle.com,
        kirill.shutemov@linux.intel.com, glider@google.com,
        aarcange@redhat.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch removed from -mm tree
Message-Id: <20221003210704.ED4D5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: prevent THP_ZERO_PAGE_ALLOC increased twice
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


