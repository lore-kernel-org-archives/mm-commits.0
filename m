From: akpm@linux-foundation.org
Subject: [merged] proc-kcore-fix-statst_size.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:15 -0700
Message-ID: <200909231957.n8NJvF57006569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808AbZIWT5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     /proc/kcore: fix stat.st_size
has been removed from the -mm tree.  Its filename was
     proc-kcore-fix-statst_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/kcore: fix stat.st_size
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently the size of /proc/kcore which can be read by 'ls -l' is 0.  But
it's not the correct value.

On x86-64, ls -l shows
 ... root root 140737486266368 2009-09-17 10:29 /proc/kcore
Then, 7FFFFFFE02000. This comes from vmalloc area's size.
(*) This shows "core" size, not  memory size.

This patch shows the size by updating "size" field in struct
proc_dir_entry.  Later, lookup routine will create inode and fill
inode->i_size based on this value.  Then, this has a problem.

 - Once inode is cached, inode->i_size will never be updated.

Then, this patch is not memory-hotplug-aware.

To update inode->i_size, we have to know dentry or inode.
But there is no way to lookup them by inside kernel. Hmmm....
Next patch will try it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~proc-kcore-fix-statst_size fs/proc/kcore.c
--- a/fs/proc/kcore.c~proc-kcore-fix-statst_size
+++ a/fs/proc/kcore.c
@@ -107,6 +107,8 @@ static void free_kclist_ents(struct list
  */
 static void __kcore_update_ram(struct list_head *list)
 {
+	int nphdr;
+	size_t size;
 	struct kcore_list *tmp, *pos;
 	LIST_HEAD(garbage);
 
@@ -121,6 +123,7 @@ static void __kcore_update_ram(struct li
 	} else
 		list_splice(list, &garbage);
 	kcore_need_update = 0;
+	proc_root_kcore->size = get_kcore_size(&nphdr, &size);
 	write_unlock(&kclist_lock);
 
 	free_kclist_ents(&garbage);
@@ -429,7 +432,8 @@ read_kcore(struct file *file, char __use
 	unsigned long start;
 
 	read_lock(&kclist_lock);
-	proc_root_kcore->size = size = get_kcore_size(&nphdr, &elf_buflen);
+	size = get_kcore_size(&nphdr, &elf_buflen);
+
 	if (buflen == 0 || *fpos >= size) {
 		read_unlock(&kclist_lock);
 		return 0;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

