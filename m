From: akpm@linux-foundation.org
Subject: - proc-simplify-remove_proc_entry-wrt-locking.patch removed from -mm tree
Date: Tue, 20 Nov 2007 20:08:51 -0800
Message-ID: <200711210408.lAL48pf1006592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbXKUEJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 23:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     proc: simplify remove_proc_entry() wrt locking
has been removed from the -mm tree.  Its filename was
     proc-simplify-remove_proc_entry-wrt-locking.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: proc: simplify remove_proc_entry() wrt locking
From: Alexey Dobriyan <adobriyan@sw.ru>

We can take proc_subdir_lock for duration of list searching and removing from
lists only.  It can't hurt -- we can gather any amount of looked up PDEs right
after proc_subdir_lock droppage in proc_lookup() anyway.  Current code should
already deal with this correctly.

Also this should make code more undestandable:
* original looks like a loop, however, it's a loop with unconditional
  trailing "break;" -- not loop at all.
* more explicit statement that proc_subdir_lock protects only ->subdir lists.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   73 +++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 38 deletions(-)

diff -puN fs/proc/generic.c~proc-simplify-remove_proc_entry-wrt-locking fs/proc/generic.c
--- a/fs/proc/generic.c~proc-simplify-remove_proc_entry-wrt-locking
+++ a/fs/proc/generic.c
@@ -686,12 +686,12 @@ void free_proc_entry(struct proc_dir_ent
 void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 {
 	struct proc_dir_entry **p;
-	struct proc_dir_entry *de;
+	struct proc_dir_entry *de = NULL;
 	const char *fn = name;
 	int len;
 
 	if (!parent && xlate_proc_name(name, &parent, &fn) != 0)
-		goto out;
+		return;
 	len = strlen(fn);
 
 	spin_lock(&proc_subdir_lock);
@@ -701,45 +701,42 @@ void remove_proc_entry(const char *name,
 		de = *p;
 		*p = de->next;
 		de->next = NULL;
+	}
+	spin_unlock(&proc_subdir_lock);
+	if (!de)
+		return;
+
+	spin_lock(&de->pde_unload_lock);
+	/*
+	 * Stop accepting new callers into module. If you're
+	 * dynamically allocating ->proc_fops, save a pointer somewhere.
+	 */
+	de->proc_fops = NULL;
+	/* Wait until all existing callers into module are done. */
+	if (de->pde_users > 0) {
+		DECLARE_COMPLETION_ONSTACK(c);
+
+		if (!de->pde_unload_completion)
+			de->pde_unload_completion = &c;
 
-		spin_lock(&de->pde_unload_lock);
-		/*
-		 * Stop accepting new callers into module. If you're
-		 * dynamically allocating ->proc_fops, save a pointer somewhere.
-		 */
-		de->proc_fops = NULL;
-		/* Wait until all existing callers into module are done. */
-		if (de->pde_users > 0) {
-			DECLARE_COMPLETION_ONSTACK(c);
-
-			if (!de->pde_unload_completion)
-				de->pde_unload_completion = &c;
-
-			spin_unlock(&de->pde_unload_lock);
-			spin_unlock(&proc_subdir_lock);
-
-			wait_for_completion(de->pde_unload_completion);
-
-			spin_lock(&proc_subdir_lock);
-			goto continue_removing;
-		}
 		spin_unlock(&de->pde_unload_lock);
 
+		wait_for_completion(de->pde_unload_completion);
+
+		goto continue_removing;
+	}
+	spin_unlock(&de->pde_unload_lock);
+
 continue_removing:
-		if (S_ISDIR(de->mode))
-			parent->nlink--;
-		de->nlink = 0;
-		WARN_ON(de->subdir);
-		if (!atomic_read(&de->count))
-			free_proc_entry(de);
-		else {
-			de->deleted = 1;
-			printk("remove_proc_entry: %s/%s busy, count=%d\n",
-				parent->name, de->name, atomic_read(&de->count));
-		}
-		break;
+	if (S_ISDIR(de->mode))
+		parent->nlink--;
+	de->nlink = 0;
+	WARN_ON(de->subdir);
+	if (!atomic_read(&de->count))
+		free_proc_entry(de);
+	else {
+		de->deleted = 1;
+		printk("remove_proc_entry: %s/%s busy, count=%d\n",
+			parent->name, de->name, atomic_read(&de->count));
 	}
-	spin_unlock(&proc_subdir_lock);
-out:
-	return;
 }
_

Patches currently in -mm which might be from adobriyan@sw.ru are

proc-fix-null-i_fop-oops.patch
proc-remove-module_license.patch
proc-less-lock-operations-during-lookup.patch
proc-simplify-function-prototypes.patch
proc-remove-useless-check-on-symlink-removal.patch
proc-remove-useless-checks-in-proc_register.patch
proc-detect-duplicate-names-on-registration.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-simplify-remove_proc_entry-wrt-locking.patch
proc-simplify-remove_proc_entry-wrt-locking-checkpatch-fixes.patch
single_open-seq_release-leak-diagnostics.patch
