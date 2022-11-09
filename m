Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51983C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiKIB0n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKIB0l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:26:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C86F5E9ED
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 921C761803
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96E0C433C1;
        Wed,  9 Nov 2022 01:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957200;
        bh=sJkckQ618/u4iaQnuq9TWGoFnVuIh4jOT5GzHJ19VEs=;
        h=Date:To:From:Subject:From;
        b=dJV33gOVYuVnIBuJC8nBWzT/dY4kvJgxyJ8iQN7qURdlNcIWIP+fBv1JAXEr37a81
         qDgJfD54FCDeTsC6FoAQBq/1IT6VJIinxjrVSWdc+NVwAleXEigVjk30rN6LrndMAW
         H5GHvnyCLrjTWOnnIzzJ6VP2vDowFjKQrKqxFO7c=
Date:   Tue, 08 Nov 2022 17:26:39 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        naoya.horiguchi@linux.dev, mpe@ellerman.id.au, david@redhat.com,
        christophe.leroy@csgroup.eu, baolin.wang@linux.alibaba.com,
        aneesh.kumar@linux.ibm.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5.patch removed from -mm tree
Message-Id: <20221109012639.E96E0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5
has been removed from the -mm tree.  Its filename was
     hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5.patch

This patch was dropped because it was folded into hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5
Date: Sun, 30 Oct 2022 15:58:25 -0700

remove left over hugetlb_vma_unlock_read()

Link: https://lkml.kernel.org/r/20221030225825.40872-1-mike.kravetz@oracle.com
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5
+++ a/mm/hugetlb.c
@@ -6265,7 +6265,6 @@ retry:
 	} else {
 		if (is_hugetlb_entry_migration(entry)) {
 			spin_unlock(ptl);
-			hugetlb_vma_unlock_read(vma);
 			__migration_entry_wait_huge(pte, ptl);
 			goto retry;
 		}
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch
selftests-vm-update-hugetlb-madvise.patch

