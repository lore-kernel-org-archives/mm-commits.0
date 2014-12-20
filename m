From: akpm@linux-foundation.org
Subject: + drivers-char-mem-make-dev-mem-an-optional-device.patch added to -mm tree
Date: Fri, 19 Dec 2014 16:24:39 -0800
Message-ID: <5494c1c7.ZFwa4Sw4m9yov7kf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaLTAYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 19:24:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.ward114@googlemail.com, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/char/mem.c: make /dev/mem an optional device
has been added to the -mm tree.  Its filename is
     drivers-char-mem-make-dev-mem-an-optional-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-char-mem-make-dev-mem-an-optional-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-char-mem-make-dev-mem-an-optional-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Ward <robert.ward114@googlemail.com>
Subject: drivers/char/mem.c: make /dev/mem an optional device

Make the /dev/mem device optional using the CONFIG_DEVMEM option.

This brings /dev/mem in line with /dev/kmem so it can de disabled. 
Disabling /dev/mem is preferable on devices that do not require direct
access to memory in order to improve security.  This is especially true on
platforms where no restiction is placed on the areas of memory that can be
accessed(for example mips) without custom modifcations to the kernel
source.

The implementation of this functionality declares the mem_fops structure
as __maybe_unused to eliminate the need for #ifdefs throughout the file.

Follow up changes are present to change CONFIG_DEVKMEM and CONFIG_DEVPORT
to use __maybe_unused.  This simplifies the code and make the
implementations consistent.


This patch (of 3):

Adds Kconfig option CONFIG_DEVMEM that allows the /dev/mem device to be
disabled.

Option defaults to /dev/mem enabled.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    9 +++++++++
 drivers/char/mem.c   |    4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~drivers-char-mem-make-dev-mem-an-optional-device drivers/char/Kconfig
--- a/drivers/char/Kconfig~drivers-char-mem-make-dev-mem-an-optional-device
+++ a/drivers/char/Kconfig
@@ -6,6 +6,15 @@ menu "Character devices"
 
 source "drivers/tty/Kconfig"
 
+config DEVMEM
+	bool "/dev/mem virtual device support"
+	default y
+	help
+	  Say Y here if you want to support the /dev/mem device.
+	  The /dev/mem device is used to access areas of physical
+	  memory.
+	  When in doubt, say "Y".
+
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
 	default y
diff -puN drivers/char/mem.c~drivers-char-mem-make-dev-mem-an-optional-device drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-mem-make-dev-mem-an-optional-device
+++ a/drivers/char/mem.c
@@ -715,7 +715,7 @@ static int open_port(struct inode *inode
 #define open_mem	open_port
 #define open_kmem	open_mem
 
-static const struct file_operations mem_fops = {
+static const struct file_operations __maybe_unused mem_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_mem,
 	.write		= write_mem,
@@ -785,7 +785,9 @@ static const struct memdev {
 	const struct file_operations *fops;
 	struct backing_dev_info *dev_info;
 } devlist[] = {
+#ifdef CONFIG_DEVMEM
 	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
+#endif
 #ifdef CONFIG_DEVKMEM
 	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
 #endif
_

Patches currently in -mm which might be from robert.ward114@googlemail.com are

origin.patch
drivers-char-mem-make-dev-mem-an-optional-device.patch
drivers-char-mem-simplify-devkmem-configuration.patch
drivers-char-mem-simplify-devport-configuration.patch

