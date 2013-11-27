From: akpm@linux-foundation.org
Subject: + ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name.patch
 added to -mm tree
Date: Wed, 27 Nov 2013 15:40:02 -0800
Message-ID: <529682d2.8GR9L4VM83iOsKh1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520Ab3K0XkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 18:40:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: + ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name.patch added to -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 15:40:02 -0800


The patch titled
     Subject: ocfs2: drop the unwanted null byte in dentry lock name
has been added to the -mm tree.  Its filename is
     ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: drop the unwanted null byte in dentry lock name

Dentry lock name is made up of the type 'N', the parent blkno and its
blkno represented as a binary value.  Now there is a null byte between
parent blkno and the binary blkno value, so drop it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdebug.c |    2 +-
 fs/ocfs2/dlmglue.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdebug.c~ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name fs/ocfs2/dlm/dlmdebug.c
--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -257,7 +257,7 @@ static int stringify_lockname(const char
 #define OCFS2_DENTRY_LOCK_INO_START	18
 	if (*lockname == 'N') {
 		memcpy((__be64 *)&inode_blkno_be,
-		       (char *)&lockname[OCFS2_DENTRY_LOCK_INO_START],
+		       (char *)&lockname[OCFS2_DENTRY_LOCK_INO_START - 1],
 		       sizeof(__be64));
 		out += snprintf(buf + out, len - out, "%.*s%08x",
 				OCFS2_DENTRY_LOCK_INO_START - 1, lockname,
diff -puN fs/ocfs2/dlmglue.c~ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name
+++ a/fs/ocfs2/dlmglue.c
@@ -586,7 +586,7 @@ static __u64 ocfs2_get_dentry_lock_ino(s
 {
 	__be64 inode_blkno_be;
 
-	memcpy(&inode_blkno_be, &lockres->l_name[OCFS2_DENTRY_LOCK_INO_START],
+	memcpy(&inode_blkno_be, &lockres->l_name[OCFS2_DENTRY_LOCK_INO_START - 1],
 	       sizeof(__be64));
 
 	return be64_to_cpu(inode_blkno_be);
@@ -631,7 +631,7 @@ void ocfs2_dentry_lock_res_init(struct o
 
 	BUG_ON(len != (OCFS2_DENTRY_LOCK_INO_START - 1));
 
-	memcpy(&lockres->l_name[OCFS2_DENTRY_LOCK_INO_START], &inode_blkno_be,
+	memcpy(&lockres->l_name[OCFS2_DENTRY_LOCK_INO_START - 1], &inode_blkno_be,
 	       sizeof(__be64));
 
 	ocfs2_lock_res_init_common(OCFS2_SB(inode->i_sb), lockres,
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-drop-the-unwanted-null-byte-in-dentry-lock-name.patch
ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch

