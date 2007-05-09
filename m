From: akpm@linux-foundation.org
Subject: - slim-main-lsm-getprocattr-hook-api-change.patch removed from -mm tree
Date: Wed, 09 May 2007 03:03:20 -0700
Message-ID: <200705091003.l49A3K6k020744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724AbXEIKDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:03:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     SLIM LSM getprocattr hook API change
has been removed from the -mm tree.  Its filename was
     slim-main-lsm-getprocattr-hook-api-change.patch

This patch was dropped because it was folded into slim-main-patch.patch

------------------------------------------------------
Subject: SLIM LSM getprocattr hook API change
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

This patch addresses the 2.6.21-rc4 LSM getprocattr hook API change.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/slim/slm_main.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN security/slim/slm_main.c~slim-main-lsm-getprocattr-hook-api-change security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-main-lsm-getprocattr-hook-api-change
+++ a/security/slim/slm_main.c
@@ -1057,25 +1057,29 @@ static int slm_setprocattr(struct task_s
 }
 
 static int slm_getprocattr(struct task_struct *tsk,
-				  char *name, void *value, size_t size)
+				  char *name, char **value)
 {
 	struct slm_tsec_data *tsec = tsk->security;
 	size_t len = 0;
+	int buf_size = 31;
+	char buf[buf_size];
 
 	if (is_kernel_thread(tsk))
-		len = snprintf(value, size, "KERNEL");
+		len = snprintf(buf, buf_size, "KERNEL");
 	else {
 		spin_lock(&tsec->lock);
 		if (tsec->iac_wx != tsec->iac_r)
-			len = snprintf(value, size, "GUARD wx:%s r:%s",
+			len = snprintf(buf, buf_size, "GUARD wx:%s r:%s",
 				       slm_iac_str[tsec->iac_wx],
 				       slm_iac_str[tsec->iac_r]);
 		else
-			len = snprintf(value, size, "%s",
+			len = snprintf(buf, buf_size, "%s",
 				       slm_iac_str[tsec->iac_wx]);
 		spin_unlock(&tsec->lock);
 	}
-	return min(len, size);
+	*value = kzalloc(len, GFP_KERNEL);
+	memcpy(*value, buf, len);
+	return len;
 }
 
 /*
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
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
