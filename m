From: akpm@linux-foundation.org
Subject: [merged] lib-dynamic_debugc-use-kstrdup_const.patch removed from
 -mm tree
Date: Mon, 09 Nov 2015 11:45:46 -0800
Message-ID: <5640f7ea.jSsm6icj+Eaq524T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbbKITpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, jbaron@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dynamic_debug.c: use kstrdup_const
has been removed from the -mm tree.  Its filename was
     lib-dynamic_debugc-use-kstrdup_const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/dynamic_debug.c: use kstrdup_const

Using kstrdup_const, thus reusing .rodata when possible, saves around 2 kB
of runtime memory on my laptop/.config combination.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/dynamic_debug.c~lib-dynamic_debugc-use-kstrdup_const lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~lib-dynamic_debugc-use-kstrdup_const
+++ a/lib/dynamic_debug.c
@@ -42,7 +42,7 @@ extern struct _ddebug __stop___verbose[]
 
 struct ddebug_table {
 	struct list_head link;
-	char *mod_name;
+	const char *mod_name;
 	unsigned int num_ddebugs;
 	struct _ddebug *ddebugs;
 };
@@ -841,12 +841,12 @@ int ddebug_add_module(struct _ddebug *ta
 			     const char *name)
 {
 	struct ddebug_table *dt;
-	char *new_name;
+	const char *new_name;
 
 	dt = kzalloc(sizeof(*dt), GFP_KERNEL);
 	if (dt == NULL)
 		return -ENOMEM;
-	new_name = kstrdup(name, GFP_KERNEL);
+	new_name = kstrdup_const(name, GFP_KERNEL);
 	if (new_name == NULL) {
 		kfree(dt);
 		return -ENOMEM;
@@ -907,7 +907,7 @@ int ddebug_dyndbg_module_param_cb(char *
 static void ddebug_table_free(struct ddebug_table *dt)
 {
 	list_del_init(&dt->link);
-	kfree(dt->mod_name);
+	kfree_const(dt->mod_name);
 	kfree(dt);
 }
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch
slabh-sprinkle-__assume_aligned-attributes.patch

