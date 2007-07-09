From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:36:27 -0700
Message-ID: <200707092336.l69NaRPO020577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758246AbXGIXgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:36:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size fix fix fix
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch

This patch was dropped because it was folded into knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch

------------------------------------------------------
Subject: knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size fix fix fix
From: "J. Bruce Fields" <bfields@fieldses.org>

This code would benefit from a little more explanation.

Also, I screwed up the previous patch and forgot to delete a line, so the
calculation here is off; fix it.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix
+++ a/fs/nfsd/nfs4state.c
@@ -3198,13 +3198,27 @@ get_nfs4_grace_period(void)
 	return max(user_lease_time, lease_time) * HZ;
 }
 
+/*
+ * Since the lifetime of a delegation isn't limited to that of an open, a
+ * client may quite reasonably hang on to a delegation as long as it has
+ * the inode cached.  This becomes an obvious problem the first time a
+ * client's inode cache approaches the size of the server's total memory.
+ *
+ * For now we avoid this problem by imposing a hard limit on the number
+ * of delegations, which varies according to the server's memory size.
+ */
 static void
 set_max_delegations(void)
 {
 	struct sysinfo sys;
 
 	si_meminfo(&sys);
-	sys.totalram *= sys.mem_unit;
+	/*
+	 * Allow at most 4 delegations per megabyte of RAM.  Quick
+	 * estimates suggest that in the worst case (where every delegation
+	 * is for a different inode), a delegation could take about 1.5K,
+	 * giving a worst case usage of about 6% of memory.
+	 */
 	sys.totalram >>= (18 - PAGE_SHIFT);
 	max_delegations = (unsigned int) sys.totalram;
 }
_

Patches currently in -mm which might be from bfields@fieldses.org are

rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch
git-vfs-lease-api.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch
