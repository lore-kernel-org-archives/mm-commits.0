From: akpm@linux-foundation.org
Subject: + add-ability-to-keep-track-of-callers-of-symbol_getput.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:09:47 -0800
Message-ID: <200703110809.l2B89mSQ007528@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39471 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbXCKIKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:10:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xyzzy@speakeasy.org, dwmw2@infradead.org, mchehab@infradead.org, rusty@rustcorp.com.au


The patch titled
     Add ability to keep track of callers of symbol_(get|put)
has been added to the -mm tree.  Its filename is
     add-ability-to-keep-track-of-callers-of-symbol_getput.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add ability to keep track of callers of symbol_(get|put)
From: Trent Piepho <xyzzy@speakeasy.org>

When a module uses symbol_get() to increase the ref count of another module,
there is no record what module called symbol_get().  A module can show up as
having other users, but there is no way to tell who those users are.

This adds that ability to symbol_put() and symbol_get().

__symbol_get() and __symbol_put() get another parameter, which specifies the
module that is doing the getting or putting.  symbol_put_addr() is renamed to
__symbol_put_addr() and has the same parameter added.  The module can be NULL,
in which case the symbol's owner's refcount is incremented without recording
who did it, as was the case before.

The macros symbol_get(), symbol_put(), and symbol_put_addr() will use
THIS_MODULE as the getter/putter and so don't have an extra parameter.  A
macro symbol_put_user() is added that allows specifying the putting module.

The module_use structure that keeps track of one modules use of another gains
a count member.  The module_use will not go away until the count goes down to
zero.  The count wasn't necessary before because a module could only use
another module once, when the module is linked in, and un-use that module
once, when it is unloaded.

When a module calls symbol_get() to get a symbol from module that owns the
symbol, the ref count of the owning module is _not_ incremented if the getting
module was already listed as using the owning module.  Rather, the count of
that module_use is incremented.

When a module is loaded and the kernel module linker is resolving symbols, it
will not increment the module_use count for each symbol used, but will just
leave it at one.  We don't count each symbol resolved, because during module
unloading we wouldn't know how many times to decrement the module_use count.

When the module is unloaded, the module_use count will only be decremented by
one, which should bring it to zero.  If it's not zero, then the remaining
count is the number of symbol_get()s the module did that were unmatched with a
symbol_put().

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |   13 +++---
 kernel/module.c        |   79 +++++++++++++++++++++++++++++----------
 2 files changed, 68 insertions(+), 24 deletions(-)

diff -puN include/linux/module.h~add-ability-to-keep-track-of-callers-of-symbol_getput include/linux/module.h
--- a/include/linux/module.h~add-ability-to-keep-track-of-callers-of-symbol_getput
+++ a/include/linux/module.h
@@ -167,9 +167,10 @@ struct notifier_block;
 #ifdef CONFIG_MODULES
 
 /* Get/put a kernel symbol (calls must be symmetric) */
-void *__symbol_get(const char *symbol);
+void *__symbol_get(const char *symbol, struct module *user);
 void *__symbol_get_gpl(const char *symbol);
-#define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX #x)))
+#define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX#x, \
+			THIS_MODULE)))
 
 #ifndef __GENKSYMS__
 #ifdef CONFIG_MODVERSIONS
@@ -389,9 +390,11 @@ extern void __module_put_and_exit(struct
 
 #ifdef CONFIG_MODULE_UNLOAD
 unsigned int module_refcount(struct module *mod);
-void __symbol_put(const char *symbol);
-#define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x)
-void symbol_put_addr(void *addr);
+void __symbol_put(const char *symbol, struct module *user);
+#define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x, THIS_MODULE)
+#define symbol_put_user(x,u) __symbol_put(MODULE_SYMBOL_PREFIX #x, (u))
+void __symbol_put_addr(void *addr, struct module *user);
+#define symbol_put_addr(x) __symbol_put_addr((x), THIS_MODULE)
 
 /* Sometimes we know we already have a refcount, and it's easier not
    to handle the error case (which only happens with rmmod --wait). */
diff -puN kernel/module.c~add-ability-to-keep-track-of-callers-of-symbol_getput kernel/module.c
--- a/kernel/module.c~add-ability-to-keep-track-of-callers-of-symbol_getput
+++ a/kernel/module.c
@@ -714,30 +714,39 @@ struct module_use
 {
 	struct list_head list;
 	struct module *module_which_uses;
+	int count;
 };
 
-/* Does a already use b? */
-static int already_uses(struct module *a, struct module *b)
+/* Does a already use b?  Return NULL if it doesn't, a pointer to the
+   relevant module_use structure if it does. */
+static struct module_use *already_uses(struct module *a, struct module *b)
 {
 	struct module_use *use;
 
 	list_for_each_entry(use, &b->modules_which_use_me, list) {
 		if (use->module_which_uses == a) {
 			DEBUGP("%s uses %s!\n", a->name, b->name);
-			return 1;
+			return use;
 		}
 	}
 	DEBUGP("%s does not use %s!\n", a->name, b->name);
-	return 0;
+	return NULL;
 }
 
-/* Module a uses b */
-static int use_module(struct module *a, struct module *b)
+/* Module a uses b
+   If inc is set, then the use count will be incremented. */
+static int use_module(struct module *a, struct module *b, bool inc)
 {
 	struct module_use *use;
 	int no_warn;
 
-	if (b == NULL || already_uses(a, b)) return 1;
+	if (b == NULL) return 1;
+
+	if ((use = already_uses(a, b))) {
+		if (inc) use->count++;
+		DEBUGP("%s: %s already used %s, count now at %d\n", __FUNCTION__, a->name, b->name, use->count);
+		return 1;
+	}
 
 	if (!strong_try_module_get(b))
 		return 0;
@@ -751,11 +760,32 @@ static int use_module(struct module *a, 
 	}
 
 	use->module_which_uses = a;
+	use->count = 1;
 	list_add(&use->list, &b->modules_which_use_me);
 	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
 	return 1;
 }
 
+/* Module a is "un-using" module b.  The use count is decremented, and if
+   it reaches zero the module_use is removed.  Returns number of
+   remaining uses. */
+static int unuse_module(struct module *a, struct module *b)
+{
+	struct module_use *use = already_uses(a, b);
+	DEBUGP("%s: unuse %s by %s\n", __FUNCTION__, b->name, a->name);
+
+	BUG_ON(!use);
+	DEBUGP("%s: %s used %s %d time(s)\n", __FUNCTION__, a->name, b->name, use->count);
+	if (! --(use->count)) {
+		DEBUGP("%s: removing module_use structure and sysfs link\n", __FUNCTION__);
+		list_del(&use->list);
+		kfree(use);
+		sysfs_remove_link(b->holders_dir, a->name);
+		return 0;
+	}
+	return use->count;
+}
+
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
 {
@@ -767,10 +797,9 @@ static void module_unload_free(struct mo
 		list_for_each_entry(use, &i->modules_which_use_me, list) {
 			if (use->module_which_uses == mod) {
 				DEBUGP("%s unusing %s\n", mod->name, i->name);
+				if (unuse_module(mod, i))
+					printk(KERN_ERR "%s unloading but still has uses of %s\n", mod->name, i->name);
 				module_put(i);
-				list_del(&use->list);
-				kfree(use);
-				sysfs_remove_link(i->holders_dir, mod->name);
 				/* There can be at most one match. */
 				break;
 			}
@@ -953,32 +982,42 @@ static void print_unload_info(struct seq
 		seq_printf(m, "-");
 }
 
-void __symbol_put(const char *symbol)
+void __symbol_put(const char *symbol, struct module *user)
 {
 	struct module *owner;
 	unsigned long flags;
 	const unsigned long *crc;
 
+	DEBUGP("%s: putting %s by %s\n", __FUNCTION__, symbol, user?user->name:"(unknown)");
 	spin_lock_irqsave(&modlist_lock, flags);
 	if (!__find_symbol(symbol, &owner, &crc, 1))
 		BUG();
-	module_put(owner);
+
+	/* If the symbol is owned by a module, put it if no user was
+	   specified or if this is the last of user's uses of the module. */
+	if (owner && (!user || !unuse_module(user, owner)))
+		module_put(owner);
 	spin_unlock_irqrestore(&modlist_lock, flags);
 }
 EXPORT_SYMBOL(__symbol_put);
 
-void symbol_put_addr(void *addr)
+void __symbol_put_addr(void *addr, struct module *user)
 {
 	struct module *modaddr;
+	unsigned long flags;
 
+	DEBUGP("%s: putting %p by %s\n", __FUNCTION__, addr, user?user->name:"(unknown)");
 	if (core_kernel_text((unsigned long)addr))
 		return;
 
 	if (!(modaddr = module_text_address((unsigned long)addr)))
 		BUG();
-	module_put(modaddr);
+	spin_lock_irqsave(&modlist_lock, flags);
+	if (!user || !unuse_module(user, modaddr))
+		module_put(modaddr);
+	spin_unlock_irqrestore(&modlist_lock, flags);
 }
-EXPORT_SYMBOL_GPL(symbol_put_addr);
+EXPORT_SYMBOL_GPL(__symbol_put_addr);
 
 static ssize_t show_refcnt(struct module_attribute *mattr,
 			   struct module *mod, char *buffer)
@@ -1016,7 +1055,7 @@ static inline void module_unload_free(st
 {
 }
 
-static inline int use_module(struct module *a, struct module *b)
+static inline int use_module(struct module *a, struct module *b, bool inc)
 {
 	return strong_try_module_get(b);
 }
@@ -1159,7 +1198,7 @@ static unsigned long resolve_symbol(Elf_
 	if (ret) {
 		/* use_module can fail due to OOM, or module unloading */
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
-		    !use_module(mod, owner))
+		    !use_module(mod, owner, false))
 			ret = 0;
 	}
 	return ret;
@@ -1421,15 +1460,17 @@ static void free_module(struct module *m
 	module_free(mod, mod->module_core);
 }
 
-void *__symbol_get(const char *symbol)
+void *__symbol_get(const char *symbol, struct module *user)
 {
 	struct module *owner;
 	unsigned long value, flags;
 	const unsigned long *crc;
 
+	DEBUGP("%s: get symbol %s by %s\n", __FUNCTION__, symbol, user?user->name:"(unknown)");
 	spin_lock_irqsave(&modlist_lock, flags);
 	value = __find_symbol(symbol, &owner, &crc, 1);
-	if (value && !strong_try_module_get(owner))
+	DEBUGP("%s: symbol %s is 0WN3D by %s\n", __FUNCTION__, symbol, owner?owner->name:"yer mom");
+	if (value && owner && !use_module(user, owner, true))
 		value = 0;
 	spin_unlock_irqrestore(&modlist_lock, flags);
 
_

Patches currently in -mm which might be from xyzzy@speakeasy.org are

git-dvb.patch
fix-constant-folding-and-poor-optimization-in-byte-swapping.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
