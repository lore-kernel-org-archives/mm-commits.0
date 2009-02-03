From: akpm@linux-foundation.org
Subject: [to-be-updated] pps-documentation-programs-and-examples.patch removed from -mm tree
Date: Mon, 02 Feb 2009 23:42:05 -0800
Message-ID: <200902030742.n137g5lP013588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbZBCHnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 02:43:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, davej@redhat.com, dwmw2@infradead.org, greg@kroah.com, hpa@zytor.com, kay.sievers@vrfy.org, mingo@elte.hu, mtk.manpages@gmail.com, randy.d


The patch titled
     PPS: documentation programs and examples
has been removed from the -mm tree.  Its filename was
     pps-documentation-programs-and-examples.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PPS: documentation programs and examples
From: Rodolfo Giometti <giometti@linux.it>

Here some utilities and examples about the PPS API and the LinuxPPS
support.

* ppsldisc.c shows how to manage PPS line discipline;

* ppstest.c implements an useful testing program, while

* ppsfind tries to help the user into finding a specific PPS source by
  using its name or path.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pps/Makefile   |   28 ++++++
 Documentation/pps/ppsfind    |   17 +++
 Documentation/pps/ppsldisc.c |   46 ++++++++++
 Documentation/pps/ppstest.c  |  151 +++++++++++++++++++++++++++++++++
 4 files changed, 242 insertions(+)

diff -puN /dev/null Documentation/pps/Makefile
--- /dev/null
+++ a/Documentation/pps/Makefile
@@ -0,0 +1,28 @@
+TARGETS = ppstest ppsldisc
+
+CFLAGS += -Wall -O2 -D_GNU_SOURCE
+CFLAGS += -I .
+CFLAGS += -ggdb
+CFLAGS += -D__N_PPS=$(shell awk '/N_PPS/ {print $$3}' ../../include/linux/tty.h)
+
+# -- Actions section --
+
+.PHONY : all depend dep
+
+all : .depend $(TARGETS)
+
+.depend depend dep :
+	$(CC) $(CFLAGS) -M $(TARGETS:=.c) > .depend
+
+ifeq (.depend,$(wildcard .depend))
+include .depend
+endif
+
+
+# -- Clean section --
+
+.PHONY : clean
+
+clean :
+	rm -f *.o *~ core .depend
+	rm -f ${TARGETS}
diff -puN /dev/null Documentation/pps/ppsfind
--- /dev/null
+++ a/Documentation/pps/ppsfind
@@ -0,0 +1,17 @@
+#!/bin/sh
+
+SYS="/sys/class/pps/"
+
+if [ $# -lt 1 ] ; then
+	echo "usage: ppsfind <name>" >&2
+	exit 1
+fi
+
+for d in $(ls $SYS) ; do
+	if grep $1 $SYS/$d/name >& /dev/null || \
+	   grep $1 $SYS/$d/path >& /dev/null ; then
+		echo "$d: name=$(cat $SYS/$d/name) path=$(cat $SYS/$d/path)"
+	fi
+done
+
+exit 0
diff -puN /dev/null Documentation/pps/ppsldisc.c
--- /dev/null
+++ a/Documentation/pps/ppsldisc.c
@@ -0,0 +1,46 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+
+#ifndef N_PPS
+#define N_PPS __N_PPS
+#endif
+
+void usage(char *name)
+{
+	fprintf(stderr, "usage: %s <ttyS>\n", name);
+
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
+	int ldisc = N_PPS;
+	int ret;
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
+	ret = ioctl(fd, TIOCSETD, &ldisc);
+	if (ret < 0) {
+		perror("ioctl(TIOCSETD)");
+		exit(EXIT_FAILURE);
+	}
+
+	pause();
+
+	return 0;
+}
diff -puN /dev/null Documentation/pps/ppstest.c
--- /dev/null
+++ a/Documentation/pps/ppstest.c
@@ -0,0 +1,151 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <timepps.h>
+
+int find_source(char *path, pps_handle_t *handle, int *avail_mode)
+{
+	pps_params_t params;
+	int ret;
+
+	printf("trying PPS source \"%s\"\n", path);
+
+	/* Try to find the source by using the supplied "path" name */
+	ret = open(path, O_RDWR);
+	if (ret < 0) {
+		fprintf(stderr, "unable to open device \"%s\" (%m)\n", path);
+		return ret;
+	}
+
+	/* Open the PPS source (and check the file descriptor) */
+	ret = time_pps_create(ret, handle);
+	if (ret < 0) {
+		fprintf(stderr, "cannot create a PPS source from device "
+				"\"%s\" (%m)\n", path);
+		return -1;
+	}
+	printf("found PPS source \"%s\"\n", path);
+
+	/* Find out what features are supported */
+	ret = time_pps_getcap(*handle, avail_mode);
+	if (ret < 0) {
+		fprintf(stderr, "cannot get capabilities (%m)\n");
+		return -1;
+	}
+	if ((*avail_mode & PPS_CAPTUREASSERT) == 0) {
+		fprintf(stderr, "cannot CAPTUREASSERT\n");
+		return -1;
+	}
+	if ((*avail_mode & PPS_OFFSETASSERT) == 0) {
+		fprintf(stderr, "cannot OFFSETASSERT\n");
+		return -1;
+	}
+
+	/* Capture assert timestamps, and compensate for a 675 nsec
+	 * propagation delay */
+	ret = time_pps_getparams(*handle, &params);
+	if (ret < 0) {
+		fprintf(stderr, "cannot get parameters (%m)\n");
+		return -1;
+	}
+	params.assert_offset.tv_sec = 0;
+	params.assert_offset.tv_nsec = 675;
+	params.mode |= PPS_CAPTUREASSERT | PPS_OFFSETASSERT;
+	ret = time_pps_setparams(*handle, &params);
+	if (ret < 0) {
+		fprintf(stderr, "cannot set parameters (%m)\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+int fetch_source(int i, pps_handle_t *handle, int *avail_mode)
+{
+	struct timespec timeout;
+	pps_info_t infobuf;
+	int ret;
+
+	/* create a zero-valued timeout */
+	timeout.tv_sec = 3;
+	timeout.tv_nsec = 0;
+
+retry:
+	if (*avail_mode & PPS_CANWAIT) /* waits for the next event */
+		ret = time_pps_fetch(*handle, PPS_TSFMT_TSPEC, &infobuf,
+				   &timeout);
+	else {
+		sleep(1);
+		ret = time_pps_fetch(*handle, PPS_TSFMT_TSPEC, &infobuf,
+				   &timeout);
+	}
+	if (ret < 0) {
+		if (ret == -EINTR) {
+			fprintf(stderr, "time_pps_fetch() got a signal!\n");
+			goto retry;
+		}
+
+		fprintf(stderr, "time_pps_fetch() error %d (%m)\n", ret);
+		return -1;
+	}
+
+	printf("source %d - "
+	       "assert %ld.%09ld, sequence: %ld - "
+	       "clear  %ld.%09ld, sequence: %ld\n",
+	       i,
+	       infobuf.assert_timestamp.tv_sec,
+	       infobuf.assert_timestamp.tv_nsec,
+	       infobuf.assert_sequence,
+	       infobuf.clear_timestamp.tv_sec,
+	       infobuf.clear_timestamp.tv_nsec, infobuf.clear_sequence);
+
+	return 0;
+}
+
+void usage(char *name)
+{
+	fprintf(stderr, "usage: %s <ppsdev> [<ppsdev> ...]\n", name);
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char *argv[])
+{
+	int num;
+	pps_handle_t handle[4];
+	int avail_mode[4];
+	int i = 0;
+	int ret;
+
+	/* Check the command line */
+	if (argc < 2)
+		usage(argv[0]);
+
+	for (i = 1; i < argc && i <= 4; i++) {
+		ret = find_source(argv[i], &handle[i - 1], &avail_mode[i - 1]);
+		if (ret < 0)
+			exit(EXIT_FAILURE);
+	}
+
+	num = i - 1;
+	printf("ok, found %d source(s), now start fetching data...\n", num);
+
+	/* loop, printing the most recent timestamp every second or so */
+	while (1) {
+		for (i = 0; i < num; i++) {
+			ret = fetch_source(i, &handle[i], &avail_mode[i]);
+			if (ret < 0 && errno != ETIMEDOUT)
+				exit(EXIT_FAILURE);
+		}
+	}
+
+	for (; i >= 0; i--)
+		time_pps_destroy(handle[i]);
+
+	return 0;
+}
_

Patches currently in -mm which might be from giometti@linux.it are

pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

