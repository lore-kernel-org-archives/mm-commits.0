From: akpm@linux-foundation.org
Subject: + add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch added to -mm tree
Date: Thu, 15 Mar 2007 19:00:16 -0800
Message-ID: <200703160300.l2G30G2e001075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50887 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXCPDAb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 23:00:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xyzzy@speakeasy.org, dwmw2@infradead.org, mchehab@infradead.org, rusty@rustcorp.com.au


The patch titled
     Add ability to keep track of callers of symbol_(get|put) (update)
has been added to the -mm tree.  Its filename is
     add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add ability to keep track of callers of symbol_(get|put) (update)
From: Trent Piepho <xyzzy@speakeasy.org>

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    2 
 kernel/module.c        |   99 +++++++++++++++++++++++++++------------
 2 files changed, 70 insertions(+), 31 deletions(-)

diff -puN include/linux/module.h~add-ability-to-keep-track-of-callers-of-symbol_getput-update include/linux/module.h
--- a/include/linux/module.h~add-ability-to-keep-track-of-callers-of-symbol_getput-update
+++ a/include/linux/module.h
@@ -171,7 +171,7 @@ struct notifier_block;
 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol, struct module *user);
 void *__symbol_get_gpl(const char *symbol);
-#define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX#x, \
+#define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX #x, \
 			THIS_MODULE)))
 
 #ifndef __GENKSYMS__
diff -puN kernel/module.c~add-ability-to-keep-track-of-callers-of-symbol_getput-update kernel/module.c
--- a/kernel/module.c~add-ability-to-keep-track-of-callers-of-symbol_getput-update
+++ a/kernel/module.c
@@ -717,8 +717,10 @@ struct module_use
 	int count;
 };
 
-/* Does a already use b?  Return NULL if it doesn't, a pointer to the
-   relevant module_use structure if it does. */
+/*
+ * Does a already use b?  Return NULL if it doesn't, a pointer to the
+ * relevant module_use structure if it does.
+ */
 static struct module_use *already_uses(struct module *a, struct module *b)
 {
 	struct module_use *use;
@@ -733,18 +735,31 @@ static struct module_use *already_uses(s
 	return NULL;
 }
 
-/* Module a uses b
-   If inc is set, then the use count will be incremented. */
+/*
+ * Module a uses b.  If module a is a _new_ user of module b, module b's ref
+ * count will be incremented.  If a is not a new user of b, and inc is true,
+ * then the use count (i.e.  how many times a uses b) will be incremented.  If a
+ * is NULL, then the ref count will just always be incremented.
+ */
 static int use_module(struct module *a, struct module *b, bool inc)
 {
 	struct module_use *use;
 	int no_warn;
 
-	if (b == NULL) return 1;
+	if (b == NULL)
+		return 1;
 
-	if ((use = already_uses(a, b))) {
-		if (inc) use->count++;
-		DEBUGP("%s: %s already used %s, count now at %d\n", __FUNCTION__, a->name, b->name, use->count);
+	DEBUGP("%s: %s uses %s\n", __FUNCTION__, a?a->name:"(unknown)",
+	       b->name);
+	if (a == NULL)
+		return strong_try_module_get(b);
+
+	use = already_uses(a, b);
+	if (use) {
+		if (inc)
+			use->count++;
+		DEBUGP("%s: %s already used %s, count now at %d\n",
+		       __FUNCTION__, a->name, b->name, use->count);
 		return 1;
 	}
 
@@ -766,21 +781,39 @@ static int use_module(struct module *a, 
 	return 1;
 }
 
-/* Module a is "un-using" module b.  The use count is decremented, and if
-   it reaches zero the module_use is removed.  Returns number of
-   remaining uses. */
+/*
+ * Module a is "un-using" module b.  The use count is decremented, and if
+ * it reaches zero the module_use is removed and module b's ref-count is
+ * decremented.  Returns number of remaining uses.  If a is NULL, then
+ * just decrement b's ref count.
+ */
 static int unuse_module(struct module *a, struct module *b)
 {
-	struct module_use *use = already_uses(a, b);
-	DEBUGP("%s: unuse %s by %s\n", __FUNCTION__, b->name, a->name);
+	struct module_use *use;
 
-	BUG_ON(!use);
-	DEBUGP("%s: %s used %s %d time(s)\n", __FUNCTION__, a->name, b->name, use->count);
-	if (! --(use->count)) {
-		DEBUGP("%s: removing module_use structure and sysfs link\n", __FUNCTION__);
+	DEBUGP("%s: unuse %s by %s\n", __FUNCTION__, b->name,
+	       a?a->name:"(unknown)");
+	if (!a) {
+		module_put(b);
+		return 0;
+	}
+
+	use = already_uses(a, b);
+	if (!use) {
+	    printk(KERN_ERR "module %s trying to un-use a module, %s, which "
+	           "it is not using", a->name, b->name);
+            BUG();
+	}
+
+	DEBUGP("%s: %s used %s %d time(s)\n", __FUNCTION__,
+	       a->name, b->name, use->count);
+	if (!--(use->count)) {
+		DEBUGP("%s: removing module_use structure and sysfs link\n",
+		       __FUNCTION__);
 		list_del(&use->list);
 		kfree(use);
 		sysfs_remove_link(b->holders_dir, a->name);
+		module_put(b);
 		return 0;
 	}
 	return use->count;
@@ -797,9 +830,14 @@ static void module_unload_free(struct mo
 		list_for_each_entry(use, &i->modules_which_use_me, list) {
 			if (use->module_which_uses == mod) {
 				DEBUGP("%s unusing %s\n", mod->name, i->name);
-				if (unuse_module(mod, i))
-					printk(KERN_ERR "%s unloading but still has uses of %s\n", mod->name, i->name);
-				module_put(i);
+				if (unuse_module(mod, i)) {
+					/* Someone messed up! */
+					printk(KERN_ERR "module %s unloading "
+					       "but still has uses of %s\n",
+					       mod->name, i->name);
+					while (unuse_module(mod, i))
+						;
+				}
 				/* There can be at most one match. */
 				break;
 			}
@@ -988,15 +1026,14 @@ void __symbol_put(const char *symbol, st
 	unsigned long flags;
 	const unsigned long *crc;
 
-	DEBUGP("%s: putting %s by %s\n", __FUNCTION__, symbol, user?user->name:"(unknown)");
+	DEBUGP("%s: putting symbol %s by %s\n", __FUNCTION__, symbol,
+	       user?user->name:"(unknown)");
 	spin_lock_irqsave(&modlist_lock, flags);
 	if (!__find_symbol(symbol, &owner, &crc, 1))
 		BUG();
 
-	/* If the symbol is owned by a module, put it if no user was
-	   specified or if this is the last of user's uses of the module. */
-	if (owner && (!user || !unuse_module(user, owner)))
-		module_put(owner);
+	if (owner)
+		unuse_module(user, owner);
 	spin_unlock_irqrestore(&modlist_lock, flags);
 }
 EXPORT_SYMBOL(__symbol_put);
@@ -1006,15 +1043,15 @@ void __symbol_put_addr(void *addr, struc
 	struct module *modaddr;
 	unsigned long flags;
 
-	DEBUGP("%s: putting %p by %s\n", __FUNCTION__, addr, user?user->name:"(unknown)");
+	DEBUGP("%s: putting %p by %s\n", __FUNCTION__, addr,
+	       user?user->name:"(unknown)");
 	if (core_kernel_text((unsigned long)addr))
 		return;
 
 	if (!(modaddr = module_text_address((unsigned long)addr)))
 		BUG();
 	spin_lock_irqsave(&modlist_lock, flags);
-	if (!user || !unuse_module(user, modaddr))
-		module_put(modaddr);
+	unuse_module(user, modaddr);
 	spin_unlock_irqrestore(&modlist_lock, flags);
 }
 EXPORT_SYMBOL_GPL(__symbol_put_addr);
@@ -1466,10 +1503,12 @@ void *__symbol_get(const char *symbol, s
 	unsigned long value, flags;
 	const unsigned long *crc;
 
-	DEBUGP("%s: get symbol %s by %s\n", __FUNCTION__, symbol, user?user->name:"(unknown)");
+	DEBUGP("%s: get symbol %s by %s\n", __FUNCTION__, symbol,
+	       user?user->name:"(unknown)");
 	spin_lock_irqsave(&modlist_lock, flags);
 	value = __find_symbol(symbol, &owner, &crc, 1);
-	DEBUGP("%s: symbol %s is 0WN3D by %s\n", __FUNCTION__, symbol, owner?owner->name:"yer mom");
+	DEBUGP("%s: symbol %s is 0WN3D by %s\n", __FUNCTION__, symbol,
+	       value?(owner?owner->name:"yer mom"):"no one");
 	if (value && owner && !use_module(user, owner, true))
 		value = 0;
 	spin_unlock_irqrestore(&modlist_lock, flags);
_

Patches currently in -mm which might be from xyzzy@speakeasy.org are

git-dvb.patch
fix-constant-folding-and-poor-optimization-in-byte-swapping.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
