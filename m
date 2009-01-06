From: akpm@linux-foundation.org
Subject: - vfs-factor-out-duplicated-code-in-get_fs_type.patch removed from -mm tree
Date: Tue, 06 Jan 2009 11:59:02 -0800
Message-ID: <200901061959.n06Jx2wc031838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbZAFT7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 14:59:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: factor out duplicated code in get_fs_type()
has been removed from the -mm tree.  Its filename was
     vfs-factor-out-duplicated-code-in-get_fs_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: factor out duplicated code in get_fs_type()
From: Li Zefan <lizf@cn.fujitsu.com>

save 14 bytes:

   text    data     bss     dec     hex filename
   1354      32       4    1390     56e fs/filesystems.o.before
   text    data     bss     dec     hex filename
   1340      32       4    1376     560 fs/filesystems.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/filesystems.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN fs/filesystems.c~vfs-factor-out-duplicated-code-in-get_fs_type fs/filesystems.c
--- a/fs/filesystems.c~vfs-factor-out-duplicated-code-in-get_fs_type
+++ a/fs/filesystems.c
@@ -253,24 +253,27 @@ static int __init proc_filesystems_init(
 module_init(proc_filesystems_init);
 #endif
 
-struct file_system_type *get_fs_type(const char *name)
+static struct file_system_type *__get_fs_type(const char *name, int len)
 {
 	struct file_system_type *fs;
-	const char *dot = strchr(name, '.');
-	unsigned len = dot ? dot - name : strlen(name);
 
 	read_lock(&file_systems_lock);
 	fs = *(find_filesystem(name, len));
 	if (fs && !try_module_get(fs->owner))
 		fs = NULL;
 	read_unlock(&file_systems_lock);
-	if (!fs && (request_module("%.*s", len, name) == 0)) {
-		read_lock(&file_systems_lock);
-		fs = *(find_filesystem(name, len));
-		if (fs && !try_module_get(fs->owner))
-			fs = NULL;
-		read_unlock(&file_systems_lock);
-	}
+	return fs;
+}
+
+struct file_system_type *get_fs_type(const char *name)
+{
+	struct file_system_type *fs;
+	const char *dot = strchr(name, '.');
+	int len = dot ? dot - name : strlen(name);
+
+	fs = __get_fs_type(name, len);
+	if (!fs && (request_module("%.*s", len, name) == 0))
+		fs = __get_fs_type(name, len);
 
 	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
 		put_filesystem(fs);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
cgroups-make-cgroup_path-rcu-safe.patch
cgroups-make-cgroup_path-rcu-safe-fixlet.patch
devices-cgroup-allow-mkfifo.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-swapout-refcnt-fix.patch
memcg-fix-double-free-and-make-refcnt-sane.patch
memcg-use-css_tryget-in-memcg.patch
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_sprintf_cpulist.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_can_attach.patch
cpuset-convert-cpuset_attach-to-use-cpumask_var_t.patch
cpuset-dont-allocate-trial-cpuset-on-stack.patch
cpuset-convert-cpuset-cpus_allowed-to-cpumask_var_t.patch
cpuset-remove-remaining-pointers-to-cpumask_t.patch

