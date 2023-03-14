Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E315C7618B
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 21:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjCNVcC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCNVcB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 17:32:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C1539B9B
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 14:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C8E7619E8
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 21:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925BDC433EF;
        Tue, 14 Mar 2023 21:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678829513;
        bh=uQR8sKp5fecVJQCtuMXFDkTQoFLUiNDi6aQplPCQp8Q=;
        h=Date:To:From:Subject:From;
        b=06KNoBO0zq0xD0ySAnNLu3t6lQYecvnMoTND3C4buD+LHBWzw436zVhqK1Siv3ouu
         vQxP1yX9hCOZhptM8aQqf1OsZyJvG8feWN8LIeAxb7h21hqQALeFN1sztNksz7ivwW
         TFdpvy/x59H0l7bNHGrLfZhdB0kiBX384x6HzVbM=
Date:   Tue, 14 Mar 2023 14:31:52 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, surenb@google.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        borntraeger@linux.ibm.com, agordeev@linux.ibm.com,
        hca@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-mm-try-vma-lock-based-page-fault-handling-first.patch added to mm-unstable branch
Message-Id: <20230314213153.925BDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: try VMA lock-based page fault handling first
has been added to the -mm mm-unstable branch.  Its filename is
     s390-mm-try-vma-lock-based-page-fault-handling-first.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-mm-try-vma-lock-based-page-fault-handling-first.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

s390-mm-try-vma-lock-based-page-fault-handling-first.patch

