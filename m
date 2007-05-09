From: akpm@linux-foundation.org
Subject: - integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata.patch removed from -mm tree
Date: Wed, 09 May 2007 03:02:42 -0700
Message-ID: <200705091002.l49A2gBB020727@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbXEIKDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:03:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: integrity_dummy_verify_metadata
has been removed from the -mm tree.  Its filename was
     integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata.patch

This patch was dropped because it was folded into integrity-service-api-and-dummy-provider.patch

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

integrity-service-api-and-dummy-provider.patch
integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata.patch
slim-main-lsm-getprocattr-hook-api-change.patch
slim-integrity-patch.patch
integrity-new-hooks.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-identifiers.patch
integrity-ima-cleanup.patch
integrity-tpm-internal-kernel-interface.patch
ibac-patch.patch
