From: akpm@linux-foundation.org
Subject: + x86-ioremap-ram-check-fix.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:36:19 -0700
Message-ID: <200804301736.m3UHaJqC026096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758523AbYD3RhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 13:37:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: ioremap ram check fix
has been added to the -mm tree.  Its filename is
     x86-ioremap-ram-check-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86-ioremap-ram-check-fix.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch

