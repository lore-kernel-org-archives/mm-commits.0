From: akpm@linux-foundation.org
Subject: + slim-main-lsm-getprocattr-hook-api-change.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:31:51 -0800
Message-ID: <200703250831.l2P8VpOk023822@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36302 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933234AbXCYIfL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:35:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     SLIM LSM getprocattr hook API change
has been added to the -mm tree.  Its filename is
     slim-main-lsm-getprocattr-hook-api-change.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

slim-main-lsm-getprocattr-hook-api-change.patch
slim-integrity-patch.patch
integrity-new-hooks.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-tpm-internal-kernel-interface.patch
integrity-tpm-internal-kernel-interface-tidy.patch
ibac-patch.patch
