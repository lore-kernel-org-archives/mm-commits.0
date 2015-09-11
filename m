From: akpm@linux-foundation.org
Subject: [merged]
 sysctl-fix-int-unsigned-long-assignments-in-int_min-case.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:13:30 -0700
Message-ID: <55f319ca.jXBuTL5F8cEnf0rW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbbIKSNb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: idryomov@gmail.com, ebiederm@xmission.com, keescook@chromium.org, mikulas@twibright.com, nneonneo@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: fix int -> unsigned long assignments in INT_MIN case
has been removed from the -mm tree.  Its filename was
     sysctl-fix-int-unsigned-long-assignments-in-int_min-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ilya Dryomov <idryomov@gmail.com>
Subject: sysctl: fix int -> unsigned long assignments in INT_MIN case

The following

    if (val < 0)
        *lvalp = (unsigned long)-val;

is incorrect because the compiler is free to assume -val to be positive
and use a sign-extend instruction for extending the bit pattern.  This is
a problem if val == INT_MIN:

    # echo -2147483648 >/proc/sys/dev/scsi/logging_level
    # cat /proc/sys/dev/scsi/logging_level
    -18446744071562067968

Cast to unsigned long before negation - that way we first sign-extend and
then negate an unsigned, which is well defined.  With this:

    # cat /proc/sys/dev/scsi/logging_level
    -2147483648

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Cc: Mikulas Patocka <mikulas@twibright.com>
Cc: Robert Xiao <nneonneo@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/sysctl.c~sysctl-fix-int-unsigned-long-assignments-in-int_min-case kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fix-int-unsigned-long-assignments-in-int_min-case
+++ a/kernel/sysctl.c
@@ -1995,7 +1995,7 @@ static int do_proc_dointvec_conv(bool *n
 		int val = *valp;
 		if (val < 0) {
 			*negp = true;
-			*lvalp = (unsigned long)-val;
+			*lvalp = -(unsigned long)val;
 		} else {
 			*negp = false;
 			*lvalp = (unsigned long)val;
@@ -2201,7 +2201,7 @@ static int do_proc_dointvec_minmax_conv(
 		int val = *valp;
 		if (val < 0) {
 			*negp = true;
-			*lvalp = (unsigned long)-val;
+			*lvalp = -(unsigned long)val;
 		} else {
 			*negp = false;
 			*lvalp = (unsigned long)val;
@@ -2436,7 +2436,7 @@ static int do_proc_dointvec_jiffies_conv
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
-			lval = (unsigned long)-val;
+			lval = -(unsigned long)val;
 		} else {
 			*negp = false;
 			lval = (unsigned long)val;
@@ -2459,7 +2459,7 @@ static int do_proc_dointvec_userhz_jiffi
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
-			lval = (unsigned long)-val;
+			lval = -(unsigned long)val;
 		} else {
 			*negp = false;
 			lval = (unsigned long)val;
@@ -2484,7 +2484,7 @@ static int do_proc_dointvec_ms_jiffies_c
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
-			lval = (unsigned long)-val;
+			lval = -(unsigned long)val;
 		} else {
 			*negp = false;
 			lval = (unsigned long)val;
_

Patches currently in -mm which might be from idryomov@gmail.com are


