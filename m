From: akpm@linux-foundation.org
Subject: + cifs-dont-overwrite-dentry-name-in-d_revalidate.patch added to -mm tree
Date: Thu, 11 Nov 2010 12:08:07 -0800
Message-ID: <201011112008.oABK87wO032573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942Ab0KKUJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 15:09:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@kernel.dk, jlayton@redhat.com, sfrench@us.ibm.com


The patch titled
     cifs: don't overwrite dentry name in d_revalidate
has been added to the -mm tree.  Its filename is
     cifs-dont-overwrite-dentry-name-in-d_revalidate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: don't overwrite dentry name in d_revalidate
From: Nick Piggin <npiggin@kernel.dk>

Instead, use fatfs's method for dealing with negative dentries to preserve
case, rather than overwrite dentry name in d_revalidate, which is a bit
ugly and also gets in the way of doing lock-free path walking.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
Acked-by: Jeff Layton <jlayton@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/dir.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff -puN fs/cifs/dir.c~cifs-dont-overwrite-dentry-name-in-d_revalidate fs/cifs/dir.c
--- a/fs/cifs/dir.c~cifs-dont-overwrite-dentry-name-in-d_revalidate
+++ a/fs/cifs/dir.c
@@ -656,22 +656,34 @@ lookup_out:
 static int
 cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 {
-	int isValid = 1;
-
 	if (direntry->d_inode) {
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
-	} else {
-		cFYI(1, "neg dentry 0x%p name = %s",
-			 direntry, direntry->d_name.name);
-		if (time_after(jiffies, direntry->d_time + HZ) ||
-			!lookupCacheEnabled) {
-			d_drop(direntry);
-			isValid = 0;
-		}
+		else
+			return 1;
+	}
+
+	/*
+	 * This may be nfsd (or something), anyway, we can't see the
+	 * intent of this. So, since this can be for creation, drop it.
+	 */
+	if (!nd)
+		return 0;
+
+	/*
+	 * Drop the negative dentry, in order to make sure to use the
+	 * case sensitive name which is specified by user if this is
+	 * for creation.
+	 */
+	if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
+		if (nd->flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET))
+			return 0;
 	}
 
-	return isValid;
+	if (time_after(jiffies, direntry->d_time + HZ) || !lookupCacheEnabled)
+		return 0;
+
+	return 1;
 }
 
 /* static int cifs_d_delete(struct dentry *direntry)
@@ -709,15 +721,8 @@ static int cifs_ci_compare(struct dentry
 	struct nls_table *codepage = CIFS_SB(dentry->d_inode->i_sb)->local_nls;
 
 	if ((a->len == b->len) &&
-	    (nls_strnicmp(codepage, a->name, b->name, a->len) == 0)) {
-		/*
-		 * To preserve case, don't let an existing negative dentry's
-		 * case take precedence.  If a is not a negative dentry, this
-		 * should have no side effects
-		 */
-		memcpy((void *)a->name, b->name, a->len);
+	    (nls_strnicmp(codepage, a->name, b->name, a->len) == 0))
 		return 0;
-	}
 	return 1;
 }
 
_

Patches currently in -mm which might be from npiggin@kernel.dk are

atomic-add-atomic_inc_not_zero_hint.patch
linux-next.patch
radix-tree-fix-rcu-bug.patch
cifs-dont-overwrite-dentry-name-in-d_revalidate.patch

