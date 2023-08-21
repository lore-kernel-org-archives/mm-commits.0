Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7608EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjHUUmI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjHUUlK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E38E46
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1198A61806
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60690C433C7;
        Mon, 21 Aug 2023 20:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650447;
        bh=/z4Qzfo3EhHMFejLFfECl8MaHNQ3zb129GBo7zG5hv4=;
        h=Date:To:From:Subject:From;
        b=RXjqvNp2UIIda5QdMGcthyqW4RtXpYAkomz/JZMOXUMP0x8EFh54gN0jEq4FT1b0e
         zajIRu5mrNlHbOIcl9kw8y9nwHPpAQzUtaFjsc92qIOi+q9Bue+1Tq2a6k7Eu0NFRs
         azqezt3jgdM5SvHfX/3GPif3DrxA6nU3sXrZR9Hc=
Date:   Mon, 21 Aug 2023 13:40:46 -0700
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        osalvador@suse.de, npiggin@gmail.com, mpe@ellerman.id.au,
        mhocko@suse.com, david@redhat.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch removed from -mm tree
Message-Id: <20230821204047.60690C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: simplify ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE kconfig
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/memory_hotplug: simplify ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE kconfig
Date: Tue, 8 Aug 2023 14:44:56 +0530

Patch series "Add support for memmap on memory feature on ppc64", v8.

This patch series update memmap on memory feature to fall back to
memmap allocation outside the memory block if the alignment rules are
not met. This makes the feature more useful on architectures like
ppc64 where alignment rules are different with 64K page size.


This patch (of 6):

Instead of adding menu entry with all supported architectures, add
mm/Kconfig variable and select the same from supported architectures.

No functional change in this patch.

Link: https://lkml.kernel.org/r/20230808091501.287660-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20230808091501.287660-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    4 +---
 arch/x86/Kconfig   |    4 +---
 mm/Kconfig         |    3 +++
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/arch/arm64/Kconfig~mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig
+++ a/arch/arm64/Kconfig
@@ -78,6 +78,7 @@ config ARM64
 	select ARCH_INLINE_SPIN_UNLOCK_IRQ if !PREEMPTION
 	select ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE if !PREEMPTION
 	select ARCH_KEEP_MEMBLOCK
+	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_GNU_PROPERTY
 	select ARCH_USE_MEMTEST
@@ -349,9 +350,6 @@ config GENERIC_CSUM
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
-	def_bool y
-
 config SMP
 	def_bool y
 
--- a/arch/x86/Kconfig~mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig
+++ a/arch/x86/Kconfig
@@ -102,6 +102,7 @@ config X86
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
@@ -2610,9 +2611,6 @@ config ARCH_HAS_ADD_PAGES
 	def_bool y
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
 
-config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
-	def_bool y
-
 menu "Power management and ACPI options"
 
 config ARCH_HIBERNATION_HEADER
--- a/mm/Kconfig~mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig
+++ a/mm/Kconfig
@@ -571,6 +571,9 @@ config MHP_MEMMAP_ON_MEMORY
 
 endif # MEMORY_HOTPLUG
 
+config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+       bool
+
 # Heavily threaded applications may benefit from splitting the mm-wide
 # page_table_lock, so that faults on different parts of the user address
 # space can be handled with less contention: split it at this NR_CPUS.
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


