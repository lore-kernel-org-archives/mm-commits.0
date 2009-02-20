From: akpm@linux-foundation.org
Subject: + integrity-ima-iint-radix_tree_lookup-locking-fix.patch added to -mm tree
Date: Fri, 20 Feb 2009 14:28:29 -0800
Message-ID: <200902202228.n1KMSTVh003966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbZBTW2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Feb 2009 17:28:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, zohar@us.ibm.com


The patch titled
     integrity: ima iint radix_tree_lookup locking fix
has been added to the -mm tree.  Its filename is
     integrity-ima-iint-radix_tree_lookup-locking-fix.patch

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
integrity-ima-iint-radix_tree_lookup-locking-fix.patch

