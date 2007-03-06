From: akpm@linux-foundation.org
Subject: - integrity-service-api-and-dummy-provider-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:10:09 -0800
Message-ID: <200703060210.l262A9VO009011@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46998 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965745AbXCFCKR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:10:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: don't return a value from void function
has been removed from the -mm tree.  Its filename was
     integrity-service-api-and-dummy-provider-fix.patch

This patch was dropped because it was folded into integrity-service-api-and-dummy-provider.patch

------------------------------------------------------
Subject: integrity: don't return a value from void function
From: "Serge E. Hallyn" <serue@us.ibm.com>

include/linux/integrity.h:integrity_measure() returns void,
but the non-integrity dummy version does 'return 0;'.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/integrity.h |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/integrity.h~integrity-service-api-and-dummy-provider-fix include/linux/integrity.h
--- a/include/linux/integrity.h~integrity-service-api-and-dummy-provider-fix
+++ a/include/linux/integrity.h
@@ -86,7 +86,7 @@ static inline int integrity_verify_data(
 static inline void integrity_measure(struct dentry *dentry,
 			const unsigned char *filename, int mask)
 {
-	return integrity_ops->measure(dentry, filename, mask);
+	integrity_ops->measure(dentry, filename, mask);
 }
 #else
 static inline int integrity_verify_metadata(struct dentry *dentry,
@@ -107,7 +107,6 @@ static inline int integrity_verify_data(
 static inline void integrity_measure(struct dentry *dentry,
 			const unsigned char *filename, int mask)
 {
-	return 0;
 }
 #endif
 #endif
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
integrity-service-api-and-dummy-provider.patch
integrity-service-api-and-dummy-provider-fix.patch
