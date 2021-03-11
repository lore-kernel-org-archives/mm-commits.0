Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2838C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B31C764FCD
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhCKAvP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:51:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhCKAvF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 19:51:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 066FA64FC0;
        Thu, 11 Mar 2021 00:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615423865;
        bh=XoJ32CQ6s+2wytkG8HWlUG2rj/LWK3Nsipvz6mZrqbY=;
        h=Date:From:To:Subject:From;
        b=GVIsysK8v0HcVlGoNd6RGhNuf34A7kqzwAAkQFlCqq0cCVFdGGEZTE8TDN4XnbtmU
         1lpqrPBa6wG2B8Ns2LiczhDuMMQoUC1vxUqD+mjDYk7aZvgIMgBgTM+xWTL6kBB/dZ
         te2omUsNWoftOYlK3MmuLtlPNDyjGPRZIEoyX+dw=
Date:   Wed, 10 Mar 2021 16:51:04 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  +
 x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch added to -mm
 tree
Message-ID: <20210311005104.Yqa6nSjec%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
has been added to the -mm tree.  Its filename is
     x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: x86/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE

Enable x86_64 platform to use the MHP_MEMMAP_ON_MEMORY feature.

Link: https://lkml.kernel.org/r/20210309175546.5877-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/Kconfig~x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable
+++ a/arch/x86/Kconfig
@@ -2434,6 +2434,9 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 	depends on MEMORY_HOTPLUG
 
+config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+	def_bool y
+
 config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

