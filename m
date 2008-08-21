From: akpm@linux-foundation.org
Subject: - mn10300-supply-ioremap_wc-for-mn10300.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:34 -0700
Message-ID: <200808210349.m7L3nYmN015647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865AbYHUDtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MN10300: supply ioremap_wc() for MN10300
has been removed from the -mm tree.  Its filename was
     mn10300-supply-ioremap_wc-for-mn10300.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

