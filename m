From: akpm@linux-foundation.org
Subject: + mn10300-supply-ioremap_wc-for-mn10300.patch added to -mm tree
Date: Wed, 20 Aug 2008 12:06:10 -0700
Message-ID: <200808201906.m7KJ6AqH026537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbYHTTGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 15:06:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     MN10300: supply ioremap_wc() for MN10300
has been added to the -mm tree.  Its filename is
     mn10300-supply-ioremap_wc-for-mn10300.patch

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
Subject: MN10300: supply ioremap_wc() for MN10300
From: David Howells <dhowells@redhat.com>

Supply ioremap_wc() for MN10300.

(akpm: fixes the build on various random drivers which mn10300 probably
doesn't use)

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/io.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-mn10300/io.h~mn10300-supply-ioremap_wc-for-mn10300 include/asm-mn10300/io.h
--- a/include/asm-mn10300/io.h~mn10300-supply-ioremap_wc-for-mn10300
+++ a/include/asm-mn10300/io.h
@@ -259,6 +259,8 @@ static inline void *ioremap_nocache(unsi
 	return (void *) (offset | 0x20000000);
 }
 
+#define ioremap_wc ioremap_nocache
+
 static inline void iounmap(void *addr)
 {
 }
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
mn10300-supply-ioremap_wc-for-mn10300.patch
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

