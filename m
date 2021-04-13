Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE78C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C502613B7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhDMRjs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230234AbhDMRjr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Apr 2021 13:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B998361004;
        Tue, 13 Apr 2021 17:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618335567;
        bh=57JZ0JoE1EqereMvk3bToRpI1DNweInQ9zKLvQsec6o=;
        h=Date:From:To:Subject:From;
        b=O21y/+R1fUgPARwm7Cq8dHItWYAdzVYpZZ5PIFzkIS+QCX1aDnVOfL/0H0Y5A51Gr
         4QT6GcfvDgHl/H4k6q/d5a4nsSXUs/mItR/ZYMDd4ZxGmxuBd2VzLwRXQzxHUcX+Bl
         xhwmIKEIYOIxreT3ZgUHGpHmao8IXpq3ur2xvbRo=
Date:   Tue, 13 Apr 2021 10:39:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        osalvador@suse.de, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
Subject:  + mm-drop-redundant-arch_enable__migration-fix.patch added
 to -mm tree
Message-ID: <20210413173927.BqF-i%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-redundant-arch_enable__migration-fix
has been added to the -mm tree.  Its filename is
     mm-drop-redundant-arch_enable__migration-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-drop-redundant-arch_enable__migration-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-redundant-arch_enable__migration-fix.patch

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
Subject: mm-drop-redundant-arch_enable__migration-fix

s/X86_64/X86_64/, per Oscar

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig~mm-drop-redundant-arch_enable__migration-fix
+++ a/arch/x86/Kconfig
@@ -60,7 +60,7 @@ config X86
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
 	select ARCH_32BIT_OFF_T			if X86_32
 	select ARCH_CLOCKSOURCE_INIT
-	select ARCH_ENABLE_HUGEPAGE_MIGRATION if x86_64 && HUGETLB_PAGE && MIGRATION
+	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_THP_MIGRATION if x86_64 && TRANSPARENT_HUGEPAGE
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

