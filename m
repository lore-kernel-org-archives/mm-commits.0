From: akpm@linux-foundation.org
Subject: - containersv10-add-tasks-file-interface-fix-2.patch removed from -mm tree
Date: Fri, 20 Jul 2007 13:29:14 -0700
Message-ID: <200707202029.l6KKTEjW014865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760515AbXGTUaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     containersv10-add-tasks-file-interface-fix 2
has been removed from the -mm tree.  Its filename was
     containersv10-add-tasks-file-interface-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: containersv10-add-tasks-file-interface-fix 2
From: Cedric Le Goater <clg@fr.ibm.com>

when there's no tasks in a container, opening

<containerfs>/<container>/tasks

spits the following warning because we are trying to
kmalloc(0).

WARNING: at mm/slab.c:777 __find_general_cachep()
 [<c0102b01>] show_trace_log_lvl+0x1a/0x2f
 [<c0103627>] show_trace+0x12/0x14
 [<c010363e>] dump_stack+0x15/0x17
 [<c0148040>] __kmalloc+0x56/0xf3
 [<c012d030>] container_tasks_open+0x56/0x131
 [<c012cdf8>] container_file_open+0x32/0x3a
 [<c014964d>] __dentry_open+0x99/0x13c
 [<c0149771>] nameidata_to_filp+0x27/0x37
 [<c01497b4>] do_filp_open+0x33/0x3b
 [<c0149801>] do_sys_open+0x45/0xc9
 [<c01498bd>] sys_open+0x1c/0x1e
 [<c0102540>] syscall_call+0x7/0xb

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/container.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff -puN kernel/container.c~containersv10-add-tasks-file-interface-fix-2 kernel/container.c
--- a/kernel/container.c~containersv10-add-tasks-file-interface-fix-2
+++ a/kernel/container.c
@@ -1141,21 +1141,26 @@ static int container_tasks_open(struct i
 	 * show up until sometime later on.
 	 */
 	npids = container_task_count(cont);
-	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
-	if (!pidarray)
-		goto err1;
-
-	npids = pid_array_load(pidarray, npids, cont);
-	sort(pidarray, npids, sizeof(pid_t), cmppid, NULL);
-
-	/* Call pid_array_to_buf() twice, first just to get bufsz */
-	ctr->bufsz = pid_array_to_buf(&c, sizeof(c), pidarray, npids) + 1;
-	ctr->buf = kmalloc(ctr->bufsz, GFP_KERNEL);
-	if (!ctr->buf)
-		goto err2;
-	ctr->bufsz = pid_array_to_buf(ctr->buf, ctr->bufsz, pidarray, npids);
-
-	kfree(pidarray);
+	if (npids) {
+		pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
+		if (!pidarray)
+			goto err1;
+
+		npids = pid_array_load(pidarray, npids, cont);
+		sort(pidarray, npids, sizeof(pid_t), cmppid, NULL);
+
+		/* Call pid_array_to_buf() twice, first just to get bufsz */
+		ctr->bufsz = pid_array_to_buf(&c, sizeof(c), pidarray, npids) + 1;
+		ctr->buf = kmalloc(ctr->bufsz, GFP_KERNEL);
+		if (!ctr->buf)
+			goto err2;
+		ctr->bufsz = pid_array_to_buf(ctr->buf, ctr->bufsz, pidarray, npids);
+
+		kfree(pidarray);
+	} else {
+		ctr->buf = 0;
+		ctr->bufsz = 0;
+	}
 	file->private_data = ctr;
 	return 0;
 
_

Patches currently in -mm which might be from clg@fr.ibm.com are

origin.patch
containersv10-add-tasks-file-interface-fix-2.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
