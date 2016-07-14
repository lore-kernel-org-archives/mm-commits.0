From: akpm@linux-foundation.org
Subject: [patch 20/20] m32r: fix build warning about putc
Date: Thu, 14 Jul 2016 12:07:43 -0700
Message-ID: <5787e2ff.i+/zKwUi9oYnapRp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbcGNTHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:07:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: fix build warning about putc

We were getting build warning:
arch/m32r/boot/compressed/m32r_sio.c:11:13:
        warning: conflicting types for built-in function 'putc'

Here putc is used as a static function so lets just rename it to avoid
the conflict with the builtin putc.

Link: http://lkml.kernel.org/r/1466977046-24724-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/boot/compressed/m32r_sio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/m32r/boot/compressed/m32r_sio.c~m32r-fix-build-warning-about-putc arch/m32r/boot/compressed/m32r_sio.c
--- a/arch/m32r/boot/compressed/m32r_sio.c~m32r-fix-build-warning-about-putc
+++ a/arch/m32r/boot/compressed/m32r_sio.c
@@ -8,12 +8,13 @@
 
 #include <asm/processor.h>
 
-static void putc(char c);
+static void m32r_putc(char c);
 
 static int puts(const char *s)
 {
 	char c;
-	while ((c = *s++)) putc(c);
+	while ((c = *s++))
+		m32r_putc(c);
 	return 0;
 }
 
@@ -41,7 +42,7 @@ static int puts(const char *s)
 #define BOOT_SIO0TXB	PLD_ESIO0TXB
 #endif
 
-static void putc(char c)
+static void m32r_putc(char c)
 {
 	while ((*BOOT_SIO0STS & 0x3) != 0x3)
 		cpu_relax();
@@ -61,7 +62,7 @@ static void putc(char c)
 #define SIO0TXB	(volatile unsigned short *)(0x00efd000 + 30)
 #endif
 
-static void putc(char c)
+static void m32r_putc(char c)
 {
 	while ((*SIO0STS & 0x1) == 0)
 		cpu_relax();
_
