From: akpm@linux-foundation.org
Subject: + user_ns-improve-the-user_ns-on-the-slab-packaging.patch added to -mm tree
Date: Tue, 07 Dec 2010 13:58:32 -0800
Message-ID: <201012072158.oB7LwWXL010435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab0LGV7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 16:59:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@parallels.com, serge@hallyn.com, xemul@openvz.org


The patch titled
     user_ns: improve the user_ns on-the-slab packaging
has been added to the -mm tree.  Its filename is
     user_ns-improve-the-user_ns-on-the-slab-packaging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: user_ns: improve the user_ns on-the-slab packaging
From: Pavel Emelyanov <xemul@parallels.com>

Currently on 64-bit arch the user_namespace is 2096 and when being
kmalloc-ed it resides on a 4k slab wasting 2003 bytes.

If we allocate a separate cache for it and reduce the hash size from 128
to 64 chains the packaging becomes *much* better - the struct is 1072
bytes and the hole between is 98 bytes.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/user_namespace.h |    2 +-
 kernel/user_namespace.c        |   16 +++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff -puN include/linux/user_namespace.h~user_ns-improve-the-user_ns-on-the-slab-packaging include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user_ns-improve-the-user_ns-on-the-slab-packaging
+++ a/include/linux/user_namespace.h
@@ -6,7 +6,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 
-#define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 8)
+#define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 7)
 #define UIDHASH_SZ	(1 << UIDHASH_BITS)
 
 struct user_namespace {
diff -puN kernel/user_namespace.c~user_ns-improve-the-user_ns-on-the-slab-packaging kernel/user_namespace.c
--- a/kernel/user_namespace.c~user_ns-improve-the-user_ns-on-the-slab-packaging
+++ a/kernel/user_namespace.c
@@ -12,6 +12,8 @@
 #include <linux/highuid.h>
 #include <linux/cred.h>
 
+static struct kmem_cache *user_ns_cachep __read_mostly;
+
 /*
  * Create a new user namespace, deriving the creator from the user in the
  * passed credentials, and replacing that user with the new root user for the
@@ -26,7 +28,7 @@ int create_user_ns(struct cred *new)
 	struct user_struct *root_user;
 	int n;
 
-	ns = kmalloc(sizeof(struct user_namespace), GFP_KERNEL);
+	ns = kmem_cache_alloc(user_ns_cachep, GFP_KERNEL);
 	if (!ns)
 		return -ENOMEM;
 
@@ -38,7 +40,7 @@ int create_user_ns(struct cred *new)
 	/* Alloc new root user.  */
 	root_user = alloc_uid(ns, 0);
 	if (!root_user) {
-		kfree(ns);
+		kmem_cache_free(user_ns_cachep, ns);
 		return -ENOMEM;
 	}
 
@@ -71,7 +73,7 @@ static void free_user_ns_work(struct wor
 	struct user_namespace *ns =
 		container_of(work, struct user_namespace, destroyer);
 	free_uid(ns->creator);
-	kfree(ns);
+	kmem_cache_free(user_ns_cachep, ns);
 }
 
 void free_user_ns(struct kref *kref)
@@ -126,3 +128,11 @@ gid_t user_ns_map_gid(struct user_namesp
 	/* No useful relationship so no mapping */
 	return overflowgid;
 }
+
+static __init int user_namespaces_init(void)
+{
+	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC);
+	return 0;
+}
+
+__initcall(user_namespaces_init);
_

Patches currently in -mm which might be from xemul@parallels.com are

linux-next.patch
user_ns-improve-the-user_ns-on-the-slab-packaging.patch

