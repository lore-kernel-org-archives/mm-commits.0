From: akpm@linux-foundation.org
Subject: + documentation-spi-spidev_testc-constify-some-variables.patch added to -mm tree
Date: Sat, 06 Oct 2007 00:49:29 -0700
Message-ID: <200710060749.l967nTIb013695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbXJFHtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Oct 2007 03:49:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net


The patch titled
     Documentation/spi/spidev_test.c: constify some variables
has been added to the -mm tree.  Its filename is
     documentation-spi-spidev_testc-constify-some-variables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation/spi/spidev_test.c: constify some variables
From: WANG Cong <xiyou.wangcong@gmail.com>

Constify two char pointers and a struct in Documentation/spi/spidev_test.c.

Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spidev_test.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/spi/spidev_test.c~documentation-spi-spidev_testc-constify-some-variables Documentation/spi/spidev_test.c
--- a/Documentation/spi/spidev_test.c~documentation-spi-spidev_testc-constify-some-variables
+++ a/Documentation/spi/spidev_test.c
@@ -29,7 +29,7 @@ static void pabort(const char *s)
 	abort();
 }
 
-static char *device = "/dev/spidev1.1";
+static const char *device = "/dev/spidev1.1";
 static uint8_t mode;
 static uint8_t bits = 8;
 static uint32_t speed = 500000;
@@ -69,7 +69,7 @@ static void transfer(int fd)
 	puts("");
 }
 
-void print_usage(char *prog)
+void print_usage(const char *prog)
 {
 	printf("Usage: %s [-DsbdlHOLC3]\n", prog);
 	puts("  -D --device   device to use (default /dev/spidev1.1)\n"
@@ -88,7 +88,7 @@ void print_usage(char *prog)
 void parse_opts(int argc, char *argv[])
 {
 	while (1) {
-		static struct option lopts[] = {
+		static const struct option lopts[] = {
 			{ "device",  1, 0, 'D' },
 			{ "speed",   1, 0, 's' },
 			{ "delay",   1, 0, 'd' },
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-net.patch
fs-romfs-inodec-trivial-improvements.patch
fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
documentation-spi-spidev_testc-constify-some-variables.patch
documentation-vm-slabinfoc-clean-up-this-code.patch
