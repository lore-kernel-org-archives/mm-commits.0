From: akpm@linux-foundation.org
Subject: [merged] hypfs-remove-useless-variable-qname.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:34 -0700
Message-ID: <200908101928.n7AJSYZw027844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbZHJT2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgusev@openvz.org, holzheu@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hypfs: remove useless variable qname
has been removed from the -mm tree.  Its filename was
     hypfs-remove-useless-variable-qname.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

