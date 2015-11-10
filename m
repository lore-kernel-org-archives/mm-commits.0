From: akpm@linux-foundation.org
Subject: + iio-core-introduce-iio-configfs-support.patch added to -mm tree
Date: Tue, 10 Nov 2015 13:09:59 -0800
Message-ID: <56425d27.EdXdwrKeHxlP4YRi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbKJVKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 16:10:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.baluta@intel.com, adriana.reus@intel.com, cristina.opriceana@gmail.com, hch@lst.de, jlbec@evilplan.org, knaack.h@gmx.de, lars@metafoo.de, octavian.purdila@intel.com, pebolle@tiscali.nl, pmeerw@pmeerw.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: iio: core: introduce IIO configfs support
has been added to the -mm tree.  Its filename is
     iio-core-introduce-iio-configfs-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iio-core-introduce-iio-configfs-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iio-core-introduce-iio-configfs-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Baluta <daniel.baluta@intel.com>
Subject: iio: core: introduce IIO configfs support

This patch creates the IIO configfs root group.  The group will appear
under <mount-point>/iio/, usually /config/iio.

We introduce configfs support in IIO in order to be able to easily create
IIO objects from userspace.  The first supported IIO objects are triggers
introduced with next patches.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Adriana Reus <adriana.reus@intel.com>
Cc: Cristina Opriceana <cristina.opriceana@gmail.com>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/Kconfig                 |    8 ++++
 drivers/iio/Makefile                |    1 
 drivers/iio/industrialio-configfs.c |   50 ++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff -puN drivers/iio/Kconfig~iio-core-introduce-iio-configfs-support drivers/iio/Kconfig
--- a/drivers/iio/Kconfig~iio-core-introduce-iio-configfs-support
+++ a/drivers/iio/Kconfig
@@ -22,6 +22,14 @@ if IIO_BUFFER
 	source "drivers/iio/buffer/Kconfig"
 endif # IIO_BUFFER
 
+config IIO_CONFIGFS
+	tristate "Enable IIO configuration via configfs"
+	select CONFIGFS_FS
+	help
+	  This allows configuring various IIO bits through configfs
+	  (e.g. software triggers). For more info see
+	  Documentation/iio/iio_configfs.txt.
+
 config IIO_TRIGGER
 	bool "Enable triggered sampling support"
 	help
diff -puN drivers/iio/Makefile~iio-core-introduce-iio-configfs-support drivers/iio/Makefile
--- a/drivers/iio/Makefile~iio-core-introduce-iio-configfs-support
+++ a/drivers/iio/Makefile
@@ -7,6 +7,7 @@ industrialio-y := industrialio-core.o in
 industrialio-$(CONFIG_IIO_BUFFER) += industrialio-buffer.o
 industrialio-$(CONFIG_IIO_TRIGGER) += industrialio-trigger.o
 
+obj-$(CONFIG_IIO_CONFIGFS) += industrialio-configfs.o
 obj-$(CONFIG_IIO_TRIGGERED_EVENT) += industrialio-triggered-event.o
 
 obj-y += accel/
diff -puN /dev/null drivers/iio/industrialio-configfs.c
--- /dev/null
+++ a/drivers/iio/industrialio-configfs.c
@@ -0,0 +1,50 @@
+/*
+ * Industrial I/O configfs bits
+ *
+ * Copyright (c) 2015 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/configfs.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kmod.h>
+#include <linux/slab.h>
+
+#include <linux/iio/iio.h>
+
+static struct config_item_type iio_root_group_type = {
+	.ct_owner       = THIS_MODULE,
+};
+
+struct configfs_subsystem iio_configfs_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = "iio",
+			.ci_type = &iio_root_group_type,
+		},
+	},
+	.su_mutex = __MUTEX_INITIALIZER(iio_configfs_subsys.su_mutex),
+};
+EXPORT_SYMBOL(iio_configfs_subsys);
+
+static int __init iio_configfs_init(void)
+{
+	config_group_init(&iio_configfs_subsys.su_group);
+
+	return configfs_register_subsystem(&iio_configfs_subsys);
+}
+module_init(iio_configfs_init);
+
+static void __exit iio_configfs_exit(void)
+{
+	configfs_unregister_subsystem(&iio_configfs_subsys);
+}
+module_exit(iio_configfs_exit);
+
+MODULE_AUTHOR("Daniel Baluta <daniel.baluta@intel.com>");
+MODULE_DESCRIPTION("Industrial I/O configfs support");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from daniel.baluta@intel.com are

configfs-allow-dynamic-group-creation.patch
iio-core-introduce-iio-configfs-support.patch
iio-core-introduce-iio-software-triggers.patch
iio-trigger-introduce-iio-hrtimer-based-trigger.patch
iio-documentation-add-iio-configfs-documentation.patch

