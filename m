From: akpm@osdl.org
Subject: - fix2-gregkh-driver-modules-state.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:23:25 -0800
Message-ID: <200612062223.kB6MNPPK018530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48202 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937693AbWLFWXe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:23:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, greg@kroah.com, m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     fix gregkh-driver-modules-state
has been removed from the -mm tree.  Its filename was
     fix2-gregkh-driver-modules-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix gregkh-driver-modules-state
From: Kay Sievers <kay.sievers@vrfy.org>

When CONFIG_MODULE_UNLOAD is not set then this happens:

  CC      kernel/module.o
kernel/module.c:852: error: `initstate' undeclared here (not in a function)
kernel/module.c:852: error: initializer element is not constant
kernel/module.c:852: error: (near initialization for `modinfo_attrs[2]')
make[1]: *** [kernel/module.o] Error 1
make: *** [kernel] Error 2

Reference to 'initstate' should stay under #ifdef CONFIG_MODULE_UNLOAD
as its definition I guess.

Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/module.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN kernel/module.c~fix2-gregkh-driver-modules-state kernel/module.c
--- a/kernel/module.c~fix2-gregkh-driver-modules-state
+++ a/kernel/module.c
@@ -790,6 +790,27 @@ static struct module_attribute refcnt = 
 	.show = show_refcnt,
 };
 
+#else /* !CONFIG_MODULE_UNLOAD */
+static void print_unload_info(struct seq_file *m, struct module *mod)
+{
+	/* We don't know the usage count, or what modules are using. */
+	seq_printf(m, " - -");
+}
+
+static inline void module_unload_free(struct module *mod)
+{
+}
+
+static inline int use_module(struct module *a, struct module *b)
+{
+	return strong_try_module_get(b);
+}
+
+static inline void module_unload_init(struct module *mod)
+{
+}
+#endif /* CONFIG_MODULE_UNLOAD */
+
 static ssize_t show_initstate(struct module_attribute *mattr,
 			   struct module *mod, char *buffer)
 {
@@ -814,27 +835,6 @@ static struct module_attribute initstate
 	.show = show_initstate,
 };
 
-#else /* !CONFIG_MODULE_UNLOAD */
-static void print_unload_info(struct seq_file *m, struct module *mod)
-{
-	/* We don't know the usage count, or what modules are using. */
-	seq_printf(m, " - -");
-}
-
-static inline void module_unload_free(struct module *mod)
-{
-}
-
-static inline int use_module(struct module *a, struct module *b)
-{
-	return strong_try_module_get(b);
-}
-
-static inline void module_unload_init(struct module *mod)
-{
-}
-#endif /* CONFIG_MODULE_UNLOAD */
-
 static struct module_attribute *modinfo_attrs[] = {
 	&modinfo_version,
 	&modinfo_srcversion,
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch

