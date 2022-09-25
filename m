Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66415C04A95
	for <mm-commits@archiver.kernel.org>; Sun, 25 Sep 2022 18:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbiIYSzO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 25 Sep 2022 14:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiIYSzN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 25 Sep 2022 14:55:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF488186C3
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 11:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 585B5615E0
        for <mm-commits@vger.kernel.org>; Sun, 25 Sep 2022 18:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4FAC433D7;
        Sun, 25 Sep 2022 18:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664132110;
        bh=cEMt9BcfivMHK8l0NLrYNLXgFgY4teK74Sok7Ro7CBs=;
        h=Date:To:From:Subject:From;
        b=Xym+3TcihpPJUD9987f4/n+FqJ7XkFV+FC7/Cz4DA1TqJVg8yn90511mgtey0iaaf
         Z4Oqni9LvPTv7xCuipKgBkD9879/IiYMb5/nTpwXpXpUdfl0AbYW6Spv7o6UUtfDiG
         0nw0w/1Ye1y2zCu8qy0BWhMh6knqkeRPrrUrnR2U=
Date:   Sun, 25 Sep 2022 11:55:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, trix@redhat.com,
        songmuchun@bytedance.com, shy828301@gmail.com, peterx@redhat.com,
        ndesaulniers@google.com, nathan@kernel.org,
        mike.kravetz@oracle.com, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix.patch added to mm-unstable branch
Message-Id: <20220925185510.6D4FAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix
Date: Fri, 23 Sep 2022 17:14:38 -0700 (PDT)

Link: https://lkml.kernel.org/r/7693a84-bdc2-27b5-2695-d0fe8566571f@google.com
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/shmem.c~shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix
+++ a/mm/shmem.c
@@ -2065,7 +2065,7 @@ static vm_fault_t shmem_fault(struct vm_
 	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = file_inode(vma->vm_file);
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
-	struct folio *folio;
+	struct folio *folio = NULL;
 	int err;
 	vm_fault_t ret = VM_FAULT_LOCKED;
 
@@ -2132,7 +2132,8 @@ static vm_fault_t shmem_fault(struct vm_
 				  gfp, vma, vmf, &ret);
 	if (err)
 		return vmf_error(err);
-	vmf->page = folio_file_page(folio, vmf->pgoff);
+	if (folio)
+		vmf->page = folio_file_page(folio, vmf->pgoff);
 	return ret;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix.patch

