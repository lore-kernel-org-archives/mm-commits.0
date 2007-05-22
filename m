From: akpm@linux-foundation.org
Subject: - slim-make-and-config-stuff.patch removed from -mm tree
Date: Tue, 22 May 2007 14:24:19 -0700
Message-ID: <200705222124.l4MLOJSa010096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764172AbXEVV3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 17:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kjhall@us.ibm.com, chrisw@sous-sol.org, dwalker@mvista.com, jmorris@namei.org, safford@us.ibm.com, sds@tycho.nsa.gov, sergeh@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     SLIM: make and config stuff
has been removed from the -mm tree.  Its filename was
     slim-make-and-config-stuff.patch

This patch was dropped because this work seems to be stalled

------------------------------------------------------
Subject: SLIM: make and config stuff
From: Kylene Jo Hall <kjhall@us.ibm.com>

This patch contains the Makefile, Kconfig and .h files for SLIM.

[dwalker@mvista.com: fix panic on SLIM + selinux]
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Cc: Dave Safford <safford@us.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Serge Hallyn <sergeh@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/Kconfig       |    1 
 security/Makefile      |    1 
 security/slim/Kconfig  |   36 +++++++++++++++
 security/slim/Makefile |    6 ++
 security/slim/slim.h   |   89 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 133 insertions(+)

diff -puN security/Kconfig~slim-make-and-config-stuff security/Kconfig
--- a/security/Kconfig~slim-make-and-config-stuff
+++ a/security/Kconfig
@@ -113,5 +113,6 @@ config SECURITY_ROOTPLUG
 
 source security/selinux/Kconfig
 
+source security/slim/Kconfig
 endmenu
 
diff -puN security/Makefile~slim-make-and-config-stuff security/Makefile
--- a/security/Makefile~slim-make-and-config-stuff
+++ a/security/Makefile
@@ -14,6 +14,7 @@ endif
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 obj-$(CONFIG_INTEGRITY)		+= integrity.o integrity_dummy.o
 # Must precede capability.o in order to stack properly.
+obj-$(CONFIG_SECURITY_SLIM)		+= slim/
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
diff -puN /dev/null security/slim/Kconfig
--- /dev/null
+++ a/security/slim/Kconfig
@@ -0,0 +1,36 @@
+config SECURITY_SLIM
+	boolean "SLIM support"
+	depends on SECURITY && SECURITY_NETWORK && INTEGRITY && !SECURITY_SELINUX
+	help
+	  The Simple Linux Integrity Module implements a modified low water-mark
+	  mandatory access control integrity model.
+
+config SECURITY_SLIM_BOOTPARAM
+	bool "SLIM boot parameter"
+	depends on SECURITY_SLIM
+	default n
+	help
+	  This option adds a kernel parameter 'slim', which allows SLIM
+	  to be disabled at boot.  If this option is selected, SLIM
+	  functionality can be disabled with slim=0 on the kernel
+	  command line.  The purpose of this option is to allow a single
+	  kernel image to be distributed with SLIM built in, but not
+	  necessarily enabled.
+
+	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_SLIM_BOOTPARAM_VALUE
+	int "SLIM boot parameter default value"
+	depends on SECURITY_SLIM_BOOTPARAM
+	range 0 1
+	default 1
+	help
+	  This option sets the default value for the kernel parameter
+	  'slim', which allows SLIM to be disabled at boot.  If this
+	  option is set to 0 (zero), the SLIM kernel parameter will
+	  default to 0, disabling SLIM at bootup.  If this option is
+	  set to 1 (one), the SLIM kernel parameter will default to 1,
+	  enabling SLIM at bootup.
+
+	  If you are unsure how to answer this question, answer 1.
+
diff -puN /dev/null security/slim/Makefile
--- /dev/null
+++ a/security/slim/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for building the SLIM module as part of the kernel tree.
+#
+
+obj-$(CONFIG_SECURITY_SLIM) += slim.o
+slim-y 	:= slm_main.o slm_secfs.o
diff -puN /dev/null security/slim/slim.h
--- /dev/null
+++ a/security/slim/slim.h
@@ -0,0 +1,89 @@
+/*
+ * slim.h - simple linux integrity module
+ *
+ * SLIM's specific model is:
+ *
+ *  All objects are labeled with extended attributes to indicate:
+ *      Integrity Access Class (IAC)
+ *      Secrecy Access Class (SAC)
+ *
+ *  All processes inherit from their parents:
+ *      Integrity Read Access Class (IRAC)
+ *      Integrity Write/Execute Access Class (IWXAC)
+ *      Secrecy Write Access Class (SWAC)
+ *      Secrecy Read/Execute Access Class (SRXAC)
+ *
+ *  SLIM enforces the following Mandatory Access Control Rules:
+ *      Read:
+ *          IRAC(process) <= IAC(object)
+ *          SRXAC(process) >= SAC(object)
+ *      Write:
+ *          IWXAC(process) >= IAC(object)
+ *          SWAC(process) <= SAC(process)
+ *      Execute:
+ *          IWXAC(process) <= IAC(object)
+ *          SRXAC(process) >= SAC(object)
+*/
+
+#include <linux/security.h>
+#include <linux/version.h>
+#include <linux/spinlock_types.h>
+
+struct xattr_data {
+	char *name;
+	void *value;
+	size_t len;
+};
+
+ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer,
+			 size_t size);
+ssize_t generic_listxattr(struct dentry *dentry, char *buffer,
+			  size_t buffer_size);
+int generic_setxattr(struct dentry *dentry, const char *name, const void *value,
+		     size_t size, int flags);
+enum slm_iac_level {		/* integrity access class */
+	SLM_IAC_ERROR = -2,
+	SLM_IAC_EXEMPT = -1,
+	SLM_IAC_NOTDEFINED = 0,
+	SLM_IAC_UNTRUSTED,
+	SLM_IAC_USER,
+	SLM_IAC_SYSTEM,
+	SLM_IAC_HIGHEST
+};
+extern char *slm_iac_str[];
+
+struct slm_tsec_data {		/* task security data (process info) */
+	enum slm_iac_level iac_r;	/* read low integrity files */
+	enum slm_iac_level iac_wx;	/* ability to write/execute higher */
+	int unlimited;		/* unlimited guard process */
+	struct dentry *script_dentry;	/* used when filename != interp */
+	spinlock_t lock;
+};
+
+struct slm_file_xattr {		/* file extended attributes */
+	enum slm_iac_level iac_level;	/* integrity */
+	struct slm_tsec_data guard;	/* guard process information */
+};
+
+#define SLM_LSM_ID 0x999
+extern int slm_idx;
+extern int slim_enabled;
+
+struct slm_isec_data {
+	struct slm_file_xattr level;
+	spinlock_t lock;
+};
+
+static inline int is_kernel_thread(struct task_struct *tsk)
+{
+	return (!tsk->mm) ? 1 : 0;
+}
+
+extern struct slm_xattr_config *slm_parse_config(char *data,
+						 unsigned long datalen,
+						 int *datasize);
+
+extern int slm_init_config(void);
+
+extern __init int slm_init_secfs(void);
+extern __exit void slm_cleanup_secfs(void);
_

Patches currently in -mm which might be from kjhall@us.ibm.com are

use-menuconfig-objects-ii-tpm.patch
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
