From: akpm@linux-foundation.org
Subject: - cgroup-api-files-use-read_u64-in-memory-controller.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:15 -0700
Message-ID: <200804300542.m3U5gFHM029129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756907AbYD3Fnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     CGroup API files: use read_u64 in memory controller
has been removed from the -mm tree.  Its filename was
     cgroup-api-files-use-read_u64-in-memory-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroup API files: use read_u64 in memory controller
From: Paul Menage <menage@google.com>

Update the memory controller to use read_u64 for its limit/usage/failcnt
control files, calling the new res_counter_read_u64() function.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~cgroup-api-files-use-read_u64-in-memory-controller mm/memcontrol.c
--- a/mm/memcontrol.c~cgroup-api-files-use-read_u64-in-memory-controller
+++ a/mm/memcontrol.c
@@ -853,13 +853,10 @@ static int mem_cgroup_write_strategy(cha
 	return 0;
 }
 
-static ssize_t mem_cgroup_read(struct cgroup *cont,
-			struct cftype *cft, struct file *file,
-			char __user *userbuf, size_t nbytes, loff_t *ppos)
+static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
-	return res_counter_read(&mem_cgroup_from_cont(cont)->res,
-				cft->private, userbuf, nbytes, ppos,
-				NULL);
+	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
+				    cft->private);
 }
 
 static ssize_t mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
@@ -950,18 +947,18 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "usage_in_bytes",
 		.private = RES_USAGE,
-		.read = mem_cgroup_read,
+		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "limit_in_bytes",
 		.private = RES_LIMIT,
 		.write = mem_cgroup_write,
-		.read = mem_cgroup_read,
+		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "failcnt",
 		.private = RES_FAILCNT,
-		.read = mem_cgroup_read,
+		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "force_empty",
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch

