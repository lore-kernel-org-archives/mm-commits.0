From: akpm@osdl.org
Subject: - lockdep-misc-fixes-in-lockdepc.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:33 -0800
Message-ID: <200612072302.kB7N2Xla029864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51723 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163698AbWLGXCm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: misc fixes in lockdep.c
has been removed from the -mm tree.  Its filename was
     lockdep-misc-fixes-in-lockdepc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: misc fixes in lockdep.c
From: Jarek Poplawski <jarkao2@o2.pl>

- numeric string size replaced with constant in print_lock_name and
  print_lockdep_cache,

- return on null pointer in print_lock_dependencies,

- one more lockdep return with 0 with unlocking fix in mark_lock.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/lockdep.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/lockdep.c~lockdep-misc-fixes-in-lockdepc kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-misc-fixes-in-lockdepc
+++ a/kernel/lockdep.c
@@ -359,7 +359,7 @@ get_usage_chars(struct lock_class *class
 
 static void print_lock_name(struct lock_class *class)
 {
-	char str[128], c1, c2, c3, c4;
+	char str[KSYM_NAME_LEN + 1], c1, c2, c3, c4;
 	const char *name;
 
 	get_usage_chars(class, &c1, &c2, &c3, &c4);
@@ -381,7 +381,7 @@ static void print_lock_name(struct lock_
 static void print_lockdep_cache(struct lockdep_map *lock)
 {
 	const char *name;
-	char str[128];
+	char str[KSYM_NAME_LEN + 1];
 
 	name = lock->name;
 	if (!name)
@@ -451,7 +451,9 @@ static void print_lock_dependencies(stru
 	print_lock_class_header(class, depth);
 
 	list_for_each_entry(entry, &class->locks_after, entry) {
-		DEBUG_LOCKS_WARN_ON(!entry->class);
+		if (DEBUG_LOCKS_WARN_ON(!entry->class))
+			return;
+
 		print_lock_dependencies(entry->class, depth + 1);
 
 		printk("%*s ... acquired at:\n",depth,"");
@@ -1734,6 +1736,7 @@ static int mark_lock(struct task_struct 
 		debug_atomic_dec(&nr_unused_locks);
 		break;
 	default:
+		__raw_spin_unlock(&hash_lock);
 		debug_locks_off();
 		WARN_ON(1);
 		return 0;
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch

