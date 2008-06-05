From: akpm@linux-foundation.org
Subject: + getdelaysc-add-a-usr1-signal-handler.patch added to -mm tree
Date: Thu, 05 Jun 2008 12:46:06 -0700
Message-ID: <200806051946.m55Jk6XM026682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbYFETqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 15:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scott@perlcode.org, balbir@in.ibm.com, matt@bluehost.com


The patch titled
     getdelays.c: add a USR1 signal handler
has been added to the -mm tree.  Its filename is
     getdelaysc-add-a-usr1-signal-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: getdelays.c: add a USR1 signal handler
From: Scott Wiersdorf <scott@perlcode.org>

Add a USR1 signal handler to getdelays.c, which causes getdelays to close
its logfile and reopen it (if '-w logfile' is specified).  This is useful
in situations when getdelays is running for a long time (i.e, the log file
growing) and you need to rotate the logs but don't want to lose any log
data.

Sample usage:

1  # ./getdelays -m0,1,2,3 -l -w getdelays.log &
   (time passes)
2  # mv getdelays.log getdelays.log.1
3  # kill -USR1 <getdelays pid>

line 1: starts the program
line 2: renames the logfile. The log descriptor is still open and data
        being written to the log (assuming we didn't cross mountpoints)
line 3: getdelays closes the old descriptor and reopens getdelays.log

Note on 'volatile' usage:

I know this is generally frowned on, but I think it's needed here to avoid
the compiler optimizing away the variable (it will appear as if it's never
called, since its value only changes in the signal handler).

Cc: Matt Heaton <matt@bluehost.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |   37 ++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 6 deletions(-)

diff -puN Documentation/accounting/getdelays.c~getdelaysc-add-a-usr1-signal-handler Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~getdelaysc-add-a-usr1-signal-handler
+++ a/Documentation/accounting/getdelays.c
@@ -50,6 +50,7 @@ int dbg;
 int print_delays;
 int print_io_accounting;
 int print_task_context_switch_counts;
+volatile sig_atomic_t reopen_log = 0;
 __u64 stime, utime;
 
 #define PRINTF(fmt, arg...) {			\
@@ -80,6 +81,7 @@ static void usage(void)
 	fprintf(stderr, "  -l: listen forever\n");
 	fprintf(stderr, "  -v: debug on\n");
 	fprintf(stderr, "  -C: container path\n");
+	fprintf(stderr, "\nSend USR1 to reopen the logfile if -w is used.\n");
 }
 
 /*
@@ -231,6 +233,30 @@ void print_ioacct(struct taskstats *t)
 		(unsigned long long)t->cancelled_write_bytes);
 }
 
+void catch_usr1(int sig)
+{
+	reopen_log = 1;
+	signal(sig, catch_usr1);
+}
+
+int reopen_logfile(int fd, char *logfile)
+{
+	if (fd) {
+		PRINTF("USR1 received. Closing logfile.\n");
+		close(fd);
+	}
+	fd = open(logfile, O_WRONLY | O_CREAT | O_TRUNC,
+		  S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+	if (fd == -1) {
+		perror("Cannot open output file\n");
+		exit(1);
+	}
+
+	reopen_log = 0;
+
+	return fd;
+}
+
 int main(int argc, char *argv[])
 {
 	int c, rc, rep_len, aggr_len, len2, cmd_type;
@@ -320,12 +346,8 @@ int main(int argc, char *argv[])
 	}
 
 	if (write_file) {
-		fd = open(logfile, O_WRONLY | O_CREAT | O_TRUNC,
-			  S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
-		if (fd == -1) {
-			perror("Cannot open output file\n");
-			exit(1);
-		}
+		fd = reopen_logfile(fd, logfile);
+		signal(SIGUSR1, catch_usr1); /* only set when write_file is set */
 	}
 
 	if ((nl_sd = create_nl_socket(NETLINK_GENERIC)) < 0)
@@ -444,6 +466,9 @@ int main(int argc, char *argv[])
 								err(1,"write error\n");
 							}
 						}
+						if (reopen_log) {
+							fd = reopen_logfile(fd, logfile);
+						}
 						if (!loop)
 							goto done;
 						break;
_

Patches currently in -mm which might be from scott@perlcode.org are

getdelaysc-add-a-usr1-signal-handler.patch

