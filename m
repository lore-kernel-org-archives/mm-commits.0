From: akpm@linux-foundation.org
Subject: + cgroup-api-files-drop-mem_cgroup_force_empty.patch added to -mm tree
Date: Wed, 27 Feb 2008 17:04:40 -0800
Message-ID: <200802280104.m1S14eL1008267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761437AbYB1BFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 20:05:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     CGroup API files: drop mem_cgroup_force_empty()
has been added to the -mm tree.  Its filename is
     cgroup-api-files-drop-mem_cgroup_force_empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroup API files: drop mem_cgroup_force_empty()
From: Paul Menage <menage@google.com>

This function isn't needed - a NULL pointer in the cftype read function will
result in the same EINVAL response to userspace.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN mm/memcontrol.c~cgroup-api-files-drop-mem_cgroup_force_empty mm/memcontrol.c
--- a/mm/memcontrol.c~cgroup-api-files-drop-mem_cgroup_force_empty
+++ a/mm/memcontrol.c
@@ -949,19 +949,6 @@ static ssize_t mem_force_empty_write(str
 	return ret;
 }
 
-/*
- * Note: This should be removed if cgroup supports write-only file.
- */
-
-static ssize_t mem_force_empty_read(struct cgroup *cont,
-				struct cftype *cft,
-				struct file *file, char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
-{
-	return -EINVAL;
-}
-
-
 static const struct mem_cgroup_stat_desc {
 	const char *msg;
 	u64 unit;
@@ -1018,7 +1005,6 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "force_empty",
 		.write = mem_force_empty_write,
-		.read = mem_force_empty_read,
 	},
 	{
 		.name = "stat",
_

Patches currently in -mm which might be from menage@google.com are

cgroup-fix-default-notify_on_release-setting.patch
memory-resource-controller-use-strstrip-while-parsing-arguments.patch
memory-controller-rename-to-memory-resource-controller.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
add-a-refcount-check-in-dput.patch
