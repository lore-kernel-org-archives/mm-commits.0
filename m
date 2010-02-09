From: akpm@linux-foundation.org
Subject: + documentation-laptop-split-txt-and-source-files.patch added to -mm tree
Date: Tue, 09 Feb 2010 14:26:29 -0800
Message-ID: <201002092226.o19MQUu6005438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529Ab0BIW1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 17:27:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     Documentation/laptop/: split txt and source files
has been added to the -mm tree.  Its filename is
     documentation-laptop-split-txt-and-source-files.patch

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
Subject: Documentation/laptop/: split txt and source files
From: Randy Dunlap <randy.dunlap@oracle.com>

Documentation/laptops/laptop-mode.txt:
Expose example and tool source files in the Documentation/ directory in
their own files instead of being buried (almost hidden) in readme/txt files.
This should help to prevent bitrot.

This will make them more visible/usable to users who may need
to use them, to developers who may need to test with them, and
to anyone who would fix/update them if they were more visible.

Also, if any of these possibly should not be in the kernel tree at
all, it will be clearer that they are here and we can discuss if
they should be removed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Makefile                |    2 
 Documentation/laptops/00-INDEX        |    4 
 Documentation/laptops/Makefile        |    8 +
 Documentation/laptops/dslm.c          |  166 +++++++++++++++++++++++
 Documentation/laptops/laptop-mode.txt |  170 ------------------------
 5 files changed, 179 insertions(+), 171 deletions(-)

diff -puN Documentation/Makefile~documentation-laptop-split-txt-and-source-files Documentation/Makefile
--- a/Documentation/Makefile~documentation-laptop-split-txt-and-source-files
+++ a/Documentation/Makefile
@@ -1,3 +1,3 @@
 obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
-	filesystems/configfs/ ia64/ networking/ \
+	filesystems/configfs/ ia64/ laptops/ networking/ \
 	pcmcia/ spi/ timers/ video4linux/ vm/ watchdog/src/
diff -puN Documentation/laptops/00-INDEX~documentation-laptop-split-txt-and-source-files Documentation/laptops/00-INDEX
--- a/Documentation/laptops/00-INDEX~documentation-laptop-split-txt-and-source-files
+++ a/Documentation/laptops/00-INDEX
@@ -5,7 +5,9 @@ acer-wmi.txt
 asus-laptop.txt
 	- information on the Asus Laptop Extras driver.
 disk-shock-protection.txt
-	- information on hard disk shock protection.
+	- information on Hard disk shock protection
+dslm.c
+	- Simple Disk Sleep Monitor program
 laptop-mode.txt
 	- how to conserve battery power using laptop-mode.
 sony-laptop.txt
diff -puN /dev/null Documentation/laptops/Makefile
--- /dev/null
+++ a/Documentation/laptops/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := dslm
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
diff -puN /dev/null Documentation/laptops/dslm.c
--- /dev/null
+++ a/Documentation/laptops/dslm.c
@@ -0,0 +1,166 @@
+/*
+ * dslm.c
+ * Simple Disk Sleep Monitor
+ *  by Bartek Kania
+ * Licenced under the GPL
+ */
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <time.h>
+#include <string.h>
+#include <signal.h>
+#include <sys/ioctl.h>
+#include <linux/hdreg.h>
+
+#ifdef DEBUG
+#define D(x) x
+#else
+#define D(x)
+#endif
+
+int endit = 0;
+
+/* Check if the disk is in powersave-mode
+ * Most of the code is stolen from hdparm.
+ * 1 = active, 0 = standby/sleep, -1 = unknown */
+static int check_powermode(int fd)
+{
+    unsigned char args[4] = {WIN_CHECKPOWERMODE1,0,0,0};
+    int state;
+
+    if (ioctl(fd, HDIO_DRIVE_CMD, &args)
+	&& (args[0] = WIN_CHECKPOWERMODE2) /* try again with 0x98 */
+	&& ioctl(fd, HDIO_DRIVE_CMD, &args)) {
+	if (errno != EIO || args[0] != 0 || args[1] != 0) {
+	    state = -1; /* "unknown"; */
+	} else
+	    state = 0; /* "sleeping"; */
+    } else {
+	state = (args[2] == 255) ? 1 : 0;
+    }
+    D(printf(" drive state is:  %d\n", state));
+
+    return state;
+}
+
+static char *state_name(int i)
+{
+    if (i == -1) return "unknown";
+    if (i == 0) return "sleeping";
+    if (i == 1) return "active";
+
+    return "internal error";
+}
+
+static char *myctime(time_t time)
+{
+    char *ts = ctime(&time);
+    ts[strlen(ts) - 1] = 0;
+
+    return ts;
+}
+
+static void measure(int fd)
+{
+    time_t start_time;
+    int last_state;
+    time_t last_time;
+    int curr_state;
+    time_t curr_time = 0;
+    time_t time_diff;
+    time_t active_time = 0;
+    time_t sleep_time = 0;
+    time_t unknown_time = 0;
+    time_t total_time = 0;
+    int changes = 0;
+    float tmp;
+
+    printf("Starting measurements\n");
+
+    last_state = check_powermode(fd);
+    start_time = last_time = time(0);
+    printf("  System is in state %s\n\n", state_name(last_state));
+
+    while(!endit) {
+	sleep(1);
+	curr_state = check_powermode(fd);
+
+	if (curr_state != last_state || endit) {
+	    changes++;
+	    curr_time = time(0);
+	    time_diff = curr_time - last_time;
+
+	    if (last_state == 1) active_time += time_diff;
+	    else if (last_state == 0) sleep_time += time_diff;
+	    else unknown_time += time_diff;
+
+	    last_state = curr_state;
+	    last_time = curr_time;
+
+	    printf("%s: State-change to %s\n", myctime(curr_time),
+		   state_name(curr_state));
+	}
+    }
+    changes--; /* Compensate for SIGINT */
+
+    total_time = time(0) - start_time;
+    printf("\nTotal running time:  %lus\n", curr_time - start_time);
+    printf(" State changed %d times\n", changes);
+
+    tmp = (float)sleep_time / (float)total_time * 100;
+    printf(" Time in sleep state:   %lus (%.2f%%)\n", sleep_time, tmp);
+    tmp = (float)active_time / (float)total_time * 100;
+    printf(" Time in active state:  %lus (%.2f%%)\n", active_time, tmp);
+    tmp = (float)unknown_time / (float)total_time * 100;
+    printf(" Time in unknown state: %lus (%.2f%%)\n", unknown_time, tmp);
+}
+
+static void ender(int s)
+{
+    endit = 1;
+}
+
+static void usage(void)
+{
+    puts("usage: dslm [-w <time>] <disk>");
+    exit(0);
+}
+
+int main(int argc, char **argv)
+{
+    int fd;
+    char *disk = 0;
+    int settle_time = 60;
+
+    /* Parse the simple command-line */
+    if (argc == 2)
+	disk = argv[1];
+    else if (argc == 4) {
+	settle_time = atoi(argv[2]);
+	disk = argv[3];
+    } else
+	usage();
+
+    if (!(fd = open(disk, O_RDONLY|O_NONBLOCK))) {
+	printf("Can't open %s, because: %s\n", disk, strerror(errno));
+	exit(-1);
+    }
+
+    if (settle_time) {
+	printf("Waiting %d seconds for the system to settle down to "
+	       "'normal'\n", settle_time);
+	sleep(settle_time);
+    } else
+	puts("Not waiting for system to settle down");
+
+    signal(SIGINT, ender);
+
+    measure(fd);
+
+    close(fd);
+
+    return 0;
+}
diff -puN Documentation/laptops/laptop-mode.txt~documentation-laptop-split-txt-and-source-files Documentation/laptops/laptop-mode.txt
--- a/Documentation/laptops/laptop-mode.txt~documentation-laptop-split-txt-and-source-files
+++ a/Documentation/laptops/laptop-mode.txt
@@ -779,172 +779,4 @@ Monitoring tool
 ---------------
 
 Bartek Kania submitted this, it can be used to measure how much time your disk
-spends spun up/down.
-
----------------------------dslm.c BEGIN-----------------------------------------
-/*
- * Simple Disk Sleep Monitor
- *  by Bartek Kania
- * Licenced under the GPL
- */
-#include <unistd.h>
-#include <stdlib.h>
-#include <stdio.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <time.h>
-#include <string.h>
-#include <signal.h>
-#include <sys/ioctl.h>
-#include <linux/hdreg.h>
-
-#ifdef DEBUG
-#define D(x) x
-#else
-#define D(x)
-#endif
-
-int endit = 0;
-
-/* Check if the disk is in powersave-mode
- * Most of the code is stolen from hdparm.
- * 1 = active, 0 = standby/sleep, -1 = unknown */
-int check_powermode(int fd)
-{
-    unsigned char args[4] = {WIN_CHECKPOWERMODE1,0,0,0};
-    int state;
-
-    if (ioctl(fd, HDIO_DRIVE_CMD, &args)
-	&& (args[0] = WIN_CHECKPOWERMODE2) /* try again with 0x98 */
-	&& ioctl(fd, HDIO_DRIVE_CMD, &args)) {
-	if (errno != EIO || args[0] != 0 || args[1] != 0) {
-	    state = -1; /* "unknown"; */
-	} else
-	    state = 0; /* "sleeping"; */
-    } else {
-	state = (args[2] == 255) ? 1 : 0;
-    }
-    D(printf(" drive state is:  %d\n", state));
-
-    return state;
-}
-
-char *state_name(int i)
-{
-    if (i == -1) return "unknown";
-    if (i == 0) return "sleeping";
-    if (i == 1) return "active";
-
-    return "internal error";
-}
-
-char *myctime(time_t time)
-{
-    char *ts = ctime(&time);
-    ts[strlen(ts) - 1] = 0;
-
-    return ts;
-}
-
-void measure(int fd)
-{
-    time_t start_time;
-    int last_state;
-    time_t last_time;
-    int curr_state;
-    time_t curr_time = 0;
-    time_t time_diff;
-    time_t active_time = 0;
-    time_t sleep_time = 0;
-    time_t unknown_time = 0;
-    time_t total_time = 0;
-    int changes = 0;
-    float tmp;
-
-    printf("Starting measurements\n");
-
-    last_state = check_powermode(fd);
-    start_time = last_time = time(0);
-    printf("  System is in state %s\n\n", state_name(last_state));
-
-    while(!endit) {
-	sleep(1);
-	curr_state = check_powermode(fd);
-
-	if (curr_state != last_state || endit) {
-	    changes++;
-	    curr_time = time(0);
-	    time_diff = curr_time - last_time;
-
-	    if (last_state == 1) active_time += time_diff;
-	    else if (last_state == 0) sleep_time += time_diff;
-	    else unknown_time += time_diff;
-
-	    last_state = curr_state;
-	    last_time = curr_time;
-
-	    printf("%s: State-change to %s\n", myctime(curr_time),
-		   state_name(curr_state));
-	}
-    }
-    changes--; /* Compensate for SIGINT */
-
-    total_time = time(0) - start_time;
-    printf("\nTotal running time:  %lus\n", curr_time - start_time);
-    printf(" State changed %d times\n", changes);
-
-    tmp = (float)sleep_time / (float)total_time * 100;
-    printf(" Time in sleep state:   %lus (%.2f%%)\n", sleep_time, tmp);
-    tmp = (float)active_time / (float)total_time * 100;
-    printf(" Time in active state:  %lus (%.2f%%)\n", active_time, tmp);
-    tmp = (float)unknown_time / (float)total_time * 100;
-    printf(" Time in unknown state: %lus (%.2f%%)\n", unknown_time, tmp);
-}
-
-void ender(int s)
-{
-    endit = 1;
-}
-
-void usage()
-{
-    puts("usage: dslm [-w <time>] <disk>");
-    exit(0);
-}
-
-int main(int argc, char **argv)
-{
-    int fd;
-    char *disk = 0;
-    int settle_time = 60;
-
-    /* Parse the simple command-line */
-    if (argc == 2)
-	disk = argv[1];
-    else if (argc == 4) {
-	settle_time = atoi(argv[2]);
-	disk = argv[3];
-    } else
-	usage();
-
-    if (!(fd = open(disk, O_RDONLY|O_NONBLOCK))) {
-	printf("Can't open %s, because: %s\n", disk, strerror(errno));
-	exit(-1);
-    }
-
-    if (settle_time) {
-	printf("Waiting %d seconds for the system to settle down to "
-	       "'normal'\n", settle_time);
-	sleep(settle_time);
-    } else
-	puts("Not waiting for system to settle down");
-
-    signal(SIGINT, ender);
-
-    measure(fd);
-
-    close(fd);
-
-    return 0;
-}
----------------------------dslm.c END-------------------------------------------
+spends spun up/down.  See Documentation/laptops/dslm.c
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

