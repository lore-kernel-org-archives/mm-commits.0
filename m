Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C2C236453
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 02:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757471237; cv=none; b=g3jj1qBdB+MlZwen+rRiVwO2rQjKlRni/812ZOG9x2C6w8BXpr5T74n1IVMvlW4K0p/IN+naDCGtqm9BIkEKamCGQf4RVoM5Ucb4rEQ5vUgiyMgV3YBloEPrbT+UYlIflwvsSiNhswVjBnyAfwJMNJICGff2Hs5UcpiijBs9Dnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757471237; c=relaxed/simple;
	bh=KmXBLNAN2EGJ2vChgXFeYv+M3E22fPy0m6ZkJXe7894=;
	h=Date:To:From:Subject:Message-Id; b=Lz3wjt6QPu2T1zLZkfoyZtO3C32gVs96b6KPIj5ANf7IO2+lbUB/SreIKZ0p3Ux5n5KKW62TUXAxu/ZpLeqmbzG7EXi1vQt+HfyTC8wLw8uHF/Fk/DZKZfv007etWYmG4OMkArQiWUiG7SmNJhd3i16X+vq/merGyE99zb26rUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vy1SbqGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vy1SbqGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD8EC4CEF4;
	Wed, 10 Sep 2025 02:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757471235;
	bh=KmXBLNAN2EGJ2vChgXFeYv+M3E22fPy0m6ZkJXe7894=;
	h=Date:To:From:Subject:From;
	b=Vy1SbqGqiKmdn8Z1ftCUmogudQ001O9u5eP9r3fhaWztlEpu4CfdKIXCGgEh8BPaV
	 rB4mQfrkfyuDhrvxBZPgCU5ehGBO7qw8sTz7A1TJ5+4MdygCWe8CSbHET3y/IgmDUy
	 TJVDD/RPnBasUVtZne6AimFmpvPweaUVciqdXhQM=
Date: Tue, 09 Sep 2025 19:27:14 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ardb@kernel.org,epetron@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + efi-support-booting-with-kexec-handover-kho.patch added to mm-nonmm-unstable branch
Message-Id: <20250910022715.5BD8EC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: efi: support booting with kexec handover (KHO)
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     efi-support-booting-with-kexec-handover-kho.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/efi-support-booting-with-kexec-handover-kho.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Evangelos Petrongonas <epetron@amazon.de>
Subject: efi: support booting with kexec handover (KHO)
Date: Thu, 21 Aug 2025 17:59:00 +0000

When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
early during device tree scanning.  After kexec, the new kernel
exclusively uses this region for memory allocations during boot up to the
initialization of the page allocator

However, when booting with EFI, EFI's reserve_regions() uses
memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
rebuilding them from EFI data.  This destroys KHO scratch regions and
their flags, thus causing a kernel panic, as there are no scratch memory
regions.

Instead of wholesale removal, iterate through memory regions and only
remove non-KHO ones.  This preserves KHO scratch regions, which are good
known memory, while still allowing EFI to rebuild its memory map.

Link: https://lkml.kernel.org/r/b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/efi-init.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/drivers/firmware/efi/efi-init.c~efi-support-booting-with-kexec-handover-kho
+++ a/drivers/firmware/efi/efi-init.c
@@ -12,6 +12,7 @@
 #include <linux/efi.h>
 #include <linux/fwnode.h>
 #include <linux/init.h>
+#include <linux/kexec_handover.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
 #include <linux/of.h>
@@ -164,12 +165,32 @@ static __init void reserve_regions(void)
 		pr_info("Processing EFI memory map:\n");
 
 	/*
-	 * Discard memblocks discovered so far: if there are any at this
-	 * point, they originate from memory nodes in the DT, and UEFI
-	 * uses its own memory map instead.
+	 * Discard memblocks discovered so far except for KHO scratch
+	 * regions. Most memblocks at this point originate from memory nodes
+	 * in the DT and UEFI uses its own memory map instead. However, if
+	 * KHO is enabled, scratch regions, which are good known memory
+	 * must be preserved.
 	 */
 	memblock_dump_all();
-	memblock_remove(0, PHYS_ADDR_MAX);
+
+	if (is_kho_boot()) {
+		struct memblock_region *r;
+
+		/* Remove all non-KHO regions */
+		for_each_mem_region(r) {
+			if (!memblock_is_kho_scratch(r)) {
+				memblock_remove(r->base, r->size);
+				r--;
+			}
+		}
+	} else {
+		/*
+		 * KHO is disabled. Discard memblocks discovered so far:
+		 * if there are any at this point, they originate from memory
+		 * nodes in the DT, and UEFI uses its own memory map instead.
+		 */
+		memblock_remove(0, PHYS_ADDR_MAX);
+	}
 
 	for_each_efi_memory_desc(md) {
 		paddr = md->phys_addr;
_

Patches currently in -mm which might be from epetron@amazon.de are

kexec-introduce-is_kho_boot.patch
efi-support-booting-with-kexec-handover-kho.patch

