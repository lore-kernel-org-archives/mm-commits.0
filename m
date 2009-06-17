From: akpm@linux-foundation.org
Subject: [folded] gcov-add-gcov-profiling-infrastructure-use-strict_strtoul.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:56:11 -0700
Message-ID: <200906172256.n5HMuBa0015646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbZFQW4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:56:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     gcov: use strict_strtoul
has been removed from the -mm tree.  Its filename was
     gcov-add-gcov-profiling-infrastructure-use-strict_strtoul.patch

This patch was dropped because it was folded into gcov-add-gcov-profiling-infrastructure.patch

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
gcov-add-gcov-profiling-infrastructure-use-strict_strtoul.patch
gcov-add-gcov-profiling-infrastructure-use-vmalloc-for-duplicating-counter-data.patch
gcov-enable-gcov_profile_all-for-x86_64.patch

