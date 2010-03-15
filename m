From: akpm@linux-foundation.org
Subject: [merged] documentation-fs-split-txt-and-source-files.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:49 -0400
Message-ID: <201003150658.o2F6wMjN016442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935633Ab0COG6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Documentation/fs/: split txt and source files
has been removed from the -mm tree.  Its filename was
     documentation-fs-split-txt-and-source-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

