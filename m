From: akpm@linux-foundation.org
Subject: + update-getdelays-to-become-containerstats-aware.patch added to -mm tree
Date: Fri, 08 Jun 2007 12:49:35 -0700
Message-ID: <200706081949.l58JnZlg010153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089AbXFHTtu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 15:49:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, jlan@engr.sgi.com, menage@google.com


The patch titled
     Update getdelays to become containerstats aware
has been added to the -mm tree.  Its filename is
     update-getdelays-to-become-containerstats-aware.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update getdelays to become containerstats aware
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Update the getdelays utility to become containerstats aware.  A new -C
option has been added.  It takes in a container path and prints out a
summary of task states in the container.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |   43 ++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 1 deletion(-)

diff -puN Documentation/accounting/getdelays.c~update-getdelays-to-become-containerstats-aware Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~update-getdelays-to-become-containerstats-aware
+++ a/Documentation/accounting/getdelays.c
@@ -26,6 +26,7 @@
 
 #include <linux/genetlink.h>
 #include <linux/taskstats.h>
+#include <linux/containerstats.h>
 
 /*
  * Generic macros for dealing with netlink sockets. Might be duplicated
@@ -79,6 +80,7 @@ static void usage(void)
 	fprintf(stderr, "  -i: print IO accounting (works only with -p)\n");
 	fprintf(stderr, "  -l: listen forever\n");
 	fprintf(stderr, "  -v: debug on\n");
+	fprintf(stderr, "  -C: container path\n");
 }
 
 /*
@@ -213,6 +215,14 @@ void task_context_switch_counts(struct t
 	       t->nvcsw, t->nivcsw);
 }
 
+void print_containerstats(struct containerstats *c)
+{
+	printf("sleeping %llu, blocked %llu, running %llu, stopped %llu, "
+		"uninterruptible %llu\n", c->nr_sleeping, c->nr_io_wait,
+		c->nr_running, c->nr_stopped, c->nr_uninterruptible);
+}
+
+
 void print_ioacct(struct taskstats *t)
 {
 	printf("%s: read=%llu, write=%llu, cancelled_write=%llu\n",
@@ -240,11 +250,14 @@ int main(int argc, char *argv[])
 	int maskset = 0;
 	char *logfile = NULL;
 	int loop = 0;
+	int containerset = 0;
+	char containerpath[1024];
+	int cfd = 0;
 
 	struct msgtemplate msg;
 
 	while (1) {
-		c = getopt(argc, argv, "qdiw:r:m:t:p:vl");
+		c = getopt(argc, argv, "qdiw:r:m:t:p:vlC:");
 		if (c < 0)
 			break;
 
@@ -261,6 +274,10 @@ int main(int argc, char *argv[])
 			printf("printing task/process context switch rates\n");
 			print_task_context_switch_counts = 1;
 			break;
+		case 'C':
+			containerset = 1;
+			strncpy(containerpath, optarg, strlen(optarg) + 1);
+			break;
 		case 'w':
 			logfile = strdup(optarg);
 			printf("write to file %s\n", logfile);
@@ -335,6 +352,11 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (tid && containerset) {
+		fprintf(stderr, "Select either -t or -C, not both\n");
+		goto err;
+	}
+
 	if (tid) {
 		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
 			      cmd_type, &tid, sizeof(__u32));
@@ -345,6 +367,20 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (containerset) {
+		cfd = open(containerpath, O_RDONLY);
+		if (cfd < 0) {
+			perror("error opening container file");
+			goto err;
+		}
+		rc = send_cmd(nl_sd, id, mypid, CONTAINERSTATS_CMD_GET,
+			      CONTAINERSTATS_CMD_ATTR_FD, &cfd, sizeof(__u32));
+		if (rc < 0) {
+			perror("error sending containerstats command");
+			goto err;
+		}
+	}
+
 	do {
 		int i;
 
@@ -423,6 +459,9 @@ int main(int argc, char *argv[])
 				}
 				break;
 
+			case CONTAINERSTATS_TYPE_CONTAINER_STATS:
+				print_containerstats(NLA_DATA(na));
+				break;
 			default:
 				fprintf(stderr, "Unknown nla_type %d\n",
 					na->nla_type);
@@ -444,5 +483,7 @@ err:
 	close(nl_sd);
 	if (fd)
 		close(fd);
+	if (cfd)
+		close(cfd);
 	return 0;
 }
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

add-containerstats-v3.patch
update-getdelays-to-become-containerstats-aware.patch
