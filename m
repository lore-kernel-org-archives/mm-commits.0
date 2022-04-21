Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FB6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 20:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392160AbiDUUFW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392168AbiDUUFW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 16:05:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B014A921
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 13:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A32261CC4
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 20:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CA8C385A5;
        Thu, 21 Apr 2022 20:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650571350;
        bh=SB7qhGG1lqUi07hLnrbWeVjD2GdlVOO9FC4DPD8R+Mw=;
        h=Date:To:From:Subject:From;
        b=d0J1gUxhO05pi+aZK6YwANfBjvwjzVgF3hpdCmPCpl7B5YSlsNXp98XM9msTiXQxW
         F1UeJPezTZnzM4gqR3yAUzFyktUrtdIlYtbEItnQXDDGXBt/ZaUTODEQOUhxrMCYzm
         uj+n01aL3NLU67LzbZ+jlSSaKCbxBogEsmNs4F48=
Date:   Thu, 21 Apr 2022 13:02:29 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch added to -mm tree
Message-Id: <20220421200229.F3CA8C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix

move zap_flags_t from mm.h to mm_types.h to fix build issues

Reported-by: kernel test robot <lkp@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    2 --
 include/linux/mm_types.h |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix
+++ a/include/linux/mm.h
@@ -3431,8 +3431,6 @@ madvise_set_anon_name(struct mm_struct *
 }
 #endif
 
-typedef unsigned int __bitwise zap_flags_t;
-
 /*
  * Whether to drop the pte markers, for example, the uffd-wp information for
  * file-backed memory.  This should only be specified when we will completely
--- a/include/linux/mm_types.h~mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix
+++ a/include/linux/mm_types.h
@@ -850,4 +850,6 @@ enum fault_flag {
 	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
 };
 
+typedef unsigned int __bitwise zap_flags_t;
+
 #endif /* _LINUX_MM_TYPES_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

