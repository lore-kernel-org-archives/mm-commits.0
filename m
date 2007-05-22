From: akpm@linux-foundation.org
Subject: - integrity-service-api-and-dummy-provider.patch removed from -mm tree
Date: Tue, 22 May 2007 14:24:09 -0700
Message-ID: <200705222124.l4MLO9qb010087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023AbXEVV2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 17:28:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, safford@us.ibm.com, sds@tycho.nsa.gov, sergeh@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Integrity Service API and dummy provider
has been removed from the -mm tree.  Its filename was
     integrity-service-api-and-dummy-provider.patch

This patch was dropped because this work seems to be stalled

------------------------------------------------------
Subject: Integrity Service API and dummy provider
From: Kylene Jo Hall <kjhall@us.ibm.com>

This patch provides a framework and dummy provider for an integrity service. 
The three integrity functions provided are:

	integrity_verify_metadata
	integrity_verity_data
	integrity_measure

(Details on the calls and their exact arguments are in linux/integrity.h,
included in the patch.)

Normally these functions would be called by an LSM module during
d_instantiate.  The first function is used to retrieve a requested dentry's
label (xattr, such as security.selinux, or security.slim.level), along with
the result of integrity verification of the label.

Based on the result of this call, the LSM module may also choose to use
integrity_verify_data to request a verification of the file's data, and
integrity_measure, to commit the file's measurement to some form of
logging/attestation service, such as a TPM.

The latter two functions are separate calls, so that the LSM module can
optimize performance by using them only as needed.  For example, if the
integrity_verify_metadata call shows that the label is not trustworthy, it is
probably not necessary to hash and measure the file, as the current LSM check
will likely be denied anyway.

Updated to use more standard error returning per comments.

[zohar@linux.vnet.ibm.com: fix use-uninitialised bug]
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

 include/linux/integrity.h  |  112 +++++++++++++++++++++++++++++++++++
 security/Kconfig           |    8 ++
 security/Makefile          |    1 
 security/integrity.c       |   44 +++++++++++++
 security/integrity_dummy.c |   70 +++++++++++++++++++++
 security/integrity_dummy.h |   12 +++
 6 files changed, 247 insertions(+)

diff -puN /dev/null include/linux/integrity.h
--- /dev/null
+++ a/include/linux/integrity.h
@@ -0,0 +1,112 @@
+/*
+ * integrity.h
+ *
+ * Copyright (C) 2005,2006 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2 of the License.
+ */
+
+#ifndef _LINUX_INTEGRITY_H
+#define _LINUX_INTEGRITY_H
+
+#include <linux/fs.h>
+
+/*
+ * struct integrity_operations - main integrity structure
+ *
+ * @verify_data:
+ *	Verify the integrity of a dentry.
+ *	@dentry contains the dentry structure to be verified.
+ *	@status contains INTEGRITY_PASS, INTEGRITY_FAIL, or
+ * 		INTEGRITY_NOLABEL
+ *	Return 0 on success or errno values
+ *
+ * @verify_metadata:
+ *	Verify the integrity of a dentry's metadata; return the value
+ * 	of the requested xattr_name and the verification result of the
+ *	dentry's metadata.
+ *	@dentry contains the dentry structure of the metadata to be verified.
+ *	@xattr_name, if not null, contains the name of the xattr
+ *		 being requested.
+ *	@xattr_value, if not null, is a pointer for the xattr value.
+ *	@xattr_val_len will be set to the length of the xattr value.
+ *	@status contains INTEGRITY_PASS, INTEGRITY_FAIL, or
+ * 		INTEGRITY_NOLABEL
+ *	Return 0 on success or errno values
+ *
+ * @measure:
+ *	Update an aggregate integrity value with the inode's measurement.
+ *	The aggregate integrity value is maintained in secure storage such
+ *	as in a TPM PCR.
+ *	@dentry contains the dentry structure of the inode to be measured.
+ *	@filename either contains the full pathname/short file name.
+ *	@mask contains the filename permission status(i.e. read, write, append).
+ *
+ */
+
+#define PASS_STR "INTEGRITY_PASS"
+#define FAIL_STR "INTEGRITY_FAIL"
+#define NOLABEL_STR "INTEGRITY_NOLABEL"
+
+struct integrity_operations {
+	int (*verify_metadata) (struct dentry *dentry, char *xattr_name,
+			char **xattr_value, int *xattr_val_len, int *status);
+	int (*verify_data) (struct dentry *dentry, int *status);
+	void (*measure) (struct dentry *dentry,
+			const unsigned char *filename, int mask);
+};
+extern int register_integrity(struct integrity_operations *ops);
+extern int unregister_integrity(struct integrity_operations *ops);
+
+/* global variables */
+extern struct integrity_operations *integrity_ops;
+enum integrity_verify_status {
+	INTEGRITY_PASS = 0, INTEGRITY_FAIL = -1, INTEGRITY_NOLABEL = -2
+};
+
+/* inline stuff */
+#ifdef CONFIG_INTEGRITY
+static inline int integrity_verify_metadata(struct dentry *dentry,
+			char *xattr_name, char **xattr_value,
+			int *xattr_val_len, int *status)
+{
+	return integrity_ops->verify_metadata(dentry, xattr_name,
+			xattr_value, xattr_val_len, status);
+}
+
+static inline int integrity_verify_data(struct dentry *dentry,
+					int *status)
+{
+	return integrity_ops->verify_data(dentry, status);
+}
+
+static inline void integrity_measure(struct dentry *dentry,
+			const unsigned char *filename, int mask)
+{
+	integrity_ops->measure(dentry, filename, mask);
+}
+#else
+static inline int integrity_verify_metadata(struct dentry *dentry,
+			char *xattr_name, char **xattr_value,
+			int *xattr_val_len, int *status)
+{
+	status = INTEGRITY_PASS;
+	return 0;
+}
+
+static inline int integrity_verify_data(struct dentry *dentry,
+					int *status)
+{
+	status = INTEGRITY_PASS;
+	return 0;
+}
+
+static inline void integrity_measure(struct dentry *dentry,
+			const unsigned char *filename, int mask)
+{
+}
+#endif
+#endif
diff -puN security/Kconfig~integrity-service-api-and-dummy-provider security/Kconfig
--- a/security/Kconfig~integrity-service-api-and-dummy-provider
+++ a/security/Kconfig
@@ -39,6 +39,14 @@ config KEYS_DEBUG_PROC_KEYS
 
 	  If you are unsure as to whether this is required, answer N.
 
+config INTEGRITY
+	bool "Enable different integrity models"
+	help
+	  This allows you to choose different integrity modules to be
+	  configured into your kernel.
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
diff -puN security/Makefile~integrity-service-api-and-dummy-provider security/Makefile
--- a/security/Makefile~integrity-service-api-and-dummy-provider
+++ a/security/Makefile
@@ -12,6 +12,7 @@ endif
 
 # Object file lists
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
+obj-$(CONFIG_INTEGRITY)		+= integrity.o integrity_dummy.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
diff -puN /dev/null security/integrity.c
--- /dev/null
+++ a/security/integrity.c
@@ -0,0 +1,44 @@
+/*
+ * integrity.c
+ *
+ * register integrity subsystem
+ *
+ * Copyright (C) 2005,2006 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/integrity.h>
+
+#include "integrity_dummy.h"
+
+struct integrity_operations *integrity_ops = &dummy_integrity_ops;
+
+int register_integrity(struct integrity_operations *ops)
+{
+	if (integrity_ops != &dummy_integrity_ops)
+		return -EAGAIN;
+
+	integrity_ops = ops;
+	return 0;
+}
+
+int unregister_integrity(struct integrity_operations *ops)
+{
+	if (ops != integrity_ops)
+		return -EINVAL;
+
+	integrity_ops = &dummy_integrity_ops;
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(register_integrity);
+EXPORT_SYMBOL_GPL(unregister_integrity);
+EXPORT_SYMBOL_GPL(integrity_ops);
diff -puN /dev/null security/integrity_dummy.c
--- /dev/null
+++ a/security/integrity_dummy.c
@@ -0,0 +1,70 @@
+/*
+ * integrity_dummy.c
+ *
+ * Instantiate integrity subsystem
+ *
+ * Copyright (C) 2005,2006 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/integrity.h>
+#include <linux/xattr.h>
+
+/*
+ *  Return the extended attribute, if requested.
+ */
+static int dummy_verify_metadata(struct dentry *dentry, char *xattr_name,
+				 char **xattr_value, int *xattr_value_len,
+				 int *status)
+{
+	char *value = NULL;
+	int size = 0;
+	int error = 0;
+
+	if (!xattr_value || !xattr_value_len || !status)
+		return -EINVAL;
+
+	size = vfs_getxattr(dentry, xattr_name, NULL, 0);
+	if (size < 0) {
+		if (size == -ENODATA)
+			*status = INTEGRITY_NOLABEL;
+		return size;
+	}
+
+	value = kzalloc(size + 1, GFP_KERNEL);
+	if (!value)
+		return -ENOMEM;
+	error = vfs_getxattr(dentry, xattr_name, value, size);
+
+	*xattr_value_len = size;
+	*xattr_value = value;
+	*status = INTEGRITY_PASS;
+	return error;
+}
+
+static int dummy_verify_data(struct dentry *dentry, int *status)
+{
+	if (status)
+		*status = INTEGRITY_PASS;
+	return 0;
+}
+
+static void dummy_measure(struct dentry *dentry,
+			  const unsigned char *filename, int mask)
+{
+	return;
+}
+
+struct integrity_operations dummy_integrity_ops = {
+	.verify_metadata = dummy_verify_metadata,
+	.verify_data = dummy_verify_data,
+	.measure = dummy_measure
+};
+
diff -puN /dev/null security/integrity_dummy.h
--- /dev/null
+++ a/security/integrity_dummy.h
@@ -0,0 +1,12 @@
+/*
+ * integrity_dummy.h
+ *
+ * Copyright (C) 2005,2006 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation, version 2 of the License.
+ */
+
+extern struct integrity_operations dummy_integrity_ops;
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

use-menuconfig-objects-ii-tpm.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
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
