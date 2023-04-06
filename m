Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7D3C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbjDFDFC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbjDFDEO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192249EC6
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A78A062D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D30DC433D2;
        Thu,  6 Apr 2023 03:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750242;
        bh=66ggrOI6hVOC1r1D8Xq6kChBEwIFnTlJJuE/kzFaXwU=;
        h=Date:To:From:Subject:From;
        b=ZW2HfFZIApqElk6KfVLNjlsfB/NSgGP0tUdUgGZg3lFKTZeQ/xp8crJdD5UQ+L0eQ
         EDhArTBQ0Tc+21NfW4yBFB8K1yTdzzbtsWAxjSMHkcLTjkRLQNcyOMn01SBBRyVBDP
         M7eTny6TNkMxluVJ5mHghWiJp/N62AGIqEjAzcG8=
Date:   Wed, 05 Apr 2023 20:04:01 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, surenb@google.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        borntraeger@linux.ibm.com, agordeev@linux.ibm.com,
        hca@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-mm-try-vma-lock-based-page-fault-handling-first.patch removed from -mm tree
Message-Id: <20230406030402.0D30DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: s390/mm: try VMA lock-based page fault handling first
has been removed from the -mm tree.  Its filename was
     s390-mm-try-vma-lock-based-page-fault-handling-first.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: s390/mm: try VMA lock-based page fault handling first
Date: Tue, 14 Mar 2023 14:28:08 +0100

Attempt VMA lock-based page fault handling first, and fall back to the
existing mmap_lock-based handling if that fails.

This is the s390 variant of "x86/mm: try VMA lock-based page fault handling
first".

Link: https://lkml.kernel.org/r/20230314132808.1266335-1-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig    |    1 +
 arch/s390/mm/fault.c |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/arch/s390/Kconfig~s390-mm-try-vma-lock-based-page-fault-handling-first
+++ a/arch/s390/Kconfig
@@ -120,6 +120,7 @@ config S390
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_WANTS_DYNAMIC_TASK_STRUCT
--- a/arch/s390/mm/fault.c~s390-mm-try-vma-lock-based-page-fault-handling-first
+++ a/arch/s390/mm/fault.c
@@ -407,6 +407,30 @@ static inline vm_fault_t do_exception(st
 		access = VM_WRITE;
 	if (access == VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
+#ifdef CONFIG_PER_VMA_LOCK
+	if (!(flags & FAULT_FLAG_USER))
+		goto lock_mmap;
+	vma = lock_vma_under_rcu(mm, address);
+	if (!vma)
+		goto lock_mmap;
+	if (!(vma->vm_flags & access)) {
+		vma_end_read(vma);
+		goto lock_mmap;
+	}
+	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
+	vma_end_read(vma);
+	if (!(fault & VM_FAULT_RETRY)) {
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		goto out;
+	}
+	count_vm_vma_lock_event(VMA_LOCK_RETRY);
+	/* Quick path to respond to signals */
+	if (fault_signal_pending(fault, regs)) {
+		fault = VM_FAULT_SIGNAL;
+		goto out;
+	}
+lock_mmap:
+#endif /* CONFIG_PER_VMA_LOCK */
 	mmap_read_lock(mm);
 
 	gmap = NULL;
_

Patches currently in -mm which might be from hca@linux.ibm.com are

proc-stat-remove-arch_idle_time.patch

