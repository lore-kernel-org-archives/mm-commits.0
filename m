From: akpm@linux-foundation.org
Subject: + xtensa-add-flat-support.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:06:26 -0800
Message-ID: <200903052206.n25M6QeQ006450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbZCEWHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: os@emlix.com, chris@zankel.net, jw@emlix.com


The patch titled
     xtensa: add flat support
has been added to the -mm tree.  Its filename is
     xtensa-add-flat-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
flat-fix-data-sections-alignment.patch

