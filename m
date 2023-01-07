Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23459C5479D
	for <mm-commits@archiver.kernel.org>; Sat,  7 Jan 2023 01:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjAGB2t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 20:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjAGB2s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 20:28:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9CC73E1F
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 17:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2B3D61F9C
        for <mm-commits@vger.kernel.org>; Sat,  7 Jan 2023 01:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4849FC433EF;
        Sat,  7 Jan 2023 01:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673054926;
        bh=l3juVki3QXmqfJrlb4BF1AX980xqc5a6POCYMt0UBtc=;
        h=Date:To:From:Subject:From;
        b=l1jY0q47u5EjhsQwrClD+Bqp7/1qubR3zqF0C6bpIlqNTkx8GwrzOltsUJykYoOfw
         wMTI8YMWrIeLWPXH6T0eHzBQieRHKVjhFnH6spOnhSJZ1MEgnQfgT4UQ0gWxRDfVX7
         LcwcB4DHsPAaaDUx/RWidc7abRBEW+q/QtzgCdzM=
Date:   Fri, 06 Jan 2023 17:28:45 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-convert-__vma_adjust-to-use-vma-iterator-fix.patch added to mm-unstable branch
Message-Id: <20230107012846.4849FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap-convert-__vma_adjust-to-use-vma-iterator-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-convert-__vma_adjust-to-use-vma-iterator-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-convert-__vma_adjust-to-use-vma-iterator-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmap-convert-__vma_adjust-to-use-vma-iterator-fix
Date: Fri Jan  6 05:25:36 PM PST 2023

fix "no previous prototype for function 'vma_mas_store'"

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lkml.kernel.org/r/202301062207.zMezwo2P-lkp@intel.com
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~mmap-convert-__vma_adjust-to-use-vma-iterator-fix
+++ a/mm/nommu.c
@@ -544,7 +544,7 @@ static void put_nommu_region(struct vm_r
 	__put_nommu_region(region);
 }
 
-void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
+static void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
 {
 	mas_set_range(mas, vma->vm_start, vma->vm_end - 1);
 	mas_store_prealloc(mas, vma);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mmap-convert-__vma_adjust-to-use-vma-iterator-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch

