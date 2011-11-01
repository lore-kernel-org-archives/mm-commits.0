From: akpm@linux-foundation.org
Subject: [merged] printk-fix-bounds-checking-for-log_prefix.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:24 -0700
Message-ID: <201111012114.pA1LEOrZ017675@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: william.r.douglas@gmail.com, william.douglas@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: fix bounds checking for log_prefix
has been removed from the -mm tree.  Its filename was
     printk-fix-bounds-checking-for-log_prefix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: William Douglas <william.r.douglas@gmail.com>
Subject: printk: fix bounds checking for log_prefix

Currently log_prefix is testing that the first character of the log level
and facility is less than '0' and greater than '9' (which is always
false).  It should be testing to see if the character less than '0' or
greater than '9' instead.  This patch makes that change.

The code being changed worked because strtoul bombs out (endp isn't
updated) and 0 is returned anyway.

Signed-off-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-fix-bounds-checking-for-log_prefix kernel/printk.c
--- a/kernel/printk.c~printk-fix-bounds-checking-for-log_prefix
+++ a/kernel/printk.c
@@ -595,7 +595,7 @@ static size_t log_prefix(const char *p, 
 		/* multi digit including the level and facility number */
 		char *endp = NULL;
 
-		if (p[1] < '0' && p[1] > '9')
+		if (p[1] < '0' || p[1] > '9')
 			return 0;
 
 		lev = (simple_strtoul(&p[1], &endp, 10) & 7);
_

Patches currently in -mm which might be from william.r.douglas@gmail.com are

origin.patch

