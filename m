Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F925C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 30 Dec 2021 01:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhL3BYn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 20:24:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49440 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbhL3BYn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 20:24:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B928061562
        for <mm-commits@vger.kernel.org>; Thu, 30 Dec 2021 01:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992E0C36AE9;
        Thu, 30 Dec 2021 01:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640827482;
        bh=nsEoLa/rPmikpMDF3EnJYwdDCMSL07bGQIPytluUdYQ=;
        h=Date:From:To:Subject:From;
        b=0ggkEiiT6pXXRQGtd12g9qOxXOiz/Arv1sidvDYe3TsnFmgd6BBK12/zD5bdG4Pkr
         5b7piCyOjfuAwYqWgKU48nmfKB4pxYEfQx0ypIdnKpM9T84EEAGvnzXLwfzEng9Ym/
         NSvC+JGVfEgKaK0jio8kWqwNQhoLpljwLsOxM/JM=
Date:   Wed, 29 Dec 2021 17:24:41 -0800
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, akpm@linux-foundation.org, bhe@redhat.com,
        bp@alien8.de, cl@linux.com, David.Laight@ACULAB.COM,
        david@redhat.com, hch@lst.de, iamjoonsoo.kim@lge.com,
        john.p.donnelly@oracle.com, m.szyprowski@samsung.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, robin.murphy@arm.com, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-page=5Fallocc-do-not-warn-allocation-failure-on-zone-d?=
 =?US-ASCII?Q?ma-if-no-managed-pages-fix.patch?= added to -mm tree
Message-ID: <20211230012441.govniiBD_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix
has been added to the -mm tree.  Its filename is
     mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch

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
Subject: mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix

fix warning

mm/page_alloc.c: In function 'warn_alloc':
mm/page_alloc.c:4224:26: warning: suggest parentheses around '&&' within '||' [-Wparentheses]
 4224 |   (gfp_mask & __GFP_DMA) && !has_managed_dma())
      |   ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~

Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: John Donnelly  <john.p.donnelly@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix
+++ a/mm/page_alloc.c
@@ -4218,8 +4218,9 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	va_list args;
 	static DEFINE_RATELIMIT_STATE(nopage_rs, 10*HZ, 1);
 
-	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
-		(gfp_mask & __GFP_DMA) && !has_managed_dma())
+	if ((gfp_mask & __GFP_NOWARN) ||
+	     !__ratelimit(&nopage_rs) ||
+	     ((gfp_mask & __GFP_DMA) && !has_managed_dma()))
 		return;
 
 	va_start(args, fmt);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
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
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

