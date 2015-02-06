From: akpm@linux-foundation.org
Subject: [merged] mm-export-high_memory-symbol-on-mmu.patch removed from
 -mm tree
Date: Fri, 06 Feb 2015 14:02:31 -0800
Message-ID: <54d539f7.Ew+p/Asex7PGR0Gg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbBFWCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2015 17:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, gerg@uclinux.org, kirill.shutemov@linux.intel.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export "high_memory" symbol on !MMU
has been removed from the -mm tree.  Its filename was
     mm-export-high_memory-symbol-on-mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: export "high_memory" symbol on !MMU

The symbol 'high_memory' is provided on both MMU- and NOMMU-kernels, but
only one of them is exported, which leads to module build errors in
drivers that work fine built-in:

ERROR: "high_memory" [drivers/net/virtio_net.ko] undefined!
ERROR: "high_memory" [drivers/net/ppp/ppp_mppe.ko] undefined!
ERROR: "high_memory" [drivers/mtd/nand/nand.ko] undefined!
ERROR: "high_memory" [crypto/tcrypt.ko] undefined!
ERROR: "high_memory" [crypto/cts.ko] undefined!

This exports the symbol to get these to work on NOMMU as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/nommu.c~mm-export-high_memory-symbol-on-mmu mm/nommu.c
--- a/mm/nommu.c~mm-export-high_memory-symbol-on-mmu
+++ a/mm/nommu.c
@@ -59,6 +59,7 @@
 #endif
 
 void *high_memory;
+EXPORT_SYMBOL(high_memory);
 struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long highest_memmap_pfn;
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
asm-generic-drop-unused-pte_file-helpers.patch
linux-typesh-always-use-unsigned-long-for-pgoff_t.patch
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-users.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patch
of-add-vendor-prefix-for-abracon-corporation.patch
rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip.patch
rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch
kexec-fix-make-headers_check.patch
kexec-simplify-conditional.patch
kexec-add-bit-definitions-for-kimage-entry-flags.patch
kexec-add-ind_flags-macro.patch
eventfd-dont-take-the-spinlock-in-eventfd_poll-fix.patch
linux-next.patch
rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.patch
rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.patch
staging-iio-isl29028-deprecate-use-of-isl-in-compatible-string-for-isil.patch
arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-prefix.patch
ocfs2-use-64bit-variables-to-track-heartbeat-time.patch

