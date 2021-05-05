Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06632C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8E1B613D8
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 00:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhEEA6t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 20:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEEA6t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 20:58:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCA1D613CB;
        Wed,  5 May 2021 00:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176273;
        bh=c4CZqfpNvYGqIJhMh87DnoHVYzcb3ahmnDBM5i65nlU=;
        h=Date:From:To:Subject:From;
        b=pLivvJU6lT4+/V9dyyKXXbxyMhuRis2+jBQTmhumrFWWmwVRKMTkrer1+mNFrtF8w
         EULuEzW3Lkocj9yfkWhafMLVpyw6M1ETOLeJmC/1EBzS9RK8XU971wWCqmAiHp+sXD
         cYyKuOx4zrB82wP8DZxWDzUb10pyr67YoVassoJI=
Date:   Tue, 04 May 2021 17:57:52 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-drop-redundant-arch_enable__migration-fix-fix.patch removed from -mm
 tree
Message-ID: <20210505005752.4IbzW3F29%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-redundant-arch_enable__migration-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-drop-redundant-arch_enable__migration-fix-fix.patch

This patch was dropped because it was folded into mm-drop-redundant-arch_enable__migration.patch

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
@@ -63,7 +63,7 @@ config X86
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64 || (X86_32 && HIGHMEM)
 	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
-	select ARCH_ENABLE_THP_MIGRATION if x86_64 && TRANSPARENT_HUGEPAGE
+	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_DEBUG_VIRTUAL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-drop-redundant-arch_enable__migration.patch
mm.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

