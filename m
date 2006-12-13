From: akpm@osdl.org
Subject: + knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:36:27 -0800
Message-ID: <200612130136.kBD1aRMg024119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964877AbWLMBjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:39:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: staubach@redhat.com, neilb@suse.de


The patch titled
     knfsd: Don't mess with the 'mode' when storing a exclusive-create cookie
has been added to the -mm tree.  Its filename is
     knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: Don't mess with the 'mode' when storing a exclusive-create cookie
From: Peter Staubach <staubach@redhat.com>

NFS V3 (and V4) support exclusive create by passing a 'cookie' which can get
stored with the file.  If the file exists but has exactly the right cookie
stored, then we assume this is a retransmit and the exclusive create was
successful.

The cookie is 64bits and is traditionally stored in the mtime and atime
fields.  This causes a problem with Solaris7 as negative mtime or atime
confuse it.  So we moved two bits into the mode word instead.

But inherited ACLs sometimes overwrite the mode word on create, so this is a
problem.

So we give up and just store 62 of the 64 bits and assume that is close
enough.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/vfs.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff -puN fs/nfsd/vfs.c~knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie
+++ a/fs/nfsd/vfs.c
@@ -1244,7 +1244,6 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 	__be32		err;
 	int		host_err;
 	__u32		v_mtime=0, v_atime=0;
-	int		v_mode=0;
 
 	err = nfserr_perm;
 	if (!flen)
@@ -1281,16 +1280,11 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		goto out;
 
 	if (createmode == NFS3_CREATE_EXCLUSIVE) {
-		/* while the verifier would fit in mtime+atime,
-		 * solaris7 gets confused (bugid 4218508) if these have
-		 * the high bit set, so we use the mode as well
+		/* solaris7 gets confused (bugid 4218508) if these have
+		 * the high bit set, so just clear the high bits.
 		 */
 		v_mtime = verifier[0]&0x7fffffff;
 		v_atime = verifier[1]&0x7fffffff;
-		v_mode  = S_IFREG
-			| ((verifier[0]&0x80000000) >> (32-7)) /* u+x */
-			| ((verifier[1]&0x80000000) >> (32-9)) /* u+r */
-			;
 	}
 	
 	if (dchild->d_inode) {
@@ -1318,7 +1312,6 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 		case NFS3_CREATE_EXCLUSIVE:
 			if (   dchild->d_inode->i_mtime.tv_sec == v_mtime
 			    && dchild->d_inode->i_atime.tv_sec == v_atime
-			    && dchild->d_inode->i_mode  == v_mode
 			    && dchild->d_inode->i_size  == 0 )
 				break;
 			 /* fallthru */
@@ -1340,26 +1333,22 @@ nfsd_create_v3(struct svc_rqst *rqstp, s
 	}
 
 	if (createmode == NFS3_CREATE_EXCLUSIVE) {
-		/* Cram the verifier into atime/mtime/mode */
+		/* Cram the verifier into atime/mtime */
 		iap->ia_valid = ATTR_MTIME|ATTR_ATIME
-			| ATTR_MTIME_SET|ATTR_ATIME_SET
-			| ATTR_MODE;
+			| ATTR_MTIME_SET|ATTR_ATIME_SET;
 		/* XXX someone who knows this better please fix it for nsec */ 
 		iap->ia_mtime.tv_sec = v_mtime;
 		iap->ia_atime.tv_sec = v_atime;
 		iap->ia_mtime.tv_nsec = 0;
 		iap->ia_atime.tv_nsec = 0;
-		iap->ia_mode  = v_mode;
 	}
 
 	/* Set file attributes.
-	 * Mode has already been set but we might need to reset it
-	 * for CREATE_EXCLUSIVE
 	 * Irix appears to send along the gid when it tries to
 	 * implement setgid directories via NFS. Clear out all that cruft.
 	 */
  set_attr:
-	if ((iap->ia_valid &= ~(ATTR_UID|ATTR_GID)) != 0) {
+	if ((iap->ia_valid &= ~(ATTR_UID|ATTR_GID|ATTR_MODE)) != 0) {
  		__be32 err2 = nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
 		if (err2)
 			err = err2;
_

Patches currently in -mm which might be from staubach@redhat.com are

knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch

