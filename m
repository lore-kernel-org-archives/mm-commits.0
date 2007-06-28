From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch added to -mm tree
Date: Wed, 27 Jun 2007 19:28:34 -0700
Message-ID: <200706280228.l5S2SYjQ011658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760799AbXF1C2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 22:28:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size fix fix fix
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix.patch
