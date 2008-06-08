From: akpm@linux-foundation.org
Subject: - aperture_64c-corner-case-wrong.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:52 -0700
Message-ID: <200806081949.m58JnqY4017716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676AbYFHTus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, andi@firstfloor.org, davej@codemonkey.org.uk, mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     aperture_64.c: corner case wrong
has been removed from the -mm tree.  Its filename was
     aperture_64c-corner-case-wrong.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/x86/kernel/aperture_64.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/aperture_64.c~aperture_64c-corner-case-wrong arch/x86/kernel/aperture_64.c
--- a/arch/x86/kernel/aperture_64.c~aperture_64c-corner-case-wrong
+++ a/arch/x86/kernel/aperture_64.c
@@ -328,9 +328,11 @@ out:
 			add_memory_region(aper_base, aper_size, E820_RESERVED);
 			update_e820();
 		}
-		return;
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
sync_file_range_write-may-and-will-block-document-that.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
pm-boot-time-suspend-selftest.patch
remove-include-linux-pm_legacyh.patch

