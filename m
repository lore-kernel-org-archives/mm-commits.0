Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69B8CE79A8
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 16:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjISQbS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 12:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjISQbP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 12:31:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14867BF
        for <mm-commits@vger.kernel.org>; Tue, 19 Sep 2023 09:31:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDBAC433C8;
        Tue, 19 Sep 2023 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695141067;
        bh=ilzh93x3rbEkWiahNauMRjISWpXZCPxDYIsrQS1l0Yo=;
        h=Date:To:From:Subject:From;
        b=MbFoGmIfELnrth/WtFuZplnKhD+XY7UKEQNnxSAW71t8EtK+EUEs7a1MAwLDr/Nul
         JVUo1jfwHO2uEIhm3vyvuSp/3tES3wnt6ZoWfXqNbOEm7rtNl4lmsA6JZW5pbRD+00
         rDKBnPeO/h9qAc5oj47A6FZeFjfkwuIXugJQ34+Y=
Date:   Tue, 19 Sep 2023 09:31:06 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-extend-execmem_params-for-kprobes-allocations-fix.patch added to mm-unstable branch
Message-Id: <20230919163107.8FDBAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-extend-execmem_params-for-kprobes-allocations-fix
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-extend-execmem_params-for-kprobes-allocations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-extend-execmem_params-for-kprobes-allocations-fix.patch

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
From: Mike Rapoport <rppt@kernel.org>
Subject: powerpc-extend-execmem_params-for-kprobes-allocations-fix
Date: Tue, 19 Sep 2023 18:20:31 +0300

fix powerpc allocation failure

Link: https://lkml.kernel.org/r/20230919152031.GF3303@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20230919162518.180fd9f3@canb.auug.org.au
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/module.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/module.c~powerpc-extend-execmem_params-for-kprobes-allocations-fix
+++ a/arch/powerpc/kernel/module.c
@@ -138,8 +138,8 @@ struct execmem_params __init *execmem_ar
 
 	range->pgprot = prot;
 
-	execmem_params.ranges[EXECMEM_KPROBES].start = VMALLOC_START;
-	execmem_params.ranges[EXECMEM_KPROBES].start = VMALLOC_END;
+	execmem_params.ranges[EXECMEM_KPROBES].start = range->start;
+	execmem_params.ranges[EXECMEM_KPROBES].end = range->end;
 
 	if (strict_module_rwx_enabled())
 		execmem_params.ranges[EXECMEM_KPROBES].pgprot = PAGE_KERNEL_ROX;
_

Patches currently in -mm which might be from rppt@kernel.org are

nios2-define-virtual-address-space-for-modules.patch
mm-introduce-execmem_text_alloc-and-execmem_free.patch
mm-execmem-arch-convert-simple-overrides-of-module_alloc-to-execmem.patch
mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem.patch
modules-execmem-drop-module_alloc.patch
mm-execmem-introduce-execmem_data_alloc.patch
arm64-execmem-extend-execmem_params-for-generated-code-allocations.patch
riscv-extend-execmem_params-for-generated-code-allocations.patch
powerpc-extend-execmem_params-for-kprobes-allocations.patch
powerpc-extend-execmem_params-for-kprobes-allocations-fix.patch
arch-make-execmem-setup-available-regardless-of-config_modules.patch
x86-ftrace-enable-dynamic-ftrace-without-config_modules.patch
kprobes-remove-dependency-on-config_modules.patch
bpf-remove-config_bpf_jit-dependency-on-config_modules-of.patch

