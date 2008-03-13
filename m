From: akpm@linux-foundation.org
Subject: + x86-fix-aperture-vs-suspend-problem.patch added to -mm tree
Date: Thu, 13 Mar 2008 15:32:54 -0700
Message-ID: <200803132232.m2DMWsGF003778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758501AbYCMWeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 18:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, mingo@elte.hu, pavel@suse.cz, rjw@sisk.pl, stable@kernel.org, tglx@linutronix.de


The patch titled
     x86: fix aperture vs. suspend problem
has been added to the -mm tree.  Its filename is
     x86-fix-aperture-vs-suspend-problem.patch

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
Subject: x86: fix aperture vs. suspend problem
From: Pavel Machek <pavel@ucw.cz>

aperture_64.c takes a piece of memory and makes it into an iommu window.  But
such window may not be saved by swsusp -- that leads to oops during suspend.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/aperture_64.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/aperture_64.c~x86-fix-aperture-vs-suspend-problem arch/x86/kernel/aperture_64.c
--- a/arch/x86/kernel/aperture_64.c~x86-fix-aperture-vs-suspend-problem
+++ a/arch/x86/kernel/aperture_64.c
@@ -18,6 +18,7 @@
 #include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/ioport.h>
+#include <linux/suspend.h>
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/gart.h>
@@ -76,6 +77,7 @@ static u32 __init allocate_aperture(void
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
 			aper_size >> 10, __pa(p));
 	insert_aperture_resource((u32)__pa(p), aper_size);
+	register_nosave_region((u32)__pa(p) >> PAGE_SHIFT, (u32)__pa(p+aper_size) >> PAGE_SHIFT);
 
 	return (u32)__pa(p);
 }
_

Patches currently in -mm which might be from pavel@ucw.cz are

git-x86.patch
pm-handle-device-registrations-during-suspend-resume.patch
driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch
pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
git-hrt.patch
x86-fix-aperture-vs-suspend-problem.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch

