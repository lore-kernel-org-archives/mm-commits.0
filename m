Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B832C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1812C613CC
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhEEA6r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 20:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEEA6r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 20:58:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8138461078;
        Wed,  5 May 2021 00:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176270;
        bh=QToPGs7Z0oKVGEmMsVIgQ84DW+8hs0xKIXj4R5vpyVI=;
        h=Date:From:To:Subject:From;
        b=b3rMOrVbj3AMx09hZbmnV/ScVvGDm9eX6l1FTW6BAL9/LiptB3X9/pmg36l0Zl0TY
         atOKCPpgDqa30AtFWmIL32eHNrMb/ukW0UuBnoe7zq2L4gmBRz/mhDVnekDFowR3KN
         xbrydo3d3tpAio9oHdUQqTB3GXtAOvIJoHYbupg8=
Date:   Tue, 04 May 2021 17:57:50 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-drop-redundant-arch_enable__migration-fix.patch removed from -mm tree
Message-ID: <20210505005750.UcjRZq60K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-redundant-arch_enable__migration-fix
has been removed from the -mm tree.  Its filename was
     mm-drop-redundant-arch_enable__migration-fix.patch

This patch was dropped because it was folded into mm-drop-redundant-arch_enable__migration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-drop-redundant-arch_enable__migration-fix

s/x86_64/X86_64/, per Oscar

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

mm-drop-redundant-arch_enable__migration.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
mm.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

