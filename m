Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D82C433ED
	for <mm-commits@archiver.kernel.org>; Wed, 19 May 2021 00:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3231A6135B
	for <mm-commits@archiver.kernel.org>; Wed, 19 May 2021 00:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352864AbhESAqU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 20:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352863AbhESAqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 20:46:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9AB16108B;
        Wed, 19 May 2021 00:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621385101;
        bh=8c0Zh1p5dbgFlLoEwOKb/Eequ/RNaJR/eIeQRnUN5oE=;
        h=Date:From:To:Subject:From;
        b=rkjAndu0SrvT9zNMvnEOLnefd2NdvfPR2H4BOWw9kTJCHprrnm+lCCuhCIXBniBjk
         rfs3+qqehrIuZgg5Q4EhaGk4+zPD++JpnZbUn+UmVsoB5blnb4V0ef6F5i0xu4qngg
         6C7cX/ULEZuLp63KvoibgmNwkMDaAxZCwhKT8D9s=
Date:   Tue, 18 May 2021 17:45:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  +
 =?US-ASCII?Q?mm-introduce-memfd=5Fsecret-system-call-to-create-secret-me?=
 =?US-ASCII?Q?mory-areas-fix.patch?= added to -mm tree
Message-ID: <20210519004500.XP6KOnSiB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

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
Subject: mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix

suppress Kconfig whine

Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/Kconfig~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix
+++ a/mm/Kconfig
@@ -907,6 +907,5 @@ config IO_MAPPING
 
 config SECRETMEM
 	def_bool ARCH_HAS_SET_DIRECT_MAP && !EMBEDDED
-	select STRICT_DEVMEM
 
 endmenu
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

