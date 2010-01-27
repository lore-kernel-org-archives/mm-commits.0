From: akpm@linux-foundation.org
Subject: + x86-remove-bios-data-range-from-e820.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:31:21 -0800
Message-ID: <201001270031.o0R0VL3r032206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754156Ab0A0AdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:33:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, fengguang.wu@intel.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, mingo@elte.hu, ralf@linux-mips.org, tglx@linutronix.de, xiyou.wangcong@gmail.com


The patch titled
     x86: remove bios data range from e820
has been added to the -mm tree.  Its filename is
     x86-remove-bios-data-range-from-e820.patch

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
Subject: x86: remove bios data range from e820
=46rom: Yinghai Lu <yinghai@kernel.org>

To prepare move page_is_ram() as generic one.

Tested-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
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

 arch/x86/kernel/e820.c  |    8 ++++++++
 arch/x86/kernel/setup.c |   19 ++++++++++++++++++-
 arch/x86/mm/ioremap.c   |   16 ----------------
 3 files changed, 26 insertions(+), 17 deletions(-)

diff -puN arch/x86/kernel/e820.c~x86-remove-bios-data-range-from-e820 a=
rch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~x86-remove-bios-data-range-from-e820
+++ a/arch/x86/kernel/e820.c
@@ -517,11 +517,19 @@ u64 __init e820_remove_range(u64 start,=20
 			     int checktype)
 {
 	int i;
+	u64 end;
 	u64 real_removed_size =3D 0;
=20
 	if (size > (ULLONG_MAX - start))
 		size =3D ULLONG_MAX - start;
=20
+	end =3D start + size;
+	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
+		       (unsigned long long) start,
+		       (unsigned long long) end);
+	e820_print_type(old_type);
+	printk(KERN_CONT "\n");
+
 	for (i =3D 0; i < e820.nr_map; i++) {
 		struct e820entry *ei =3D &e820.map[i];
 		u64 final_start, final_end;
diff -puN arch/x86/kernel/setup.c~x86-remove-bios-data-range-from-e820 =
arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-remove-bios-data-range-from-e820
+++ a/arch/x86/kernel/setup.c
@@ -659,6 +659,23 @@ static struct dmi_system_id __initdata b
 	{}
 };
=20
+static void __init trim_bios_range(void)
+{
+	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 */
+	e820_update_range(0, PAGE_SIZE, E820_RAM, E820_RESERVED);
+	/*
+	 * special case: Some BIOSen report the PC BIOS
+	 * area (640->1Mb) as ram even though it is not.
+	 * take them out.
+	 */
+	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have =
also been
  * passed the efi memmap, systab, etc., so we should use these data st=
ructures
@@ -822,7 +839,7 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
=20
-
+	trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
diff -puN arch/x86/mm/ioremap.c~x86-remove-bios-data-range-from-e820 ar=
ch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-remove-bios-data-range-from-e820
+++ a/arch/x86/mm/ioremap.c
@@ -29,22 +29,6 @@ int page_is_ram(unsigned long pagenr)
 	resource_size_t addr, end;
 	int i;
=20
-	/*
-	 * A special case is the first 4Kb of memory;
-	 * This is a BIOS owned area, not kernel ram, but generally
-	 * not listed as such in the E820 table.
-	 */
-	if (pagenr =3D=3D 0)
-		return 0;
-
-	/*
-	 * Second special case: Some BIOSen report the PC BIOS
-	 * area (640->1Mb) as ram even though it is not.
-	 */
-	if (pagenr >=3D (BIOS_BEGIN >> PAGE_SHIFT) &&
-		    pagenr < (BIOS_END >> PAGE_SHIFT))
-		return 0;
