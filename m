From: akpm@linux-foundation.org
Subject: + arm64-support-initrd-outside-kernel-linear-map-v4.patch added
 to -mm tree
Date: Mon, 17 Aug 2015 13:19:23 -0700
Message-ID: <55d241cb.UIsSEaHHNF/F+xGn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbbHQUTY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 16:19:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-support-initrd-outside-kernel-linear-map-v4
has been added to the -mm tree.  Its filename is
     arm64-support-initrd-outside-kernel-linear-map-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-support-initrd-outside-kernel-linear-map-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-support-initrd-outside-kernel-linear-map-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: arm64-support-initrd-outside-kernel-linear-map-v4

Fixed arm64 build error with !CONFIG_BLK_DEV_INITRD case
Fixed nonsensical comment in arm64 relocate_initrd()
Moved #ifdef outside arm64 relocate_initrd() definition

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/setup.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN arch/arm64/kernel/setup.c~arm64-support-initrd-outside-kernel-linear-map-v4 arch/arm64/kernel/setup.c
--- a/arch/arm64/kernel/setup.c~arm64-support-initrd-outside-kernel-linear-map-v4
+++ a/arch/arm64/kernel/setup.c
@@ -359,13 +359,13 @@ static void __init request_standard_reso
 	}
 }
 
+#ifdef CONFIG_BLK_DEV_INITRD
 /*
  * Relocate initrd if it is not completely within the linear mapping.
  * This would be the case if mem= cuts out all or part of it.
  */
 static void __init relocate_initrd(void)
 {
-#ifdef CONFIG_BLK_DEV_INITRD
 	phys_addr_t orig_start = __virt_to_phys(initrd_start);
 	phys_addr_t orig_end = __virt_to_phys(initrd_end);
 	phys_addr_t ram_end = memblock_end_of_DRAM();
@@ -376,7 +376,10 @@ static void __init relocate_initrd(void)
 	if (orig_end <= ram_end)
 		return;
 
-	/* Note if any of original initrd will freeing below */
+	/*
+	 * Any of the original initrd which overlaps the linear map should
+	 * be freed after relocating.
+	 */
 	if (orig_start < ram_end)
 		to_free = ram_end - orig_start;
 
@@ -410,8 +413,12 @@ static void __init relocate_initrd(void)
 			orig_start, orig_start + to_free - 1);
 		memblock_free(orig_start, to_free);
 	}
-#endif
 }
+#else
+static inline void __init relocate_initrd(void)
+{
+}
+#endif
 
 u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
_

Patches currently in -mm which might be from msalter@redhat.com are

mm-add-utility-for-early-copy-from-unmapped-ram.patch
mm-add-utility-for-early-copy-from-unmapped-ram-v4.patch
arm64-support-initrd-outside-kernel-linear-map.patch
arm64-support-initrd-outside-kernel-linear-map-v4.patch
x86-use-generic-early-mem-copy.patch
x86-use-generic-early-mem-copy-fix.patch
linux-next.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch

