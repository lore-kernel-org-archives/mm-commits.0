From: akpm@linux-foundation.org
Subject: [nacked] ima-return-proper-error-value-on-failure-of-dentry_open.patch removed from -mm tree
Date: Mon, 01 Jun 2009 22:21:16 -0700
Message-ID: <200906020521.n525LG9q010788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755770AbZFBFWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 01:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vibi_sreenivasan@cms.com, jmorris@namei.org, sailer@watson.ibm.com, serue@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ima: return proper error value on failure of dentry_open()
has been removed from the -mm tree.  Its filename was
     ima-return-proper-error-value-on-failure-of-dentry_open.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ima: return proper error value on failure of dentry_open()
From: vibi sreenivasan <vibi_sreenivasan@cms.com>

dentry_open can return error value on error.  Check that value before
calling fput & return proper error value

Signed-off-by: vibi sreenivasan <vibi_sreenivasan@cms.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Reiner Sailer <sailer@watson.ibm.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/integrity/ima/ima_main.c~ima-return-proper-error-value-on-failure-of-dentry_open security/integrity/ima/ima_main.c
--- a/security/integrity/ima/ima_main.c~ima-return-proper-error-value-on-failure-of-dentry_open
+++ a/security/integrity/ima/ima_main.c
@@ -198,10 +198,10 @@ int ima_path_check(struct path *path, in
 	}
 out:
 	mutex_unlock(&iint->mutex);
-	if (file)
+	if (IS_ERR(file))
 		fput(file);
 	kref_put(&iint->refcount, iint_free);
-	return 0;
+	return rc;
 }
 EXPORT_SYMBOL_GPL(ima_path_check);
 
_

Patches currently in -mm which might be from vibi_sreenivasan@cms.com are

ima-return-proper-error-value-on-failure-of-dentry_open.patch

