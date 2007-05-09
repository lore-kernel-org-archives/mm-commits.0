From: akpm@linux-foundation.org
Subject: - getdelaysc-fix-overrun.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:38 -0700
Message-ID: <200705090250.l492ocni009374@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969994AbXEICul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scott@bluehost.com, matt@bluehost.com, mm-commits@vger.kernel.org


The patch titled
     getdelays.c: fix overrun
has been removed from the -mm tree.  Its filename was
     getdelaysc-fix-overrun.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: getdelays.c: fix overrun
From: Scott Wiersdorf <scott@bluehost.com>

A patch for getdelays.c that fixes a buffer overrun when you set -w.

Cc: <matt@bluehost.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN Documentation/accounting/getdelays.c~getdelaysc-fix-overrun Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~getdelaysc-fix-overrun
+++ a/Documentation/accounting/getdelays.c
@@ -61,8 +61,6 @@ __u64 stime, utime;
 #define MAX_MSG_SIZE	1024
 /* Maximum number of cpus expected to be specified in a cpumask */
 #define MAX_CPUS	32
-/* Maximum length of pathname to log file */
-#define MAX_FILENAME	256
 
 struct msgtemplate {
 	struct nlmsghdr n;
@@ -231,7 +229,7 @@ int main(int argc, char *argv[])
 	int count = 0;
 	int write_file = 0;
 	int maskset = 0;
-	char logfile[128];
+	char *logfile = NULL;
 	int loop = 0;
 
 	struct msgtemplate msg;
@@ -251,7 +249,7 @@ int main(int argc, char *argv[])
 			print_io_accounting = 1;
 			break;
 		case 'w':
-			strncpy(logfile, optarg, MAX_FILENAME);
+			logfile = strdup(optarg);
 			printf("write to file %s\n", logfile);
 			write_file = 1;
 			break;
_

Patches currently in -mm which might be from scott@bluehost.com are

origin.patch
