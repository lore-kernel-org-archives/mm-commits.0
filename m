From: akpm@linux-foundation.org
Subject: [merged] cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:34:18 -0700
Message-ID: <200909241934.n8OJYIMO030529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309AbZIXTey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@google.com, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: use vmalloc for large cgroups pidlist allocations
has been removed from the -mm tree.  Its filename was
     cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: use vmalloc for large cgroups pidlist allocations
From: Ben Blum <bblum@google.com>

Separates all pidlist allocation requests to a separate function that
judges based on the requested size whether or not the array needs to be
vmalloced or can be gotten via kmalloc, and similar for kfree/vfree.

Signed-off-by: Ben Blum <bblum@google.com>
Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   47 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff -puN kernel/cgroup.c~cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations
+++ a/kernel/cgroup.c
@@ -50,6 +50,7 @@
 #include <linux/smp_lock.h>
 #include <linux/pid_namespace.h>
 #include <linux/idr.h>
+#include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 
 #include <asm/atomic.h>
 
@@ -2351,6 +2352,42 @@ int cgroup_scan_tasks(struct cgroup_scan
  */
 
 /*
+ * The following two functions "fix" the issue where there are more pids
+ * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
+ * TODO: replace with a kernel-wide solution to this problem
+ */
+#define PIDLIST_TOO_LARGE(c) ((c) * sizeof(pid_t) > (PAGE_SIZE * 2))
+static void *pidlist_allocate(int count)
+{
+	if (PIDLIST_TOO_LARGE(count))
+		return vmalloc(count * sizeof(pid_t));
+	else
+		return kmalloc(count * sizeof(pid_t), GFP_KERNEL);
+}
+static void pidlist_free(void *p)
+{
+	if (is_vmalloc_addr(p))
+		vfree(p);
+	else
+		kfree(p);
+}
+static void *pidlist_resize(void *p, int newcount)
+{
+	void *newlist;
+	/* note: if new alloc fails, old p will still be valid either way */
+	if (is_vmalloc_addr(p)) {
+		newlist = vmalloc(newcount * sizeof(pid_t));
+		if (!newlist)
+			return NULL;
+		memcpy(newlist, p, newcount * sizeof(pid_t));
+		vfree(p);
+	} else {
+		newlist = krealloc(p, newcount * sizeof(pid_t), GFP_KERNEL);
+	}
+	return newlist;
+}
+
+/*
  * pidlist_uniq - given a kmalloc()ed list, strip out all duplicate entries
  * If the new stripped list is sufficiently smaller and there's enough memory
  * to allocate a new buffer, will let go of the unneeded memory. Returns the
@@ -2389,7 +2426,7 @@ after:
 	 * we'll just stay with what we've got.
 	 */
 	if (PIDLIST_REALLOC_DIFFERENCE(length, dest)) {
-		newlist = krealloc(list, dest * sizeof(pid_t), GFP_KERNEL);
+		newlist = pidlist_resize(list, dest);
 		if (newlist)
 			*p = newlist;
 	}
@@ -2470,7 +2507,7 @@ static int pidlist_array_load(struct cgr
 	 * show up until sometime later on.
 	 */
 	length = cgroup_task_count(cgrp);
-	array = kmalloc(length * sizeof(pid_t), GFP_KERNEL);
+	array = pidlist_allocate(length);
 	if (!array)
 		return -ENOMEM;
 	/* now, populate the array */
@@ -2494,11 +2531,11 @@ static int pidlist_array_load(struct cgr
 		length = pidlist_uniq(&array, length);
 	l = cgroup_pidlist_find(cgrp, type);
 	if (!l) {
-		kfree(array);
+		pidlist_free(array);
 		return -ENOMEM;
 	}
 	/* store array, freeing old if necessary - lock already held */
-	kfree(l->list);
+	pidlist_free(l->list);
 	l->list = array;
 	l->length = length;
 	l->use_count++;
@@ -2659,7 +2696,7 @@ static void cgroup_release_pid_array(str
 		/* we're the last user if refcount is 0; remove and free */
 		list_del(&l->links);
 		mutex_unlock(&l->owner->pidlist_mutex);
-		kfree(l->list);
+		pidlist_free(l->list);
 		put_pid_ns(l->key.ns);
 		up_write(&l->mutex);
 		kfree(l);
_

Patches currently in -mm which might be from bblum@google.com are

origin.patch

