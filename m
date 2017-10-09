From: akpm@linux-foundation.org
Subject: [obsolete] pid-delete-struct-pidmap-nr_free.patch removed from
 -mm tree
Date: Mon, 09 Oct 2017 16:30:53 -0700
Message-ID: <59dc06ad.XLN00wj5T52V3KCr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32780 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755257AbdJIXaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2017 19:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ebiederm@xmission.com, keescook@chromium.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid: delete struct pidmap::nr_free
has been removed from the -mm tree.  Its filename was
     pid-delete-struct-pidmap-nr_free.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: pid: delete struct pidmap::nr_free

There is a check in pid allocation code to skip a full page:

	if (likely(atomic_read(&map->nr_free))) {
		...

In practice it doesn't do anything.  To skip a pidmap page one has to have
32K consecutive pids allocated at the same time which doesn't happen.

Currently the price is _every_ fork/exit on every system being slower than
necessary.

Link: http://lkml.kernel.org/r/20170909203649.GB4791@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    1 -
 kernel/pid.c                  |   28 ++++++++++------------------
 kernel/pid_namespace.c        |    6 ------
 3 files changed, 10 insertions(+), 25 deletions(-)

diff -puN include/linux/pid_namespace.h~pid-delete-struct-pidmap-nr_free include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-delete-struct-pidmap-nr_free
+++ a/include/linux/pid_namespace.h
@@ -11,7 +11,6 @@
 #include <linux/ns_common.h>
 
 struct pidmap {
-       atomic_t nr_free;
        void *page;
 };
 
diff -puN kernel/pid.c~pid-delete-struct-pidmap-nr_free kernel/pid.c
--- a/kernel/pid.c~pid-delete-struct-pidmap-nr_free
+++ a/kernel/pid.c
@@ -68,9 +68,6 @@ static inline int mk_pid(struct pid_name
  */
 struct pid_namespace init_pid_ns = {
 	.kref = KREF_INIT(2),
-	.pidmap = {
-		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
-	},
 	.last_pid = 0,
 	.nr_hashed = PIDNS_HASH_ADDING,
 	.level = 0,
@@ -106,7 +103,6 @@ static void free_pidmap(struct upid *upi
 	int offset = nr & BITS_PER_PAGE_MASK;
 
 	clear_bit(offset, map->page);
-	atomic_inc(&map->nr_free);
 }
 
 /*
@@ -181,20 +177,17 @@ static int alloc_pidmap(struct pid_names
 			if (unlikely(!map->page))
 				return -ENOMEM;
 		}
-		if (likely(atomic_read(&map->nr_free))) {
-			for ( ; ; ) {
-				if (!test_and_set_bit(offset, map->page)) {
-					atomic_dec(&map->nr_free);
-					set_last_pid(pid_ns, last, pid);
-					return pid;
-				}
-				offset = find_next_offset(map, offset);
-				if (offset >= BITS_PER_PAGE)
-					break;
-				pid = mk_pid(pid_ns, map, offset);
-				if (pid >= pid_max)
-					break;
+		for (;;) {
+			if (!test_and_set_bit(offset, map->page)) {
+				set_last_pid(pid_ns, last, pid);
+				return pid;
 			}
+			offset = find_next_offset(map, offset);
+			if (offset >= BITS_PER_PAGE)
+				break;
+			pid = mk_pid(pid_ns, map, offset);
+			if (pid >= pid_max)
+				break;
 		}
 		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
 			++map;
@@ -591,7 +584,6 @@ void __init pidmap_init(void)
 	init_pid_ns.pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	/* Reserve PID 0. We never call free_pidmap(0) */
 	set_bit(0, init_pid_ns.pidmap[0].page);
-	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
 
 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
diff -puN kernel/pid_namespace.c~pid-delete-struct-pidmap-nr_free kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid-delete-struct-pidmap-nr_free
+++ a/kernel/pid_namespace.c
@@ -98,7 +98,6 @@ static struct pid_namespace *create_pid_
 	struct pid_namespace *ns;
 	unsigned int level = parent_pid_ns->level + 1;
 	struct ucounts *ucounts;
-	int i;
 	int err;
 
 	err = -EINVAL;
@@ -139,11 +138,6 @@ static struct pid_namespace *create_pid_
 	INIT_WORK(&ns->proc_work, proc_cleanup_work);
 
 	set_bit(0, ns->pidmap[0].page);
-	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
-
-	for (i = 1; i < PIDMAP_ENTRIES; i++)
-		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
