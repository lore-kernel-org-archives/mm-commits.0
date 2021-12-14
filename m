Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8136BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 04:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhLNEiN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 23:38:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56812 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhLNEiM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 23:38:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76E47B80DA1
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 04:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005C3C34605;
        Tue, 14 Dec 2021 04:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639456690;
        bh=7ibWMMrx2Fw4xO1HCpVSk/kx/HjQnIwY5DYdU/7LOHE=;
        h=Date:From:To:Subject:From;
        b=Mzd05ErympWKVRacrep9DSqDqBkbIVo9ioTXDd132UvH05gSUT9kMp9LPNL3W1YGW
         u5Wl2vdfSDXmDxa1Hdv1ScdORfRbeo+N/CB3ZcLAHcb/l6pKs0eo27uirgsGYsrNOM
         3OQ0mV+0UQe+uDjb9NAYWDrGAql4Gnot7Gxd4bys=
Date:   Mon, 13 Dec 2021 20:38:09 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, isabbasso@riseup.net,
        mm-commits@vger.kernel.org
Subject:  + hashh-remove-unused-define-directive-fix.patch added to
 -mm tree
Message-ID: <20211214043809.XJ6bWZxsn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/sw/rxe/rxe_qp.c: fix for "hash.h: remove unused define directive"
has been added to the -mm tree.  Its filename is
     hashh-remove-unused-define-directive-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hashh-remove-unused-define-directive-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hashh-remove-unused-define-directive-fix.patch

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
Subject: drivers/infiniband/sw/rxe/rxe_qp.c: fix for "hash.h: remove unused define directive"

hash_32_generic() becomes hash_32()

Cc: Isabella Basso <isabbasso@riseup.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/sw/rxe/rxe_qp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/infiniband/sw/rxe/rxe_qp.c~hashh-remove-unused-define-directive-fix
+++ a/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -217,8 +217,7 @@ static int rxe_qp_init_req(struct rxe_de
 	 * the port number must be in the Dynamic Ports range
 	 * (0xc000 - 0xffff).
 	 */
-	qp->src_port = RXE_ROCE_V2_SPORT +
-		(hash_32_generic(qp_num(qp), 14) & 0x3fff);
+	qp->src_port = RXE_ROCE_V2_SPORT + (hash_32(qp_num(qp), 14) & 0x3fff);
 	qp->sq.max_wr		= init->cap.max_send_wr;
 
 	/* These caps are limited by rxe_qp_chk_cap() done by the caller */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
hashh-remove-unused-define-directive-fix.patch

