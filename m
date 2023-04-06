Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656E3C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbjDFC5H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbjDFC4v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:56:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0431995
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:56:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80EE56417F
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E68C433D2;
        Thu,  6 Apr 2023 02:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749809;
        bh=fiHCNcF/y27f3nIsTs9qD5Dz9dN+5rhb+57H3YmgJqE=;
        h=Date:To:From:Subject:From;
        b=YuxnHGWkUyFClrmKdHyAdwBBRLUWcYgxLWhTG/+lXmyorsQpitq0xF0uOGB+weaMU
         ZJwRTw6MdntOahbh2lNlnfbr2wOG457BVrm2nDmnqhtjsvfVw1JWLHSI4+Hs6t2Cnr
         P/Zb1F2WEoy8S+JR6e2sKXGVuaroU+PS/GbIvjDQ=
Date:   Wed, 05 Apr 2023 19:56:48 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix.patch removed from -mm tree
Message-Id: <20230406025648.D8E68C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: txt-mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix.patch

This patch was dropped because it was folded into mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: txt-mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix
Date: Sat, 4 Mar 2023 15:24:15 -0800

I missed vma_try_start_write() definition for CONFIG_PER_VMA_LOCK=n
configuration.

Link: https://lkml.kernel.org/r/CAJuCfpFjWhtzRE1X=J+_JjgJzNKhq-=JT8yTBSTHthwp0pqWZw@mail.gmail.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mm.h~mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix
+++ a/include/linux/mm.h
@@ -717,6 +717,8 @@ static inline bool vma_start_read(struct
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
+static inline bool vma_try_start_write(struct vm_area_struct *vma)
+		{ return true; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma) {}
 
 #endif /* CONFIG_PER_VMA_LOCK */
_

Patches currently in -mm which might be from surenb@google.com are

mm-introduce-config_per_vma_lock.patch
mm-move-mmap_lock-assert-function-definitions.patch
mm-add-per-vma-lock-and-helper-functions-to-control-it.patch
mm-mark-vma-as-being-written-when-changing-vm_flags.patch
mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch
mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page.patch
mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch
mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them-fix.patch
mm-mremap-write-lock-vma-while-remapping-it-to-a-new-address-range.patch
mm-write-lock-vmas-before-removing-them-from-vma-tree.patch
mm-write-lock-vmas-before-removing-them-from-vma-tree-fix.patch
mm-conditionally-write-lock-vma-in-free_pgtables.patch
kernel-fork-assert-no-vma-readers-during-its-destruction.patch
mm-mmap-prevent-pagefault-handler-from-racing-with-mmu_notifier-registration.patch
mm-introduce-vma-detached-flag.patch
mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch
mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch
mm-add-fault_flag_vma_lock-flag.patch
mm-add-fault_flag_vma_lock-flag-fix.patch
mm-prevent-do_swap_page-from-handling-page-faults-under-vma-lock.patch
mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch
mm-introduce-per-vma-lock-statistics.patch
x86-mm-try-vma-lock-based-page-fault-handling-first.patch
arm64-mm-try-vma-lock-based-page-fault-handling-first.patch
mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch
mm-separate-vma-lock-from-vm_area_struct.patch

