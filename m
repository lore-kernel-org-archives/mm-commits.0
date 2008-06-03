From: akpm@linux-foundation.org
Subject: + uml-memcpy-export-needs-to-follow-host-declaration.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:31:16 -0700
Message-ID: <200806031931.m53JVG0K015905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbYFCTbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, nix.or.die@googlemail.com


The patch titled
     uml: memcpy export needs to follow host declaration
has been added to the -mm tree.  Its filename is
     uml-memcpy-export-needs-to-follow-host-declaration.patch

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

uml-deal-with-host-time-going-backwards.patch
uml-deal-with-inaccessible-address-space-start.patch
uml-memcpy-export-needs-to-follow-host-declaration.patch
uml-stub-needs-to-tolerate-sigwinch.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch
uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch

