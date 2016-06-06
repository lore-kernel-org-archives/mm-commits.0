From: akpm@linux-foundation.org
Subject: + tile-early_printko-is-always-required.patch added to -mm tree
Date: Mon, 06 Jun 2016 13:31:29 -0700
Message-ID: <5755dda1.xKzw/gAup3FJUHHD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbcFFUba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 16:31:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@mellanox.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: early_printk.o is always required
has been added to the -mm tree.  Its filename is
     tile-early_printko-is-always-required.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tile-early_printko-is-always-required.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tile-early_printko-is-always-required.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tile: early_printk.o is always required

arch/tile/setup.o is always compiled, and it requires early_panic() and
hence early_printk(), so we must always build and link early_printk.o.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/tile/Kconfig~tile-early_printko-is-always-required arch/tile/Kconfig
--- a/arch/tile/Kconfig~tile-early_printko-is-always-required
+++ a/arch/tile/Kconfig
@@ -14,6 +14,7 @@ config TILE
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select EARLY_PRINTK
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
tile-early_printko-is-always-required.patch
mm.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

