From: akpm@linux-foundation.org
Subject: - vt-add-comment-for-unbind_con_driver.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:08 -0700
Message-ID: <200707172307.l6HN78SC012152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764673AbXGQXPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbarnes@virtuousgeek.org, adaplas@gmail.com, jesse.barnes@intel.com, mm-commits@vger.kernel.org


The patch titled
     vt: add comment for unbind_con_driver()
has been removed from the -mm tree.  Its filename was
     vt-add-comment-for-unbind_con_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vt: add comment for unbind_con_driver()
From: Jesse Barnes <jbarnes@virtuousgeek.org>

- add comment for unbind_con_driver().
- bind_con_driver() is made private again

Signed-off-by: Jesse Barnes <jesse.barnes@intel.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c       |   21 +++++++++++++++++++--
 include/linux/vt_kern.h |    2 --
 2 files changed, 19 insertions(+), 4 deletions(-)

diff -puN drivers/char/vt.c~vt-add-comment-for-unbind_con_driver drivers/char/vt.c
--- a/drivers/char/vt.c~vt-add-comment-for-unbind_con_driver
+++ a/drivers/char/vt.c
@@ -2869,7 +2869,8 @@ int __init vty_init(void)
 
 static struct class *vtconsole_class;
 
-int bind_con_driver(const struct consw *csw, int first, int last, int deflt)
+static int bind_con_driver(const struct consw *csw, int first, int last,
+			   int deflt)
 {
 	struct module *owner = csw->owner;
 	const char *desc = NULL;
@@ -2968,7 +2969,6 @@ err:
 	module_put(owner);
 	return retval;
 };
-EXPORT_SYMBOL(bind_con_driver);
 
 #ifdef CONFIG_VT_HW_CONSOLE_BINDING
 static int con_is_graphics(const struct consw *csw, int first, int last)
@@ -2987,6 +2987,23 @@ static int con_is_graphics(const struct 
 	return retval;
 }
 
+/**
+ * unbind_con_driver - unbind a console driver
+ * @csw: pointer to console driver to unregister
+ * @first: first in range of consoles that @csw should be unbound from
+ * @last: last in range of consoles that @csw should be unbound from
+ * @deflt: should next bound console driver be default after @csw is unbound?
+ *
+ * To unbind a driver from all possible consoles, pass 0 as @first and
+ * %MAX_NR_CONSOLES as @last.
+ *
+ * @deflt controls whether the console that ends up replacing @csw should be
+ * the default console.
+ *
+ * RETURNS:
+ * -ENODEV if @csw isn't a registered console driver or can't be unregistered
+ * or 0 on success.
+ */
 int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 {
 	struct module *owner = csw->owner;
diff -puN include/linux/vt_kern.h~vt-add-comment-for-unbind_con_driver include/linux/vt_kern.h
--- a/include/linux/vt_kern.h~vt-add-comment-for-unbind_con_driver
+++ a/include/linux/vt_kern.h
@@ -75,8 +75,6 @@ int con_copy_unimap(struct vc_data *dst_
 int vt_waitactive(int vt);
 void change_console(struct vc_data *new_vc);
 void reset_vc(struct vc_data *vc);
-extern int bind_con_driver(const struct consw *csw, int first, int last,
-			   int deflt);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
 
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

origin.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
