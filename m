From: akpm@linux-foundation.org
Subject: - x86-mtrr-range-check-correction.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:52 -0800
Message-ID: <200702180215.l1I2Fqq5008435@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993130AbXBRCQC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:16:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86: mtrr range check correction
has been removed from the -mm tree.  Its filename was
     x86-mtrr-range-check-correction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
adjust-legacy-ide-resource-setting-v2.patch
