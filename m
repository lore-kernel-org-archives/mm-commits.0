Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6CEC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jan 2022 00:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiAMAuc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jan 2022 19:50:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59868 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiAMAua (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jan 2022 19:50:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A55461BAA
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 00:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB21C36AE9;
        Thu, 13 Jan 2022 00:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642035029;
        bh=OY7x6nL8l3LHTVpcwtWWevwSlEVo0aZwNTq9PAwLsHc=;
        h=Date:From:To:Subject:From;
        b=VlfMHflLHb49KcBYOrml2NImVOJa+wZmMAqxvPGmxGVcCURIjnnNgv5g1tF7m2BwP
         kSz8cpu5ZBS4gZh53sai5C3QOExZKfASc1oPj+8fmKc5YfWsoCLM4Vs3hi2S8Lne2l
         FfTqjS6FvpPwHn9a9hGu+UjzhylDQs51y/ARyiyM=
Date:   Wed, 12 Jan 2022 16:50:28 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, mm-commits@vger.kernel.org,
        sjenning@redhat.com, vitaly.wool@konsulko.com, willy@infradead.org
Subject:  + mm-remove-cleancache-fix.patch added to -mm tree
Message-ID: <20220113005028.4rdhYdNqJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-cleancache-fix
has been added to the -mm tree.  Its filename is
     mm-remove-cleancache-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-cleancache-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-cleancache-fix.patch

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
Subject: mm-remove-cleancache-fix

remove now-unreachable code

Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/data.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/f2fs/data.c~mm-remove-cleancache-fix
+++ a/fs/f2fs/data.c
@@ -2089,12 +2089,6 @@ submit_and_realloc:
 	ClearPageError(page);
 	*last_block_in_bio = block_nr;
 	goto out;
-confused:
-	if (bio) {
-		__submit_bio(F2FS_I_SB(inode), bio, DATA);
-		bio = NULL;
-	}
-	unlock_page(page);
 out:
 	*bio_ret = bio;
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
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

