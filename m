From: akpm@linux-foundation.org
Subject: - slim-secfs-patch-slim-correct-use-of-snprintf.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:11:51 -0800
Message-ID: <200703060211.l262BpvX009043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47089 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933846AbXCFCL6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:11:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     slim: correct use of snprintf
has been removed from the -mm tree.  Its filename was
     slim-secfs-patch-slim-correct-use-of-snprintf.patch

This patch was dropped because it was folded into slim-secfs-patch.patch

------------------------------------------------------
Subject: slim: correct use of snprintf
From: Kylene Jo Hall <kjhall@us.ibm.com>

Thanks to Stephen Smalley for pointing our incorrect usage of snprintf. 
This patch fixes things by using the correct function, scnprintf, instead.

Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/slim/slm_secfs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN security/slim/slm_secfs.c~slim-secfs-patch-slim-correct-use-of-snprintf security/slim/slm_secfs.c
--- a/security/slim/slm_secfs.c~slim-secfs-patch-slim-correct-use-of-snprintf
+++ a/security/slim/slm_secfs.c
@@ -27,16 +27,16 @@ static ssize_t slm_read_level(struct fil
 	ssize_t len;
 	char data[28];
 	if (is_kernel_thread(current))
-		len = snprintf(data, sizeof(data), "KERNEL\n");
+		len = scnprintf(data, sizeof(data), "KERNEL\n");
 	else if (!cur_tsec)
-		len = snprintf(data, sizeof(data), "UNKNOWN\n");
+		len = scnprintf(data, sizeof(data), "UNKNOWN\n");
 	else {
 		if (cur_tsec->iac_wx != cur_tsec->iac_r)
-			len = snprintf(data, sizeof(data), "GUARD wx:%s r:%s\n",
+			len = scnprintf(data, sizeof(data), "GUARD wx:%s r:%s\n",
 				      slm_iac_str[cur_tsec->iac_wx],
 				      slm_iac_str[cur_tsec->iac_r]);
 		else
-			len = snprintf(data, sizeof(data), "%s\n",
+			len = scnprintf(data, sizeof(data), "%s\n",
 				      slm_iac_str[cur_tsec->iac_wx]);
 	}
 	return simple_read_from_buffer(buf, buflen, ppos, data, len);
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-secfs-patch-slim-correct-use-of-snprintf.patch
slim-secfs-patch-cleanup-use-of-configh.patch
slim-make-and-config-stuff.patch
slim-make-and-config-stuff-makefile-fix.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-fix-security-issue-with-the-task_post_setuid-hook.patch
slim-secfs-inode-i_private-build-fix.patch
slim-documentation.patch
panic-on-slim-selinux.patch
