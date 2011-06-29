From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-e820c-eliminate-bubble-sort-from-sanitize_e820_map.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:00:31 -0700
Message-ID: <201106292200.p5TM0VFY014660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721Ab1F2WB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mditto@google.com, hpa@zytor.com, mingo@elte.hu, sassmann@kpanic.de, tglx@linutronix.de, yuenn@google.com


The patch titled
     arch/x86/kernel/e820.c: eliminate bubble sort from sanitize_e820_map
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-e820c-eliminate-bubble-sort-from-sanitize_e820_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/e820.c: eliminate bubble sort from sanitize_e820_map
From: Mike Ditto <mditto@google.com>

Replace the bubble sort in sanitize_e820_map() with a call to the generic
kernel sort function to avoid pathological performance with large maps.

On large (thousands of entries) E820 maps, the previous code took minutes
to run; with this change it's now milliseconds.

Signed-off-by: Mike Ditto <mditto@google.com>
Cc: Stefan Assmann <sassmann@kpanic.de>
Cc: Nancy Yuen <yuenn@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c |   59 +++++++++++++++------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

diff -puN arch/x86/kernel/e820.c~arch-x86-kernel-e820c-eliminate-bubble-sort-from-sanitize_e820_map arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~arch-x86-kernel-e820c-eliminate-bubble-sort-from-sanitize_e820_map
+++ a/arch/x86/kernel/e820.c
@@ -18,6 +18,7 @@
 #include <linux/acpi.h>
 #include <linux/firmware-map.h>
 #include <linux/memblock.h>
+#include <linux/sort.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -226,22 +227,38 @@ void __init e820_print_map(char *who)
  *	   ____________________33__
  *	   ______________________4_
  */
+struct change_member {
+	struct e820entry *pbios; /* pointer to original bios entry */
+	unsigned long long addr; /* address for this change point */
+};
+
+static int __init cpcompare(const void *a, const void *b)
+{
+	struct change_member * const *app = a, * const *bpp = b;
+	const struct change_member *ap = *app, *bp = *bpp;
+
+	/*
+	 * Inputs are pointers to two elements of change_point[].  If their
+	 * addresses are unequal, their difference dominates.  If the addresses
+	 * are equal, then consider one that represents the end of its region
+	 * to be greater than one that does not.
+	 */
+	if (ap->addr != bp->addr)
+		return ap->addr > bp->addr ? 1 : -1;
+
+	return (ap->addr != ap->pbios->addr) - (bp->addr != bp->pbios->addr);
+}
 
 int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 			     u32 *pnr_map)
 {
-	struct change_member {
-		struct e820entry *pbios; /* pointer to original bios entry */
-		unsigned long long addr; /* address for this change point */
-	};
 	static struct change_member change_point_list[2*E820_X_MAX] __initdata;
 	static struct change_member *change_point[2*E820_X_MAX] __initdata;
 	static struct e820entry *overlap_list[E820_X_MAX] __initdata;
 	static struct e820entry new_bios[E820_X_MAX] __initdata;
-	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
 	unsigned long long last_addr;
-	int chgidx, still_changing;
+	int chgidx;
 	int overlap_entries;
 	int new_bios_entry;
 	int old_nr, new_nr, chg_nr;
@@ -278,35 +295,7 @@ int __init sanitize_e820_map(struct e820
 	chg_nr = chgidx;
 
 	/* sort change-point list by memory addresses (low -> high) */
-	still_changing = 1;
-	while (still_changing)	{
-		still_changing = 0;
-		for (i = 1; i < chg_nr; i++)  {
-			unsigned long long curaddr, lastaddr;
-			unsigned long long curpbaddr, lastpbaddr;
-
-			curaddr = change_point[i]->addr;
-			lastaddr = change_point[i - 1]->addr;
-			curpbaddr = change_point[i]->pbios->addr;
-			lastpbaddr = change_point[i - 1]->pbios->addr;
-
-			/*
-			 * swap entries, when:
-			 *
-			 * curaddr > lastaddr or
-			 * curaddr == lastaddr and curaddr == curpbaddr and
-			 * lastaddr != lastpbaddr
-			 */
-			if (curaddr < lastaddr ||
-			    (curaddr == lastaddr && curaddr == curpbaddr &&
-			     lastaddr != lastpbaddr)) {
-				change_tmp = change_point[i];
-				change_point[i] = change_point[i-1];
-				change_point[i-1] = change_tmp;
-				still_changing = 1;
-			}
-		}
-	}
+	sort(change_point, chg_nr, sizeof *change_point, cpcompare, 0);
 
 	/* create a new bios memory map, removing overlaps */
 	overlap_entries = 0;	 /* number of entries in the overlap table */
_

Patches currently in -mm which might be from mditto@google.com are

arch-x86-kernel-e820c-eliminate-bubble-sort-from-sanitize_e820_map.patch

