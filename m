From: akpm@linux-foundation.org
Subject: - x86-fix-aperture-vs-suspend-problem.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:30 -0700
Message-ID: <200803212031.m2LKVUxW009076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761340AbYCUUcC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:32:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, mingo@elte.hu, pavel@suse.cz, rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix aperture vs. suspend problem
has been removed from the -mm tree.  Its filename was
     x86-fix-aperture-vs-suspend-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix aperture vs. suspend problem
From: Pavel Machek <pavel@ucw.cz>

aperture_64.c takes a piece of memory and makes it into an iommu window.  But
such window may not be saved by swsusp -- that leads to oops during suspend.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/aperture_64.c |    3 +++
 1 file changed, 3 insertions(+)

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
@@ -76,6 +77,8 @@ static u32 __init allocate_aperture(void
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
 			aper_size >> 10, __pa(p));
 	insert_aperture_resource((u32)__pa(p), aper_size);
+	register_nosave_region((u32)__pa(p) >> PAGE_SHIFT,
+				(u32)__pa(p+aper_size) >> PAGE_SHIFT);
 
 	return (u32)__pa(p);
 }
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
kernel-parameterstxt-document-memmap-option-better.patch
git-x86.patch
git-acpi.patch
git-hrt.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch

