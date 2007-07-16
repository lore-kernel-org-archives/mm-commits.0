From: akpm@linux-foundation.org
Subject: - w1_ds2760-fix-binary-file-read-callback-signature.patch removed from -mm tree
Date: Mon, 16 Jul 2007 09:09:13 -0700
Message-ID: <200707161609.l6GG9ENQ017053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932175AbXGPQKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 12:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnpol@2ka.mipt.ru, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     w1_ds2760: fix binary file read callback signature
has been removed from the -mm tree.  Its filename was
     w1_ds2760-fix-binary-file-read-callback-signature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: w1_ds2760: fix binary file read callback signature
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Commit 91a6902958f052358899f58683d44e36228d85c2 changed the binary
sysfs file signatures at the same time the w1_ds2760 driver was added.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2760.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/w1/slaves/w1_ds2760.c~w1_ds2760-fix-binary-file-read-callback-signature drivers/w1/slaves/w1_ds2760.c
--- a/drivers/w1/slaves/w1_ds2760.c~w1_ds2760-fix-binary-file-read-callback-signature
+++ a/drivers/w1/slaves/w1_ds2760.c
@@ -68,8 +68,9 @@ int w1_ds2760_write(struct device *dev, 
 	return w1_ds2760_io(dev, buf, addr, count, 1);
 }
 
-static ssize_t w1_ds2760_read_bin(struct kobject *kobj, char *buf, loff_t off,
-				  size_t count)
+static ssize_t w1_ds2760_read_bin(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	return w1_ds2760_read(dev, buf, off, count);
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

origin.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-w1.patch
w1_ds2760-fix-binary-file-read-callback-signature.patch
