Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FF1C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F18EB61CF9
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhF2AfC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhF2AfB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2F9261CDA;
        Tue, 29 Jun 2021 00:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926753;
        bh=HL3iedNeTNhDhd/CF9UpCeXqoiR5itiNxXdFXlG0NxU=;
        h=Date:From:To:Subject:From;
        b=y4r26Nm6TFLBieJR9zL2SgEOIjpALWjMMeuuTwqqF8ZvAxhauQoJkbXxC/xBzkyIR
         RmbWwJAgiPJBYMPlnvDEzzW8TqykcNogtNSCcShuWMOKh2Jfb3ZA9Oy+oY8vfVu79h
         Fy56K3FgmVSJKulvjbEDSMIiue8CHoiZ9fVg4DmM=
Date:   Mon, 28 Jun 2021 17:32:33 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andrii.nakryiko@gmail.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-page=5Falloc-convert-per-cpu-list-protection-to-local?=
 =?US-ASCII?Q?=5Flock-fix-checkpatch-fixes.patch?= removed from -mm tree
Message-ID: <20210629003233.SdYYpmDjU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes

WARNING: Non-standard signature: Debugged-by:
#77: 
Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>

WARNING: please, no spaces at the start of a line
#117: FILE: mm/page_alloc.c:128:
+    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&^I^I\$

WARNING: please, no spaces at the start of a line
#118: FILE: mm/page_alloc.c:129:
+    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)$

total: 0 errors, 3 warnings, 26 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -124,9 +124,9 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 
 struct pagesets {
 	local_lock_t lock;
-#if defined(CONFIG_DEBUG_INFO_BTF) &&			\
-    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&		\
-    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
+#if defined(CONFIG_DEBUG_INFO_BTF) &&				\
+	!defined(CONFIG_DEBUG_LOCK_ALLOC) &&			\
+	!defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
 	/*
 	 * pahole 1.21 and earlier gets confused by zero-sized per-CPU
 	 * variables and produces invalid BTF. Ensure that
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

