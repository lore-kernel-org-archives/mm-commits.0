From: akpm@linux-foundation.org
Subject: - documentation-move-spidev_fdx-example-to-its-own-source-file.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:51 -0700
Message-ID: <200804282155.m3SLtpLF018160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935940AbYD1V4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     documentation: move spidev_fdx example to its own source file
has been removed from the -mm tree.  Its filename was
     documentation-move-spidev_fdx-example-to-its-own-source-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
doc-fix-dma-api-function-parameters.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

