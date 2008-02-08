From: akpm@linux-foundation.org
Subject: - usb-net2280-cant-have-a-function-called-show_registers.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:15:02 -0800
Message-ID: <200802082014.m18KEhiN010479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbYBHU6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:58:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, dbrownell@users.sourceforge.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: net2280 can't have a function called show_registers()
has been removed from the -mm tree.  Its filename was
     usb-net2280-cant-have-a-function-called-show_registers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: net2280 can't have a function called show_registers()
From: David Howells <dhowells@redhat.com>

net2280 can't have a function called show_registers() because this can produce
a namespace clash with an arch function of the same name.

All this driver's functions and variables should really be prefixed with
"net2280_" to avoid such a problem in future.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/net2280.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/usb/gadget/net2280.c~usb-net2280-cant-have-a-function-called-show_registers drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c~usb-net2280-cant-have-a-function-called-show_registers
+++ a/drivers/usb/gadget/net2280.c
@@ -1418,8 +1418,8 @@ show_function (struct device *_dev, stru
 }
 static DEVICE_ATTR (function, S_IRUGO, show_function, NULL);
 
-static ssize_t
-show_registers (struct device *_dev, struct device_attribute *attr, char *buf)
+static ssize_t net2280_show_registers(struct device *_dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct net2280		*dev;
 	char			*next;
@@ -1571,7 +1571,7 @@ show_registers (struct device *_dev, str
 
 	return PAGE_SIZE - size;
 }
-static DEVICE_ATTR (registers, S_IRUGO, show_registers, NULL);
+static DEVICE_ATTR(registers, S_IRUGO, net2280_show_registers, NULL);
 
 static ssize_t
 show_queues (struct device *_dev, struct device_attribute *attr, char *buf)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
