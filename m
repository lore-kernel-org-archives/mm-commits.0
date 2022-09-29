Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B417C04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiI2EB3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiI2EB2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:01:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9EC726AD
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CBF12CE1F7B
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D680C433C1;
        Thu, 29 Sep 2022 04:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424084;
        bh=dYJiBEZ5o+nMLzpbz4IbnNVNMY73APbBCtEz04Iu8uU=;
        h=Date:To:From:Subject:From;
        b=kf5I6EOPSRZ4l/33QC2B5ovv+PayEI8/ed5IDI2PB2j+o1GTnHwr7tvBiAvn+6MPR
         pyAsuCPTAikdsaJace/OYXQmVe7TMPdS9cxf4yah5m0GO8E0onrBUPTFlZk/umYuOd
         qnXMj3N3BNGOUNmHAc2rse1vsdbYMVKKKXlViJyQ=
Date:   Wed, 28 Sep 2022 21:01:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, trix@redhat.com,
        songmuchun@bytedance.com, shy828301@gmail.com, peterx@redhat.com,
        ndesaulniers@google.com, nathan@kernel.org,
        mike.kravetz@oracle.com, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix.patch removed from -mm tree
Message-Id: <20220929040124.0D680C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp-fix.patch

This patch was dropped because it was folded into shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp.patch

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

 mm/shmem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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

shmem-convert-shmem_fault-to-use-shmem_get_folio_gfp.patch

