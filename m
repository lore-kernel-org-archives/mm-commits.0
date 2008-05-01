From: akpm@linux-foundation.org
Subject: - x86-ioremap-ram-check-fix.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:36 -0700
Message-ID: <200805010933.m419Xaf1031155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758136AbYEAJeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: ioremap ram check fix
has been removed from the -mm tree.  Its filename was
     x86-ioremap-ram-check-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: ioremap ram check fix
From: Andres Salomon <dilinger@queued.net>

bdd3cee2e4b7279457139058615ced6c2b41e7de (x86: ioremap(), extend check
to all RAM pages) breaks OLPC's ioremap call.  The ioremap that OLPC uses is:

        romsig = ioremap(0xffffffc0, 16);

The commit that breaks it is basically:

-       for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
-            (pfn << PAGE_SHIFT) < last_addr; pfn++) {
+       for (pfn = phys_addr >> PAGE_SHIFT;
+                               (pfn << PAGE_SHIFT) < last_addr; pfn++) {
+

Previously, the 'pfn < max_pfn_mapped' check would've caused us to not
enter the loop.  Removing that check means we loop infinitely.  The
reason for that is because pfn is 0xfffff, and last_addr is 0xffffffcf.
The remaining check that is used to exit the loop is not sufficient;
when pfn<<PAGE_SHIFT is 0xfffff000, that is less than 0xffffffcf; when
we increment pfn and it overflows (pfn == 0x100000), pfn<<PAGE_SHIFT
ends up being 0.  That, of course, is less than last_addr.  In effect,
pfn<<PAGE_SHIFT is never lower than last_addr.

The simple fix for this is to limit the last_addr check to the PAGE_MASK;
a patch is below.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/ioremap.c~x86-ioremap-ram-check-fix arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-ioremap-ram-check-fix
+++ a/arch/x86/mm/ioremap.c
@@ -149,7 +149,8 @@ static void __iomem *__ioremap_caller(re
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	for (pfn = phys_addr >> PAGE_SHIFT;
-				(pfn << PAGE_SHIFT) < last_addr; pfn++) {
+				(pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
+				pfn++) {
 
 		int is_ram = page_is_ram(pfn);
 
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
power_supply-add-eeprom-dump-file-to-olpc_batterys-sysfs.patch
power_supply-cleanup-of-the-olpc-battery-driver.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch

