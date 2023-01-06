Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF72BC5479D
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 23:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjAFXdm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 18:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjAFXdm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 18:33:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FC344C63
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 15:33:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20C47B81EF2
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 23:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EAEC433D2;
        Fri,  6 Jan 2023 23:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673048016;
        bh=khFQEzVMOq70J9O7KXJxxRbKYkFylVcGN0S5qpBtFBw=;
        h=Date:To:From:Subject:From;
        b=wwo4/DlF3R4PBZ8K66CoLKADvpOT3etP/JRpiarvycYGtufmMUpNx371/g0MGKr9B
         4P21vcq2YdT5WtUJAcaINwIsSlElvZ1mHi/rqtkDLfvZaFZOQ5gvL2ljYdg8lo9qUv
         74IkhBGxOjtQK1pkenQ3kTjERtjYo8ICPCimYzAM=
Date:   Fri, 06 Jan 2023 15:33:35 -0800
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix.patch added to mm-unstable branch
Message-Id: <20230106233336.A6EAEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm: declare different type of split_vma() for !CONFIG_MMU
has been added to the -mm mm-unstable branch.  Its filename is
     mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: include/linux/mm: declare different type of split_vma() for !CONFIG_MMU
Date: Fri, 6 Jan 2023 17:18:57 +0000

Commit 95000286ff79 ("mm: switch vma_merge(), split_vma(), and __split_vma
to vma iterator") on mm-unstable didn't make the change to nommu.c, but
the declaration change was applied to !CONFIG_MMU, too.  It causes below
build failure.

    linux/mm/nommu.c:1347:5: error: conflicting types for 'split_vma'
     1347 | int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
          |     ^~~~~~~~~
    In file included from linux/mm/nommu.c:20:
    linux/include/linux/mm.h:2846:12: note: previous declaration of 'split_vma' was here
     2846 | extern int split_vma(struct vma_iterator *vmi, struct vm_area_struct *,
          |            ^~~~~~~~~

Fix the build failure by adding the split_vma() declaration for
!CONFIG_MMU case.

Link: https://lkml.kernel.org/r/20230106171857.149918-1-sj@kernel.org
Fixes: 95000286ff79 ("mm: switch vma_merge(), split_vma(), and __split_vma to vma iterator")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/mm.h~mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix
+++ a/include/linux/mm.h
@@ -2823,8 +2823,13 @@ extern struct vm_area_struct *vma_merge(
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
 extern int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *,
 		       unsigned long addr, int new_below);
+#ifdef CONFIG_MMU
 extern int split_vma(struct vma_iterator *vmi, struct vm_area_struct *,
 			 unsigned long addr, int new_below);
+#else
+extern int split_vma(struct mm_struct *, struct vm_area_struct *,
+			 unsigned long addr, int new_below);
+#endif	/* CONFIG_MMU */
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
scripts-spelling-add-a-few-more-typos.patch

