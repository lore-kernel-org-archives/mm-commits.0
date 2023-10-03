Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB00E7AD75
	for <mm-commits@archiver.kernel.org>; Tue,  3 Oct 2023 16:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbjJCQCR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Oct 2023 12:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240191AbjJCQCP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2023 12:02:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C313C11C
        for <mm-commits@vger.kernel.org>; Tue,  3 Oct 2023 09:02:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEF1C433C8;
        Tue,  3 Oct 2023 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696348920;
        bh=fqREsnKtBFDTIIVVTtHpT+m47s31I/q6FoVpzwIY4JE=;
        h=Date:To:From:Subject:From;
        b=vJyimjWByCVE7G3VlFIwxGD7yhUI2HbJEks6AWwyJgSvTXEFCbDXJ0T8YOkp/szN2
         sP7lRzTPq9c/gkI7InPyUJ1AOPLvBQ4JmXG+n7TRPJ6sUbbWuqAkfAfiiXqqEgpqn5
         pmhhvDGGVACYQuKlETj/jnL8B913bCZ8bVFpiwzM=
Date:   Tue, 03 Oct 2023 09:01:59 -0700
To:     mm-commits@vger.kernel.org, paul.walmsley@sifive.com,
        panqinglin2020@iscas.ac.cn, palmer@dabbelt.com, conor@kernel.org,
        aou@eecs.berkeley.edu, ajones@ventanamicro.com,
        alexghiti@rivosinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-handle-vm_fault_-faults-instead-of-panicking.patch added to mm-hotfixes-unstable branch
Message-Id: <20231003160200.3FEF1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: handle VM_FAULT_[HWPOISON|HWPOISON_LARGE] faults instead of panicking
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     riscv-handle-vm_fault_-faults-instead-of-panicking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-handle-vm_fault_-faults-instead-of-panicking.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: riscv: handle VM_FAULT_[HWPOISON|HWPOISON_LARGE] faults instead of panicking
Date: Thu, 28 Sep 2023 17:18:45 +0200

Patch series "Fix set_huge_pte_at()".

A recent report [1] from Ryan for arm64 revealed that we do not handle
swap entries when setting a hugepage backed by a NAPOT region (the contpte
riscv equivalent).

As explained in [1], the issue was discovered by a new test in kselftest
which uses poison entries, but the symptoms are different from arm64 though:

- the riscv kernel bugs because we do not handle VM_FAULT_HWPOISON*,
  this is fixed by patch 1,
- after that, the test passes because the first pte_napot() fails (the
  poison entry does not have the N bit set), and then we only set the
  first page table entry covering the NAPOT hugepage, which is enough
  for hugetlb_fault() to correctly raise a VM_FAULT_HWPOISON wherever we
  write in this mapping since only this first page table entry is
  checked
  (see https://elixir.bootlin.com/linux/v6.6-rc3/source/mm/hugetlb.c#L6071).
  But this seems fragile so patch 2 sets all page table entries of a
  NAPOT mapping.

[1]: https://lore.kernel.org/linux-arm-kernel/20230922115804.2043771-1-ryan.roberts@arm.com/


This patch (of 2):

We used to panic when such faults were encountered but we should handle
those faults gracefully for userspace by sending a SIGBUS to the process,
like most architectures do.

Link: https://lkml.kernel.org/r/20230928151846.8229-1-alexghiti@rivosinc.com
Link: https://lkml.kernel.org/r/20230928151846.8229-2-alexghiti@rivosinc.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Qinglin Pan <panqinglin2020@iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/mm/fault.c~riscv-handle-vm_fault_-faults-instead-of-panicking
+++ a/arch/riscv/mm/fault.c
@@ -72,7 +72,7 @@ static inline void mm_fault_error(struct
 		}
 		pagefault_out_of_memory();
 		return;
-	} else if (fault & VM_FAULT_SIGBUS) {
+	} else if (fault & (VM_FAULT_SIGBUS | VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE)) {
 		/* Kernel mode? Handle exceptions or die */
 		if (!user_mode(regs)) {
 			no_context(regs, addr);
_

Patches currently in -mm which might be from alexghiti@rivosinc.com are

riscv-handle-vm_fault_-faults-instead-of-panicking.patch
riscv-fix-set_huge_pte_at-for-napot-mappings-when-a-swap-entry-is-set.patch

