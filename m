From: akpm@linux-foundation.org
Subject: + hypfs-remove-useless-variable-qname.patch added to -mm tree
Date: Mon, 22 Jun 2009 16:10:42 -0700
Message-ID: <200906222310.n5MNAg73012199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbZFVXLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 19:11:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgusev@openvz.org, holzheu@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     hypfs: remove useless variable qname
has been added to the -mm tree.  Its filename is
     hypfs-remove-useless-variable-qname.patch

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
Subject: hypfs: remove useless variable qname
From: Vitaliy Gusev <vgusev@openvz.org>

Local variable 'qname' in the function hypfs_create_file() really is not
used for any purpose.

Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>
Cc: Michael Holzheu <holzheu@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/hypfs/inode.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/s390/hypfs/inode.c~hypfs-remove-useless-variable-qname arch/s390/hypfs/inode.c
--- a/arch/s390/hypfs/inode.c~hypfs-remove-useless-variable-qname
+++ a/arch/s390/hypfs/inode.c
@@ -355,11 +355,7 @@ static struct dentry *hypfs_create_file(
 {
 	struct dentry *dentry;
 	struct inode *inode;
-	struct qstr qname;
 
-	qname.name = name;
-	qname.len = strlen(name);
-	qname.hash = full_name_hash(name, qname.len);
 	mutex_lock(&parent->d_inode->i_mutex);
 	dentry = lookup_one_len(name, parent, strlen(name));
 	if (IS_ERR(dentry)) {
_

Patches currently in -mm which might be from vgusev@openvz.org are

origin.patch
hypfs-remove-useless-variable-qname.patch

