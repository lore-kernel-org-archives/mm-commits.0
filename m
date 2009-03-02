From: akpm@linux-foundation.org
Subject: [merged] fix-recursive-lock-in-free_uid-free_user_ns.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:01 -0800
Message-ID: <200903021923.n22JN1Ww014358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758093AbZCBTXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:23:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix recursive lock in free_uid()/free_user_ns()
has been removed from the -mm tree.  Its filename was
     fix-recursive-lock-in-free_uid-free_user_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix recursive lock in free_uid()/free_user_ns()
From: David Howells <dhowells@redhat.com>

free_uid() and free_user_ns() are corecursive when CONFIG_USER_SCHED=n,
but free_user_ns() is called from free_uid() by way of uid_hash_remove(),
which requires uidhash_lock to be held.  free_user_ns() then calls
free_uid() to complete the destruction.

Fix this by deferring the destruction of the user_namespace.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/user_namespace.h |    1 +
 kernel/user_namespace.c        |   21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff -puN include/linux/user_namespace.h~fix-recursive-lock-in-free_uid-free_user_ns include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~fix-recursive-lock-in-free_uid-free_user_ns
+++ a/include/linux/user_namespace.h
@@ -13,6 +13,7 @@ struct user_namespace {
 	struct kref		kref;
 	struct hlist_head	uidhash_table[UIDHASH_SZ];
 	struct user_struct	*creator;
+	struct work_struct	destroyer;
 };
 
 extern struct user_namespace init_user_ns;
diff -puN kernel/user_namespace.c~fix-recursive-lock-in-free_uid-free_user_ns kernel/user_namespace.c
--- a/kernel/user_namespace.c~fix-recursive-lock-in-free_uid-free_user_ns
+++ a/kernel/user_namespace.c
@@ -60,12 +60,25 @@ int create_user_ns(struct cred *new)
 	return 0;
 }
 
-void free_user_ns(struct kref *kref)
+/*
+ * Deferred destructor for a user namespace.  This is required because
+ * free_user_ns() may be called with uidhash_lock held, but we need to call
+ * back to free_uid() which will want to take the lock again.
+ */
+static void free_user_ns_work(struct work_struct *work)
 {
-	struct user_namespace *ns;
-
-	ns = container_of(kref, struct user_namespace, kref);
+	struct user_namespace *ns =
+		container_of(work, struct user_namespace, destroyer);
 	free_uid(ns->creator);
 	kfree(ns);
 }
+
+void free_user_ns(struct kref *kref)
+{
+	struct user_namespace *ns =
+		container_of(kref, struct user_namespace, kref);
+
+	INIT_WORK(&ns->destroyer, free_user_ns_work);
+	schedule_work(&ns->destroyer);
+}
 EXPORT_SYMBOL(free_user_ns);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-present-backing-device-capabilities-for-mtd-chardevs.patch
nommu-add-support-for-direct-mapping-through-mtdconcat-if-possible.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-directly-fix.patch
mtd-fix-a-bad-dependency-in-the-blackfin-code.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

