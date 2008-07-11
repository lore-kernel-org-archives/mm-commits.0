From: akpm@linux-foundation.org
Subject: + use-warn-in-lib.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:45:34 -0700
Message-ID: <200807111851.m6BIpF6M031321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757343AbYGKSvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     Use WARN() in lib/
has been added to the -mm tree.  Its filename is
     use-warn-in-lib.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in lib/
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message becomes
part of the warning section for better reporting/collection.  In addition, one
of the if() clauses collapes into the WARN() entirely now.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c   |   15 +++++----------
 lib/iomap.c          |    3 +--
 lib/kobject_uevent.c |    6 ++----
 lib/plist.c          |   13 +++++++------
 4 files changed, 15 insertions(+), 22 deletions(-)

diff -puN lib/debugobjects.c~use-warn-in-lib lib/debugobjects.c
--- a/lib/debugobjects.c~use-warn-in-lib
+++ a/lib/debugobjects.c
@@ -205,9 +205,8 @@ static void debug_print_object(struct de
 
 	if (limit < 5 && obj->descr != descr_test) {
 		limit++;
-		printk(KERN_ERR "ODEBUG: %s %s object type: %s\n", msg,
+		WARN(1, KERN_ERR "ODEBUG: %s %s object type: %s\n", msg,
 		       obj_states[obj->state], obj->descr->name);
-		WARN_ON(1);
 	}
 	debug_objects_warnings++;
 }
@@ -733,26 +732,22 @@ check_results(void *addr, enum debug_obj
 
 	obj = lookup_object(addr, db);
 	if (!obj && state != ODEBUG_STATE_NONE) {
-		printk(KERN_ERR "ODEBUG: selftest object not found\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "ODEBUG: selftest object not found\n");
 		goto out;
 	}
 	if (obj && obj->state != state) {
-		printk(KERN_ERR "ODEBUG: selftest wrong state: %d != %d\n",
+		WARN(1, KERN_ERR "ODEBUG: selftest wrong state: %d != %d\n",
 		       obj->state, state);
-		WARN_ON(1);
 		goto out;
 	}
 	if (fixups != debug_objects_fixups) {
-		printk(KERN_ERR "ODEBUG: selftest fixups failed %d != %d\n",
+		WARN(1, KERN_ERR "ODEBUG: selftest fixups failed %d != %d\n",
 		       fixups, debug_objects_fixups);
-		WARN_ON(1);
 		goto out;
 	}
 	if (warnings != debug_objects_warnings) {
-		printk(KERN_ERR "ODEBUG: selftest warnings failed %d != %d\n",
+		WARN(1, KERN_ERR "ODEBUG: selftest warnings failed %d != %d\n",
 		       warnings, debug_objects_warnings);
-		WARN_ON(1);
 		goto out;
 	}
 	res = 0;
diff -puN lib/iomap.c~use-warn-in-lib lib/iomap.c
--- a/lib/iomap.c~use-warn-in-lib
+++ a/lib/iomap.c
@@ -40,8 +40,7 @@ static void bad_io_access(unsigned long 
 	static int count = 10;
 	if (count) {
 		count--;
-		printk(KERN_ERR "Bad IO access at port %#lx (%s)\n", port, access);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "Bad IO access at port %#lx (%s)\n", port, access);
 	}
 }
 
diff -puN lib/kobject_uevent.c~use-warn-in-lib lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~use-warn-in-lib
+++ a/lib/kobject_uevent.c
@@ -285,8 +285,7 @@ int add_uevent_var(struct kobj_uevent_en
 	int len;
 
 	if (env->envp_idx >= ARRAY_SIZE(env->envp)) {
-		printk(KERN_ERR "add_uevent_var: too many keys\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "add_uevent_var: too many keys\n");
 		return -ENOMEM;
 	}
 
@@ -297,8 +296,7 @@ int add_uevent_var(struct kobj_uevent_en
 	va_end(args);
 
 	if (len >= (sizeof(env->buf) - env->buflen)) {
-		printk(KERN_ERR "add_uevent_var: buffer size too small\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "add_uevent_var: buffer size too small\n");
 		return -ENOMEM;
 	}
 
diff -puN lib/plist.c~use-warn-in-lib lib/plist.c
--- a/lib/plist.c~use-warn-in-lib
+++ a/lib/plist.c
@@ -31,12 +31,13 @@
 static void plist_check_prev_next(struct list_head *t, struct list_head *p,
 				  struct list_head *n)
 {
-	if (n->prev != p || p->next != n) {
-		printk("top: %p, n: %p, p: %p\n", t, t->next, t->prev);
-		printk("prev: %p, n: %p, p: %p\n", p, p->next, p->prev);
-		printk("next: %p, n: %p, p: %p\n", n, n->next, n->prev);
-		WARN_ON(1);
-	}
+	WARN(n->prev != p || p->next != n,
+			"top: %p, n: %p, p: %p\n"
+			"prev: %p, n: %p, p: %p\n"
+			"next: %p, n: %p, p: %p\n",
+			 t, t->next, t->prev,
+			p, p->next, p->prev,
+			n, n->next, n->prev);
 }
 
 static void plist_check_list(struct list_head *top)
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-panicc.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch

