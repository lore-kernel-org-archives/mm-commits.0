Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BA9C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EABA361476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhGABAh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGABAh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED4636146D;
        Thu,  1 Jul 2021 00:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101088;
        bh=Ikz5oQmEgtD0BEKvLEboRhSOyj4ah+SYZ3M+/X2MXJ4=;
        h=Date:From:To:Subject:From;
        b=R63KAy+Bdz+dGrIWdt1vpftZ7cJ0vqtnGaXWZQ8ykiqeUWBjf7orkTXplpRAm0IfX
         dM2ITRtQYa/eWkjH0t3Dlu/CVgM8xSucydOVXKnPivoMab33I5tFQ5sfGgeFWg5N0z
         5vfQ0qH4UKq3CtlOvH8J5iOyp44PIcNiUTJgD2IU=
Date:   Wed, 30 Jun 2021 17:58:07 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chenli@uniontech.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
 removed from -mm tree
Message-ID: <20210701005807.xqmqtzKJl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch

This patch was dropped because it was folded into nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes

Cc: Chen Li <chenli@uniontech.com>

WARNING: please, no spaces at the start of a line
#37: FILE: mm/nommu.c:226:
+       return __vmalloc(size, GFP_KERNEL);$

total: 0 errors, 1 warnings, 16 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Chen Li <chenli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes
+++ a/mm/nommu.c
@@ -223,7 +223,7 @@ long vread(char *buf, char *addr, unsign
  */
 void *vmalloc(unsigned long size)
 {
-       return __vmalloc(size, GFP_KERNEL);
+	return __vmalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL(vmalloc);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

