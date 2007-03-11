From: akpm@linux-foundation.org
Subject: + add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:09:52 -0800
Message-ID: <200703110809.l2B89qkV007533@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39476 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbXCKIKH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org, mchehab@infradead.org, rusty@rustcorp.com.au, xyzzy@speakeasy.org


The patch titled
     add-ability-to-keep-track-of-callers-of-symbol_getput-tidy
has been added to the -mm tree.  Its filename is
     add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-ability-to-keep-track-of-callers-of-symbol_getput-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   61 ++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 21 deletions(-)

diff -puN kernel/module.c~add-ability-to-keep-track-of-callers-of-symbol_getput-tidy kernel/module.c
--- a/kernel/module.c~add-ability-to-keep-track-of-callers-of-symbol_getput-tidy
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
@@ -733,18 +735,23 @@ static struct module_use *already_uses(s
 	return NULL;
 }
 
-/* Module a uses b
-   If inc is set, then the use count will be incremented. */
+/*
+ * Module a uses b.  If inc is set, then the use count will be incremented.
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
+	use = already_uses(a, b);
+	if (use) {
+		if (inc)
+			use->count++;
+		DEBUGP("%s: %s already used %s, count now at %d\n",
+				__FUNCTION__, a->name, b->name, use->count);
 		return 1;
 	}
 
@@ -766,18 +773,22 @@ static int use_module(struct module *a, 
 	return 1;
 }
 
-/* Module a is "un-using" module b.  The use count is decremented, and if
-   it reaches zero the module_use is removed.  Returns number of
-   remaining uses. */
+/*
+ * Module a is "un-using" module b.  The use count is decremented, and if it
+ * reaches zero the module_use is removed.  Returns number of remaining uses.
+ */
 static int unuse_module(struct module *a, struct module *b)
 {
 	struct module_use *use = already_uses(a, b);
+
 	DEBUGP("%s: unuse %s by %s\n", __FUNCTION__, b->name, a->name);
 
 	BUG_ON(!use);
-	DEBUGP("%s: %s used %s %d time(s)\n", __FUNCTION__, a->name, b->name, use->count);
-	if (! --(use->count)) {
-		DEBUGP("%s: removing module_use structure and sysfs link\n", __FUNCTION__);
+	DEBUGP("%s: %s used %s %d time(s)\n", __FUNCTION__, a->name,
+			b->name, use->count);
+	if (!--(use->count)) {
+		DEBUGP("%s: removing module_use structure and sysfs link\n",
+			__FUNCTION__);
 		list_del(&use->list);
 		kfree(use);
 		sysfs_remove_link(b->holders_dir, a->name);
@@ -798,7 +809,9 @@ static void module_unload_free(struct mo
 			if (use->module_which_uses == mod) {
 				DEBUGP("%s unusing %s\n", mod->name, i->name);
 				if (unuse_module(mod, i))
-					printk(KERN_ERR "%s unloading but still has uses of %s\n", mod->name, i->name);
+					printk(KERN_ERR "%s unloading but still"
+						" has uses of %s\n",
+						mod->name, i->name);
 				module_put(i);
 				/* There can be at most one match. */
 				break;
@@ -988,13 +1001,16 @@ void __symbol_put(const char *symbol, st
 	unsigned long flags;
 	const unsigned long *crc;
 
-	DEBUGP("%s: putting %s by %s\n", __FUNCTION__, symbol, user?user->name:"(unknown)");
+	DEBUGP("%s: putting %s by %s\n", __FUNCTION__, symbol,
+			user ? user->name : "(unknown)");
 	spin_lock_irqsave(&modlist_lock, flags);
 	if (!__find_symbol(symbol, &owner, &crc, 1))
 		BUG();
 
-	/* If the symbol is owned by a module, put it if no user was
-	   specified or if this is the last of user's uses of the module. */
+	/*
+	 * If the symbol is owned by a module, put it if no user was specified
+	 * or if this is the last of user's uses of the module.
+	 */
 	if (owner && (!user || !unuse_module(user, owner)))
 		module_put(owner);
 	spin_unlock_irqrestore(&modlist_lock, flags);
@@ -1006,7 +1022,8 @@ void __symbol_put_addr(void *addr, struc
 	struct module *modaddr;
 	unsigned long flags;
 
-	DEBUGP("%s: putting %p by %s\n", __FUNCTION__, addr, user?user->name:"(unknown)");
+	DEBUGP("%s: putting %p by %s\n", __FUNCTION__, addr,
+		user ? user->name : "(unknown)");
 	if (core_kernel_text((unsigned long)addr))
 		return;
 
@@ -1466,10 +1483,12 @@ void *__symbol_get(const char *symbol, s
 	unsigned long value, flags;
 	const unsigned long *crc;
 
-	DEBUGP("%s: get symbol %s by %s\n", __FUNCTION__, symbol, user?user->name:"(unknown)");
+	DEBUGP("%s: get symbol %s by %s\n", __FUNCTION__, symbol,
+		user ? user->name : "(unknown)");
 	spin_lock_irqsave(&modlist_lock, flags);
 	value = __find_symbol(symbol, &owner, &crc, 1);
-	DEBUGP("%s: symbol %s is 0WN3D by %s\n", __FUNCTION__, symbol, owner?owner->name:"yer mom");
+	DEBUGP("%s: symbol %s is 0WN3D by %s\n", __FUNCTION__, symbol,
+		owner ? owner->name : "yer mom");
 	if (value && owner && !use_module(user, owner, true))
 		value = 0;
 	spin_unlock_irqrestore(&modlist_lock, flags);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ivtv-warning-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fixup.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
