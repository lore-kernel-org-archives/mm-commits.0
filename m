Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A243AECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 22:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiJaWyk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiJaWyj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 18:54:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963222DC2
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 15:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 326D0614C3
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 22:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6F2C433D6;
        Mon, 31 Oct 2022 22:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667256876;
        bh=OZon34DYCcIOZr2CkRM1C9lKvmDy5g7HBMKW6JlpaBA=;
        h=Date:To:From:Subject:From;
        b=d6HZPMGJqijHbrCPurpIOHovjiEUP7q7Py/DLVlPbbsk6uie9Il6m7fIRNalQvGIV
         gPuGUuY3l+ICRZhdD+ZsZTsySeWoTSo84J886q7V47aYCYTAmgK41Mg8WOb9XM8nAS
         1lRIYOPVTMMGyq8RKtmgCDXmiFjTGYtcWzQlmtXs=
Date:   Mon, 31 Oct 2022 15:54:35 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        naoya.horiguchi@linux.dev, mpe@ellerman.id.au, david@redhat.com,
        christophe.leroy@csgroup.eu, baolin.wang@linux.alibaba.com,
        aneesh.kumar@linux.ibm.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5.patch added to mm-unstable branch
Message-Id: <20221031225436.7E6F2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5.patch

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
@@ -6292,7 +6292,6 @@ retry:
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
hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5.patch

