From: akpm@linux-foundation.org
Subject: - knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:03 -0700
Message-ID: <200705092153.l49Lr3g1003044@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759000AbXEIVyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     knfsd: avoid use of unitialised variables on error path when nfs exports
has been removed from the -mm tree.  Its filename was
     knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: avoid use of unitialised variables on error path when nfs exports
From: NeilBrown <neilb@suse.de>

We need to zero various parts of 'exp' before any 'goto out', otherwise when
we go to free the contents...  we die.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports
+++ a/fs/nfsd/export.c
@@ -469,6 +469,13 @@ static int svc_export_parse(struct cache
 	nd.dentry = NULL;
 	exp.ex_path = NULL;
 
+	/* fs locations */
+	exp.ex_fslocs.locations = NULL;
+	exp.ex_fslocs.locations_count = 0;
+	exp.ex_fslocs.migrated = 0;
+
+	exp.ex_uuid = NULL;
+
 	if (mesg[mlen-1] != '\n')
 		return -EINVAL;
 	mesg[mlen-1] = 0;
@@ -509,13 +516,6 @@ static int svc_export_parse(struct cache
 	if (exp.h.expiry_time == 0)
 		goto out;
 
-	/* fs locations */
-	exp.ex_fslocs.locations = NULL;
-	exp.ex_fslocs.locations_count = 0;
-	exp.ex_fslocs.migrated = 0;
-
-	exp.ex_uuid = NULL;
-
 	/* flags */
 	err = get_int(&mesg, &an_int);
 	if (err == -ENOENT)
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
git-md-accel.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
