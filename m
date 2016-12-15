From: akpm@linux-foundation.org
Subject: [merged] idr-add-ida_is_empty.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:49:12 -0800
Message-ID: <5852e5a8.dWlWmed5+v52lcei%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754155AbcLOStN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:49:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, balbi@kernel.org, gregkh@linuxfoundation.org, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, mina86@mina86.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: add ida_is_empty
has been removed from the -mm tree.  Its filename was
     idr-add-ida_is_empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: idr: add ida_is_empty

Two of the USB Gadgets were poking around in the internals of struct ida
in order to determine if it is empty.  Add the appropriate abstraction.

Link: http://lkml.kernel.org/r/1480369871-5271-63-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/function/f_hid.c     |    6 +++---
 drivers/usb/gadget/function/f_printer.c |    6 +++---
 include/linux/idr.h                     |    5 +++++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/usb/gadget/function/f_hid.c~idr-add-ida_is_empty drivers/usb/gadget/function/f_hid.c
--- a/drivers/usb/gadget/function/f_hid.c~idr-add-ida_is_empty
+++ a/drivers/usb/gadget/function/f_hid.c
@@ -905,7 +905,7 @@ static void hidg_free_inst(struct usb_fu
 	mutex_lock(&hidg_ida_lock);
 
 	hidg_put_minor(opts->minor);
-	if (idr_is_empty(&hidg_ida.idr))
+	if (ida_is_empty(&hidg_ida))
 		ghid_cleanup();
 
 	mutex_unlock(&hidg_ida_lock);
@@ -931,7 +931,7 @@ static struct usb_function_instance *hid
 
 	mutex_lock(&hidg_ida_lock);
 
-	if (idr_is_empty(&hidg_ida.idr)) {
+	if (ida_is_empty(&hidg_ida)) {
 		status = ghid_setup(NULL, HIDG_MINORS);
 		if (status)  {
 			ret = ERR_PTR(status);
@@ -944,7 +944,7 @@ static struct usb_function_instance *hid
 	if (opts->minor < 0) {
 		ret = ERR_PTR(opts->minor);
 		kfree(opts);
-		if (idr_is_empty(&hidg_ida.idr))
+		if (ida_is_empty(&hidg_ida))
 			ghid_cleanup();
 		goto unlock;
 	}
diff -puN drivers/usb/gadget/function/f_printer.c~idr-add-ida_is_empty drivers/usb/gadget/function/f_printer.c
--- a/drivers/usb/gadget/function/f_printer.c~idr-add-ida_is_empty
+++ a/drivers/usb/gadget/function/f_printer.c
@@ -1265,7 +1265,7 @@ static void gprinter_free_inst(struct us
 	mutex_lock(&printer_ida_lock);
 
 	gprinter_put_minor(opts->minor);
-	if (idr_is_empty(&printer_ida.idr))
+	if (ida_is_empty(&printer_ida))
 		gprinter_cleanup();
 
 	mutex_unlock(&printer_ida_lock);
@@ -1289,7 +1289,7 @@ static struct usb_function_instance *gpr
 
 	mutex_lock(&printer_ida_lock);
 
-	if (idr_is_empty(&printer_ida.idr)) {
+	if (ida_is_empty(&printer_ida)) {
 		status = gprinter_setup(PRINTER_MINORS);
 		if (status) {
 			ret = ERR_PTR(status);
@@ -1302,7 +1302,7 @@ static struct usb_function_instance *gpr
 	if (opts->minor < 0) {
 		ret = ERR_PTR(opts->minor);
 		kfree(opts);
-		if (idr_is_empty(&printer_ida.idr))
+		if (ida_is_empty(&printer_ida))
 			gprinter_cleanup();
 		goto unlock;
 	}
diff -puN include/linux/idr.h~idr-add-ida_is_empty include/linux/idr.h
--- a/include/linux/idr.h~idr-add-ida_is_empty
+++ a/include/linux/idr.h
@@ -195,6 +195,11 @@ static inline int ida_get_new(struct ida
 	return ida_get_new_above(ida, 0, p_id);
 }
 
+static inline bool ida_is_empty(struct ida *ida)
+{
+	return idr_is_empty(&ida->idr);
+}
+
 void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
_

Patches currently in -mm which might be from willy@linux.intel.com are

reimplement-idr-and-ida-using-the-radix-tree.patch

