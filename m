From: akpm@linux-foundation.org
Subject: + getdelaysc-fix-overrun.patch added to -mm tree
Date: Thu, 19 Apr 2007 22:46:29 -0700
Message-ID: <200704200546.l3K5kT9A008005@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422910AbXDTFqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 01:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scott@bluehost.com, matt@bluehost.com


The patch titled
     getdelays.c: fix overrun
has been added to the -mm tree.  Its filename is
     getdelaysc-fix-overrun.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

getdelaysc-fix-overrun.patch
