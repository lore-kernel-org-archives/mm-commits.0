From: akpm@linux-foundation.org
Subject: + pps-documentation-programs-and-examples.patch added to -mm tree
Date: Thu, 20 Mar 2008 13:03:28 -0700
Message-ID: <200803202003.m2KK3TNt021534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978AbYCTUEE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Mar 2008 16:04:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it


The patch titled
     PPS: documentation programs and examples
has been added to the -mm tree.  Its filename is
     pps-documentation-programs-and-examples.patch

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
Subject: PPS: documentation programs and examples
From: Rodolfo Giometti <giometti@linux.it>

Here some utilities and examples about the PPS API and the LinuxPPS support.

* ppstest.c implements an useful testing program, while

* ppsfind tries to help the user into finding a specific PPS source by
  using its name or path.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pps/Makefile  |   27 ++++++
 Documentation/pps/ppsfind   |   17 +++
 Documentation/pps/ppstest.c |  151 ++++++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+)

diff -puN /dev/null Documentation/pps/Makefile
--- /dev/null
+++ a/Documentation/pps/Makefile
@@ -0,0 +1,27 @@
+TARGETS = ppstest
+
+CFLAGS += -Wall -O2 -D_GNU_SOURCE
+CFLAGS += -I .
+CFLAGS += -ggdb
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

linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
pps-serial-clients-support.patch
pps-example-program-to-enable-pps-support-on-serial-ports.patch
pps-parallel-port-clients-support.patch

