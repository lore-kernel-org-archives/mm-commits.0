From: akpm@linux-foundation.org
Subject: - ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch removed from -mm tree
Date: Fri, 19 Sep 2008 15:00:36 -0700
Message-ID: <200809192200.m8JM0axk008638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbYISWB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ip2: fix iiEllisCleanup() as it is static but not always used
has been removed from the -mm tree.  Its filename was
     ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ip2: fix iiEllisCleanup() as it is static but not always used
From: David Howells <dhowells@redhat.com>

Fix iiEllisCleanup(), which is static but only used if the driver is being
built as a module, by wrapping it in #ifdef MODULE as the function that calls
it is.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/i2ellis.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/char/ip2/i2ellis.c~ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used drivers/char/ip2/i2ellis.c
--- a/drivers/char/ip2/i2ellis.c~ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used
+++ a/drivers/char/ip2/i2ellis.c
@@ -95,10 +95,12 @@ iiEllisInit(void)
 // This routine performs any required cleanup of the iiEllis subsystem.
 //
 //******************************************************************************
+#ifdef MODULE
 static void
 iiEllisCleanup(void)
 {
 }
+#endif
 
 //******************************************************************************
 // Function:   iiSetAddress(pB, address, delay)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
cifs-fix-range-check.patch
fix-cred-wrap-current-cred-and-a-few-other-accessors-on-mips.patch
uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
sysctl-simplify-strategy.patch
mn10300-use-bcd2bin-bin2bcd.patch
mutex-subsystem-synchro-test-module.patch

