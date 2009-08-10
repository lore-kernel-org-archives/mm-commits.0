From: akpm@linux-foundation.org
Subject: [merged] hpfall-reduce-risk-that-hpfall-can-do-harm.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:29:12 -0700
Message-ID: <200908101929.n7AJTCuS029000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbZHJT30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:29:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ct@pipapo.org, elendil@planet.nl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     hpfall: reduce risk that hpfall can do harm
has been removed from the -mm tree.  Its filename was
     hpfall-reduce-risk-that-hpfall-can-do-harm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpfall: reduce risk that hpfall can do harm
From: Christian Thaeter <ct@pipapo.org>

Improve the example code to be at least useable, as in not causing harm
(as shown below).  Code can still be improved further, but this adds some
basic safeguards.

1. hpfall *MUST* mlockall(MCL_CURRENT|MCL_FUTURE); itself!  Since the
   Program sits and waits most of the time it becomes very likely swapped
   out.  If it gets woken up when the laptop drops from the table while it
   is swapped out it actually triggers harddrive activity!

2. Daemonize hpfall using 'daemon(0,0)' (quick and dirty).

3. Give hpfall realtime priority.  Should give a chance that it has
   less latency when woken up.

Signed-off-by: Christian Thaeter <ct@pipapo.org>
Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/hpfall.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN Documentation/hwmon/hpfall.c~hpfall-reduce-risk-that-hpfall-can-do-harm Documentation/hwmon/hpfall.c
--- a/Documentation/hwmon/hpfall.c~hpfall-reduce-risk-that-hpfall-can-do-harm
+++ a/Documentation/hwmon/hpfall.c
@@ -16,6 +16,8 @@
 #include <stdint.h>
 #include <errno.h>
 #include <signal.h>
+#include <sys/mman.h>
+#include <sched.h>
 
 void write_int(char *path, int i)
 {
@@ -62,6 +64,7 @@ void ignore_me(void)
 int main(int argc, char *argv[])
 {
 	int fd, ret;
+	struct sched_param param;
 
 	fd = open("/dev/freefall", O_RDONLY);
 	if (fd < 0) {
@@ -69,6 +72,11 @@ int main(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
+	daemon(0, 0);
+	param.sched_priority = sched_get_priority_max(SCHED_FIFO);
+	sched_setscheduler(0, SCHED_FIFO, &param);
+	mlockall(MCL_CURRENT|MCL_FUTURE);
+
 	signal(SIGALRM, ignore_me);
 
 	for (;;) {
_

Patches currently in -mm which might be from ct@pipapo.org are

linux-next.patch
vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea.patch

