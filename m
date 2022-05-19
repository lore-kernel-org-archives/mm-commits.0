Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ABF1C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiESW2C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245498AbiESWZ5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BB314092
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D958DB828C1
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D3FC385AA;
        Thu, 19 May 2022 22:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999150;
        bh=y7waQ1TMOXWc9dBbIvKclxGA54e0CsuQeNF9T5YGMpQ=;
        h=Date:To:From:Subject:From;
        b=J74wex/weReppryPGGSsvBYzPLZmAx5wC+rSzYW8XMvQ4+H78SlVHmGDH3cyqseiQ
         m7z1u3o03cQdm5MOZ8W6MKvGm9GT2Uel+6/mS7FzdgnKHXI8O7wiYcmmtPhbAD0TUz
         iGOsAFcsUMTlTHtK4j7sZIjMZzw+vVK8QT0birJw=
Date:   Thu, 19 May 2022 15:25:50 -0700
To:     mm-commits@vger.kernel.org, sjenning@redhat.com,
        shakeelb@google.com, minchan@kernel.org, mhocko@suse.com,
        guro@fb.com, ddstreet@ieee.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch removed from -mm tree
Message-Id: <20220519222550.93D3FC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: Kconfig: move swap and slab config options to the MM section
has been removed from the -mm tree.  Its filename was
     mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: Kconfig: move swap and slab config options to the MM section

These are currently under General Setup. MM seems like a better fit.

Link: https://lkml.kernel.org/r/20220510152847.230957-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |  123 -------------------------------------------------
 mm/Kconfig   |  123 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 123 deletions(-)

--- a/init/Kconfig~mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section
+++ a/init/Kconfig
@@ -352,23 +352,6 @@ config DEFAULT_HOSTNAME
 	  but you may wish to use a different default here to make a minimal
 	  system more usable with less configuration.
 
-#
-# For some reason microblaze and nios2 hard code SWAP=n.  Hopefully we can
-# add proper SWAP support to them, in which case this can be remove.
-#
-config ARCH_NO_SWAP
-	bool
-
-config SWAP
-	bool "Support for paging of anonymous memory (swap)"
-	depends on MMU && BLOCK && !ARCH_NO_SWAP
-	default y
-	help
-	  This option allows you to choose whether you want to have support
-	  for so called swap devices or swap files in your kernel that are
-	  used to provide more virtual memory than the actual RAM present
-	  in your computer.  If unsure say Y.
-
 config SYSVIPC
 	bool "System V IPC"
 	help
@@ -1876,112 +1859,6 @@ config COMPAT_BRK
 
 	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
 
-choice
-	prompt "Choose SLAB allocator"
-	default SLUB
-	help
-	   This option allows to select a slab allocator.
-
-config SLAB
-	bool "SLAB"
-	depends on !PREEMPT_RT
-	select HAVE_HARDENED_USERCOPY_ALLOCATOR
-	help
-	  The regular slab allocator that is established and known to work
-	  well in all environments. It organizes cache hot objects in
-	  per cpu and per node queues.
-
-config SLUB
-	bool "SLUB (Unqueued Allocator)"
-	select HAVE_HARDENED_USERCOPY_ALLOCATOR
-	help
-	   SLUB is a slab allocator that minimizes cache line usage
-	   instead of managing queues of cached objects (SLAB approach).
-	   Per cpu caching is realized using slabs of objects instead
-	   of queues of objects. SLUB can use memory efficiently
-	   and has enhanced diagnostics. SLUB is the default choice for
-	   a slab allocator.
-
-config SLOB
-	depends on EXPERT
-	bool "SLOB (Simple Allocator)"
-	depends on !PREEMPT_RT
-	help
-	   SLOB replaces the stock allocator with a drastically simpler
-	   allocator. SLOB is generally more space efficient but
-	   does not perform as well on large systems.
-
-endchoice
-
-config SLAB_MERGE_DEFAULT
-	bool "Allow slab caches to be merged"
-	default y
-	depends on SLAB || SLUB
-	help
-	  For reduced kernel memory fragmentation, slab caches can be
-	  merged when they share the same size and other characteristics.
-	  This carries a risk of kernel heap overflows being able to
-	  overwrite objects from merged caches (and more easily control
-	  cache layout), which makes such heap attacks easier to exploit
-	  by attackers. By keeping caches unmerged, these kinds of exploits
-	  can usually only damage objects in the same cache. To disable
-	  merging at runtime, "slab_nomerge" can be passed on the kernel
-	  command line.
-
-config SLAB_FREELIST_RANDOM
-	bool "Randomize slab freelist"
-	depends on SLAB || SLUB
-	help
-	  Randomizes the freelist order used on creating new pages. This
-	  security feature reduces the predictability of the kernel slab
-	  allocator against heap overflows.
-
-config SLAB_FREELIST_HARDENED
-	bool "Harden slab freelist metadata"
-	depends on SLAB || SLUB
-	help
-	  Many kernel heap attacks try to target slab cache metadata and
-	  other infrastructure. This options makes minor performance
-	  sacrifices to harden the kernel slab allocator against common
-	  freelist exploit methods. Some slab implementations have more
-	  sanity-checking than others. This option is most effective with
-	  CONFIG_SLUB.
-
-config SHUFFLE_PAGE_ALLOCATOR
-	bool "Page allocator randomization"
-	default SLAB_FREELIST_RANDOM && ACPI_NUMA
-	help
-	  Randomization of the page allocator improves the average
-	  utilization of a direct-mapped memory-side-cache. See section
-	  5.2.27 Heterogeneous Memory Attribute Table (HMAT) in the ACPI
-	  6.2a specification for an example of how a platform advertises
-	  the presence of a memory-side-cache. There are also incidental
-	  security benefits as it reduces the predictability of page
-	  allocations to compliment SLAB_FREELIST_RANDOM, but the
-	  default granularity of shuffling on the "MAX_ORDER - 1" i.e,
-	  10th order of pages is selected based on cache utilization
-	  benefits on x86.
-
-	  While the randomization improves cache utilization it may
-	  negatively impact workloads on platforms without a cache. For
-	  this reason, by default, the randomization is enabled only
-	  after runtime detection of a direct-mapped memory-side-cache.
-	  Otherwise, the randomization may be force enabled with the
-	  'page_alloc.shuffle' kernel command line parameter.
-
-	  Say Y if unsure.
-
-config SLUB_CPU_PARTIAL
-	default y
-	depends on SLUB && SMP
-	bool "SLUB per cpu partial cache"
-	help
-	  Per cpu partial caches accelerate objects allocation and freeing
-	  that is local to a processor at the price of more indeterminism
-	  in the latency of the free. On overflow these caches will be cleared
-	  which requires the taking of locks that may cause latency spikes.
-	  Typically one would choose no for a realtime system.
-
 config MMAP_ALLOW_UNINITIALIZED
 	bool "Allow mmapped anonymous memory to be uninitialized"
 	depends on EXPERT && !MMU
--- a/mm/Kconfig~mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section
+++ a/mm/Kconfig
@@ -2,6 +2,129 @@
 
 menu "Memory Management options"
 
+#
+# For some reason microblaze and nios2 hard code SWAP=n.  Hopefully we can
+# add proper SWAP support to them, in which case this can be remove.
+#
+config ARCH_NO_SWAP
+	bool
+
+config SWAP
+	bool "Support for paging of anonymous memory (swap)"
+	depends on MMU && BLOCK && !ARCH_NO_SWAP
+	default y
+	help
+	  This option allows you to choose whether you want to have support
+	  for so called swap devices or swap files in your kernel that are
+	  used to provide more virtual memory than the actual RAM present
+	  in your computer.  If unsure say Y.
+
+choice
+	prompt "Choose SLAB allocator"
+	default SLUB
+	help
+	   This option allows to select a slab allocator.
+
+config SLAB
+	bool "SLAB"
+	depends on !PREEMPT_RT
+	select HAVE_HARDENED_USERCOPY_ALLOCATOR
+	help
+	  The regular slab allocator that is established and known to work
+	  well in all environments. It organizes cache hot objects in
+	  per cpu and per node queues.
+
+config SLUB
+	bool "SLUB (Unqueued Allocator)"
+	select HAVE_HARDENED_USERCOPY_ALLOCATOR
+	help
+	   SLUB is a slab allocator that minimizes cache line usage
+	   instead of managing queues of cached objects (SLAB approach).
+	   Per cpu caching is realized using slabs of objects instead
+	   of queues of objects. SLUB can use memory efficiently
+	   and has enhanced diagnostics. SLUB is the default choice for
+	   a slab allocator.
+
+config SLOB
+	depends on EXPERT
+	bool "SLOB (Simple Allocator)"
+	depends on !PREEMPT_RT
+	help
+	   SLOB replaces the stock allocator with a drastically simpler
+	   allocator. SLOB is generally more space efficient but
+	   does not perform as well on large systems.
+
+endchoice
+
+config SLAB_MERGE_DEFAULT
+	bool "Allow slab caches to be merged"
+	default y
+	depends on SLAB || SLUB
+	help
+	  For reduced kernel memory fragmentation, slab caches can be
+	  merged when they share the same size and other characteristics.
+	  This carries a risk of kernel heap overflows being able to
+	  overwrite objects from merged caches (and more easily control
+	  cache layout), which makes such heap attacks easier to exploit
+	  by attackers. By keeping caches unmerged, these kinds of exploits
+	  can usually only damage objects in the same cache. To disable
+	  merging at runtime, "slab_nomerge" can be passed on the kernel
+	  command line.
+
+config SLAB_FREELIST_RANDOM
+	bool "Randomize slab freelist"
+	depends on SLAB || SLUB
+	help
+	  Randomizes the freelist order used on creating new pages. This
+	  security feature reduces the predictability of the kernel slab
+	  allocator against heap overflows.
+
+config SLAB_FREELIST_HARDENED
+	bool "Harden slab freelist metadata"
+	depends on SLAB || SLUB
+	help
+	  Many kernel heap attacks try to target slab cache metadata and
+	  other infrastructure. This options makes minor performance
+	  sacrifices to harden the kernel slab allocator against common
+	  freelist exploit methods. Some slab implementations have more
+	  sanity-checking than others. This option is most effective with
+	  CONFIG_SLUB.
+
+config SHUFFLE_PAGE_ALLOCATOR
+	bool "Page allocator randomization"
+	default SLAB_FREELIST_RANDOM && ACPI_NUMA
+	help
+	  Randomization of the page allocator improves the average
+	  utilization of a direct-mapped memory-side-cache. See section
+	  5.2.27 Heterogeneous Memory Attribute Table (HMAT) in the ACPI
+	  6.2a specification for an example of how a platform advertises
+	  the presence of a memory-side-cache. There are also incidental
+	  security benefits as it reduces the predictability of page
+	  allocations to compliment SLAB_FREELIST_RANDOM, but the
+	  default granularity of shuffling on the "MAX_ORDER - 1" i.e,
+	  10th order of pages is selected based on cache utilization
+	  benefits on x86.
+
+	  While the randomization improves cache utilization it may
+	  negatively impact workloads on platforms without a cache. For
+	  this reason, by default, the randomization is enabled only
+	  after runtime detection of a direct-mapped memory-side-cache.
+	  Otherwise, the randomization may be force enabled with the
+	  'page_alloc.shuffle' kernel command line parameter.
+
+	  Say Y if unsure.
+
+config SLUB_CPU_PARTIAL
+	default y
+	depends on SLUB && SMP
+	bool "SLUB per cpu partial cache"
+	help
+	  Per cpu partial caches accelerate objects allocation and freeing
+	  that is local to a processor at the price of more indeterminism
+	  in the latency of the free. On overflow these caches will be cleared
+	  which requires the taking of locks that may cause latency spikes.
+	  Typically one would choose no for a realtime system.
+
 config SELECT_MEMORY_MODEL
 	def_bool y
 	depends on ARCH_SELECT_MEMORY_MODEL
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

