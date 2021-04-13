Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6CEC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 20:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8792D613CC
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 20:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348147AbhDMUBh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Apr 2021 16:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348144AbhDMUBg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Apr 2021 16:01:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4750613C8;
        Tue, 13 Apr 2021 20:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618344076;
        bh=OXCWAYOdqSmBPIFbx1sQOUdfTrlcYTo9LNAqklnJYQo=;
        h=Date:From:To:Subject:From;
        b=npbhEMBLbPYhJ/eyD6IsvzLo/svXFJ3Bqw4WJHn06iH7WYynuOWD00Xw3up49NMsI
         hmXT4YS2HVYrEexSP6N5WrsLhfdQkp01GLvHLlpbPv72qB14d1EoWjdzz9mNKO0EFk
         xEMqnjVK6WlZMRq4+SLoEugZ06PVR59DWOqg/Ric=
Date:   Tue, 13 Apr 2021 13:01:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        osalvador@suse.de, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
Subject:  + mm-drop-redundant-arch_enable__migration-fix-fix.patch
 added to -mm tree
Message-ID: <20210413200116.-T_6s%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-redundant-arch_enable__migration-fix-fix
has been added to the -mm tree.  Its filename is
     mm-drop-redundant-arch_enable__migration-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-drop-redundant-arch_enable__migration-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-redundant-arch_enable__migration-fix-fix.patch

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
Subject: mm-drop-redundant-arch_enable__migration-fix-fix

s/x86_64/X86_64/, per Oscar

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig~mm-drop-redundant-arch_enable__migration-fix-fix
+++ a/arch/x86/Kconfig
@@ -64,7 +64,7 @@ config X86
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if X86_64 || X86_PAE
-	select ARCH_ENABLE_THP_MIGRATION if x86_64 && TRANSPARENT_HUGEPAGE
+	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
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
mm-drop-redundant-arch_enable__migration-fix-fix.patch

