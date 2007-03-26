From: akpm@linux-foundation.org
Subject: + integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata.patch added to -mm tree
Date: Mon, 26 Mar 2007 15:14:43 -0700
Message-ID: <200703262214.l2QMEh0c031924@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54947 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933333AbXCZWOt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     integrity: integrity_dummy_verify_metadata
has been added to the -mm tree.  Its filename is
     integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: integrity: integrity_dummy_verify_metadata
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

The following patch addresses the missing initialization values bug.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity_dummy.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN security/integrity_dummy.c~integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata security/integrity_dummy.c
--- a/security/integrity_dummy.c~integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata
+++ a/security/integrity_dummy.c
@@ -18,15 +18,15 @@
 #include <linux/xattr.h>
 
 /*
- *  Return the extended attribute
+ *  Return the extended attribute, if requested.
  */
 static int dummy_verify_metadata(struct dentry *dentry, char *xattr_name,
 				 char **xattr_value, int *xattr_value_len,
 				 int *status)
 {
-	char *value;
-	int size;
-	int error;
+	char *value = NULL;
+	int size = 0;
+	int error = 0;
 
 	if (!xattr_value || !xattr_value_len || !status)
 		return -EINVAL;
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata.patch
slim-main-lsm-getprocattr-hook-api-change.patch
slim-integrity-patch.patch
integrity-new-hooks.patch
integrity-new-hooks-fix.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface.patch
integrity-tpm-internal-kernel-interface-tidy.patch
ibac-patch.patch
