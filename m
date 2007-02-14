From: akpm@linux-foundation.org
Subject: + x86-mtrr-range-check-correction.patch added to -mm tree
Date: Wed, 14 Feb 2007 15:26:37 -0800
Message-ID: <200702142326.l1ENQbVU012667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50676 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbXBNX0o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 18:26:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, ak@suse.de


The patch titled
     x86: mtrr range check correction
has been added to the -mm tree.  Its filename is
     x86-mtrr-range-check-correction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: mtrr range check correction
From: "Jan Beulich" <jbeulich@novell.com>

Whether a region is below 1Mb is determined by its start rather than
its end.

This hunk got erroneously dropped from a previous patch.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~x86-mtrr-range-check-correction arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~x86-mtrr-range-check-correction
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -428,7 +428,7 @@ int generic_validate_add_page(unsigned l
 		}
 	}
 
-	if (base + size < 0x100) {
+	if (base < 0x100) {
 		printk(KERN_WARNING "mtrr: cannot set region below 1 MiB (0x%lx000,0x%lx000)\n",
 		       base, size);
 		return -EINVAL;
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
broken-config_compat_vdso-on-i386.patch
x86-fatal-kernel-faults-should-update-thread-struct.patch
i386-adjustments-to-page-table-dump-during-oops-v3.patch
small-irq-management-simplification.patch
x86-mtrr-range-check-correction.patch
x86-consolidate-smp_send_stop.patch
