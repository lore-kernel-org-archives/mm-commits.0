From: akpm@linux-foundation.org
Subject: + gcov-add-gcov-profiling-infrastructure-use-strict_strtoul.patch added to -mm tree
Date: Fri, 05 Jun 2009 13:13:55 -0700
Message-ID: <200906052013.n55KDtK8019839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbZFEUN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 16:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com


The patch titled
     gcov: use strict_strtoul
has been added to the -mm tree.  Its filename is
     gcov-add-gcov-profiling-infrastructure-use-strict_strtoul.patch

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
Subject: gcov: use strict_strtoul
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Use strict_strtoul to identify kernel parameter format errors.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/gcov/fs.c~gcov-add-gcov-profiling-infrastructure-use-strict_strtoul kernel/gcov/fs.c
--- a/kernel/gcov/fs.c~gcov-add-gcov-profiling-infrastructure-use-strict_strtoul
+++ a/kernel/gcov/fs.c
@@ -70,7 +70,13 @@ static int gcov_persist = 1;
 
 static int __init gcov_persist_setup(char *str)
 {
-	gcov_persist = simple_strtoul(str, NULL, 0);
+	unsigned long val;
+
+	if (strict_strtoul(str, 0, &val)) {
+		pr_warning("invalid gcov_persist parameter '%s'\n", str);
+		return 0;
+	}
+	gcov_persist = val;
 	pr_info("setting gcov_persist to %d\n", gcov_persist);
 
 	return 1;
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

kernel-constructor-support.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-add-gcov-profiling-infrastructure-update.patch
gcov-add-gcov-profiling-infrastructure-use-strict_strtoul.patch
gcov-enable-gcov_profile_all-for-x86_64.patch

