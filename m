From: akpm@linux-foundation.org
Subject: + documentation-fs-split-txt-and-source-files.patch added to -mm tree
Date: Tue, 09 Feb 2010 14:26:31 -0800
Message-ID: <201002092226.o19MQVgh005442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559Ab0BIW1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 17:27:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au


The patch titled
     Documentation/fs/: split txt and source files
has been added to the -mm tree.  Its filename is
     documentation-fs-split-txt-and-source-files.patch

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
Subject: Documentation/fs/: split txt and source files
From: Randy Dunlap <randy.dunlap@oracle.com>

Make dnotify_test.c source file and add it to Makefile so that
bitrot can be prevented.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Makefile                   |    2 -
 Documentation/filesystems/00-INDEX       |    2 +
 Documentation/filesystems/Makefile       |    8 ++++
 Documentation/filesystems/dnotify.txt    |   39 ++-------------------
 Documentation/filesystems/dnotify_test.c |   34 ++++++++++++++++++
 5 files changed, 50 insertions(+), 35 deletions(-)

diff -puN Documentation/Makefile~documentation-fs-split-txt-and-source-files Documentation/Makefile
--- a/Documentation/Makefile~documentation-fs-split-txt-and-source-files
+++ a/Documentation/Makefile
@@ -1,3 +1,3 @@
 obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
-	filesystems/configfs/ ia64/ laptops/ networking/ \
+	filesystems/ filesystems/configfs/ ia64/ laptops/ networking/ \
 	pcmcia/ spi/ timers/ video4linux/ vm/ watchdog/src/
diff -puN Documentation/filesystems/00-INDEX~documentation-fs-split-txt-and-source-files Documentation/filesystems/00-INDEX
--- a/Documentation/filesystems/00-INDEX~documentation-fs-split-txt-and-source-files
+++ a/Documentation/filesystems/00-INDEX
@@ -32,6 +32,8 @@ dlmfs.txt
 	- info on the userspace interface to the OCFS2 DLM.
 dnotify.txt
 	- info about directory notification in Linux.
+dnotify_test.c
+	- example program for dnotify
 ecryptfs.txt
 	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 exofs.txt
diff -puN /dev/null Documentation/filesystems/Makefile
--- /dev/null
+++ a/Documentation/filesystems/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := dnotify_test
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
diff -puN Documentation/filesystems/dnotify.txt~documentation-fs-split-txt-and-source-files Documentation/filesystems/dnotify.txt
--- a/Documentation/filesystems/dnotify.txt~documentation-fs-split-txt-and-source-files
+++ a/Documentation/filesystems/dnotify.txt
@@ -62,38 +62,9 @@ disabled, fcntl(fd, F_NOTIFY, ...) will 
 
 Example
 -------
+See Documentation/filesystems/dnotify_test.c for an example.
 
-	#define _GNU_SOURCE	/* needed to get the defines */
-	#include <fcntl.h>	/* in glibc 2.2 this has the needed
-					   values defined */
-	#include <signal.h>
-	#include <stdio.h>
-	#include <unistd.h>
-
-	static volatile int event_fd;
-
-	static void handler(int sig, siginfo_t *si, void *data)
-	{
-		event_fd = si->si_fd;
-	}
-
-	int main(void)
-	{
-		struct sigaction act;
-		int fd;
-
-		act.sa_sigaction = handler;
-		sigemptyset(&act.sa_mask);
-		act.sa_flags = SA_SIGINFO;
-		sigaction(SIGRTMIN + 1, &act, NULL);
-
-		fd = open(".", O_RDONLY);
-		fcntl(fd, F_SETSIG, SIGRTMIN + 1);
-		fcntl(fd, F_NOTIFY, DN_MODIFY|DN_CREATE|DN_MULTISHOT);
-		/* we will now be notified if any of the files
-		   in "." is modified or new files are created */
-		while (1) {
-			pause();
-			printf("Got event on fd=%d\n", event_fd);
-		}
-	}
+NOTE
+----
+Beginning with Linux 2.6.13, dnotify has been replaced by inotify.
+See Documentation/filesystems/inotify.txt for more information on it.
diff -puN /dev/null Documentation/filesystems/dnotify_test.c
--- /dev/null
+++ a/Documentation/filesystems/dnotify_test.c
@@ -0,0 +1,34 @@
+#define _GNU_SOURCE	/* needed to get the defines */
+#include <fcntl.h>	/* in glibc 2.2 this has the needed
+				   values defined */
+#include <signal.h>
+#include <stdio.h>
+#include <unistd.h>
+
+static volatile int event_fd;
+
+static void handler(int sig, siginfo_t *si, void *data)
+{
+	event_fd = si->si_fd;
+}
+
+int main(void)
+{
+	struct sigaction act;
+	int fd;
+
+	act.sa_sigaction = handler;
+	sigemptyset(&act.sa_mask);
+	act.sa_flags = SA_SIGINFO;
+	sigaction(SIGRTMIN + 1, &act, NULL);
+
+	fd = open(".", O_RDONLY);
+	fcntl(fd, F_SETSIG, SIGRTMIN + 1);
+	fcntl(fd, F_NOTIFY, DN_MODIFY|DN_CREATE|DN_MULTISHOT);
+	/* we will now be notified if any of the files
+	   in "." is modified or new files are created */
+	while (1) {
+		pause();
+		printf("Got event on fd=%d\n", event_fd);
+	}
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

