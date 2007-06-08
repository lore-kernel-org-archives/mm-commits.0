From: akpm@linux-foundation.org
Subject: - lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:17:58 -0700
Message-ID: <200706080617.l586HwtP021096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707AbXFHGSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: don't signal like crazy, use LHREQ_BREAK command
has been removed from the -mm tree.  Its filename was
     lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch

This patch was dropped because it was folded into lguest-the-documentation-example-launcher.patch

------------------------------------------------------
Subject: lguest: don't signal like crazy, use LHREQ_BREAK command
From: Rusty Russell <rusty@rustcorp.com.au>

We currently use a "waker" process: a child of the launcher which selects() on
the incoming file descriptors.  It sends a SIGUSR1 to the launcher whenever
select() returns to kick the launcher out of the kernel.

This has nasty side-effects: the waker needs to keep sending signals to avoid
the race, so we nice it to try to make sure the launcher runs soon.  Also the
launcher blocks SIGUSR1 when it's not running the guest, so it doesn't have to
deal with other interrupted reads...

It's better to explicitly tell the kernel to break out of the guest, and this
is what we do, with a new LHREQ_BREAK command.  This makes the launcher return
-EAGAIN from reading /dev/lguest, and blocks the waker until the launcher
calls LHREQ_BREAK, avoiding the race.

We also take precautions against simultaneous writes or reads on the
/dev/lguest fd.  As only root can open these file descriptors it's not much of
a problem, but we want to relax that restriction eventually.

The main improvement is in consistency, rather than raw benchmark
results:

Before:
Time for one context switch via pipe: 9265 (4534 - 9495)
Time for one Copy-on-Write fault: 67687 (14898 - 159125)
Time to exec client once: 1102812 (795843 - 1128250)
Time for one fork/exit/wait: 712000 (400625 - 723156)
Time for gettimeofday(): 16681 (16378 - 35835)
Time to send 4 MB from host: 141317343 (140165578 - 141469500)
Time for one int-0x80 syscall: 272 (272 - 575)
Time for one syscall via libc: 275 (274 - 904)
Time for two PTE updates: 16232 (6430 - 16316)
Time to read from disk (256 kB): 16786750 (16597500 - 31493250)
Time for one disk read: 192656 (189312 - 958687)
Time for inter-guest pingpong: 110453 (104492 - 316429)

After:
Time for one context switch via pipe: 4687 (4563 - 4857)
Time for one Copy-on-Write fault: 44523 (11628 - 77855)
Time to exec client once: 814765 (805796 - 829875)
Time for one fork/exit/wait: 405875 (400562 - 434750)
Time for gettimeofday(): 16644 (16203 - 16931)
Time to send 4 MB from host: 136530000 (121522250 - 151629000)
Time for one int-0x80 syscall: 273 (272 - 274)
Time for one syscall via libc: 279 (277 - 279)
Time for two PTE updates: 6439 (6395 - 6528)
Time to read from disk (256 kB): 16787000 (16641250 - 16861250)
Time for one disk read: 192187 (190515 - 193843)
Time for inter-guest pingpong: 111093 (109203 - 136554)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c |   68 ++++++++++++++------------------
 1 files changed, 30 insertions(+), 38 deletions(-)

diff -puN Documentation/lguest/lguest.c~lguest-dont-signal-like-crazy-use-lhreq_break-command-doc Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-dont-signal-like-crazy-use-lhreq_break-command-doc
+++ a/Documentation/lguest/lguest.c
@@ -16,7 +16,6 @@
 #include <fcntl.h>
 #include <stdbool.h>
 #include <errno.h>
-#include <signal.h>
 #include <ctype.h>
 #include <sys/socket.h>
 #include <sys/ioctl.h>
@@ -47,6 +46,7 @@ typedef uint8_t u8;
 static bool verbose;
 #define verbose(args...) \
 	do { if (verbose) printf(args); } while(0)
+static int waker_fd;
 
 struct device_list
 {
@@ -341,15 +341,14 @@ static void set_fd(int fd, struct device
 		devices->max_infd = fd;
 }
 
-/* We send lguest_add signals while input is pending: avoids races. */
-static void wake_parent(int pipefd, struct device_list *devices)
+/* When input arrives, we tell the kernel to kick lguest out with -EAGAIN. */
+static void wake_parent(int pipefd, int lguest_fd, struct device_list *devices)
 {
-	nice(19);
-
 	set_fd(pipefd, devices);
 
 	for (;;) {
 		fd_set rfds = devices->infds;
+		u32 args[] = { LHREQ_BREAK, 1 };
 
 		select(devices->max_infd+1, &rfds, NULL, NULL, NULL);
 		if (FD_ISSET(pipefd, &rfds)) {
@@ -357,25 +356,14 @@ static void wake_parent(int pipefd, stru
 			if (read(pipefd, &ignorefd, sizeof(ignorefd)) == 0)
 				exit(0);
 			FD_CLR(ignorefd, &devices->infds);
-		}
-		kill(getppid(), SIGUSR1);
+		} else
+			write(lguest_fd, args, sizeof(args));
 	}
 }
 
-/* We don't want signal to kill us, just jerk us out of kernel. */
-static void wakeup(int signo)
-{
-}
-
-static int setup_waker(struct device_list *device_list)
+static int setup_waker(int lguest_fd, struct device_list *device_list)
 {
 	int pipefd[2], child;
-	struct sigaction act;
-
-	act.sa_handler = wakeup;
-	sigemptyset(&act.sa_mask);
-	act.sa_flags = 0;
-	sigaction(SIGUSR1, &act, NULL);
 
 	pipe(pipefd);
 	child = fork();
@@ -384,7 +372,7 @@ static int setup_waker(struct device_lis
 
 	if (child == 0) {
 		close(pipefd[1]);
-		wake_parent(pipefd[0], device_list);
+		wake_parent(pipefd[0], lguest_fd, device_list);
 	}
 	close(pipefd[0]);
 
@@ -495,8 +483,13 @@ static bool handle_console_input(int fd,
 		else if (abort->count == 3) {
 			struct timeval now;
 			gettimeofday(&now, NULL);
-			if (now.tv_sec <= abort->start.tv_sec+1)
+			if (now.tv_sec <= abort->start.tv_sec+1) {
+				/* Make sure waker is not blocked in BREAK */
+				u32 args[] = { LHREQ_BREAK, 0 };
+				close(waker_fd);
+				write(fd, args, sizeof(args));
 				exit(2);
+			}
 			abort->count = 0;
 		}
 	} else
@@ -613,7 +606,7 @@ static void handle_output(int fd, unsign
 	warnx("Pending dma %p, key %p", (void *)dma, (void *)key);
 }
 
-static void handle_input(int fd, int childfd, struct device_list *devices)
+static void handle_input(int fd, struct device_list *devices)
 {
 	struct timeval poll = { .tv_sec = 0, .tv_usec = 0 };
 
@@ -628,8 +621,8 @@ static void handle_input(int fd, int chi
 			if (i->handle_input && FD_ISSET(i->fd, &fds)) {
 				if (!i->handle_input(fd, i)) {
 					FD_CLR(i->fd, &devices->infds);
-					/* Tell child to ignore it too... */
-					write(childfd, &i->fd, sizeof(i->fd));
+					/* Tell waker to ignore it too... */
+					write(waker_fd, &i->fd, sizeof(i->fd));
 				}
 			}
 		}
@@ -898,29 +891,28 @@ static void map_device_descriptors(struc
 }
 
 static void __attribute__((noreturn))
-run_guest(int lguest_fd, int waker_fd, struct device_list *device_list)
+run_guest(int lguest_fd, struct device_list *device_list)
 {
-	sigset_t sigset;
-
-	sigemptyset(&sigset);
-	sigaddset(&sigset, SIGUSR1);
 	for (;;) {
+		u32 args[] = { LHREQ_BREAK, 0 };
 		unsigned long arr[2];
 		int readval;
 
-		sigprocmask(SIG_UNBLOCK, &sigset, NULL);
+		/* We read from the /dev/lguest device to run the Guest. */
 		readval = read(lguest_fd, arr, sizeof(arr));
-		sigprocmask(SIG_BLOCK, &sigset, NULL);
 
-		if (readval == sizeof(arr))
+		if (readval == sizeof(arr)) {
 			handle_output(lguest_fd, arr[0], arr[1], device_list);
-		else if (errno == ENOENT) {
+			continue;
+		} else if (errno == ENOENT) {
 			char reason[1024] = { 0 };
 			read(lguest_fd, reason, sizeof(reason)-1);
 			errx(1, "%s", reason);
-		} else if (errno != EINTR)
+		} else if (errno != EAGAIN)
 			err(1, "Running guest failed");
-		handle_input(lguest_fd, waker_fd, device_list);
+		handle_input(lguest_fd, device_list);
+		if (write(lguest_fd, args, sizeof(args)) < 0)
+			err(1, "Resetting break");
 	}
 }
 
@@ -943,7 +935,7 @@ static void usage(void)
 int main(int argc, char *argv[])
 {
 	unsigned long mem, pgdir, start, page_offset, initrd_size = 0;
-	int c, lguest_fd, waker_fd;
+	int c, lguest_fd;
 	struct device_list device_list;
 	void *boot = (void *)0;
 	const char *initrd_name = NULL;
@@ -1014,7 +1006,7 @@ int main(int argc, char *argv[])
 	*(int *)(boot + 0x23c) = 1;
 
 	lguest_fd = tell_kernel(pgdir, start, page_offset);
-	waker_fd = setup_waker(&device_list);
+	waker_fd = setup_waker(lguest_fd, &device_list);
 
-	run_guest(lguest_fd, waker_fd, &device_list);
+	run_guest(lguest_fd, &device_list);
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
