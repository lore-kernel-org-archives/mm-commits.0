Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBDBC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJLW5S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLW5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E8111C247
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD8506164F
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A27C433C1;
        Wed, 12 Oct 2022 22:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615433;
        bh=mT10aHIYfnNAMMdDuY2UkJlmErw8voxoDNIuNaUn3Ck=;
        h=Date:To:From:Subject:From;
        b=ct2WRWUKMFbDZwOmn1r8QPYo292TZ6+qTGXt3rXYwmK3A3Rm81+1zwGjEcuiHrUxH
         k2MwA6ZeC5xVxrjsorz2uMplsbjZPPKQiTJnM3j5Jhfzg41QLzJebizze1BQZ4WCUW
         z5oTc4hS/cPic3pi/g4t/gFh98RkdiWARc7uNm4E=
Date:   Wed, 12 Oct 2022 15:57:12 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix-2.patch removed from -mm tree
Message-Id: <20221012225713.32A27C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb.c: make __hugetlb_vma_unlock_write_put() static
has been removed from the -mm tree.  Its filename was
     hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix-2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb.c: make __hugetlb_vma_unlock_write_put() static
Date: Fri Oct  7 12:59:20 PM PDT 2022

Reported-by: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix-2
+++ a/mm/hugetlb.c
@@ -6804,7 +6804,7 @@ void hugetlb_vma_lock_release(struct kre
 	kfree(vma_lock);
 }
 
-void __hugetlb_vma_unlock_write_put(struct hugetlb_vma_lock *vma_lock)
+static void __hugetlb_vma_unlock_write_put(struct hugetlb_vma_lock *vma_lock)
 {
 	struct vm_area_struct *vma = vma_lock->vma;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


