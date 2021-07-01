Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F432C11F7A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1044061469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhGABDj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238345AbhGABDb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:03:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B64610A1;
        Thu,  1 Jul 2021 01:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101261;
        bh=p/2KVwpopqvOAUXeQWTcL7QnplQg1tOdaO8FkqLLx1Q=;
        h=Date:From:To:Subject:From;
        b=WQy61OBsLDfuV/HAITcH5oI1DfOhOgoFDnhISRWdfO47CvdgB5bLil24IhmVTpxFo
         UgI0oeShTsK1vIVYLyrcRMC5PhiR0TQ8QL5mKawR0z1nKnoONCqreJJ/5XZ/SN3Z0X
         Xpr/KT6TTZj+KQrA8CaEjGGn2IatpZ3crs3GSvg4=
Date:   Wed, 30 Jun 2021 18:01:00 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        chenying.kernel@bytedance.com, mm-commits@vger.kernel.org,
        rppt@kernel.org, songmuchun@bytedance.com,
        zhouchengming@bytedance.com, zhoufeng.zf@bytedance.com
Subject:  [folded-merged]
 fs-proc-kcorec-add-mmap-interface-fix.patch removed from -mm tree
Message-ID: <20210701010100.DkjgJNZLU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-kcorec-add-mmap-interface-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-kcorec-add-mmap-interface-fix.patch

This patch was dropped because it was folded into fs-proc-kcorec-add-mmap-interface.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-kcorec-add-mmap-interface-fix

KCORE_REMAP is no more

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: CHENYING <chenying.kernel@bytedance.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: ZHOUFENG <zhoufeng.zf@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/kcore.c~fs-proc-kcorec-add-mmap-interface-fix
+++ a/fs/proc/kcore.c
@@ -660,7 +660,7 @@ static int mmap_kcore(struct file *file,
 	vma->vm_ops = &kcore_mmap_ops;
 
 	if (kern_addr_valid(start)) {
-		if (m->type == KCORE_RAM || m->type == KCORE_REMAP)
+		if (m->type == KCORE_RAM)
 			pfn = __pa(start) >> PAGE_SHIFT;
 		else if (m->type == KCORE_TEXT)
 			pfn = __pa_symbol(start) >> PAGE_SHIFT;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-kcorec-add-mmap-interface.patch
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

