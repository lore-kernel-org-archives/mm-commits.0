From: akpm@osdl.org
Subject: - sysctl-string-length-calculated-is-wrong-if-it-contains-negative-numbers.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:41 -0800
Message-ID: <200612072307.kB7N7fSY030384@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52840 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163728AbWLGXIA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:08:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: praveenbp@ti.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: string length calculated is wrong if it contains negative numbers
has been removed from the -mm tree.  Its filename was
     sysctl-string-length-calculated-is-wrong-if-it-contains-negative-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: string length calculated is wrong if it contains negative numbers
From: "BP, Praveen" <praveenbp@ti.com>

In the functions do_proc_dointvec() and do_proc_doulongvec_minmax(),
there seems to be a bug in string length calculation if string contains
negative integer.

The console log given below explains the bug. Setting negative values
may not be a right thing to do for "console log level" but then the test
(given below) can be used to demonstrate the bug in the code.

# echo "-1 -1 -1 -123456" > /proc/sys/kernel/printk
# cat /proc/sys/kernel/printk
-1      -1      -1      -1234
#
# echo "-1 -1 -1 123456" > /proc/sys/kernel/printk
# cat /proc/sys/kernel/printk
-1      -1      -1      1234
#

(akpm: the bug is that 123456 gets truncated)

It works as expected if string contains all +ve integers

# echo "1 2 3 4" > /proc/sys/kernel/printk
# cat /proc/sys/kernel/printk
1       2       3       4
#

The patch given below fixes the issue.

Signed-off-by: Praveen BP <praveenbp@ti.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sysctl.c~sysctl-string-length-calculated-is-wrong-if-it-contains-negative-numbers kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-string-length-calculated-is-wrong-if-it-contains-negative-numbers
+++ a/kernel/sysctl.c
@@ -1875,7 +1875,7 @@ static int __do_proc_dointvec(void *tbl_
 			p = buf;
 			if (*p == '-' && left > 1) {
 				neg = 1;
-				left--, p++;
+				p++;
 			}
 			if (*p < '0' || *p > '9')
 				break;
@@ -2126,7 +2126,7 @@ static int __do_proc_doulongvec_minmax(v
 			p = buf;
 			if (*p == '-' && left > 1) {
 				neg = 1;
-				left--, p++;
+				p++;
 			}
 			if (*p < '0' || *p > '9')
 				break;
_

Patches currently in -mm which might be from praveenbp@ti.com are

origin.patch

