From: akpm@linux-foundation.org
Subject: - uml-memcpy-export-needs-to-follow-host-declaration.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:45 -0700
Message-ID: <200806081947.m58Jlj3U017442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbYFHTsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, nix.or.die@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     uml: memcpy export needs to follow host declaration
has been removed from the -mm tree.  Its filename was
     uml-memcpy-export-needs-to-follow-host-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: memcpy export needs to follow host declaration
From: Jeff Dike <jdike@addtoit.com>

x86_64 defines either memcpy or __memcpy depending on the gcc version, and
it looks like UML needs to follow that in its exporting.

Cc: Gabriel C <nix.or.die@googlemail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-x86_64/ksyms.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/um/sys-x86_64/ksyms.c~uml-memcpy-export-needs-to-follow-host-declaration arch/um/sys-x86_64/ksyms.c
--- a/arch/um/sys-x86_64/ksyms.c~uml-memcpy-export-needs-to-follow-host-declaration
+++ a/arch/um/sys-x86_64/ksyms.c
@@ -3,5 +3,9 @@
 #include <asm/checksum.h>
 
 /*XXX: we need them because they would be exported by x86_64 */
+#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
+EXPORT_SYMBOL(memcpy);
+#else
 EXPORT_SYMBOL(__memcpy);
+#endif
 EXPORT_SYMBOL(csum_partial);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

