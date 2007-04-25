From: akpm@linux-foundation.org
Subject: - allow-reading-tainted-flag-as-user.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:38:58 -0700
Message-ID: <200704252038.l3PKcwgv012266@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993172AbXDYU5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bastian@waldi.eu.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Allow reading tainted flag as user
has been removed from the -mm tree.  Its filename was
     allow-reading-tainted-flag-as-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow reading tainted flag as user
From: Bastian Blank <bastian@waldi.eu.org>

The commit 34f5a39899f3f3e815da64f48ddb72942d86c366 restricted reading
of the tainted value. The attached patch changes this back to a
write-only check and restores the read behaviour of older versions.

Signed-off-by: Bastian Blank <bastian@waldi.eu.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~allow-reading-tainted-flag-as-user kernel/sysctl.c
--- a/kernel/sysctl.c~allow-reading-tainted-flag-as-user
+++ a/kernel/sysctl.c
@@ -1676,7 +1676,7 @@ static int proc_dointvec_taint(ctl_table
 {
 	int op;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (write && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	op = OP_OR;
_

Patches currently in -mm which might be from bastian@waldi.eu.org are

origin.patch
