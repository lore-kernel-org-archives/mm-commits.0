Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431DFC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjDFDE5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjDFDEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F77977C
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D492F640CA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32ADBC433D2;
        Thu,  6 Apr 2023 03:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750237;
        bh=DFVAPR10d/YNYTJzpHGfcc5abW/xIH9VMZD+6ytURbQ=;
        h=Date:To:From:Subject:From;
        b=sGkP6SMweKBfoiDEW9YqPHwcJJqV5UuiC+JME1oQ5OU6rld/wdmrGcgPIHs0y8o6i
         tt/p/eJV1AxA3AtxMXM7XjLh3IdSjQYSzMw/kxKRQeJyfmZCDwRHBPPNiX4fabbKiB
         PR51bf2/J4dhT0qErLv86j9usMAqXwfC+Qq5Zjh0=
Date:   Wed, 05 Apr 2023 20:03:56 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-try-vma-lock-based-page-fault-handling-first.patch removed from -mm tree
Message-Id: <20230406030357.32ADBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64/mm: try VMA lock-based page fault handling first
has been removed from the -mm tree.  Its filename was
     arm64-mm-try-vma-lock-based-page-fault-handling-first.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: arm64/mm: try VMA lock-based page fault handling first
Date: Mon, 27 Feb 2023 09:36:29 -0800

Attempt VMA lock-based page fault handling first, and fall back to the
existing mmap_lock-based handling if that fails.

Link: https://lkml.kernel.org/r/20230227173632.3292573-31-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig    |    1 +
 arch/arm64/mm/fault.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

--- a/arch/arm64/Kconfig~arm64-mm-try-vma-lock-based-page-fault-handling-first
+++ a/arch/arm64/Kconfig
@@ -95,6 +95,7 @@ config ARM64
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
+	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_BPF_JIT
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
--- a/arch/arm64/mm/fault.c~arm64-mm-try-vma-lock-based-page-fault-handling-first
+++ a/arch/arm64/mm/fault.c
@@ -535,6 +535,9 @@ static int __kprobes do_page_fault(unsig
 	unsigned long vm_flags;
 	unsigned int mm_flags = FAULT_FLAG_DEFAULT;
 	unsigned long addr = untagged_addr(far);
+#ifdef CONFIG_PER_VMA_LOCK
+	struct vm_area_struct *vma;
+#endif
 
 	if (kprobe_page_fault(regs, esr))
 		return 0;
@@ -585,6 +588,36 @@ static int __kprobes do_page_fault(unsig
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 
+#ifdef CONFIG_PER_VMA_LOCK
+	if (!(mm_flags & FAULT_FLAG_USER))
+		goto lock_mmap;
+
+	vma = lock_vma_under_rcu(mm, addr);
+	if (!vma)
+		goto lock_mmap;
+
+	if (!(vma->vm_flags & vm_flags)) {
+		vma_end_read(vma);
+		goto lock_mmap;
+	}
+	fault = handle_mm_fault(vma, addr & PAGE_MASK,
+				mm_flags | FAULT_FLAG_VMA_LOCK, regs);
+	vma_end_read(vma);
+
+	if (!(fault & VM_FAULT_RETRY)) {
+		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
+		goto done;
+	}
+	count_vm_vma_lock_event(VMA_LOCK_RETRY);
+
+	/* Quick path to respond to signals */
+	if (fault_signal_pending(fault, regs)) {
+		if (!user_mode(regs))
+			goto no_context;
+		return 0;
+	}
+lock_mmap:
+#endif /* CONFIG_PER_VMA_LOCK */
 	/*
 	 * As per x86, we may deadlock here. However, since the kernel only
 	 * validly references user space from well defined areas of the code,
@@ -628,6 +661,9 @@ retry:
 	}
 	mmap_read_unlock(mm);
 
+#ifdef CONFIG_PER_VMA_LOCK
+done:
+#endif
 	/*
 	 * Handle the "normal" (no error) case first.
 	 */
_

Patches currently in -mm which might be from surenb@google.com are


