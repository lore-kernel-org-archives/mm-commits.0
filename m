From: akpm@linux-foundation.org
Subject: + pps-example-program-to-enable-pps-support-on-serial-ports.patch added to -mm tree
Date: Thu, 20 Mar 2008 13:03:41 -0700
Message-ID: <200803202003.m2KK3fqR021543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953AbYCTUEQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 16:04:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it


The patch titled
     PPS: example program to enable PPS support on serial ports
has been added to the -mm tree.  Its filename is
     pps-example-program-to-enable-pps-support-on-serial-ports.patch

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
Subject: PPS: example program to enable PPS support on serial ports
From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pps/Makefile |    2 -
 Documentation/pps/ppsctl.c |   62 +++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff -puN Documentation/pps/Makefile~pps-example-program-to-enable-pps-support-on-serial-ports Documentation/pps/Makefile
--- a/Documentation/pps/Makefile~pps-example-program-to-enable-pps-support-on-serial-ports
+++ a/Documentation/pps/Makefile
@@ -1,4 +1,4 @@
-TARGETS = ppstest
+TARGETS = ppstest ppsctl
 
 CFLAGS += -Wall -O2 -D_GNU_SOURCE
 CFLAGS += -I .
diff -puN /dev/null Documentation/pps/ppsctl.c
--- /dev/null
+++ a/Documentation/pps/ppsctl.c
@@ -0,0 +1,62 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+#include <linux/serial.h>
+
+void usage(char *name)
+{
+	fprintf(stderr, "usage: %s <ttyS> [enable|disable]\n", name);
+
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
+	int ret;
+	struct serial_struct ss;
+
+	if (argc < 2)
+		usage(argv[0]);
+
+	fd = open(argv[1], O_RDWR);
+	if (fd < 0) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = ioctl(fd, TIOCGSERIAL, &ss);
+	if (ret < 0) {
+		perror("ioctl(TIOCGSERIAL)");
+		exit(EXIT_FAILURE);
+	}
+
+	if (argc < 3) {		/* just read PPS status */
+		printf("PPS is %sabled\n",
+		       ss.flags & ASYNC_HARDPPS_CD ? "en" : "dis");
+		exit(EXIT_SUCCESS);
+	}
+
+	if (argv[2][0] == 'e' || argv[2][0] == '1')
+		ss.flags |= ASYNC_HARDPPS_CD;
+	else if (argv[2][0] == 'd' || argv[2][0] == '0')
+		ss.flags &= ~ASYNC_HARDPPS_CD;
+	else {
+		fprintf(stderr, "invalid state argument \"%s\"\n", argv[2]);
+		exit(EXIT_FAILURE);
+	}
+
+	ret = ioctl(fd, TIOCSSERIAL, &ss);
+	if (ret < 0) {
+		perror("ioctl(TIOCSSERIAL)");
+		exit(EXIT_FAILURE);
+	}
+
+	return 0;
+}
_

Patches currently in -mm which might be from giometti@linux.it are

linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
pps-serial-clients-support.patch
pps-example-program-to-enable-pps-support-on-serial-ports.patch
pps-parallel-port-clients-support.patch

