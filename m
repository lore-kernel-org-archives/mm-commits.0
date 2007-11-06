From: akpm@linux-foundation.org
Subject: + make-getdelays-cgroupstats-aware.patch added to -mm tree
Date: Tue, 06 Nov 2007 02:02:20 -0800
Message-ID: <200711061009.lA6A99qr017929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753478AbXKFKJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 05:09:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com


The patch titled
     make getdelays cgroupstats aware
has been added to the -mm tree.  Its filename is
     make-getdelays-cgroupstats-aware.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make getdelays cgroupstats aware
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Update the getdelays utility to become cgroupstats aware.  A new -C option has
been added.  It takes in a control group path and prints out a summary of the
states of tasks in the control group

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |   43 ++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff -puN Documentation/accounting/getdelays.c~make-getdelays-cgroupstats-aware Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~make-getdelays-cgroupstats-aware
+++ a/Documentation/accounting/getdelays.c
@@ -25,6 +25,7 @@
 
 #include <linux/genetlink.h>
 #include <linux/taskstats.h>
+#include <linux/cgroupstats.h>
 
 /*
  * Generic macros for dealing with netlink sockets. Might be duplicated
@@ -78,6 +79,7 @@ static void usage(void)
 	fprintf(stderr, "  -i: print IO accounting (works only with -p)\n");
 	fprintf(stderr, "  -l: listen forever\n");
 	fprintf(stderr, "  -v: debug on\n");
+	fprintf(stderr, "  -C: container path\n");
 }
 
 /*
@@ -212,6 +214,14 @@ void task_context_switch_counts(struct t
 	       t->nvcsw, t->nivcsw);
 }
 
+void print_cgroupstats(struct cgroupstats *c)
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
@@ -239,11 +249,14 @@ int main(int argc, char *argv[])
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
 
@@ -260,6 +273,10 @@ int main(int argc, char *argv[])
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
@@ -334,6 +351,11 @@ int main(int argc, char *argv[])
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
@@ -344,6 +366,20 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (containerset) {
+		cfd = open(containerpath, O_RDONLY);
+		if (cfd < 0) {
+			perror("error opening container file");
+			goto err;
+		}
+		rc = send_cmd(nl_sd, id, mypid, CGROUPSTATS_CMD_GET,
+			      CGROUPSTATS_CMD_ATTR_FD, &cfd, sizeof(__u32));
+		if (rc < 0) {
+			perror("error sending cgroupstats command");
+			goto err;
+		}
+	}
+
 	do {
 		int i;
 
@@ -422,6 +458,9 @@ int main(int argc, char *argv[])
 				}
 				break;
 
+			case CGROUPSTATS_TYPE_CGROUP_STATS:
+				print_cgroupstats(NLA_DATA(na));
+				break;
 			default:
 				fprintf(stderr, "Unknown nla_type %d\n",
 					na->nla_type);
@@ -443,5 +482,7 @@ err:
 	close(nl_sd);
 	if (fd)
 		close(fd);
+	if (cfd)
+		close(cfd);
 	return 0;
 }
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
make-getdelays-cgroupstats-aware.patch
swap-delay-accounting-include-lock_page-delays.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
remove-unused-code-from-mm-tiny-shmemc.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
memory-controller-bug_on.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
