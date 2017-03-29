From: akpm@linux-foundation.org
Subject: + kernel-reboot-add-devm_register_reboot_notifier.patch added to
 -mm tree
Date: Wed, 29 Mar 2017 16:19:01 -0700
Message-ID: <58dc40e5.x2WAf5XMEne8uHxy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdC2XTD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 19:19:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.smirnov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/reboot.c: add devm_register_reboot_notifier()
has been added to the -mm tree.  Its filename is
     kernel-reboot-add-devm_register_reboot_notifier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-reboot-add-devm_register_reboot_notifier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-reboot-add-devm_register_reboot_notifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: kernel/reboot.c: add devm_register_reboot_notifier()

Add devm_* wrapper around register_reboot_notifier to simplify device
specific reboot notifier registration/unregistration.

Link: http://lkml.kernel.org/r/20170320171753.1705-1-andrew.smirnov@gmail.com
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    3 +++
 kernel/reboot.c        |   27 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff -puN include/linux/reboot.h~kernel-reboot-add-devm_register_reboot_notifier include/linux/reboot.h
--- a/include/linux/reboot.h~kernel-reboot-add-devm_register_reboot_notifier
+++ a/include/linux/reboot.h
@@ -38,6 +38,9 @@ extern int reboot_force;
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
 
+struct device;
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

Patches currently in -mm which might be from andrew.smirnov@gmail.com are

kernel-reboot-add-devm_register_reboot_notifier.patch

