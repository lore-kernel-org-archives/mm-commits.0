From: akpm@linux-foundation.org
Subject: [patch 80/94] kernel/reboot.c: add
 devm_register_reboot_notifier()
Date: Fri, 17 Nov 2017 15:30:57 -0800
Message-ID: <20171117233057.dUFrqTfjG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966959AbdKQXa7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:30:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrew.smirnov@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: kernel/reboot.c: add devm_register_reboot_notifier()

Add devm_* wrapper around register_reboot_notifier to simplify device
specific reboot notifier registration/unregistration.

[akpm@linux-foundation.org: move `struct device' forward decl to top-of-file]
Link: http://lkml.kernel.org/r/20170320171753.1705-1-andrew.smirnov@gmail.com
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    4 ++++
 kernel/reboot.c        |   27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN include/linux/reboot.h~kernel-reboot-add-devm_register_reboot_notifier include/linux/reboot.h
--- a/include/linux/reboot.h~kernel-reboot-add-devm_register_reboot_notifier
+++ a/include/linux/reboot.h
@@ -6,6 +6,8 @@
 #include <linux/notifier.h>
 #include <uapi/linux/reboot.h>
 
+struct device;
+
 #define SYS_DOWN	0x0001	/* Notify of system down */
 #define SYS_RESTART	SYS_DOWN
 #define SYS_HALT	0x0002	/* Notify of system halt */
@@ -39,6 +41,8 @@ extern int reboot_force;
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
 
+extern int devm_register_reboot_notifier(struct device *, struct notifier_block *);
+
 extern int register_restart_handler(struct notifier_block *);
 extern int unregister_restart_handler(struct notifier_block *);
 extern void do_kernel_restart(char *cmd);
diff -puN kernel/reboot.c~kernel-reboot-add-devm_register_reboot_notifier kernel/reboot.c
--- a/kernel/reboot.c~kernel-reboot-add-devm_register_reboot_notifier
+++ a/kernel/reboot.c
@@ -104,6 +104,33 @@ int unregister_reboot_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+static void devm_unregister_reboot_notifier(struct device *dev, void *res)
+{
+	WARN_ON(unregister_reboot_notifier(*(struct notifier_block **)res));
+}
+
+int devm_register_reboot_notifier(struct device *dev, struct notifier_block *nb)
+{
+	struct notifier_block **rcnb;
+	int ret;
+
+	rcnb = devres_alloc(devm_unregister_reboot_notifier,
+			    sizeof(*rcnb), GFP_KERNEL);
+	if (!rcnb)
+		return -ENOMEM;
+
+	ret = register_reboot_notifier(nb);
+	if (!ret) {
+		*rcnb = nb;
+		devres_add(dev, rcnb);
+	} else {
+		devres_free(rcnb);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(devm_register_reboot_notifier);
+
 /*
  *	Notifier list for kernel code which wants to be called
  *	to restart the system.
_
