From: akpm@osdl.org
Subject: + knfsd-nfsd4-clarify-units-of-compound_slack_space.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:24 -0800
Message-ID: <200612090009.kB909OPM010380@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947561AbWLIAJi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: clarify units of COMPOUND_SLACK_SPACE
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-clarify-units-of-compound_slack_space.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: clarify units of COMPOUND_SLACK_SPACE
From: J.Bruce Fields <bfields@fieldses.org>

A comment here incorrectly states that "slack_space" is measured in words, not
bytes.  Remove the comment, and adjust a variable name and a few comments to
clarify the situation.

This is pure cleanup; there should be no change in functionality.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4proc.c        |   10 +++++-----
 include/linux/nfsd/nfsd.h |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~knfsd-nfsd4-clarify-units-of-compound_slack_space fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~knfsd-nfsd4-clarify-units-of-compound_slack_space
+++ a/fs/nfsd/nfs4proc.c
@@ -740,7 +740,7 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 	struct svc_fh	*current_fh = NULL;
 	struct svc_fh	*save_fh = NULL;
 	struct nfs4_stateowner *replay_owner = NULL;
-	int		slack_space;    /* in words, not bytes! */
+	int		slack_bytes;
 	__be32		status;
 
 	status = nfserr_resource;
@@ -790,10 +790,10 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 		 * failed response to the next operation.  If we don't
 		 * have enough room, fail with ERR_RESOURCE.
 		 */
-/* FIXME - is slack_space *really* words, or bytes??? - neilb */
-		slack_space = (char *)resp->end - (char *)resp->p;
-		if (slack_space < COMPOUND_SLACK_SPACE + COMPOUND_ERR_SLACK_SPACE) {
-			BUG_ON(slack_space < COMPOUND_ERR_SLACK_SPACE);
+		slack_bytes = (char *)resp->end - (char *)resp->p;
+		if (slack_bytes < COMPOUND_SLACK_SPACE
+				+ COMPOUND_ERR_SLACK_SPACE) {
+			BUG_ON(slack_bytes < COMPOUND_ERR_SLACK_SPACE);
 			op->status = nfserr_resource;
 			goto encode_op;
 		}
diff -puN include/linux/nfsd/nfsd.h~knfsd-nfsd4-clarify-units-of-compound_slack_space include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~knfsd-nfsd4-clarify-units-of-compound_slack_space
+++ a/include/linux/nfsd/nfsd.h
@@ -275,12 +275,12 @@ static inline int is_fsid(struct svc_fh 
  * we might process an operation with side effects, and be unable to
  * tell the client that the operation succeeded.
  *
- * COMPOUND_SLACK_SPACE - this is the minimum amount of buffer space
+ * COMPOUND_SLACK_SPACE - this is the minimum bytes of buffer space
  * needed to encode an "ordinary" _successful_ operation.  (GETATTR,
  * READ, READDIR, and READLINK have their own buffer checks.)  if we
  * fall below this level, we fail the next operation with NFS4ERR_RESOURCE.
  *
- * COMPOUND_ERR_SLACK_SPACE - this is the minimum amount of buffer space
+ * COMPOUND_ERR_SLACK_SPACE - this is the minimum bytes of buffer space
  * needed to encode an operation which has failed with NFS4ERR_RESOURCE.
  * care is taken to ensure that we never fall below this level for any
  * reason.
_

Patches currently in -mm which might be from bfields@fieldses.org are

origin.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch

