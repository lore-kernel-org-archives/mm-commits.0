From: akpm@linux-foundation.org
Subject: + allow-reading-tainted-flag-as-user.patch added to -mm tree
Date: Sun, 22 Apr 2007 02:06:59 -0700
Message-ID: <200704220906.l3M96x2k023373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965533AbXDVJHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 05:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bastian@waldi.eu.org, tytso@mit.edu


The patch titled
     Allow reading tainted flag as user
has been added to the -mm tree.  Its filename is
     allow-reading-tainted-flag-as-user.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

allow-reading-tainted-flag-as-user.patch
