From: akpm@linux-foundation.org
Subject: - arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:12 -0800
Message-ID: <200901082246.n08MkCf9025730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756273AbZAHWrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:47:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, rmk+lkml@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: provide _sdata and __bss_stop in the vmlinux.lds.S file
has been removed from the -mm tree.  Its filename was
     arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: provide _sdata and __bss_stop in the vmlinux.lds.S file
From: Catalin Marinas <catalin.marinas@arm.com>

_sdata and __bss_stop are common symbols defined by many architectures and
made available to the kernel via asm-generic/sections.h.  Kmemleak uses
these symbols when scanning the data sections.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/arm/kernel/vmlinux.lds.S~arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -120,6 +120,7 @@ SECTIONS
 
 	.data : AT(__data_loc) {
 		_data = .;		/* address in memory */
+		_sdata = .;
 
 		/*
 		 * first, the init task union, aligned
@@ -171,6 +172,7 @@ SECTIONS
 		__bss_start = .;	/* BSS				*/
 		*(.bss)
 		*(COMMON)
+		__bss_stop = .;
 		_end = .;
 	}
 					/* Stabs debugging sections.	*/
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

