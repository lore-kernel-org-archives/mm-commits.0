From: akpm@linux-foundation.org
Subject: [merged] xtensa-add-flat-support.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:28 -0700
Message-ID: <200904061939.n36JdSxl013914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346AbZDFTnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: os@emlix.com, chris@zankel.net, jw@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: add flat support
has been removed from the -mm tree.  Its filename was
     xtensa-add-flat-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: add flat support
From: Oskar Schirmer <os@emlix.com>

Add the arch-specific header for flat support on xtensa in preparation for
the Xtensa S6000 nommu port.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/flat.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN /dev/null arch/xtensa/include/asm/flat.h
--- /dev/null
+++ a/arch/xtensa/include/asm/flat.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_XTENSA_FLAT_H
+#define __ASM_XTENSA_FLAT_H
+
+#define flat_argvp_envp_on_stack()			0
+#define flat_old_ram_flag(flags)			(flags)
+#define flat_reloc_valid(reloc, size)			((reloc) <= (size))
+#define flat_get_addr_from_rp(rp, relval, flags, p)	get_unaligned(rp)
+#define flat_put_addr_at_rp(rp, val, relval	)	put_unaligned(val, rp)
+#define flat_get_relocate_addr(rel)			(rel)
+#define flat_set_persistent(relval, p)			0
+
+#endif /* __ASM_XTENSA_FLAT_H */
_

Patches currently in -mm which might be from os@emlix.com are

origin.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch

