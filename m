Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD389C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbjDFDFB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234876AbjDFDEN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD7E93E4
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAE0564174
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EFAC433EF;
        Thu,  6 Apr 2023 03:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750238;
        bh=RkK+T5zYHC5GJiX8cQW91WOLF/H8gFhAfm5qLMIi+Nw=;
        h=Date:To:From:Subject:From;
        b=uSBmfaFhNgkHrqS5yCF1856B2Bd2I4YiHiFhQa2z6Fod6Wws0C+ihT1YcKl4ZvcSY
         TMzNaVKYFi84jIpXBI2unbItvjyEgUbhsRaM4jY/JbXnbcjJhWBzN3Q8UxVMaMDNPu
         yPaUX9HdNjbkgOJM6n6VWE9ZWu3cf6sDTedhWG7Y=
Date:   Wed, 05 Apr 2023 20:03:57 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        sachinp@linux.ibm.com, ldufour@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerc-mm-try-vma-lock-based-page-fault-handling-first.patch removed from -mm tree
Message-Id: <20230406030358.42EFAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerc/mm: try VMA lock-based page fault handling first
has been removed from the -mm tree.  Its filename was
     powerc-mm-try-vma-lock-based-page-fault-handling-first.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.ibm.com>
Subject: powerc/mm: try VMA lock-based page fault handling first
Date: Mon, 27 Feb 2023 09:36:30 -0800

Attempt VMA lock-based page fault handling first, and fall back to the
existing mmap_lock-based handling if that fails.  Copied from "x86/mm: try
VMA lock-based page fault handling first"

[ldufour@linux.ibm.com: powerpc/mm: fix mmap_lock bad unlock]
  Link: https://lkml.kernel.org/r/20230306154244.17560-1-ldufour@linux.ibm.com
  Link: https://lore.kernel.org/linux-mm/842502FB-F99C-417C-9648-A37D0ECDC9CE@linux.ibm.com
Link: https://lkml.kernel.org/r/20230227173632.3292573-32-surenb@google.com
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/fault.c                |   37 +++++++++++++++++++++++
 arch/powerpc/platforms/powernv/Kconfig |    1 
 arch/powerpc/platforms/pseries/Kconfig |    1 
 3 files changed, 39 insertions(+)

--- a/arch/powerpc/mm/fault.c~powerc-mm-try-vma-lock-based-page-fault-handling-first
+++ a/arch/powerpc/mm/fault.c
@@ -474,6 +474,40 @@ static int ___do_page_fault(struct pt_re
 	if (is_exec)
 		flags |= FAULT_FLAG_INSTRUCTION;
 
+#ifdef CONFIG_PER_VMA_LOCK
+	if (!(flags & FAULT_FLAG_USER))
+		goto lock_mmap;
+
+	vma = lock_vma_under_rcu(mm, address);
+	if (!vma)
+		goto lock_mmap;
+
+	if (unlikely(access_pkey_error(is_write, is_exec,
+				       (error_code & DSISR_KEYFAULT), vma))) {
+		vma_end_read(vma);
+		goto lock_mmap;
+	}
+
+	if (unlikely(access_error(is_write, is_exec, vma))) {
+		vma_end_read(vma);
+		goto lock_mmap;
+	}
+
+	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs);
+	vma_end_read(vma);
+
+	if (!(fault & VM_FAULT_RETRY)) {
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		goto done;
+	}
+	count_vm_vma_lock_event(VMA_LOCK_RETRY);
+
+	if (fault_signal_pending(fault, regs))
+		return user_mode(regs) ? 0 : SIGBUS;
+
+lock_mmap:
+#endif /* CONFIG_PER_VMA_LOCK */
+
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
@@ -550,6 +584,9 @@ retry:
 
 	mmap_read_unlock(current->mm);
 
+#ifdef CONFIG_PER_VMA_LOCK
+done:
+#endif
 	if (unlikely(fault & VM_FAULT_ERROR))
 		return mm_fault_error(regs, address, fault);
 
--- a/arch/powerpc/platforms/powernv/Kconfig~powerc-mm-try-vma-lock-based-page-fault-handling-first
+++ a/arch/powerpc/platforms/powernv/Kconfig
@@ -16,6 +16,7 @@ config PPC_POWERNV
 	select PPC_DOORBELL
 	select MMU_NOTIFIER
 	select FORCE_SMP
+	select ARCH_SUPPORTS_PER_VMA_LOCK
 	default y
 
 config OPAL_PRD
--- a/arch/powerpc/platforms/pseries/Kconfig~powerc-mm-try-vma-lock-based-page-fault-handling-first
+++ a/arch/powerpc/platforms/pseries/Kconfig
@@ -22,6 +22,7 @@ config PPC_PSERIES
 	select HOTPLUG_CPU
 	select FORCE_SMP
 	select SWIOTLB
+	select ARCH_SUPPORTS_PER_VMA_LOCK
 	default y
 
 config PARAVIRT
_

Patches currently in -mm which might be from ldufour@linux.ibm.com are


