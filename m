Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6629E78488
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 19:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbjJAT4o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 15:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbjJAT4n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 15:56:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C48C4
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 12:56:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5565C433C9;
        Sun,  1 Oct 2023 19:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696190200;
        bh=GuDD4S6nCq+jd94REKrMWORTXPzAHHU4x0d7f7OYtss=;
        h=Date:To:From:Subject:From;
        b=J5KRlkQGk81ptYbh1bLt9pZigh8YUxHSRHgDsXNSjjD6o9AJbB0cvGp55uzV7bvVM
         BiLbxINuAAOQ/puKdup8mR7y029E2BRXMspj51oBxR+lUd0wLi5VNVlu0lzyl4jUxJ
         oJmsCldh9fl1t2zZQV0ulhLIbXuxWL5OfKMOLde8=
Date:   Sun, 01 Oct 2023 12:56:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tim.c.chen@intel.com, jack@suse.cz, hannes@cmpxchg.org,
        djwong@kernel.org, dchinner@redhat.com, chuck.lever@oracle.com,
        cem@kernel.org, brauner@kernel.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch added to mm-unstable branch
Message-Id: <20231001195640.C5565C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: remove vma arg from shmem_get_folio_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch

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
Subject: shmem: remove vma arg from shmem_get_folio_gfp()
Date: Fri, 29 Sep 2023 20:26:53 -0700 (PDT)

The vma is already there in vmf->vma, so no need for a separate arg.

Link: https://lkml.kernel.org/r/d9ce6f65-a2ed-48f4-4299-fdb0544875c5@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/shmem.c~shmem-remove-vma-arg-from-shmem_get_folio_gfp
+++ a/mm/shmem.c
@@ -1938,14 +1938,13 @@ unlock:
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache.
  *
- * vma, vmf, and fault_type are only supplied by shmem_fault:
- * otherwise they are NULL.
+ * vmf and fault_type are only supplied by shmem_fault: otherwise they are NULL.
  */
 static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
-		struct vm_area_struct *vma, struct vm_fault *vmf,
-		vm_fault_t *fault_type)
+		struct vm_fault *vmf, vm_fault_t *fault_type)
 {
+	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
@@ -2158,7 +2157,7 @@ int shmem_get_folio(struct inode *inode,
 		enum sgp_type sgp)
 {
 	return shmem_get_folio_gfp(inode, index, foliop, sgp,
-			mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
+			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
 }
 
 /*
@@ -2242,7 +2241,7 @@ static vm_fault_t shmem_fault(struct vm_
 	}
 
 	err = shmem_get_folio_gfp(inode, vmf->pgoff, &folio, SGP_CACHE,
-				  gfp, vma, vmf, &ret);
+				  gfp, vmf, &ret);
 	if (err)
 		return vmf_error(err);
 	if (folio)
@@ -4910,7 +4909,7 @@ struct folio *shmem_read_folio_gfp(struc
 
 	BUG_ON(!shmem_mapping(mapping));
 	error = shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
-				  gfp, NULL, NULL, NULL);
+				    gfp, NULL, NULL);
 	if (error)
 		return ERR_PTR(error);
 
_

Patches currently in -mm which might be from hughd@google.com are

shmem-shrink-shmem_inode_info-dir_offsets-in-a-union.patch
shmem-remove-vma-arg-from-shmem_get_folio_gfp.patch
shmem-factor-shmem_falloc_wait-out-of-shmem_fault.patch
shmem-trivial-tidyups-removing-extra-blank-lines-etc.patch
shmem-shmem_acct_blocks-and-shmem_inode_acct_blocks.patch
shmem-move-memcg-charge-out-of-shmem_add_to_page_cache.patch
shmem-_add_to_page_cache-before-shmem_inode_acct_blocks.patch
shmempercpu_counter-add-_limited_addfbc-limit-amount.patch

