From: akpm@linux-foundation.org
Subject: + cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch added to -mm tree
Date: Wed, 27 Feb 2008 17:04:36 -0800
Message-ID: <200802280104.m1S14au4008261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757925AbYB1BFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 20:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     CGroup API files: use cgroup map for memcontrol stats file
has been added to the -mm tree.  Its filename is
     cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch

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
Subject: CGroup API files: use cgroup map for memcontrol stats file
From: Paul Menage <menage@google.com>

Remove the seq_file boilerplate used to construct the memcontrol stats map,
and instead use the new map representation for cgroup control files

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff -puN mm/memcontrol.c~cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file mm/memcontrol.c
--- a/mm/memcontrol.c~cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file
+++ a/mm/memcontrol.c
@@ -970,9 +970,9 @@ static const struct mem_cgroup_stat_desc
 	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
 };
 
-static int mem_control_stat_show(struct seq_file *m, void *arg)
+static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
+				 struct cgroup_map_cb *cb)
 {
-	struct cgroup *cont = m->private;
 	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
 	struct mem_cgroup_stat *stat = &mem_cont->stat;
 	int i;
@@ -982,8 +982,7 @@ static int mem_control_stat_show(struct 
 
 		val = mem_cgroup_read_stat(stat, i);
 		val *= mem_cgroup_stat_desc[i].unit;
-		seq_printf(m, "%s %lld\n", mem_cgroup_stat_desc[i].msg,
-				(long long)val);
+		cb->fill(cb, mem_cgroup_stat_desc[i].msg, val);
 	}
 	/* showing # of active pages */
 	{
@@ -993,29 +992,12 @@ static int mem_control_stat_show(struct 
 						MEM_CGROUP_ZSTAT_INACTIVE);
 		active = mem_cgroup_get_all_zonestat(mem_cont,
 						MEM_CGROUP_ZSTAT_ACTIVE);
-		seq_printf(m, "active %ld\n", (active) * PAGE_SIZE);
-		seq_printf(m, "inactive %ld\n", (inactive) * PAGE_SIZE);
+		cb->fill(cb, "active", (active) * PAGE_SIZE);
+		cb->fill(cb, "inactive", (inactive) * PAGE_SIZE);
 	}
 	return 0;
 }
 
-static const struct file_operations mem_control_stat_file_operations = {
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int mem_control_stat_open(struct inode *unused, struct file *file)
-{
-	/* XXX __d_cont */
-	struct cgroup *cont = file->f_dentry->d_parent->d_fsdata;
-
-	file->f_op = &mem_control_stat_file_operations;
-	return single_open(file, mem_control_stat_show, cont);
-}
-
-
-
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -1040,7 +1022,7 @@ static struct cftype mem_cgroup_files[] 
 	},
 	{
 		.name = "stat",
-		.open = mem_control_stat_open,
+		.read_map = mem_control_stat_show,
 	},
 };
 
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
