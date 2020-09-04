Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBA2C28E83
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 06:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 533B920748
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 06:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599200987;
	bh=DaUw9EEPXCFzT4tQfQQvfyhuBeVPIuNOkbpmnWZteK4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dSnJUBLyE3wp5Kyts3s3ApEGKxngYHBIQgrlJm53qXL5mszdPeGgdn3fyt6ZLUu+t
	 UpYR/Y+Nvl0O2eGANae+QGcZx/yKMxa43t7j4YE/D1+AYC1Y9asJfD3EpjCnYrD+97
	 HvXYtHJieWfVb1zyoUY9AEbEyBwyOZR1tnxVNDss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgIDG3q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 02:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgIDG3o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 02:29:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25833206A5;
        Fri,  4 Sep 2020 06:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599200984;
        bh=DaUw9EEPXCFzT4tQfQQvfyhuBeVPIuNOkbpmnWZteK4=;
        h=Date:From:To:Subject:From;
        b=WbHACOZ1JJOGEGNf5ScvyxrJbpYeHJ48+/yw6xtUe8XMYr1hJCJBAvvw/PVek92s2
         xPfy8FNVg7CPRnlwFwdKoTWSbcdQtRpUsR8n06pfhae8zquGA7lRVMqwAOJgaD2y8q
         4Qv6/oAkJ2xi/Zb7QK+eeIPfjlkzvlmdtuLtVGI8=
Date:   Thu, 03 Sep 2020 23:29:43 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bp@suse.de, mliska@suse.cz,
        mm-commits@vger.kernel.org, ndesaulniers@google.com
Subject:  + arch-x86-makefile-use-config_shell.patch added to -mm
 tree
Message-ID: <20200904062943.A5iMzUm1q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/Makefile: use $(CONFIG_SHELL)
has been added to the -mm tree.  Its filename is
     arch-x86-makefile-use-config_shell.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-makefile-use-config_shell.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-makefile-use-config_shell.patch

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
Subject: arch/x86/Makefile: use $(CONFIG_SHELL)

Fix this:

y:/usr/src/25> make mrproper
make: execvp: ./scripts/x86-check-compiler.sh: Permission denied

Fixes: 73da86741e7f75 ("x86/build: Check whether the compiler is sane")
Cc: Martin Lika <mliska@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Makefile~arch-x86-makefile-use-config_shell
+++ a/arch/x86/Makefile
@@ -2,7 +2,7 @@
 # Unified Makefile for i386 and x86_64
 
 #  Check the compiler
-sane_compiler := $(shell $(srctree)/scripts/x86-check-compiler.sh $(CC))
+sane_compiler := $($(CONFIG_SHELL) $(srctree)/scripts/x86-check-compiler.sh $(CC))
 $(if $(sane_compiler),$(error $(CC) check failed. Aborting),)
 
 # select defconfig based on actual architecture
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
arch-x86-makefile-use-config_shell.patch
kernel-forkc-export-kernel_thread-to-modules.patch

