From: akpm@osdl.org
Subject: + integrity-service-api-and-dummy-provider-fix.patch added to -mm tree
Date: Thu, 04 Jan 2007 14:13:30 -0800
Message-ID: <200701042213.l04MDVqC000502@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58550 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965089AbXADWOp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:14:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, kjhall@us.ibm.com, zohar@us.ibm.com


The patch titled
     integrity: don't return a value from void function
has been added to the -mm tree.  Its filename is
     integrity-service-api-and-dummy-provider-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
integrity-service-api-and-dummy-provider-fix.patch
