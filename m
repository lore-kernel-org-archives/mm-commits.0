From: akpm@linux-foundation.org
Subject: + resources-introduce-generic-page_is_ram.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:31:17 -0800
Message-ID: <201001270031.o0R0VHNT032200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003Ab0A0AdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:33:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, mingo@elte.hu, ralf@linux-mips.org, tglx@linutronix.de, xiyou.wangcong@gmail.com, yinghai@kernel.org


The patch titled
     resources: introduce generic page_is_ram()
has been added to the -mm tree.  Its filename is
     resources-introduce-generic-page_is_ram.patch

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
Subject: resources: introduce generic page_is_ram()
=46rom: Wu Fengguang <fengguang.wu@intel.com>

This introduces a generic iomem_resource based page_is_ram()
and removes the x86 page_is_ram().

The resource based page_is_ram() is more hotplug friendly, because memo=
ry
hotplug only updates resource and leave e820 unchanged.


This patch:

Introduce generic page_is_ram().  It's based on walk_system_ram_range()=
,
for archs that don't have their own page_is_ram().

The static verions in MIPS and SCORE are also made global.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Am=E9rico Wang <xiyou.wangcong@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c    |    2 +-
 arch/score/mm/init.c   |    2 +-
 include/linux/ioport.h |    2 ++
 kernel/resource.c      |   13 +++++++++++++
 4 files changed, 17 insertions(+), 2 deletions(-)

diff -puN arch/mips/mm/init.c~resources-introduce-generic-page_is_ram a=
rch/mips/mm/init.c
--- a/arch/mips/mm/init.c~resources-introduce-generic-page_is_ram
+++ a/arch/mips/mm/init.c
@@ -298,7 +298,7 @@ void __init fixrange_init(unsigned long=20
 }
=20
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static int __init page_is_ram(unsigned long pagenr)
+int page_is_ram(unsigned long pagenr)
 {
 	int i;
=20
diff -puN arch/score/mm/init.c~resources-introduce-generic-page_is_ram =
arch/score/mm/init.c
--- a/arch/score/mm/init.c~resources-introduce-generic-page_is_ram
+++ a/arch/score/mm/init.c
@@ -59,7 +59,7 @@ static unsigned long setup_zero_page(voi
 }
=20
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static int __init page_is_ram(unsigned long pagenr)
+int page_is_ram(unsigned long pagenr)
 {
 	if (pagenr >=3D min_low_pfn && pagenr < max_low_pfn)
 		return 1;
diff -puN include/linux/ioport.h~resources-introduce-generic-page_is_ra=
m include/linux/ioport.h
--- a/include/linux/ioport.h~resources-introduce-generic-page_is_ram
+++ a/include/linux/ioport.h
@@ -191,5 +191,7 @@ extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
=20
+extern int page_is_ram(unsigned long pfn);
+
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff -puN kernel/resource.c~resources-introduce-generic-page_is_ram ker=
nel/resource.c
--- a/kernel/resource.c~resources-introduce-generic-page_is_ram
+++ a/kernel/resource.c
@@ -327,6 +327,19 @@ int walk_system_ram_range(unsigned long=20
=20
 #endif
=20
+static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *a=
rg)
+{
+	return 1;
+}
+/*
+ * This generic page_is_ram() returns true if specified address is
+ * registered as "System RAM" in iomem_resource list.
+ */
+int __attribute__((weak)) page_is_ram(unsigned long pfn)
+{
+	return walk_system_ram_range(pfn, 1, NULL, __is_ram) =3D=3D 1;
+}
+
 /*
  * Find empty slot in the resource tree given range and alignment.
  */
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patc=
h
resources-introduce-generic-page_is_ram.patch
resources-introduce-generic-page_is_ram-fix.patch
x86-remove-bios-data-range-from-e820.patch
x86-use-the-generic-page_is_ram.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
