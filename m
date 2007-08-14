From: akpm@linux-foundation.org
Subject: + documentation-fix-getdelaysc-example-l-option-and-segv.patch added to -mm tree
Date: Tue, 14 Aug 2007 12:42:20 -0700
Message-ID: <200708141942.l7EJgKcO017752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934584AbXHNTmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikey@neuling.org, balbir@linux.vnet.ibm.com


The patch titled
     Documentation: fix getdelays.c example -l option and segv
has been added to the -mm tree.  Its filename is
     documentation-fix-getdelaysc-example-l-option-and-segv.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation: fix getdelays.c example -l option and segv
From: Michael Neuling <mikey@neuling.org>

Fix a couple of minor issues with the getdelays.c example code.  -l option
(loop) doesn't work and it seg faults in print_delayacct.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff -puN Documentation/accounting/getdelays.c~documentation-fix-getdelaysc-example-l-option-and-segv Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-fix-getdelaysc-example-l-option-and-segv
+++ a/Documentation/accounting/getdelays.c
@@ -196,7 +196,7 @@ void print_delayacct(struct taskstats *t
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "MEM   %15s%15s\n"
-	       "      %15llu%15llu\n"
+	       "      %15llu%15llu\n",
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
@@ -335,17 +335,17 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (tid) {
-		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
-			      cmd_type, &tid, sizeof(__u32));
-		PRINTF("Sent pid/tgid, retval %d\n", rc);
-		if (rc < 0) {
-			fprintf(stderr, "error sending tid/tgid cmd\n");
-			goto done;
+	do {
+		if (tid) {
+			rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
+				      cmd_type, &tid, sizeof(__u32));
+			PRINTF("Sent pid/tgid, retval %d\n", rc);
+			if (rc < 0) {
+				fprintf(stderr, "error sending tid/tgid cmd\n");
+				goto done;
+			}
 		}
-	}
 
-	do {
 		int i;
 
 		rep_len = recv(nl_sd, &msg, sizeof(msg), 0);
@@ -430,6 +430,7 @@ int main(int argc, char *argv[])
 			}
 			na = (struct nlattr *) (GENLMSG_DATA(&msg) + len);
 		}
+		sleep(2);
 	} while (loop);
 done:
 	if (maskset) {
_

Patches currently in -mm which might be from mikey@neuling.org are

documentation-fix-getdelaysc-example-l-option-and-segv.patch
