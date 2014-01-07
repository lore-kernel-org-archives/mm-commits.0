From: akpm@linux-foundation.org
Subject: + userns-relax-the-posix_acl_valid-checks.patch added to -mm tree
Date: Tue, 07 Jan 2014 15:57:21 -0800
Message-ID: <52cc9461.rkHIfbP20sMP16j0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaAGX5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 18:57:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, jack@suse.cz, hch@infradead.org, ebiederm@xmission.com, adilger.kernel@dilger.ca, agruen@linbit.com

Subject: + userns-relax-the-posix_acl_valid-checks.patch added to -mm tree
To: agruen@linbit.com,adilger.kernel@dilger.ca,ebiederm@xmission.com,hch@infradead.org,jack@suse.cz,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 15:57:21 -0800


The patch titled
     Subject: userns: relax the posix_acl_valid() checks
has been added to the -mm tree.  Its filename is
     userns-relax-the-posix_acl_valid-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userns-relax-the-posix_acl_valid-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userns-relax-the-posix_acl_valid-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Gruenbacher <agruen@linbit.com>
Subject: userns: relax the posix_acl_valid() checks

So far, POSIX ACLs are using a canonical representation that keeps all ACL
entries in a strict order; the ACL_USER and ACL_GROUP entries for specific
users and groups are ordered by user and group identifier, respectively. 
The user-space code provides ACL entries in this order; the kernel
verifies that the ACL entry order is correct in posix_acl_valid().

User namespaces allow to arbitrary map user and group identifiers which
can cause the ACL_USER and ACL_GROUP entry order to differ between user
space and the kernel; posix_acl_valid() would then fail.

Work around this by allowing ACL_USER and ACL_GROUP entries to be in any
order in the kernel.  The effect is only minor: file permission checks
will pick the first matching ACL_USER entry, and check all matching
ACL_GROUP entries.

(The libacl user-space library and getfacl / setfacl tools will not create
ACLs with duplicate user or group idenfifiers; they will handle ACLs with
entries in an arbitrary order correctly.)

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/posix_acl.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN fs/posix_acl.c~userns-relax-the-posix_acl_valid-checks fs/posix_acl.c
--- a/fs/posix_acl.c~userns-relax-the-posix_acl_valid-checks
+++ a/fs/posix_acl.c
@@ -149,8 +149,6 @@ posix_acl_valid(const struct posix_acl *
 {
 	const struct posix_acl_entry *pa, *pe;
 	int state = ACL_USER_OBJ;
-	kuid_t prev_uid = INVALID_UID;
-	kgid_t prev_gid = INVALID_GID;
 	int needs_mask = 0;
 
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
@@ -169,10 +167,6 @@ posix_acl_valid(const struct posix_acl *
 					return -EINVAL;
 				if (!uid_valid(pa->e_uid))
 					return -EINVAL;
-				if (uid_valid(prev_uid) &&
-				    uid_lte(pa->e_uid, prev_uid))
-					return -EINVAL;
-				prev_uid = pa->e_uid;
 				needs_mask = 1;
 				break;
 
@@ -188,10 +182,6 @@ posix_acl_valid(const struct posix_acl *
 					return -EINVAL;
 				if (!gid_valid(pa->e_gid))
 					return -EINVAL;
-				if (gid_valid(prev_gid) &&
-				    gid_lte(pa->e_gid, prev_gid))
-					return -EINVAL;
-				prev_gid = pa->e_gid;
 				needs_mask = 1;
 				break;
 
_

Patches currently in -mm which might be from agruen@linbit.com are

userns-relax-the-posix_acl_valid-checks.patch

