From: akpm@linux-foundation.org
Subject: - proc-simplify-locking-in-remove_proc_entry.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:49 -0700
Message-ID: <200804300545.m3U5jnTS029546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756722AbYD3GCi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:02:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: simplify locking in remove_proc_entry()
has been removed from the -mm tree.  Its filename was
     proc-simplify-locking-in-remove_proc_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: simplify locking in remove_proc_entry()
From: Alexey Dobriyan <adobriyan@gmail.com>

proc_subdir_lock protects only modifying and walking through PDE lists, so
after we've found PDE to remove and actually removed it from lists, there is
no need to hold proc_subdir_lock for the rest of operation.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   80 +++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 41 deletions(-)

diff -puN fs/proc/generic.c~proc-simplify-locking-in-remove_proc_entry fs/proc/generic.c
--- a/fs/proc/generic.c~proc-simplify-locking-in-remove_proc_entry
+++ a/fs/proc/generic.c
@@ -734,60 +734,58 @@ void free_proc_entry(struct proc_dir_ent
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
 	for (p = &parent->subdir; *p; p=&(*p)->next ) {
-		if (!proc_match(len, fn, *p))
-			continue;
-		de = *p;
-		*p = de->next;
-		de->next = NULL;
-
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
+		if (proc_match(len, fn, *p)) {
+			de = *p;
+			*p = de->next;
+			de->next = NULL;
+			break;
+		}
+	}
+	spin_unlock(&proc_subdir_lock);
+	if (!de)
+		return;
 
-			spin_unlock(&de->pde_unload_lock);
-			spin_unlock(&proc_subdir_lock);
+	spin_lock(&de->pde_unload_lock);
+	/*
+	 * Stop accepting new callers into module. If you're
+	 * dynamically allocating ->proc_fops, save a pointer somewhere.
+	 */
+	de->proc_fops = NULL;
+	/* Wait until all existing callers into module are done. */
+	if (de->pde_users > 0) {
+		DECLARE_COMPLETION_ONSTACK(c);
 
-			wait_for_completion(de->pde_unload_completion);
+		if (!de->pde_unload_completion)
+			de->pde_unload_completion = &c;
 
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
-		if (de->subdir) {
-			printk(KERN_WARNING "%s: removing non-empty directory "
-			       "'%s/%s', leaking at least '%s'\n", __func__,
-			       de->parent->name, de->name, de->subdir->name);
-			WARN_ON(1);
-		}
-		if (atomic_dec_and_test(&de->count))
-			free_proc_entry(de);
-		break;
+	if (S_ISDIR(de->mode))
+		parent->nlink--;
+	de->nlink = 0;
+	if (de->subdir) {
+		printk(KERN_WARNING "%s: removing non-empty directory "
+			"'%s/%s', leaking at least '%s'\n", __func__,
+			de->parent->name, de->name, de->subdir->name);
+		WARN_ON(1);
 	}
-	spin_unlock(&proc_subdir_lock);
-out:
-	return;
+	if (atomic_dec_and_test(&de->count))
+		free_proc_entry(de);
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
git-xfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

