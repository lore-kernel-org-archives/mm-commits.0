Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8366CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 15:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiGMPcS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 11:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiGMPcS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 11:32:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF1E4D178
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 08:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B884B81FC6
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 15:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B254EC34114;
        Wed, 13 Jul 2022 15:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657726334;
        bh=uLgdOd7M5sV5d0HoG0N/qXz8v3XoNyxUqRvocEru32w=;
        h=Date:To:From:Subject:From;
        b=zo02xCUU0vQ4CYaJ+9I8LrnH7gotNMrVjdMoBE5eB8fTqQ5wdD/iFHxM+A5rb9f7z
         f5hNnBzkLl4maPvQu7VtBNCUPmMXtZxltphZeoVWIwU5oJEPYDC4mvTOqierrptCNZ
         0KrWOHPWgHw3pyj1G6I9LX3TVf1+DJO65CHbJhOw=
Date:   Wed, 13 Jul 2022 08:32:13 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, lkp@intel.com,
        dan.carpenter@oracle.com, jrdr.linux@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch added to mm-unstable branch
Message-Id: <20220713153214.B254EC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: Avoid possible memory leak in failure path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch

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
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: mm/khugepaged: Avoid possible memory leak in failure path
Date: Wed, 13 Jul 2022 08:11:09 +0530


smatch warnings:
mm/khugepaged.c:2409 madvise_collapse() warn: possible memory
leak of 'cc'

Avoiding possible memory leak.

Link: https://lkml.kernel.org/r/20220713024109.62810-1-jrdr.linux@gmail.com
Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c~mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix
+++ a/mm/khugepaged.c
@@ -2396,12 +2396,6 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
-	if (!cc)
-		return -ENOMEM;
-	cc->is_khugepaged = false;
-	cc->last_target_node = NUMA_NO_NODE;
-
 	*prev = vma;
 
 	/* TODO: Support file/shmem */
@@ -2414,6 +2408,12 @@ int madvise_collapse(struct vm_area_stru
 	if (!hugepage_vma_check(vma, vma->vm_flags, false, false, false))
 		return -EINVAL;
 
+	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
+	if (!cc)
+		return -ENOMEM;
+	cc->is_khugepaged = false;
+	cc->last_target_node = NUMA_NO_NODE;
+
 	mmgrab(mm);
 	lru_add_drain_all();
 
_

Patches currently in -mm which might be from jrdr.linux@gmail.com are

mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch

