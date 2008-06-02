From: akpm@linux-foundation.org
Subject: + aperture_64c-corner-case-wrong.patch added to -mm tree
Date: Mon, 02 Jun 2008 15:31:10 -0700
Message-ID: <200806022231.m52MVAY8003177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbYFBWcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 18:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, andi@firstfloor.org, davej@codemonkey.org.uk, mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com


The patch titled
     aperture_64.c: corner case wrong
has been added to the -mm tree.  Its filename is
     aperture_64c-corner-case-wrong.patch

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
Subject: aperture_64.c: corner case wrong
From: Pavel Machek <pavel@suse.cz>

If

fix == 0, aper_enabled == 1, gart_fix_e820 == 0

	if (!fix && !aper_enabled)
		return;

	if (gart_fix_e820 && !fix && aper_enabled) {
		if (e820_any_mapped(aper_base, aper_base + aper_size,
				    E820_RAM)) {
			/* reserve it, so we can reuse it in second kernel */
			printk(KERN_INFO "update e820 for GART\n");
			add_memory_region(aper_base, aper_size, E820_RESERVED);
			update_e820();
		}
		return;
	}

	/* different nodes have different setting, disable them all atfirst*/

we'll fall back here and disable all the settings, even when they were all
consistent.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/aperture_64.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/kernel/aperture_64.c~aperture_64c-corner-case-wrong arch/x86/kernel/aperture_64.c
--- a/arch/x86/kernel/aperture_64.c~aperture_64c-corner-case-wrong
+++ a/arch/x86/kernel/aperture_64.c
@@ -331,6 +331,9 @@ out:
 		return;
 	}
 
+	if (!fix)
+		return;
+
 	/* different nodes have different setting, disable them all at first*/
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;
_

Patches currently in -mm which might be from pavel@suse.cz are

linux-next.patch
suspend-vs-iommu-prevent-suspend-if-we-could-not-resume.patch
aperture_64c-corner-case-wrong.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch

