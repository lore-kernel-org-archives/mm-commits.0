Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5003DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 19:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243985AbiESTa1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 15:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234985AbiESTa0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 15:30:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0994C9B197
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 12:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9956D61BF4
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 19:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36E6C385AA;
        Thu, 19 May 2022 19:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652988625;
        bh=lils1ORm5cuw+7NLyJoeyoSD1jjholjSqSip4cVY6K8=;
        h=Date:To:From:Subject:From;
        b=RHD+kX6xl/QKvZbDROBzhupA6ehjZgdYEZqg3TyitUjFUfcgjKWAHN7B0d73C2xS8
         WQP9m2HMCqSu3bhBK/2Hcq0TcFa1nIQhcCwHys8xkjcBt/BbC5X2KjVdDNFY5yvdn/
         qLCSrekKeOzawyiF7H1RwMA7ZWCGqkXI/9+RktD8=
Date:   Thu, 19 May 2022 12:30:24 -0700
To:     mm-commits@vger.kernel.org, naveen.n.rao@linux.vnet.ibm.com,
        mpe@ellerman.id.au, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20220519193024.F36E6C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix
Date: Thu May 19 10:19:00 AM PDT 2022

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/kexec.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/include/asm/kexec.h~kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix
+++ a/arch/s390/include/asm/kexec.h
@@ -9,6 +9,8 @@
 #ifndef _S390_KEXEC_H
 #define _S390_KEXEC_H
 
+#include <linux/module.h>
+
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/setup.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch
mm-swap-add-helper-swap_offset_available-fix.patch
mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

