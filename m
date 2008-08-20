From: akpm@linux-foundation.org
Subject: + frv-provide-ioremap_wc-for-frv.patch added to -mm tree
Date: Wed, 20 Aug 2008 12:06:57 -0700
Message-ID: <200808201906.m7KJ6v6g026582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbYHTTH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 15:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: provide ioremap_wc() for FRV
has been added to the -mm tree.  Its filename is
     frv-provide-ioremap_wc-for-frv.patch

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
Subject: FRV: provide ioremap_wc() for FRV
From: David Howells <dhowells@redhat.com>

Provide ioremap_wc() for FRV.

(akpm: fixes the build on various random drivers which frv probably
doesn't use)

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/io.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-frv/io.h~frv-provide-ioremap_wc-for-frv include/asm-frv/io.h
--- a/include/asm-frv/io.h~frv-provide-ioremap_wc-for-frv
+++ a/include/asm-frv/io.h
@@ -271,6 +271,8 @@ static inline void __iomem *ioremap_full
 	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
 }
 
+#define ioremap_wc ioremap_nocache
+
 extern void iounmap(void volatile __iomem *addr);
 
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
mn10300-supply-ioremap_wc-for-mn10300.patch
frv-provide-ioremap_wc-for-frv.patch
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
mn10300-use-bcd2bin-bin2bcd.patch
mutex-subsystem-synchro-test-module.patch

