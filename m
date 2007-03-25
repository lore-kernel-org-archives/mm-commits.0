From: akpm@linux-foundation.org
Subject: + slim-integrity-patch.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:30:54 -0800
Message-ID: <200703250830.l2P8UsbZ023807@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36329 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227AbXCYIhQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     SLIM Integrity Patch
has been added to the -mm tree.  Its filename is
     slim-integrity-patch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLIM Integrity Patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

This is a minor patch to SLIM that only addresses the integrity service
issues, to be reviewed in conjuction with the integrity service framework
and provider that were just posted.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/slim/Kconfig    |    4 -
 security/slim/slm_main.c |   98 +++++++++++++++++++++++--------------
 2 files changed, 65 insertions(+), 37 deletions(-)

diff -puN security/slim/Kconfig~slim-integrity-patch security/slim/Kconfig
--- a/security/slim/Kconfig~slim-integrity-patch
+++ a/security/slim/Kconfig
@@ -23,7 +23,7 @@ config SECURITY_SLIM_BOOTPARAM_VALUE
 	int "SLIM boot parameter default value"
 	depends on SECURITY_SLIM_BOOTPARAM
 	range 0 1
-	default 1
+	default 0
 	help
 	  This option sets the default value for the kernel parameter
 	  'slim', which allows SLIM to be disabled at boot.  If this
@@ -32,5 +32,5 @@ config SECURITY_SLIM_BOOTPARAM_VALUE
 	  set to 1 (one), the SLIM kernel parameter will default to 1,
 	  enabling SLIM at bootup.
 
-	  If you are unsure how to answer this question, answer 1.
+	  If you are unsure how to answer this question, answer 0.
 
diff -puN security/slim/slm_main.c~slim-integrity-patch security/slim/slm_main.c
--- a/security/slim/slm_main.c~slim-integrity-patch
+++ a/security/slim/slm_main.c
@@ -1,7 +1,7 @@
 /*
  * SLIM - Simple Linux Integrity Module
  *
- * Copyright (C) 2005,2006 IBM Corporation
+ * Copyright (C) 2005,2006,2007 IBM Corporation
  * Author: Mimi Zohar <zohar@us.ibm.com>
  * 	   Kylene Hall <kjhall@us.ibm.com>
  *
@@ -32,6 +32,29 @@
 extern struct security_operations dummy_security_ops;
 
 unsigned int slm_debug = SLM_BASE;
+
+#ifdef CONFIG_SECURITY_SLIM_BOOTPARAM
+int slim_enabled = CONFIG_SECURITY_SLIM_BOOTPARAM_VALUE;
+
+static int __init slim_enabled_setup(char *str)
+{
+	slim_enabled = simple_strtol(str, NULL, 0);
+	return 1;
+}
+__setup("slim=", slim_enabled_setup);
+#else
+int slim_enabled = 1;
+#endif
+
+unsigned int integrity_enforce = 0;
+static int __init integrity_enforce_setup(char *str)
+{
+	integrity_enforce = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("slim_integrity_enforce=", integrity_enforce_setup);
+
 #define XATTR_NAME "security.slim.level"
 
 #define ZERO_STR "0"
@@ -319,16 +342,13 @@ static int slm_get_xattr(struct dentry *
 			"(rc: %d - status: %d)\n",
 			dentry->d_name.name, rc, *status);
 
-	} else if (rc >=0 && *status == INTEGRITY_PASS && xattr_value) {
-		rc = slm_parse_xattr(xattr_value, xattr_len, level);
+	} else {
+		if (!integrity_enforce)
+			*status = INTEGRITY_PASS;
+
+		if (rc >= 0 && xattr_value && *status != INTEGRITY_FAIL)
+			rc = slm_parse_xattr(xattr_value, xattr_len, level);
 		kfree(xattr_value);
-		if (rc == 0 && level->iac_level != SLM_IAC_UNTRUSTED) {
-			rc = integrity_verify_data(dentry, status);
-			if ((rc < 0) || (*status != INTEGRITY_PASS))
-				dprintk(SLM_BASE, "%s integrity_verify_data failed "
-				" (rc: %d status: %d)\n", dentry->d_name.name,
-					rc, *status);
-		}
 	}
 	return rc;
 }
@@ -392,13 +412,12 @@ static void update_level(struct dentry *
 			break;
 		}
 	} else {
-		switch(status) {
-			case INTEGRITY_FAIL:
-			case INTEGRITY_NOLABEL:
-				dprintk(SLM_INTEGRITY, "%s: %s FAIL/NOLABEL (%d)\n",
+		switch (status) {
+		case INTEGRITY_FAIL:
+			dprintk(SLM_INTEGRITY, "%s: %s FAIL(%d)\n",
 				__FUNCTION__, dentry->d_name.name, rc);
-				set_level_untrusted(level);
-				break;
+			set_level_untrusted(level);
+			break;
 		}
 	}
 }
@@ -699,8 +718,28 @@ static int slm_inode_permission(struct i
 
 	slm_get_level(dentry, &level);
 
-	/* measure all SYSTEM level integrity objects */
-	if (level.iac_level == SLM_IAC_SYSTEM)
+	/* verify data for all trusted integrity objects */
+	if (level.iac_level != SLM_IAC_UNTRUSTED) {
+		int status;
+
+		rc = integrity_verify_data(dentry, &status);
+		switch (status) {
+		case INTEGRITY_FAIL:
+			dprintk(SLM_INTEGRITY, "%s: %s (Integrity status: "
+				" FAIL)\n", __FUNCTION__, fname);
+			if (integrity_enforce)
+				set_level_untrusted(&level);
+			break;
+		case INTEGRITY_NOLABEL:
+			dprintk(SLM_INTEGRITY, "%s: %s (Integrity status: "
+				" NOLABEL)\n", __FUNCTION__, fname);
+		default:
+			break;
+		}
+	}
+
+	/* measure all SYSTEM level integrity objects to be read */
+	if ((level.iac_level == SLM_IAC_SYSTEM) && (mask == MAY_READ))
 		integrity_measure(dentry, fname, mask);
 
 	rc = slm_set_taskperm(mask, &level, fname);
@@ -789,7 +828,6 @@ static int slm_set_xattr(struct slm_file
 		memcpy(bufp, slm_iac_str[level->iac_level], len);
 		bufp += len;
 	}
-	*bufp++ = ' ';
 	xattr_len = bufp - buf;
 
 	/* point after 'security.' */
@@ -1410,23 +1448,25 @@ static int slm_bprm_check_security(struc
 
 	/* Possible return codes: PERMIT, DENY, NOLABEL */
 	rc = integrity_verify_data(dentry, &status);
-	if (rc < 0)
+	if ((rc < 0) && integrity_enforce)
 		return rc;
 
-	switch(status) {
+	switch (status) {
 	case INTEGRITY_FAIL:
 		if (!is_kernel_thread(current)) {
 			dprintk(SLM_BASE,
 				"%s: %s (Integrity status: FAIL)\n",
 				__FUNCTION__, bprm->filename);
-			return -EACCES;
+			if (integrity_enforce)
+				return -EACCES;
 		}
 		break;
 	case INTEGRITY_NOLABEL:
 		dprintk(SLM_BASE,
 			"%s: %s (Integrity status: NOLABEL)\n",
 			__FUNCTION__, bprm->filename);
-		level.iac_level = SLM_IAC_UNTRUSTED;
+		if (integrity_enforce)
+			level.iac_level = SLM_IAC_UNTRUSTED;
 	}
 
 	rc = enforce_integrity_execute(bprm, &level, cur_tsec);
@@ -1609,18 +1649,6 @@ static struct security_operations slm_se
 	.d_instantiate = slm_d_instantiate
 };
 
-#ifdef CONFIG_SECURITY_SLIM_BOOTPARAM
-int slim_enabled = CONFIG_SECURITY_SLIM_BOOTPARAM_VALUE;
-
-static int __init slim_enabled_setup(char *str)
-{
-	slim_enabled = simple_strtol(str, NULL, 0);
-	return 1;
-}
-__setup("slim=", slim_enabled_setup);
-#else
-int slim_enabled = 1;
-#endif
 static int __init init_slm(void)
 {
 	int rc;
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

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
