From: akpm@linux-foundation.org
Subject: - fix-param_sysfs_builtin-name-length-check.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:38 -0800
Message-ID: <200711152110.lAFLAcek015673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761947AbXKOVRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@web.de, greg@kroah.com, hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fix param_sysfs_builtin name length check
has been removed from the -mm tree.  Its filename was
     fix-param_sysfs_builtin-name-length-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix param_sysfs_builtin name length check
From: Jan Kiszka <jan.kiszka@web.de>

Commit faf8c714f4508207a9c81cc94dafc76ed6680b44 caused a regression:
parameter names longer than MAX_KBUILD_MODNAME will now be rejected,
although we just need to keep the module name part that short.  This patch
restores the old behaviour while still avoiding that memchr is called with
its length parameter larger than the total string length.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/params.c~fix-param_sysfs_builtin-name-length-check kernel/params.c
--- a/kernel/params.c~fix-param_sysfs_builtin-name-length-check
+++ a/kernel/params.c
@@ -592,19 +592,16 @@ static void __init param_sysfs_builtin(v
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
-		size_t kplen;
+		size_t max_name_len;
 
 		kp = &__start___param[i];
-		kplen = strlen(kp->name);
+		max_name_len =
+			min_t(size_t, MAX_KBUILD_MODNAME, strlen(kp->name));
 
-		/* We do not handle args without periods. */
-		if (kplen > MAX_KBUILD_MODNAME) {
-			DEBUGP("kernel parameter name is too long: %s\n", kp->name);
-			continue;
-		}
-		dot = memchr(kp->name, '.', kplen);
+		dot = memchr(kp->name, '.', max_name_len);
 		if (!dot) {
-			DEBUGP("couldn't find period in %s\n", kp->name);
+			DEBUGP("couldn't find period in first %d characters "
+			       "of %s\n", MAX_KBUILD_MODNAME, kp->name);
 			continue;
 		}
 		name_len = dot - kp->name;
_

Patches currently in -mm which might be from jan.kiszka@web.de are

origin.patch
