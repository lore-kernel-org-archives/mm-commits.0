Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3BBC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiANVXo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:23:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52902 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiANVXo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:23:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3A1661F85
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B020C36AE9;
        Fri, 14 Jan 2022 21:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195423;
        bh=1v6Jl3VLa6tDnFwRLP3MIsIHSflsgjKmFfE+41pQVd4=;
        h=Date:From:To:Subject:From;
        b=C3yQKAXg7btAXmgPQ8f3ckfTzJ5V+j0rcResgsAHo5GK0a29qleR82Cj+kJSXaBlI
         EnUgmmcFB3dHNIHEgHsQnU1oJ3fNGLwvRZg3tu1M0w5sN5bk+Egiqr7IhyiEhTX0Kc
         3HEW3+Mx9oSZCC6kIQwyS5aKjNE7qjy9AQcQfzKA=
Date:   Fri, 14 Jan 2022 13:23:42 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-shmem-dont-truncate-page-if-memory-failure-happens-checkp?=
 =?US-ASCII?Q?atch-fixes.patch?= removed from -mm tree
Message-ID: <20220114212342.p0h5AetGb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-shmem-dont-truncate-page-if-memory-failure-happens.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#20: 
 slight different implementation from what Ajay Garg <ajaygargnsit@gmail.com>

WARNING: suspect code indent for conditional statements (16, 23)
#148: FILE: mm/shmem.c:3129:
+		if (!page)
+		       return ERR_PTR(-ECHILD);

WARNING: Statements should start on a tabstop
#149: FILE: mm/shmem.c:3130:
+		       return ERR_PTR(-ECHILD);

total: 0 errors, 3 warnings, 150 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-shmem-dont-truncate-page-if-memory-failure-happens.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes
+++ a/mm/shmem.c
@@ -3127,7 +3127,7 @@ static const char *shmem_get_link(struct
 		if (error)
 			return ERR_PTR(error);
 		if (!page)
-		       return ERR_PTR(-ECHILD);
+			return ERR_PTR(-ECHILD);
 		if (PageHWPoison(page)) {
 			unlock_page(page);
 			put_page(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

