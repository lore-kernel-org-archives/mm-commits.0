Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FD4C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DE872087C
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927803;
	bh=DqwEo6mO4UlNALCVSRzCY1SXo1J7QUSn/LWgsUdv1og=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yLPMC8V/AaWnN8FMA1uExu3YIO7i1Bg+rvmnZXBA74gfhOuKjDc7Rzck115KidN4g
	 GGOTfrWKXbqvVI9MNwWdxGL06XTE/i75F85/810S2F11CkvZ8KHQmNqbVA8LGcj8Xl
	 D7Jb2aKOcT4Yc8eV+3llZGXeQbv+1LRtWzK+E6o0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgILQXV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgILQXU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:23:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 095E22083E;
        Sat, 12 Sep 2020 16:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927800;
        bh=DqwEo6mO4UlNALCVSRzCY1SXo1J7QUSn/LWgsUdv1og=;
        h=Date:From:To:Subject:From;
        b=zmyTb1YxObYZn3glJnqAb9S0XblRn4dbtx4sDfOsfAiTFbhVRClVj3IvEZbgKjJku
         q3iNsw/hM+QDQ1u9Hk2TbeUgu+D+TCIKGkzVQMfor6Ggvb+SwiN8iLnPBijCunwQxn
         4jYpcaKYGzAI7uNq24kxZaj6O/hPCx7ZXN/5XhGo=
Date:   Sat, 12 Sep 2020 09:23:19 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bp@suse.de, mliska@suse.cz,
        mm-commits@vger.kernel.org, ndesaulniers@google.com
Subject:  [obsolete] arch-x86-makefile-use-config_shell.patch
 removed from -mm tree
Message-ID: <20200912162319.UzBEHhxzt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/Makefile: use $(CONFIG_SHELL)
has been removed from the -mm tree.  Its filename was
     arch-x86-makefile-use-config_shell.patch

This patch was dropped because it is obsolete

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

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

