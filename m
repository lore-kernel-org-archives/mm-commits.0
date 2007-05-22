From: akpm@linux-foundation.org
Subject: - slim-secfs-patch.patch removed from -mm tree
Date: Tue, 22 May 2007 14:24:16 -0700
Message-ID: <200705222124.l4MLOGqo010093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127AbXEVV2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 17:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, safford@us.ibm.com, sds@tycho.nsa.gov, sergeh@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     SLIM: secfs patch
has been removed from the -mm tree.  Its filename was
     slim-secfs-patch.patch

This patch was dropped because this work seems to be stalled

------------------------------------------------------
Subject: SLIM: secfs patch
From: Kylene Jo Hall <kjhall@us.ibm.com>

This patch provides the securityfs used by SLIM.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Cc: Dave Safford <safford@us.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge Hallyn <sergeh@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/slim/slm_main.c  |    1 
 security/slim/slm_secfs.c |   72 ++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 1 deletion(-)

diff -puN /dev/null security/slim/slm_secfs.c
--- /dev/null
+++ a/security/slim/slm_secfs.c
@@ -0,0 +1,72 @@
+/*
+ * SLIM securityfs support: debugging control files
+ *
+ * Copyright (C) 2005, 2006 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *	   Kylene Hall <kjhall@us.ibm.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2 of the License.
+ */
+
+#include <asm/uaccess.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/security.h>
+#include <linux/debugfs.h>
+#include "slim.h"
+
+static struct dentry *slim_sec_dir, *slim_level;
+
+static ssize_t slm_read_level(struct file *file, char __user *buf,
+			      size_t buflen, loff_t *ppos)
+{
+	struct slm_tsec_data *cur_tsec = current->security;
+	ssize_t len;
+	char data[28];
+	if (is_kernel_thread(current))
+		len = scnprintf(data, sizeof(data), "KERNEL\n");
+	else if (!cur_tsec)
+		len = scnprintf(data, sizeof(data), "UNKNOWN\n");
+	else {
+		if (cur_tsec->iac_wx != cur_tsec->iac_r)
+			len = scnprintf(data, sizeof(data), "GUARD wx:%s r:%s\n",
+				      slm_iac_str[cur_tsec->iac_wx],
+				      slm_iac_str[cur_tsec->iac_r]);
+		else
+			len = scnprintf(data, sizeof(data), "%s\n",
+				      slm_iac_str[cur_tsec->iac_wx]);
+	}
+	return simple_read_from_buffer(buf, buflen, ppos, data, len);
+}
+
+static struct file_operations slm_level_ops = {
+	.read = slm_read_level,
+};
+
+int __init slm_init_secfs(void)
+{
+	if (!slim_enabled)
+		return 0;
+
+	slim_sec_dir = securityfs_create_dir("slim", NULL);
+	if (!slim_sec_dir || IS_ERR(slim_sec_dir))
+		return -EFAULT;
+	slim_level = securityfs_create_file("level", S_IRUGO,
+					    slim_sec_dir, NULL, &slm_level_ops);
+	if (!slim_level || IS_ERR(slim_level)) {
+		securityfs_remove(slim_sec_dir);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+__initcall(slm_init_secfs);
+
+void __exit slm_cleanup_secfs(void)
+{
+	securityfs_remove(slim_level);
+	securityfs_remove(slim_sec_dir);
+}
+
diff -puN security/slim/slm_main.c~slim-secfs-patch security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-secfs-patch
+++ a/security/slim/slm_main.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/mman.h>
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
 #include <linux/integrity.h>
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

use-menuconfig-objects-ii-tpm.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch
integrity-new-hooks.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-identifiers.patch
integrity-ima-cleanup.patch
integrity-tpm-internal-kernel-interface.patch
