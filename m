From: akpm@linux-foundation.org
Subject: + x86-use-the-generic-page_is_ram.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:31:23 -0800
Message-ID: <201001270031.o0R0VOZj032209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164Ab0A0Ad1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:33:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@firstfloor.org, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, mingo@elte.hu, ralf@linux-mips.org, tglx@linutronix.de, xiyou.wangcong@gmail.com, yinghai@kernel.org


The patch titled
     x86: use the generic page_is_ram()
has been added to the -mm tree.  Its filename is
     x86-use-the-generic-page_is_ram.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
