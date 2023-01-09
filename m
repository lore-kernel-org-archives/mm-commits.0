Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9C9C54EBE
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 22:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbjAIWTd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237505AbjAIWTH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 17:19:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B3313EB1
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 14:19:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9E6EB8105D
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 22:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D97C433EF;
        Mon,  9 Jan 2023 22:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673302743;
        bh=8W7eMxw3VSGJ625p6OU86kpH94PEV++NhLwA4Tt31bc=;
        h=Date:To:From:Subject:From;
        b=1XFSdTCA73E1qSQgnwLAWr0gSjEEWOi39r1zQv++rc3e+uMczMF6iN+vRCJ53trx5
         Luzc77w5S8Q2cAMu+5xKBNzL54gLwSVlF3ikVUQ6kCSEakxpG3G8F1Pwduyq3tf51B
         KHF48epQ1Cop/n2z1YWt1eE1AyhWEkfVYHJdL+yk=
Date:   Mon, 09 Jan 2023 14:19:02 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma-fix.patch added to mm-unstable branch
Message-Id: <20230109221903.70D97C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm.h: fix "mm: Add temporary vma iterator versions of vma_merge(), split_vma(), and __split_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm.h: fix "mm: Add temporary vma iterator versions of vma_merge(), split_vma(), and __split_vma()
Date: Mon, 9 Jan 2023 20:53:22 +0000

The extern definition of __split_vma() was removed too early.  Re-add it
and remove it once the users are all converted.

Link: https://lkml.kernel.org/r/20230109205300.955019-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mm.h~mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma-fix
+++ a/include/linux/mm.h
@@ -2825,6 +2825,8 @@ extern struct vm_area_struct *vmi_vma_me
 	struct file *, pgoff_t, struct mempolicy *, struct vm_userfaultfd_ctx,
 	struct anon_vma_name *);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
+extern int __split_vma(struct mm_struct *, struct vm_area_struct *,
+			       unsigned long addr, int new_below);
 extern int vmi__split_vma(struct vma_iterator *vmi, struct mm_struct *,
 	struct vm_area_struct *, unsigned long addr, int new_below);
 extern int split_vma(struct mm_struct *, struct vm_area_struct *,
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

nommu-fix-memory-leak-in-do_mmap-error-path.patch
nommu-fix-do_munmap-error-path.patch
nommu-fix-split_vma-map_count-error.patch
mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma-fix.patch
maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

