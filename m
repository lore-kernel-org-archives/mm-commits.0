From: akpm@linux-foundation.org
Subject: [merged] printk-remove-bounds-checking-for-log_prefix.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:28 -0700
Message-ID: <201111012114.pA1LESlr007160@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16343 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1KAVOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: william.r.douglas@gmail.com, william.douglas@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: remove bounds checking for log_prefix
has been removed from the -mm tree.  Its filename was
     printk-remove-bounds-checking-for-log_prefix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: William Douglas <william.r.douglas@gmail.com>
Subject: printk: remove bounds checking for log_prefix

Currently log_prefix is testing that the first character of the log level
and facility is less than '0' and greater than '9' (which is always
false).

Since the code being updated works because strtoul bombs out (endp isn't
updated) and 0 is returned anyway just remove the check and don't change
the behavior of the function.

Signed-off-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/printk.c~printk-remove-bounds-checking-for-log_prefix kernel/printk.c
--- a/kernel/printk.c~printk-remove-bounds-checking-for-log_prefix
+++ a/kernel/printk.c
@@ -595,9 +595,6 @@ static size_t log_prefix(const char *p, 
 		/* multi digit including the level and facility number */
 		char *endp = NULL;
 
-		if (p[1] < '0' || p[1] > '9')
-			return 0;
