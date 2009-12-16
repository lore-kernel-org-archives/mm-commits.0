From: akpm@linux-foundation.org
Subject: [merged] autofs4-cleanup-active-and-expire-lookup.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:33:53 -0800
Message-ID: <200912162033.nBGKXrC6012981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763051AbZLPUeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: cleanup active and expire lookup
has been removed from the -mm tree.  Its filename was
     autofs4-cleanup-active-and-expire-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: cleanup active and expire lookup
From: Ian Kent <raven@themaw.net>

The lookup functions for active and expiring dentrys use parameters that
can be easily obtained on entry so we change the call to to take just the
dentry.  This makes the subsequent change, to send all lookups to
->lookup(), a bit cleaner.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-cleanup-active-and-expire-lookup fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-cleanup-active-and-expire-lookup
+++ a/fs/autofs4/root.c
@@ -405,8 +405,11 @@ static const struct dentry_operations au
 	.d_release	= autofs4_dentry_release,
 };
 
-static struct dentry *autofs4_lookup_active(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
+static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 {
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
 	const unsigned char *str = name->name;
@@ -457,8 +460,11 @@ next:
 	return NULL;
 }
 
-static struct dentry *autofs4_lookup_expiring(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
+static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 {
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct dentry *parent = dentry->d_parent;
+	struct qstr *name = &dentry->d_name;
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
 	const unsigned char *str = name->name;
@@ -530,7 +536,7 @@ static struct dentry *autofs4_lookup(str
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
-	active = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
+	active = autofs4_lookup_active(dentry);
 	if (active) {
 		dentry = active;
 		ino = autofs4_dentry_ino(dentry);
@@ -567,9 +573,7 @@ static struct dentry *autofs4_lookup(str
 
 	if (!oz_mode) {
 		mutex_unlock(&dir->i_mutex);
-		expiring = autofs4_lookup_expiring(sbi,
-						   dentry->d_parent,
-						   &dentry->d_name);
+		expiring = autofs4_lookup_expiring(dentry);
 		if (expiring) {
 			/*
 			 * If we are racing with expire the request might not
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch

