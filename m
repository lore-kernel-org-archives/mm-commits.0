Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AC7C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjASBOb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjASBNu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:13:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6A359552
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A365B61B0F
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E852C433F0;
        Thu, 19 Jan 2023 01:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090822;
        bh=hodM6/nA9WQuiAKkfHfM1rHdMIZTKWGlmevHag1OM7Q=;
        h=Date:To:From:Subject:From;
        b=VFhfBOROzL9iKnBN3EqFaAHlGa3mQ9Bb1hgGyl10gI5/8pGhnLTNEMhmwPhZLcCKi
         dXRV+Vv9SFsHPpJ6yQmV2bmD1iAs7aL7ezhvaaTkHvVfwxsEysfanhqq8U+vSV+A7+
         518S8ArRAoD1ipX9lR6/ZkNlVdwXd+6NvH0L1/30=
Date:   Wed, 18 Jan 2023 17:13:41 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        peterx@redhat.com, naoya.horiguchi@linux.dev, linmiaohe@huawei.com,
        jthoughton@google.com, david@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-update-vma-flag-check-for-hugetlb-vma-lock.patch removed from -mm tree
Message-Id: <20230119011342.0E852C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: update vma flag check for hugetlb vma lock
has been removed from the -mm tree.  Its filename was
     hugetlb-update-vma-flag-check-for-hugetlb-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: update vma flag check for hugetlb vma lock
Date: Mon, 12 Dec 2022 15:50:42 -0800

The check for whether a hugetlb vma lock exists partially depends on the
vma's flags.  Currently, it checks for either VM_MAYSHARE or VM_SHARED. 
The reason both flags are used is because VM_MAYSHARE was previously
cleared in hugetlb vmas as they are tore down.  This is no longer the
case, and only the VM_MAYSHARE check is required.

Link: https://lkml.kernel.org/r/20221212235042.178355-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-update-vma-flag-check-for-hugetlb-vma-lock
+++ a/mm/hugetlb.c
@@ -262,8 +262,7 @@ static inline struct hugepage_subpool *s
  */
 static bool __vma_shareable_lock(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
-		vma->vm_private_data;
+	return vma->vm_flags & VM_MAYSHARE && vma->vm_private_data;
 }
 
 void hugetlb_vma_lock_read(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


