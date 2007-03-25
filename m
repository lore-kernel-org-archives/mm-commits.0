From: akpm@linux-foundation.org
Subject: + ibac-patch.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:55:41 -0800
Message-ID: <200703250755.l2P7tfWn023257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbXCYHzp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     IBAC Patch
has been added to the -mm tree.  Its filename is
     ibac-patch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IBAC Patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

This is a new Integrity Based Access Control(IBAC) LSM module which bases
access control decisions on the new integrity framework services.  IBAC is a
sample LSM module to help clarify the interaction between LSM and Linux
Integrity Modules(LIM).

   - Updated Kconfig SECURITY_IBAC description
     and SECURITY_IBAC_BOOTPARAM default value
   - Prefixed all log messages with "ibac:"
   - Redefined a couple of 'int' variables as 'static int'

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/Kconfig          |    1 
 security/Makefile         |    1 
 security/ibac/Kconfig     |   41 ++++++++++++
 security/ibac/Makefile    |    6 +
 security/ibac/ibac_main.c |  123 ++++++++++++++++++++++++++++++++++++
 5 files changed, 172 insertions(+)

diff -puN security/Kconfig~ibac-patch security/Kconfig
--- a/security/Kconfig~ibac-patch
+++ a/security/Kconfig
@@ -125,5 +125,6 @@ config SECURITY_ROOTPLUG
 source security/selinux/Kconfig
 
 source security/slim/Kconfig
+source security/ibac/Kconfig
 endmenu
 
diff -puN security/Makefile~ibac-patch security/Makefile
--- a/security/Makefile~ibac-patch
+++ a/security/Makefile
@@ -14,6 +14,7 @@ endif
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 obj-$(CONFIG_INTEGRITY)		+= integrity.o integrity_dummy.o
 obj-$(CONFIG_INTEGRITY_EVM)		+= evm/
+obj-$(CONFIG_SECURITY_IBAC)		+= ibac/
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SLIM)		+= slim/
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
diff -puN /dev/null security/ibac/Kconfig
--- /dev/null
+++ a/security/ibac/Kconfig
@@ -0,0 +1,41 @@
+config SECURITY_IBAC
+	boolean "IBAC support"
+	depends on SECURITY && SECURITY_NETWORK && INTEGRITY
+	help
+	  Integrity Based Access Control(IBAC) uses the Linux
+	  Integrity Module(LIM) API calls to verify an executable's
+	  metadata and data's integrity.  Based on the results,
+	  execution permission is permitted/denied.  Integrity
+	  providers may implement the LIM hooks differently.  For
+	  more information on integrity verification refer to the
+	  specific integrity provider documentation.
+
+config SECURITY_IBAC_BOOTPARAM
+	bool "IBAC boot parameter"
+	depends on SECURITY_IBAC
+	default n
+	help
+	  This option adds a kernel parameter 'ibac', which allows IBAC
+	  to be disabled at boot.  If this option is selected, IBAC
+	  functionality can be disabled with ibac=0 on the kernel
+	  command line.  The purpose of this option is to allow a
+	  single kernel image to be distributed with IBAC built in,
+	  but not necessarily enabled.
+
+	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_IBAC_BOOTPARAM_VALUE
+	int "IBAC boot parameter default value"
+	depends on SECURITY_IBAC_BOOTPARAM
+	range 0 1
+	default 0
+	help
+	  This option sets the default value for the kernel parameter
+	  'ibac', which allows IBAC to be disabled at boot.  If this
+	  option is set to 0 (zero), the IBAC kernel parameter will
+	  default to 0, disabling IBAC at bootup.  If this option is
+	  set to 1 (one), the IBAC kernel parameter will default to 1,
+	  enabling IBAC at bootup.
+
+	  If you are unsure how to answer this question, answer 0.
+
diff -puN /dev/null security/ibac/Makefile
--- /dev/null
+++ a/security/ibac/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for building IBAC
+#
+
+obj-$(CONFIG_SECURITY_IBAC) += ibac.o
+ibac-y 	:= ibac_main.o
diff -puN /dev/null security/ibac/ibac_main.c
--- /dev/null
+++ a/security/ibac/ibac_main.c
@@ -0,0 +1,123 @@
+/*
+ * Integrity Based Access Control(IBAC) sample LSM module calling LIM hooks
+ *
+ * Copyright (C) 2007 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/security.h>
+#include <linux/integrity.h>
+
+#ifdef CONFIG_SECURITY_IBAC_BOOTPARAM
+static int ibac_enabled = CONFIG_SECURITY_IBAC_BOOTPARAM_VALUE;
+
+static int __init ibac_enabled_setup(char *str)
+{
+	ibac_enabled = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ibac=", ibac_enabled_setup);
+#else
+static int ibac_enabled = 1;
+#endif
+
+static unsigned int integrity_enforce;
+static int __init integrity_enforce_setup(char *str)
+{
+	integrity_enforce = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ibac_enforce=", integrity_enforce_setup);
+
+static inline int is_kernel_thread(struct task_struct *tsk)
+{
+	return (!tsk->mm) ? 1 : 0;
+}
+
+static int ibac_bprm_check_security(struct linux_binprm *bprm)
+{
+	struct dentry *dentry = bprm->file->f_dentry;
+	char *xattr_value = NULL;
+	int rc, status;
+
+	rc = integrity_verify_metadata(dentry, NULL, NULL, NULL, &status);
+	if (rc == -EOPNOTSUPP) {
+		kfree(xattr_value);
+		return 0;
+	}
+
+	if (rc < 0) {
+		printk(KERN_INFO "ibac: verify_metadata %s failed "
+		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);
+		if (!integrity_enforce)
+			rc = 0;
+		goto out;
+	}
+	if (status != INTEGRITY_PASS) {	/* FAIL | NO_LABEL */
+		if (!is_kernel_thread(current)) {
+			printk(KERN_INFO "ibac: verify_metadata %s "
+			       "(Integrity status: %s)\n", bprm->filename,
+				status == INTEGRITY_FAIL ? "FAIL" : "NOLABEL");
+			if (integrity_enforce) {
+				rc = -EACCES;
+				goto out;
+			}
+		}
+	}
+
+	rc = integrity_verify_data(dentry, &status);
+	if (rc < 0) {
+		printk(KERN_INFO "ibac: %s verify_data failed "
+		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);
+		if (!integrity_enforce)
+			rc = 0;
+		goto out;
+	}
+	if (status != INTEGRITY_PASS) {
+		if (!is_kernel_thread(current)) {
+			printk(KERN_INFO "ibac: verify_data %s "
+			       "(Integrity status: FAIL)\n", bprm->filename);
+			if (integrity_enforce) {
+				rc = -EACCES;
+				goto out;
+			}
+		}
+	}
+
+	kfree(xattr_value);
+
+	/* measure all executables */
+	integrity_measure(dentry, bprm->filename, MAY_EXEC);
+	return 0;
+out:
+	kfree(xattr_value);
+	return rc;
+}
+
+static struct security_operations ibac_security_ops = {
+	.bprm_check_security = ibac_bprm_check_security
+};
+
+static int __init init_ibac(void)
+{
+	int rc;
+
+	if (!ibac_enabled)
+		return 0;
+
+	rc = register_security(&ibac_security_ops);
+	if (rc != 0)
+		panic("ibac: unable to register with kernel\n");
+	return rc;
+}
+
+security_initcall(init_ibac);
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

integrity-new-hooks.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-mtime-patch-for-mmap-files.patch
integrity-tpm-internal-kernel-interface.patch
ibac-patch.patch
