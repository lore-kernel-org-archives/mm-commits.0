From: akpm@linux-foundation.org
Subject: + knfsd-set-the-response-bitmask-for-nfs4_create_exclusive.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:36:18 -0700
Message-ID: <200707290736.l6T7aIxi013972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758451AbXG2Hgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: set the response bitmask for NFS4_CREATE_EXCLUSIVE
has been added to the -mm tree.  Its filename is
     knfsd-set-the-response-bitmask-for-nfs4_create_exclusive.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: set the response bitmask for NFS4_CREATE_EXCLUSIVE
From: Jeff Layton <jlayton@redhat.com>

RFC 3530 says:

 If the server uses an attribute to store the exclusive create verifier, it
 will signify which attribute by setting the appropriate bit in the attribute
 mask that is returned in the results.

Linux uses the atime and mtime to store the verifier, but sends a zeroed out
bitmask back to the client.  This patch makes sure that we set the correct
bits in the bitmask in this situation.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4proc.c |   10 +++++++++-
 fs/nfsd/vfs.c      |    5 ++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~knfsd-set-the-response-bitmask-for-nfs4_create_exclusive fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~knfsd-set-the-response-bitmask-for-nfs4_create_exclusive
+++ a/fs/nfsd/nfs4proc.c
@@ -100,7 +100,15 @@ do_open_lookup(struct svc_rqst *rqstp, s
 		status = nfsd_create_v3(rqstp, current_fh, open->op_fname.data,
 					open->op_fname.len, &open->op_iattr,
 					&resfh, open->op_createmode,
-					(u32 *)open->op_verf.data, &open->op_truncate, &created);
+					(u32 *)open->op_verf.data,
+					&open->op_truncate, &created);
+
+		/* If we ever decide to use different attrs to store the
+		 * verifier in nfsd_create_v3, then we'll need to change this
+		 */
+		if (open->op_createmode == NFS4_CREATE_EXCLUSIVE && status == 0)
+			open->op_bmval[1] |= (FATTR4_WORD1_TIME_ACCESS |
+						FATTR4_WORD1_TIME_MODIFY);
 	} else {
 		status = nfsd_lookup(rqstp, current_fh,
 				     open->op_fname.data, open->op_fname.len, &resfh);
diff -puN fs/nfsd/vfs.c~knfsd-set-the-response-bitmask-for-nfs4_create_exclusive fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-set-the-response-bitmask-for-nfs4_create_exclusive
+++ a/fs/nfsd/vfs.c
@@ -1309,7 +1309,10 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 
 	if (createmode == NFS3_CREATE_EXCLUSIVE) {
 		/* solaris7 gets confused (bugid 4218508) if these have
-		 * the high bit set, so just clear the high bits.
+		 * the high bit set, so just clear the high bits. If this is
+		 * ever changed to use different attrs for storing the
+		 * verifier, then do_open_lookup() will also need to be fixed
+		 * accordingly.
 		 */
 		v_mtime = verifier[0]&0x7fffffff;
 		v_atime = verifier[1]&0x7fffffff;
_

Patches currently in -mm which might be from jlayton@redhat.com are

knfsd-set-the-response-bitmask-for-nfs4_create_exclusive.patch
