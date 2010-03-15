From: akpm@linux-foundation.org
Subject: [merged] documentation-laptop-split-txt-and-source-files.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:46 -0400
Message-ID: <201003150658.o2F6wJMU016439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935695Ab0COG6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/laptop/: split txt and source files
has been removed from the -mm tree.  Its filename was
     documentation-laptop-split-txt-and-source-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 Documentation/laptops/00-INDEX        |    2 
 Documentation/laptops/Makefile        |    8 +
 Documentation/laptops/dslm.c          |  166 +++++++++++++++++++++++
 Documentation/laptops/laptop-mode.txt |  170 ------------------------
 5 files changed, 178 insertions(+), 170 deletions(-)

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
@@ -2,6 +2,8 @@
 	- This file
 acer-wmi.txt
 	- information on the Acer Laptop WMI Extras driver.
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
