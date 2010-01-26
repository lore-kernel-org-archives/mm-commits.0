From: akpm@linux-foundation.org
Subject: + delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:47:10 -0800
Message-ID: <201001260047.o0Q0lBiA021128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621Ab0AZArq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:47:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, balbir@in.ibm.com


The patch titled
     delay-accounting: reimplement -c for getdelays.c to report information on a target command
has been added to the -mm tree.  Its filename is
     delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch

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
Subject: delay-accounting: reimplement -c for getdelays.c to report information on a target command
From: Mel Gorman <mel@csn.ul.ie>

Task delay-accounting was identified as one means of determining how long
a process spends in congestion_wait() without adding new statistics.  For
example, if the workload should not be doing IO, delay-accounting could
reveal how long it was spending in unexpected IO or delays. 
Unfortunately, on closer examination it was clear that getdelays does not
act as documented.

Commit a3baf649 ("per-task-delay-accounting: documentation") added
Documentation/accounting/getdelays.c with a -c switch that was documented
to fork/exec a child and report statistics on it but for reasons that are
unclear to me, commit 9e06d3f9 deleted support for this switch but did not
update the documentation.  It might be an oversight or it might be because
the control flow of the program meant that accounting information would be
printed once early in the lifetime of the program making it of limited
use.

This patch reimplements -c for getdelays.c to act as documented.  Unlike
the original version, it waits until the command completes before printing
any information on it.  An example of it being used looks like

$ ./getdelays -d -c find /home/mel -name mel
print delayacct stats ON
/home/mel
/home/mel/.notes-wine/drive_c/windows/profiles/mel
/home/mel/.wine/drive_c/windows/profiles/mel
/home/mel/git-configs/dot.kde/share/apps/konqueror/home/mel
PID	5923

CPU             count     real total  virtual total    delay total
                42779     5051232096     5164722692      564207988
IO              count    delay total
                41727    97804147758
SWAP            count    delay total
                    0              0
RECLAIM         count    delay total
                    0              0

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |   37 +++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff -puN Documentation/accounting/getdelays.c~delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command
+++ a/Documentation/accounting/getdelays.c
@@ -21,6 +21,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
+#include <sys/wait.h>
 #include <signal.h>
 
 #include <linux/genetlink.h>
@@ -266,11 +267,13 @@ int main(int argc, char *argv[])
 	int containerset = 0;
 	char containerpath[1024];
 	int cfd = 0;
+	int forking = 0;
+	sigset_t sigset;
 
 	struct msgtemplate msg;
 
-	while (1) {
-		c = getopt(argc, argv, "qdiw:r:m:t:p:vlC:");
+	while (!forking) {
+		c = getopt(argc, argv, "qdiw:r:m:t:p:vlC:c:");
 		if (c < 0)
 			break;
 
@@ -319,6 +322,27 @@ int main(int argc, char *argv[])
 				err(1, "Invalid pid\n");
 			cmd_type = TASKSTATS_CMD_ATTR_PID;
 			break;
+		case 'c':
+
+			/* Block SIGCHLD for sigwait() later */
+			if (sigemptyset(&sigset) == -1)
+				err(1, "Failed to empty sigset");
+			if (sigaddset(&sigset, SIGCHLD))
+				err(1, "Failed to set sigchld in sigset");
+			sigprocmask(SIG_BLOCK, &sigset, NULL);
+
+			/* fork/exec a child */
+			tid = fork();
+			if (tid < 0)
+				err(1, "Fork failed\n");
+			if (tid == 0)
+				if (execvp(argv[optind - 1], &argv[optind - 1]) < 0)
+					exit(-1);
+
+			/* Set the command type and avoid further processing */
+			cmd_type = TASKSTATS_CMD_ATTR_PID;
+			forking = 1;
+			break;
 		case 'v':
 			printf("debug on\n");
 			dbg = 1;
@@ -370,6 +394,15 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
+	/*
+	 * If we forked a child, wait for it to exit. Cannot use waitpid()
+	 * as all the delicious data would be reaped as part of the wait 
+	 */
+	if (tid && forking) {
+		int sig_received;
+		sigwait(&sigset, &sig_received);
+	}
+
 	if (tid) {
 		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
 			      cmd_type, &tid, sizeof(__u32));
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
nodemaskh-remove-macro-any_online_node.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
add-debugging-aid-for-memory-initialisation-problems.patch

