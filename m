From: akpm@linux-foundation.org
Subject: + documentation-timers-split-txt-and-source-files.patch added to -mm tree
Date: Tue, 09 Feb 2010 14:26:27 -0800
Message-ID: <201002092226.o19MQRWR005435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529Ab0BIW1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 17:27:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, tglx@linutronix.de


The patch titled
     Documentation/timers/: split txt and source files
has been added to the -mm tree.  Its filename is
     documentation-timers-split-txt-and-source-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/timers/: split txt and source files
From: Randy Dunlap <randy.dunlap@oracle.com>

Documentation/timers/hpet.txt:
Expose example and tool source files in the Documentation/timers/ directory in
their own files instead of being buried (almost hidden) in readme/txt files.
This should help to prevent bitrot.

This will make them more visible/usable to users who may need
to use them, to developers who may need to test with them, and
to anyone who would fix/update them if they were more visible.

Also, if any of these possibly should not be in the kernel tree at
all, it will be clearer that they are here and we can discuss if
they should be removed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Makefile              |    2 
 Documentation/timers/00-INDEX       |    2 
 Documentation/timers/Makefile       |    8 
 Documentation/timers/hpet.txt       |  273 --------------------------
 Documentation/timers/hpet_example.c |  269 +++++++++++++++++++++++++
 5 files changed, 282 insertions(+), 272 deletions(-)

diff -puN Documentation/Makefile~documentation-timers-split-txt-and-source-files Documentation/Makefile
--- a/Documentation/Makefile~documentation-timers-split-txt-and-source-files
+++ a/Documentation/Makefile
@@ -1,3 +1,3 @@
 obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
 	filesystems/configfs/ ia64/ networking/ \
-	pcmcia/ spi/ video4linux/ vm/ watchdog/src/
+	pcmcia/ spi/ timers/ video4linux/ vm/ watchdog/src/
diff -puN Documentation/timers/00-INDEX~documentation-timers-split-txt-and-source-files Documentation/timers/00-INDEX
--- a/Documentation/timers/00-INDEX~documentation-timers-split-txt-and-source-files
+++ a/Documentation/timers/00-INDEX
@@ -4,6 +4,8 @@ highres.txt
 	- High resolution timers and dynamic ticks design notes
 hpet.txt
 	- High Precision Event Timer Driver for Linux
+hpet_example.c
+	- sample hpet timer test program
 hrtimers.txt
 	- subsystem for high-resolution kernel timers
 timer_stats.txt
diff -puN /dev/null Documentation/timers/Makefile
--- /dev/null
+++ a/Documentation/timers/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := hpet_example
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
diff -puN Documentation/timers/hpet.txt~documentation-timers-split-txt-and-source-files Documentation/timers/hpet.txt
--- a/Documentation/timers/hpet.txt~documentation-timers-split-txt-and-source-files
+++ a/Documentation/timers/hpet.txt
@@ -26,274 +26,5 @@ initialization.  An example of this init
 arch/x86/kernel/hpet.c.
 
 The driver provides a userspace API which resembles the API found in the
-RTC driver framework.  An example user space program is provided below.
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <string.h>
-#include <memory.h>
-#include <malloc.h>
-#include <time.h>
-#include <ctype.h>
-#include <sys/types.h>
-#include <sys/wait.h>
-#include <signal.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <sys/time.h>
-#include <linux/hpet.h>
-
-
-extern void hpet_open_close(int, const char **);
-extern void hpet_info(int, const char **);
-extern void hpet_poll(int, const char **);
-extern void hpet_fasync(int, const char **);
-extern void hpet_read(int, const char **);
-
-#include <sys/poll.h>
-#include <sys/ioctl.h>
-#include <signal.h>
-
-struct hpet_command {
-	char		*command;
-	void		(*func)(int argc, const char ** argv);
-} hpet_command[] = {
-	{
-		"open-close",
-		hpet_open_close
-	},
-	{
-		"info",
-		hpet_info
-	},
-	{
-		"poll",
-		hpet_poll
-	},
-	{
-		"fasync",
-		hpet_fasync
-	},
-};
-
-int
-main(int argc, const char ** argv)
-{
-	int	i;
-
-	argc--;
-	argv++;
-
-	if (!argc) {
-		fprintf(stderr, "-hpet: requires command\n");
-		return -1;
-	}
-
-
-	for (i = 0; i < (sizeof (hpet_command) / sizeof (hpet_command[0])); i++)
-		if (!strcmp(argv[0], hpet_command[i].command)) {
-			argc--;
-			argv++;
-			fprintf(stderr, "-hpet: executing %s\n",
-				hpet_command[i].command);
-			hpet_command[i].func(argc, argv);
-			return 0;
-		}
-
-	fprintf(stderr, "do_hpet: command %s not implemented\n", argv[0]);
-
-	return -1;
-}
-
-void
-hpet_open_close(int argc, const char **argv)
-{
-	int	fd;
-
-	if (argc != 1) {
-		fprintf(stderr, "hpet_open_close: device-name\n");
-		return;
-	}
-
-	fd = open(argv[0], O_RDONLY);
-	if (fd < 0)
-		fprintf(stderr, "hpet_open_close: open failed\n");
-	else
-		close(fd);
-
-	return;
-}
-
-void
-hpet_info(int argc, const char **argv)
-{
-}
-
-void
-hpet_poll(int argc, const char **argv)
-{
-	unsigned long		freq;
-	int			iterations, i, fd;
-	struct pollfd		pfd;
-	struct hpet_info	info;
-	struct timeval		stv, etv;
-	struct timezone		tz;
-	long			usec;
-
-	if (argc != 3) {
-		fprintf(stderr, "hpet_poll: device-name freq iterations\n");
-		return;
-	}
-
-	freq = atoi(argv[1]);
-	iterations = atoi(argv[2]);
-
-	fd = open(argv[0], O_RDONLY);
-
-	if (fd < 0) {
-		fprintf(stderr, "hpet_poll: open of %s failed\n", argv[0]);
-		return;
-	}
-
-	if (ioctl(fd, HPET_IRQFREQ, freq) < 0) {
-		fprintf(stderr, "hpet_poll: HPET_IRQFREQ failed\n");
-		goto out;
-	}
-
-	if (ioctl(fd, HPET_INFO, &info) < 0) {
-		fprintf(stderr, "hpet_poll: failed to get info\n");
-		goto out;
-	}
-
-	fprintf(stderr, "hpet_poll: info.hi_flags 0x%lx\n", info.hi_flags);
-
-	if (info.hi_flags && (ioctl(fd, HPET_EPI, 0) < 0)) {
-		fprintf(stderr, "hpet_poll: HPET_EPI failed\n");
-		goto out;
-	}
-
-	if (ioctl(fd, HPET_IE_ON, 0) < 0) {
-		fprintf(stderr, "hpet_poll, HPET_IE_ON failed\n");
-		goto out;
-	}
-
-	pfd.fd = fd;
-	pfd.events = POLLIN;
-
-	for (i = 0; i < iterations; i++) {
-		pfd.revents = 0;
-		gettimeofday(&stv, &tz);
-		if (poll(&pfd, 1, -1) < 0)
-			fprintf(stderr, "hpet_poll: poll failed\n");
-		else {
-			long 	data;
-
-			gettimeofday(&etv, &tz);
-			usec = stv.tv_sec * 1000000 + stv.tv_usec;
-			usec = (etv.tv_sec * 1000000 + etv.tv_usec) - usec;
-
-			fprintf(stderr,
-				"hpet_poll: expired time = 0x%lx\n", usec);
-
-			fprintf(stderr, "hpet_poll: revents = 0x%x\n",
-				pfd.revents);
-
-			if (read(fd, &data, sizeof(data)) != sizeof(data)) {
-				fprintf(stderr, "hpet_poll: read failed\n");
-			}
-			else
-				fprintf(stderr, "hpet_poll: data 0x%lx\n",
-					data);
-		}
-	}
-
-out:
-	close(fd);
-	return;
-}
-
-static int hpet_sigio_count;
-
-static void
-hpet_sigio(int val)
-{
-	fprintf(stderr, "hpet_sigio: called\n");
-	hpet_sigio_count++;
-}
-
-void
-hpet_fasync(int argc, const char **argv)
-{
-	unsigned long		freq;
-	int			iterations, i, fd, value;
-	sig_t			oldsig;
-	struct hpet_info	info;
-
-	hpet_sigio_count = 0;
-	fd = -1;
-
-	if ((oldsig = signal(SIGIO, hpet_sigio)) == SIG_ERR) {
-		fprintf(stderr, "hpet_fasync: failed to set signal handler\n");
-		return;
-	}
-
-	if (argc != 3) {
-		fprintf(stderr, "hpet_fasync: device-name freq iterations\n");
-		goto out;
-	}
-
-	fd = open(argv[0], O_RDONLY);
-
-	if (fd < 0) {
-		fprintf(stderr, "hpet_fasync: failed to open %s\n", argv[0]);
-		return;
-	}
-
-
-	if ((fcntl(fd, F_SETOWN, getpid()) == 1) ||
-		((value = fcntl(fd, F_GETFL)) == 1) ||
-		(fcntl(fd, F_SETFL, value | O_ASYNC) == 1)) {
-		fprintf(stderr, "hpet_fasync: fcntl failed\n");
-		goto out;
-	}
-
-	freq = atoi(argv[1]);
-	iterations = atoi(argv[2]);
-
-	if (ioctl(fd, HPET_IRQFREQ, freq) < 0) {
-		fprintf(stderr, "hpet_fasync: HPET_IRQFREQ failed\n");
-		goto out;
-	}
-
-	if (ioctl(fd, HPET_INFO, &info) < 0) {
-		fprintf(stderr, "hpet_fasync: failed to get info\n");
-		goto out;
-	}
-
-	fprintf(stderr, "hpet_fasync: info.hi_flags 0x%lx\n", info.hi_flags);
-
-	if (info.hi_flags && (ioctl(fd, HPET_EPI, 0) < 0)) {
-		fprintf(stderr, "hpet_fasync: HPET_EPI failed\n");
-		goto out;
-	}
-
-	if (ioctl(fd, HPET_IE_ON, 0) < 0) {
-		fprintf(stderr, "hpet_fasync, HPET_IE_ON failed\n");
-		goto out;
-	}
-
-	for (i = 0; i < iterations; i++) {
-		(void) pause();
-		fprintf(stderr, "hpet_fasync: count = %d\n", hpet_sigio_count);
-	}
-
-out:
-	signal(SIGIO, oldsig);
-
-	if (fd >= 0)
-		close(fd);
-
-	return;
-}
+RTC driver framework.  An example user space program is provided in
+file:Documentation/timers/hpet_example.c
diff -puN /dev/null Documentation/timers/hpet_example.c
--- /dev/null
+++ a/Documentation/timers/hpet_example.c
@@ -0,0 +1,269 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <string.h>
+#include <memory.h>
+#include <malloc.h>
+#include <time.h>
+#include <ctype.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <signal.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/time.h>
+#include <linux/hpet.h>
+
+
+extern void hpet_open_close(int, const char **);
+extern void hpet_info(int, const char **);
+extern void hpet_poll(int, const char **);
+extern void hpet_fasync(int, const char **);
+extern void hpet_read(int, const char **);
+
+#include <sys/poll.h>
+#include <sys/ioctl.h>
+#include <signal.h>
+
+struct hpet_command {
+	char		*command;
+	void		(*func)(int argc, const char ** argv);
+} hpet_command[] = {
+	{
+		"open-close",
+		hpet_open_close
+	},
+	{
+		"info",
+		hpet_info
+	},
+	{
+		"poll",
+		hpet_poll
+	},
+	{
+		"fasync",
+		hpet_fasync
+	},
+};
+
+int
+main(int argc, const char ** argv)
+{
+	int	i;
+
+	argc--;
+	argv++;
+
+	if (!argc) {
+		fprintf(stderr, "-hpet: requires command\n");
+		return -1;
+	}
+
+
+	for (i = 0; i < (sizeof (hpet_command) / sizeof (hpet_command[0])); i++)
+		if (!strcmp(argv[0], hpet_command[i].command)) {
+			argc--;
+			argv++;
+			fprintf(stderr, "-hpet: executing %s\n",
+				hpet_command[i].command);
+			hpet_command[i].func(argc, argv);
+			return 0;
+		}
+
+	fprintf(stderr, "do_hpet: command %s not implemented\n", argv[0]);
+
+	return -1;
+}
+
+void
+hpet_open_close(int argc, const char **argv)
+{
+	int	fd;
+
+	if (argc != 1) {
+		fprintf(stderr, "hpet_open_close: device-name\n");
+		return;
+	}
+
+	fd = open(argv[0], O_RDONLY);
+	if (fd < 0)
+		fprintf(stderr, "hpet_open_close: open failed\n");
+	else
+		close(fd);
+
+	return;
+}
+
+void
+hpet_info(int argc, const char **argv)
+{
+}
+
+void
+hpet_poll(int argc, const char **argv)
+{
+	unsigned long		freq;
+	int			iterations, i, fd;
+	struct pollfd		pfd;
+	struct hpet_info	info;
+	struct timeval		stv, etv;
+	struct timezone		tz;
+	long			usec;
+
+	if (argc != 3) {
+		fprintf(stderr, "hpet_poll: device-name freq iterations\n");
+		return;
+	}
+
+	freq = atoi(argv[1]);
+	iterations = atoi(argv[2]);
+
+	fd = open(argv[0], O_RDONLY);
+
+	if (fd < 0) {
+		fprintf(stderr, "hpet_poll: open of %s failed\n", argv[0]);
+		return;
+	}
+
+	if (ioctl(fd, HPET_IRQFREQ, freq) < 0) {
+		fprintf(stderr, "hpet_poll: HPET_IRQFREQ failed\n");
+		goto out;
+	}
+
+	if (ioctl(fd, HPET_INFO, &info) < 0) {
+		fprintf(stderr, "hpet_poll: failed to get info\n");
+		goto out;
+	}
+
+	fprintf(stderr, "hpet_poll: info.hi_flags 0x%lx\n", info.hi_flags);
+
+	if (info.hi_flags && (ioctl(fd, HPET_EPI, 0) < 0)) {
+		fprintf(stderr, "hpet_poll: HPET_EPI failed\n");
+		goto out;
+	}
+
+	if (ioctl(fd, HPET_IE_ON, 0) < 0) {
+		fprintf(stderr, "hpet_poll, HPET_IE_ON failed\n");
+		goto out;
+	}
+
+	pfd.fd = fd;
+	pfd.events = POLLIN;
+
+	for (i = 0; i < iterations; i++) {
+		pfd.revents = 0;
+		gettimeofday(&stv, &tz);
+		if (poll(&pfd, 1, -1) < 0)
+			fprintf(stderr, "hpet_poll: poll failed\n");
+		else {
+			long 	data;
+
+			gettimeofday(&etv, &tz);
+			usec = stv.tv_sec * 1000000 + stv.tv_usec;
+			usec = (etv.tv_sec * 1000000 + etv.tv_usec) - usec;
+
+			fprintf(stderr,
+				"hpet_poll: expired time = 0x%lx\n", usec);
+
+			fprintf(stderr, "hpet_poll: revents = 0x%x\n",
+				pfd.revents);
+
+			if (read(fd, &data, sizeof(data)) != sizeof(data)) {
+				fprintf(stderr, "hpet_poll: read failed\n");
+			}
+			else
+				fprintf(stderr, "hpet_poll: data 0x%lx\n",
+					data);
+		}
+	}
+
+out:
+	close(fd);
+	return;
+}
+
+static int hpet_sigio_count;
+
+static void
+hpet_sigio(int val)
+{
+	fprintf(stderr, "hpet_sigio: called\n");
+	hpet_sigio_count++;
+}
+
+void
+hpet_fasync(int argc, const char **argv)
+{
+	unsigned long		freq;
+	int			iterations, i, fd, value;
+	sig_t			oldsig;
+	struct hpet_info	info;
+
+	hpet_sigio_count = 0;
+	fd = -1;
+
+	if ((oldsig = signal(SIGIO, hpet_sigio)) == SIG_ERR) {
+		fprintf(stderr, "hpet_fasync: failed to set signal handler\n");
+		return;
+	}
+
+	if (argc != 3) {
+		fprintf(stderr, "hpet_fasync: device-name freq iterations\n");
+		goto out;
+	}
+
+	fd = open(argv[0], O_RDONLY);
+
+	if (fd < 0) {
+		fprintf(stderr, "hpet_fasync: failed to open %s\n", argv[0]);
+		return;
+	}
+
+
+	if ((fcntl(fd, F_SETOWN, getpid()) == 1) ||
+		((value = fcntl(fd, F_GETFL)) == 1) ||
+		(fcntl(fd, F_SETFL, value | O_ASYNC) == 1)) {
+		fprintf(stderr, "hpet_fasync: fcntl failed\n");
+		goto out;
+	}
+
+	freq = atoi(argv[1]);
+	iterations = atoi(argv[2]);
+
+	if (ioctl(fd, HPET_IRQFREQ, freq) < 0) {
+		fprintf(stderr, "hpet_fasync: HPET_IRQFREQ failed\n");
+		goto out;
+	}
+
+	if (ioctl(fd, HPET_INFO, &info) < 0) {
+		fprintf(stderr, "hpet_fasync: failed to get info\n");
+		goto out;
+	}
+
+	fprintf(stderr, "hpet_fasync: info.hi_flags 0x%lx\n", info.hi_flags);
+
+	if (info.hi_flags && (ioctl(fd, HPET_EPI, 0) < 0)) {
+		fprintf(stderr, "hpet_fasync: HPET_EPI failed\n");
+		goto out;
+	}
+
+	if (ioctl(fd, HPET_IE_ON, 0) < 0) {
+		fprintf(stderr, "hpet_fasync, HPET_IE_ON failed\n");
+		goto out;
+	}
+
+	for (i = 0; i < iterations; i++) {
+		(void) pause();
+		fprintf(stderr, "hpet_fasync: count = %d\n", hpet_sigio_count);
+	}
+
+out:
+	signal(SIGIO, oldsig);
+
+	if (fd >= 0)
+		close(fd);
+
+	return;
+}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
msi-laptop-depends-on-rfkill.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
i2c-fix-xiic-build-error.patch
pci-hotplug-fix-ibmphp-build-error.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

