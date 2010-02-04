From: akpm@linux-foundation.org
Subject: [merged] x86-use-the-generic-page_is_ram.patch removed from -mm tree
Date: Thu, 04 Feb 2010 09:49:40 -0800
Message-ID: <201002041749.o14HneeO012064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001Ab0BDRvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 12:51:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, andi@firstfloor.org, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, mingo@elte.hu, ralf@linux-mips.org, tglx@lin


The patch titled
     x86: use the generic page_is_ram()
has been removed from the -mm tree.  Its filename was
     x86-use-the-generic-page_is_ram.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: x86: use the generic page_is_ram()
=46rom: Wu Fengguang <fengguang.wu@intel.com>

The generic resource based page_is_ram() works better with memory
hotplug/hotremove.  So switch the x86 e820map based code to it.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_types.h |    1 -
 arch/x86/mm/ioremap.c             |   21 ---------------------
 2 files changed, 22 deletions(-)

diff -puN arch/x86/include/asm/page_types.h~x86-use-the-generic-page_is=
_ram arch/x86/include/asm/page_types.h
--- a/arch/x86/include/asm/page_types.h~x86-use-the-generic-page_is_ram
+++ a/arch/x86/include/asm/page_types.h
@@ -40,7 +40,6 @@
=20
 #ifndef __ASSEMBLY__
=20
-extern int page_is_ram(unsigned long pagenr);
 extern int devmem_is_allowed(unsigned long pagenr);
=20
 extern unsigned long max_low_pfn_mapped;
diff -puN arch/x86/mm/ioremap.c~x86-use-the-generic-page_is_ram arch/x8=
6/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-use-the-generic-page_is_ram
+++ a/arch/x86/mm/ioremap.c
@@ -24,27 +24,6 @@
=20
 #include "physaddr.h"
=20
-int page_is_ram(unsigned long pagenr)
-{
-	resource_size_t addr, end;
-	int i;
-
-	for (i =3D 0; i < e820.nr_map; i++) {
-		/*
-		 * Not usable memory:
-		 */
-		if (e820.map[i].type !=3D E820_RAM)
-			continue;
-		addr =3D (e820.map[i].addr + PAGE_SIZE-1) >> PAGE_SHIFT;
-		end =3D (e820.map[i].addr + e820.map[i].size) >> PAGE_SHIFT;
-
-
-		if ((pagenr >=3D addr) && (pagenr < end))
-			return 1;
-	}
-	return 0;
-}
-
 /*
  * Fix up the linear direct mapping of the kernel to avoid cache attri=
bute
  * conflicts.
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
fanotify-fix-fmode_nonotify-bit-number.patch
vfs-improve-writeback_inodes_wb.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patc=
h
vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch
readahead-introduce-fmode_random-for-posix_fadv_random.patch
readahead-introduce-fmode_random-for-posix_fadv_random-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
vfs-add-super-operation-writeback_inodes.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
