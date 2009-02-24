From: akpm@linux-foundation.org
Subject: [merged] integrity-ima-iint-radix_tree_lookup-locking-fix.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:33:25 -0800
Message-ID: <200902241933.n1OJXPSb004524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250AbZBXTeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:34:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, jmorris@namei.org, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: ima iint radix_tree_lookup locking fix
has been removed from the -mm tree.  Its filename was
     integrity-ima-iint-radix_tree_lookup-locking-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: integrity: ima iint radix_tree_lookup locking fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

Based on Andrew Morton's comments:
- add missing locks around radix_tree_lookup in ima_iint_insert()

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_iint.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN security/integrity/ima/ima_iint.c~integrity-ima-iint-radix_tree_lookup-locking-fix security/integrity/ima/ima_iint.c
--- a/security/integrity/ima/ima_iint.c~integrity-ima-iint-radix_tree_lookup-locking-fix
+++ a/security/integrity/ima/ima_iint.c
@@ -73,8 +73,10 @@ out:
 	if (rc < 0) {
 		kmem_cache_free(iint_cache, iint);
 		if (rc == -EEXIST) {
+			spin_lock(&ima_iint_lock);
 			iint = radix_tree_lookup(&ima_iint_store,
 						 (unsigned long)inode);
+			spin_unlock(&ima_iint_lock);
 		} else
 			iint = NULL;
 	}
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

linux-next.patch

