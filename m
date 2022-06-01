Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B957CC43334
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 21:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiFAV1s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 17:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiFAV1q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 17:27:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD95AB7F1
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 14:27:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C8D16132A
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 21:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEE4C385A5;
        Wed,  1 Jun 2022 21:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654118862;
        bh=Uj4anoKT+ORvWgcrewRjvUieyJxy9YzrHxHVf6XFo7M=;
        h=Date:To:From:Subject:From;
        b=C+Z88V4qNGcHEpDnRpJbYtwDHHKZrXqLtdw062T8MZ89IUwUgjRCXHZTgwyMJUn6h
         mxl9xUSOjEnGvsG1mZX8CHp1iaUw+7mFTnkEnrFlkeiW4urwCibxJJQu8NFidyDGop
         cGf10Pql0feU+NnpDzJ4dWSMKgbttXGTYE3rf0K8=
Date:   Wed, 01 Jun 2022 14:27:41 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        kent.overstreet@gmail.com, hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch added to mm-unstable branch
Message-Id: <20220601212742.6EEE4C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shrinkers: introduce debugfs interface for memory shrinkers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: shrinkers: introduce debugfs interface for memory shrinkers
Date: Tue, 31 May 2022 20:22:23 -0700

This commit introduces the /sys/kernel/debug/shrinker debugfs interface
which provides an ability to observe the state of individual kernel memory
shrinkers.

Because the feature adds some memory overhead (which shouldn't be large
unless there is a huge amount of registered shrinkers), it's guarded by a
config option (enabled by default).

This commit introduces the "count" interface for each shrinker registered
in the system.

The output is in the following format:
<cgroup inode id> <nr of objects on node 0> <nr of objects on node 1>...
<cgroup inode id> <nr of objects on node 0> <nr of objects on node 1>...
...

To reduce the size of output on machines with many thousands cgroups, if
the total number of objects on all nodes is 0, the line is omitted.

If the shrinker is not memcg-aware or CONFIG_MEMCG is off, 0 is printed as
cgroup inode id.  If the shrinker is not numa-aware, 0's are printed for
all nodes except the first one.

This commit gives debugfs entries simple numeric names, which are not very
convenient.  The following commit in the series will provide shrinkers
with more meaningful names.

Link: https://lkml.kernel.org/r/20220601032227.4076670-3-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |   19 +++-
 lib/Kconfig.debug        |    9 +
 mm/Makefile              |    1 
 mm/shrinker_debug.c      |  168 +++++++++++++++++++++++++++++++++++++
 mm/vmscan.c              |    6 -
 5 files changed, 200 insertions(+), 3 deletions(-)

--- a/include/linux/shrinker.h~mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers
+++ a/include/linux/shrinker.h
@@ -73,6 +73,10 @@ struct shrinker {
 	/* ID in shrinker_idr */
 	int id;
 #endif
+#ifdef CONFIG_SHRINKER_DEBUG
+	int debugfs_id;
+	struct dentry *debugfs_entry;
+#endif
 	/* objs pending delete, per node */
 	atomic_long_t *nr_deferred;
 };
@@ -94,4 +98,17 @@ extern int register_shrinker(struct shri
 extern void unregister_shrinker(struct shrinker *shrinker);
 extern void free_prealloced_shrinker(struct shrinker *shrinker);
 extern void synchronize_shrinkers(void);
-#endif
+
+#ifdef CONFIG_SHRINKER_DEBUG
+extern int shrinker_debugfs_add(struct shrinker *shrinker);
+extern void shrinker_debugfs_remove(struct shrinker *shrinker);
+#else /* CONFIG_SHRINKER_DEBUG */
+static inline int shrinker_debugfs_add(struct shrinker *shrinker)
+{
+	return 0;
+}
+static inline void shrinker_debugfs_remove(struct shrinker *shrinker)
+{
+}
+#endif /* CONFIG_SHRINKER_DEBUG */
+#endif /* _LINUX_SHRINKER_H */
--- a/lib/Kconfig.debug~mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers
+++ a/lib/Kconfig.debug
@@ -699,6 +699,15 @@ config DEBUG_OBJECTS_ENABLE_DEFAULT
 	help
 	  Debug objects boot parameter default value
 
+config SHRINKER_DEBUG
+	default y
+	bool "Enable shrinker debugging support"
+	depends on DEBUG_FS
+	help
+	  Say Y to enable the shrinker debugfs interface which provides
+	  visibility into the kernel memory shrinkers subsystem.
+	  Disable it to avoid an extra memory footprint.
+
 config HAVE_DEBUG_KMEMLEAK
 	bool
 
--- a/mm/Makefile~mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers
+++ a/mm/Makefile
@@ -133,3 +133,4 @@ obj-$(CONFIG_PAGE_REPORTING) += page_rep
 obj-$(CONFIG_IO_MAPPING) += io-mapping.o
 obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
 obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
+obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
--- /dev/null
+++ a/mm/shrinker_debug.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/shrinker.h>
+#include <linux/memcontrol.h>
+
+/* defined in vmscan.c */
+extern struct rw_semaphore shrinker_rwsem;
+extern struct list_head shrinker_list;
+
+static DEFINE_IDA(shrinker_debugfs_ida);
+static struct dentry *shrinker_debugfs_root;
+
+static unsigned long shrinker_count_objects(struct shrinker *shrinker,
+					    struct mem_cgroup *memcg,
+					    unsigned long *count_per_node)
+{
+	unsigned long nr, total = 0;
+	int nid;
+
+	for_each_node(nid) {
+		if (nid == 0 || (shrinker->flags & SHRINKER_NUMA_AWARE)) {
+			struct shrink_control sc = {
+				.gfp_mask = GFP_KERNEL,
+				.nid = nid,
+				.memcg = memcg,
+			};
+
+			nr = shrinker->count_objects(shrinker, &sc);
+			if (nr == SHRINK_EMPTY)
+				nr = 0;
+		} else {
+			nr = 0;
+		}
+
+		count_per_node[nid] = nr;
+		total += nr;
+	}
+
+	return total;
+}
+
+static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
+{
+	struct shrinker *shrinker = m->private;
+	unsigned long *count_per_node;
+	struct mem_cgroup *memcg;
+	unsigned long total;
+	bool memcg_aware;
+	int ret, nid;
+
+	count_per_node = kcalloc(nr_node_ids, sizeof(unsigned long), GFP_KERNEL);
+	if (!count_per_node)
+		return -ENOMEM;
+
+	ret = down_read_killable(&shrinker_rwsem);
+	if (ret) {
+		kfree(count_per_node);
+		return ret;
+	}
+	rcu_read_lock();
+
+	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
+
+	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	do {
+		if (memcg && !mem_cgroup_online(memcg))
+			continue;
+
+		total = shrinker_count_objects(shrinker,
+					       memcg_aware ? memcg : NULL,
+					       count_per_node);
+		if (total) {
+			seq_printf(m, "%lu", mem_cgroup_ino(memcg));
+			for_each_node(nid)
+				seq_printf(m, " %lu", count_per_node[nid]);
+			seq_putc(m, '\n');
+		}
+
+		if (!memcg_aware) {
+			mem_cgroup_iter_break(NULL, memcg);
+			break;
+		}
+
+		if (signal_pending(current)) {
+			mem_cgroup_iter_break(NULL, memcg);
+			ret = -EINTR;
+			break;
+		}
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
+
+	rcu_read_unlock();
+	up_read(&shrinker_rwsem);
+
+	kfree(count_per_node);
+	return ret;
+}
+DEFINE_SHOW_ATTRIBUTE(shrinker_debugfs_count);
+
+int shrinker_debugfs_add(struct shrinker *shrinker)
+{
+	struct dentry *entry;
+	char buf[16];
+	int id;
+
+	lockdep_assert_held(&shrinker_rwsem);
+
+	/* debugfs isn't initialized yet, add debugfs entries later. */
+	if (!shrinker_debugfs_root)
+		return 0;
+
+	id = ida_alloc(&shrinker_debugfs_ida, GFP_KERNEL);
+	if (id < 0)
+		return id;
+	shrinker->debugfs_id = id;
+
+	snprintf(buf, sizeof(buf), "%d", id);
+
+	/* create debugfs entry */
+	entry = debugfs_create_dir(buf, shrinker_debugfs_root);
+	if (IS_ERR(entry)) {
+		ida_free(&shrinker_debugfs_ida, id);
+		return PTR_ERR(entry);
+	}
+	shrinker->debugfs_entry = entry;
+
+	debugfs_create_file("count", 0220, entry, shrinker,
+			    &shrinker_debugfs_count_fops);
+	return 0;
+}
+
+void shrinker_debugfs_remove(struct shrinker *shrinker)
+{
+	lockdep_assert_held(&shrinker_rwsem);
+
+	if (!shrinker->debugfs_entry)
+		return;
+
+	debugfs_remove_recursive(shrinker->debugfs_entry);
+	ida_free(&shrinker_debugfs_ida, shrinker->debugfs_id);
+}
+
+static int __init shrinker_debugfs_init(void)
+{
+	struct shrinker *shrinker;
+	struct dentry *dentry;
+	int ret = 0;
+
+	dentry = debugfs_create_dir("shrinker", NULL);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+	shrinker_debugfs_root = dentry;
+
+	/* Create debugfs entries for shrinkers registered at boot */
+	down_write(&shrinker_rwsem);
+	list_for_each_entry(shrinker, &shrinker_list, list)
+		if (!shrinker->debugfs_entry) {
+			ret = shrinker_debugfs_add(shrinker);
+			if (ret)
+				break;
+		}
+	up_write(&shrinker_rwsem);
+
+	return ret;
+}
+late_initcall(shrinker_debugfs_init);
--- a/mm/vmscan.c~mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers
+++ a/mm/vmscan.c
@@ -190,8 +190,8 @@ static void set_task_reclaim_state(struc
 	task->reclaim_state = rs;
 }
 
-static LIST_HEAD(shrinker_list);
-static DECLARE_RWSEM(shrinker_rwsem);
+LIST_HEAD(shrinker_list);
+DECLARE_RWSEM(shrinker_rwsem);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
@@ -650,6 +650,7 @@ void register_shrinker_prepared(struct s
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
 	shrinker->flags |= SHRINKER_REGISTERED;
+	WARN_ON_ONCE(shrinker_debugfs_add(shrinker));
 	up_write(&shrinker_rwsem);
 }
 
@@ -677,6 +678,7 @@ void unregister_shrinker(struct shrinker
 	shrinker->flags &= ~SHRINKER_REGISTERED;
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
+	shrinker_debugfs_remove(shrinker);
 	up_write(&shrinker_rwsem);
 
 	kfree(shrinker->nr_deferred);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch
mm-shrinkers-provide-shrinkers-with-names.patch
mm-docs-document-shrinker-debugfs.patch
tools-add-memcg_shrinkerpy.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch

