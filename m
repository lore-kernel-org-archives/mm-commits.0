Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1DE3594A
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 02:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756348984; cv=none; b=lg7F9Y7OStuFCNi6Pi6MAdcHOH81tHwUBIdhmCLCAp/yOhLom1VLyKqIhqtCyyXmup/V5ABGPqoo+R3s/07C+AKsRULAxgnTMf4a3Saned5uITr5QsX206fsFIDkvpzCEnJoyEc31cjT3tr1o2do/LuW9CXi7Sv59o0+ODCXAWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756348984; c=relaxed/simple;
	bh=o0XvfiFmvlKZgxtaQgh2oZoUOXGjgp03e38NgQtTbVU=;
	h=Date:To:From:Subject:Message-Id; b=BgmQGwhkrsaPDPwapcuNN/ZSZu3QxVW2jDvQDQA4HiryVLiAm2rq6aK5YiiMgSHvvJMoYYZ3j9klUPPISSSHZau9Dqvtggt31mVyDED+946aph484dua+moCxK7Fkz7OdXXS79IJkjBqvXutVSAL1xbO9JWjPtQX/ePuZAa3nXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oWYv7LTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oWYv7LTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4AEC4CEEB;
	Thu, 28 Aug 2025 02:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756348983;
	bh=o0XvfiFmvlKZgxtaQgh2oZoUOXGjgp03e38NgQtTbVU=;
	h=Date:To:From:Subject:From;
	b=oWYv7LTOXxxM+gCl4Ib0Ymh6x0bpOnZmyPLk4vtpvlndO03JmD0s+VC6OkCIE+OVv
	 JxjGeYNw0UHRX238bE8k1zgZqZr1UXPjnE0dUW4MQhp+PDwmJfZtLA9LVn9PY44zGk
	 hl53GxhMpGm0IhzqU6sUAHoXtB3pvkhGn/hmdOng=
Date: Wed, 27 Aug 2025 19:43:02 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch removed from -mm tree
Message-Id: <20250828024303.6E4AEC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT
has been removed from the -mm tree.  Its filename was
     memblock-fix-kernel-doc-for-memblock_rsrv_noinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT
Date: Tue, 26 Aug 2025 10:19:46 +0300

The kernel-doc description of MEMBLOCK_RSRV_NOINIT and
memblock_reserved_mark_noinit() do not accurately describe their
functionality.

Expand their kernel doc to make it clear that the user of
MEMBLOCK_RSRV_NOINIT is responsible to properly initialize the struct
pages for such regions and add more details about effects of using this
flag.

Link: https://lkml.kernel.org/r/20250826071947.1949725-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    5 +++--
 mm/memblock.c            |   15 +++++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/include/linux/memblock.h~memblock-fix-kernel-doc-for-memblock_rsrv_noinit
+++ a/include/linux/memblock.h
@@ -40,8 +40,9 @@ extern unsigned long long max_possible_p
  * via a driver, and never indicated in the firmware-provided memory map as
  * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
  * kernel resource tree.
- * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
- * not initialized (only for reserved regions).
+ * @MEMBLOCK_RSRV_NOINIT: reserved memory region for which struct pages are not
+ * fully initialized. Users of this flag are responsible to properly initialize
+ * struct pages of this region
  * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
  * either explictitly with memblock_reserve_kern() or via memblock
  * allocation APIs. All memblock allocations set this flag.
--- a/mm/memblock.c~memblock-fix-kernel-doc-for-memblock_rsrv_noinit
+++ a/mm/memblock.c
@@ -1091,13 +1091,20 @@ int __init_memblock memblock_clear_nomap
 
 /**
  * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
- * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
- * for this region.
+ * MEMBLOCK_RSRV_NOINIT
+ *
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * struct pages will not be initialized for reserved memory regions marked with
- * %MEMBLOCK_RSRV_NOINIT.
+ * The struct pages for the reserved regions marked %MEMBLOCK_RSRV_NOINIT will
+ * not be fully initialized to allow the caller optimize their initialization.
+ *
+ * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flag
+ * completely bypasses the initialization of struct pages for such region.
+ *
+ * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, struct pages in this
+ * region will be initialized with default values but won't be marked as
+ * reserved.
  *
  * Return: 0 on success, -errno on failure.
  */
_

Patches currently in -mm which might be from rppt@kernel.org are

init-mainc-fix-boot-time-tracing-crash.patch
kho-allow-scratch-areas-with-zero-size.patch
lib-test_kho-fixes-for-error-handling.patch
selftest-kho-update-generation-of-initrd.patch

