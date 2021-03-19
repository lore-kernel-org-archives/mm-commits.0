Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E902C433E2
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA2961986
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhCSQsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhCSQrm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 12:47:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2834561942;
        Fri, 19 Mar 2021 16:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616172462;
        bh=eYuSYVKhJme1VhZPRJqbkyPMIcmLxkNDzZPIiUolHPU=;
        h=Date:From:To:Subject:From;
        b=QGcO2gFsRTAqUkYCdyeIgVqp7QGk2apxgX3B/Ls5VHAPmG52y9l+r1pKSsJdIIE4F
         zi2jPiEczEaRnHNchqaKesYvNJl7Wgdh/fT9t+SXFq+BdvfkOx52Rg0cudO/G6ZBWQ
         PsF3L0ToThwS/4QEzsp21axgp6m/eM+o1bDgM0XQ=
Date:   Fri, 19 Mar 2021 09:47:41 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de
Subject:  +
 arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch added to -mm
 tree
Message-ID: <20210319164741.5RDFaRw78%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
has been added to the -mm tree.  Its filename is
     arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

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
Subject: arm64/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE

Enable arm64 platform to use the MHP_MEMMAP_ON_MEMORY feature.

Link: https://lkml.kernel.org/r/20210319092635.6214-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/Kconfig~arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable
+++ a/arch/arm64/Kconfig
@@ -310,6 +310,9 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 
+config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+	def_bool y
+
 config SMP
 	def_bool y
 
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

