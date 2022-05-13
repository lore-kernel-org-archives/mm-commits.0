Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DBFC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376583AbiEMCzS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376573AbiEMCzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:55:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A0627EBAE
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A736062166
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEEDC385B8;
        Fri, 13 May 2022 02:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410516;
        bh=bid7LlMUaIUQYz/GYEyzMyEkeqwSVBMzK3gMZ2wVXMc=;
        h=Date:To:From:Subject:From;
        b=DaNZVqOHMhhCEI7OkzzV41vlKoRLNoxYa77lMUMQIv3annPzkI5HxyYCthTvp710V
         JBsX9hFYcoLF6eKZZeXsO2ah9cDcc2a7OytI+Km77kywVqu96e/EMugsTeVi/rTxn2
         NYv56koqD6nNro2SGMoG56nFCsPIi0n0WVSVGk0I=
Date:   Thu, 12 May 2022 19:55:15 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        peterx@redhat.com, lkp@intel.com, lkft@linaro.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch removed from -mm tree
Message-Id: <20220513025516.0DEEDC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch

This patch was dropped because it was folded into mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix

move zap_flags_t from mm.h to mm_types.h to fix build issues

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    2 --
 include/linux/mm_types.h |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix
+++ a/include/linux/mm.h
@@ -3428,8 +3428,6 @@ madvise_set_anon_name(struct mm_struct *
 }
 #endif
 
-typedef unsigned int __bitwise zap_flags_t;
-
 /*
  * Whether to drop the pte markers, for example, the uffd-wp information for
  * file-backed memory.  This should only be specified when we will completely
--- a/include/linux/mm_types.h~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix
+++ a/include/linux/mm_types.h
@@ -863,4 +863,6 @@ enum fault_flag {
 	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
 };
 
+typedef unsigned int __bitwise zap_flags_t;
+
 #endif /* _LINUX_MM_TYPES_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

