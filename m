From: akpm@linux-foundation.org
Subject: + documentation-move-spidev_fdx-example-to-its-own-source-file.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:20 -0800
Message-ID: <200802230735.m1N7Z9U3018339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755045AbYBWHzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:55:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dbrownell@users.sourceforge.net


The patch titled
     documentation: move spidev_fdx example to its own source file
has been added to the -mm tree.  Its filename is
     documentation-move-spidev_fdx-example-to-its-own-source-file.patch

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
Subject: documentation: move spidev_fdx example to its own source file
From: Randy Dunlap <randy.dunlap@oracle.com>

Move sample source code to its own source file so that it can be used
easier and build-tested/check/maintained by anyone.

(Makefile changes are in a separate patch for all of Documentation/.)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spidev       |  168 -------------------------------
 Documentation/spi/spidev_fdx.c |  158 +++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 166 deletions(-)

diff -puN Documentation/spi/spidev~documentation-move-spidev_fdx-example-to-its-own-source-file Documentation/spi/spidev
--- a/Documentation/spi/spidev~documentation-move-spidev_fdx-example-to-its-own-source-file
+++ a/Documentation/spi/spidev
@@ -126,8 +126,8 @@ NOTES:
 FULL DUPLEX CHARACTER DEVICE API
 ================================
 
-See the sample program below for one example showing the use of the full
-duplex programming interface.  (Although it doesn't perform a full duplex
+See the spidev_fdx.c sample program for one example showing the use of the
+full duplex programming interface.  (Although it doesn't perform a full duplex
 transfer.)  The model is the same as that used in the kernel spi_sync()
 request; the individual transfers offer the same capabilities as are
 available to kernel drivers (except that it's not asynchronous).
@@ -141,167 +141,3 @@ and bitrate for each transfer segment.)
 
 To make a full duplex request, provide both rx_buf and tx_buf for the
 same transfer.  It's even OK if those are the same buffer.
-
-
-SAMPLE PROGRAM
-==============
-
---------------------------------	CUT HERE
-#include <stdio.h>
-#include <unistd.h>
-#include <stdlib.h>
-#include <fcntl.h>
-#include <string.h>
-
-#include <sys/ioctl.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-
-#include <linux/types.h>
-#include <linux/spi/spidev.h>
-
-
-static int verbose;
-
-static void do_read(int fd, int len)
-{
-	unsigned char	buf[32], *bp;
-	int		status;
-
-	/* read at least 2 bytes, no more than 32 */
-	if (len < 2)
-		len = 2;
-	else if (len > sizeof(buf))
-		len = sizeof(buf);
-	memset(buf, 0, sizeof buf);
-
-	status = read(fd, buf, len);
-	if (status < 0) {
-		perror("read");
-		return;
-	}
-	if (status != len) {
-		fprintf(stderr, "short read\n");
-		return;
-	}
-
-	printf("read(%2d, %2d): %02x %02x,", len, status,
-		buf[0], buf[1]);
-	status -= 2;
-	bp = buf + 2;
-	while (status-- > 0)
-		printf(" %02x", *bp++);
-	printf("\n");
-}
-
-static void do_msg(int fd, int len)
-{
-	struct spi_ioc_transfer	xfer[2];
-	unsigned char		buf[32], *bp;
-	int			status;
-
-	memset(xfer, 0, sizeof xfer);
-	memset(buf, 0, sizeof buf);
-
-	if (len > sizeof buf)
-		len = sizeof buf;
-
-	buf[0] = 0xaa;
-	xfer[0].tx_buf = (__u64) buf;
-	xfer[0].len = 1;
-
-	xfer[1].rx_buf = (__u64) buf;
-	xfer[1].len = len;
-
-	status = ioctl(fd, SPI_IOC_MESSAGE(2), xfer);
-	if (status < 0) {
-		perror("SPI_IOC_MESSAGE");
-		return;
-	}
-
-	printf("response(%2d, %2d): ", len, status);
-	for (bp = buf; len; len--)
-		printf(" %02x", *bp++);
-	printf("\n");
-}
-
-static void dumpstat(const char *name, int fd)
-{
-	__u8	mode, lsb, bits;
-	__u32	speed;
-
-	if (ioctl(fd, SPI_IOC_RD_MODE, &mode) < 0) {
-		perror("SPI rd_mode");
-		return;
-	}
-	if (ioctl(fd, SPI_IOC_RD_LSB_FIRST, &lsb) < 0) {
-		perror("SPI rd_lsb_fist");
-		return;
-	}
-	if (ioctl(fd, SPI_IOC_RD_BITS_PER_WORD, &bits) < 0) {
-		perror("SPI bits_per_word");
-		return;
-	}
-	if (ioctl(fd, SPI_IOC_RD_MAX_SPEED_HZ, &speed) < 0) {
-		perror("SPI max_speed_hz");
-		return;
-	}
-
-	printf("%s: spi mode %d, %d bits %sper word, %d Hz max\n",
-		name, mode, bits, lsb ? "(lsb first) " : "", speed);
-}
-
-int main(int argc, char **argv)
-{
-	int		c;
-	int		readcount = 0;
-	int		msglen = 0;
-	int		fd;
-	const char	*name;
-
-	while ((c = getopt(argc, argv, "hm:r:v")) != EOF) {
-		switch (c) {
-		case 'm':
-			msglen = atoi(optarg);
-			if (msglen < 0)
-				goto usage;
-			continue;
-		case 'r':
-			readcount = atoi(optarg);
-			if (readcount < 0)
-				goto usage;
-			continue;
-		case 'v':
-			verbose++;
-			continue;
-		case 'h':
-		case '?':
-usage:
-			fprintf(stderr,
-				"usage: %s [-h] [-m N] [-r N] /dev/spidevB.D\n",
-				argv[0]);
-			return 1;
-		}
-	}
-
-	if ((optind + 1) != argc)
-		goto usage;
-	name = argv[optind];
-
-	fd = open(name, O_RDWR);
-	if (fd < 0) {
-		perror("open");
-		return 1;
-	}
-
-	dumpstat(name, fd);
-
-	if (msglen)
-		do_msg(fd, msglen);
-
-	if (readcount)
-		do_read(fd, readcount);
-
-	close(fd);
-	return 0;
-}
diff -puN /dev/null Documentation/spi/spidev_fdx.c
--- /dev/null
+++ a/Documentation/spi/spidev_fdx.c
@@ -0,0 +1,158 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <string.h>
+
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <linux/types.h>
+#include <linux/spi/spidev.h>
+
+
+static int verbose;
+
+static void do_read(int fd, int len)
+{
+	unsigned char	buf[32], *bp;
+	int		status;
+
+	/* read at least 2 bytes, no more than 32 */
+	if (len < 2)
+		len = 2;
+	else if (len > sizeof(buf))
+		len = sizeof(buf);
+	memset(buf, 0, sizeof buf);
+
+	status = read(fd, buf, len);
+	if (status < 0) {
+		perror("read");
+		return;
+	}
+	if (status != len) {
+		fprintf(stderr, "short read\n");
+		return;
+	}
+
+	printf("read(%2d, %2d): %02x %02x,", len, status,
+		buf[0], buf[1]);
+	status -= 2;
+	bp = buf + 2;
+	while (status-- > 0)
+		printf(" %02x", *bp++);
+	printf("\n");
+}
+
+static void do_msg(int fd, int len)
+{
+	struct spi_ioc_transfer	xfer[2];
+	unsigned char		buf[32], *bp;
+	int			status;
+
+	memset(xfer, 0, sizeof xfer);
+	memset(buf, 0, sizeof buf);
+
+	if (len > sizeof buf)
+		len = sizeof buf;
+
+	buf[0] = 0xaa;
+	xfer[0].tx_buf = (__u64) buf;
+	xfer[0].len = 1;
+
+	xfer[1].rx_buf = (__u64) buf;
+	xfer[1].len = len;
+
+	status = ioctl(fd, SPI_IOC_MESSAGE(2), xfer);
+	if (status < 0) {
+		perror("SPI_IOC_MESSAGE");
+		return;
+	}
+
+	printf("response(%2d, %2d): ", len, status);
+	for (bp = buf; len; len--)
+		printf(" %02x", *bp++);
+	printf("\n");
+}
+
+static void dumpstat(const char *name, int fd)
+{
+	__u8	mode, lsb, bits;
+	__u32	speed;
+
+	if (ioctl(fd, SPI_IOC_RD_MODE, &mode) < 0) {
+		perror("SPI rd_mode");
+		return;
+	}
+	if (ioctl(fd, SPI_IOC_RD_LSB_FIRST, &lsb) < 0) {
+		perror("SPI rd_lsb_fist");
+		return;
+	}
+	if (ioctl(fd, SPI_IOC_RD_BITS_PER_WORD, &bits) < 0) {
+		perror("SPI bits_per_word");
+		return;
+	}
+	if (ioctl(fd, SPI_IOC_RD_MAX_SPEED_HZ, &speed) < 0) {
+		perror("SPI max_speed_hz");
+		return;
+	}
+
+	printf("%s: spi mode %d, %d bits %sper word, %d Hz max\n",
+		name, mode, bits, lsb ? "(lsb first) " : "", speed);
+}
+
+int main(int argc, char **argv)
+{
+	int		c;
+	int		readcount = 0;
+	int		msglen = 0;
+	int		fd;
+	const char	*name;
+
+	while ((c = getopt(argc, argv, "hm:r:v")) != EOF) {
+		switch (c) {
+		case 'm':
+			msglen = atoi(optarg);
+			if (msglen < 0)
+				goto usage;
+			continue;
+		case 'r':
+			readcount = atoi(optarg);
+			if (readcount < 0)
+				goto usage;
+			continue;
+		case 'v':
+			verbose++;
+			continue;
+		case 'h':
+		case '?':
+usage:
+			fprintf(stderr,
+				"usage: %s [-h] [-m N] [-r N] /dev/spidevB.D\n",
+				argv[0]);
+			return 1;
+		}
+	}
+
+	if ((optind + 1) != argc)
+		goto usage;
+	name = argv[optind];
+
+	fd = open(name, O_RDWR);
+	if (fd < 0) {
+		perror("open");
+		return 1;
+	}
+
+	dumpstat(name, fd);
+
+	if (msglen)
+		do_msg(fd, msglen);
+
+	if (readcount)
+		do_read(fd, readcount);
+
+	close(fd);
+	return 0;
+}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

make-lkdtm-depend-on-block.patch
git-acpi.patch
sysfs-small-header-file-cleanup.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
kernel-doc-fix-function-pointer-parameter-parsing.patch
let-log_buf_shift-default-to-17.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
firmware-move-firmware_class-from-documentation-to-samples.patch
profile-likely-unlikely-macros.patch
