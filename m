Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5AFC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiANV3f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiANV3e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:29:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C0BC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:29:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0471B82A26
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84BBC36AE9;
        Fri, 14 Jan 2022 21:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195771;
        bh=NJzMmnMlgqZjaTnSywLI+G+3Vi+FTsxlFOAZ8rSXVgY=;
        h=Date:From:To:Subject:From;
        b=QzWfHpt2luDp+n8x+yM8nNuM9WysTm6Kc5schF8Q9Ypt4dS39UCifcvI9yHQw+h7k
         nuNJADxadiHXbKYu+kXfKiKw99mQwW6sOudDiF36szV3hQV46A3VEiMSQ70849W3ck
         EeaFUoYnUDwx6YLBbsEzNohjEGbrOZr9IiOq46ng=
Date:   Fri, 14 Jan 2022 13:29:30 -0800
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, akpm@linux-foundation.org, bhe@redhat.com,
        bp@alien8.de, cl@linux.com, David.Laight@ACULAB.COM,
        david@redhat.com, hch@lst.de, iamjoonsoo.kim@lge.com,
        john.p.donnelly@oracle.com, m.szyprowski@samsung.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, robin.murphy@arm.com, vbabka@suse.cz
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-page=5Fallocc-do-not-warn-allocation-failure-on-zone-d?=
 =?US-ASCII?Q?ma-if-no-managed-pages-fix.patch?= removed from -mm tree
Message-ID: <20220114212930.rIStnfgs_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch

This patch was dropped because it was folded into mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages.patch

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

mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages.patch
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

