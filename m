Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2100C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 21:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiFAV2H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 17:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiFAV2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 17:28:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368BC60072
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 14:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C95E5613EF
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 21:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276E5C385A5;
        Wed,  1 Jun 2022 21:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654118883;
        bh=D31aRIdAFHWNESO8Mmm0YWYr9AbNlT7nDRlolmqVDAk=;
        h=Date:To:From:Subject:From;
        b=N9JYjxj95oiJE2k4M8tPT3M5Eq+GLrksZ9KM7RWOWPH1T/pNK9jsanFkfIj9NVgS0
         lulN8iKS/LRio8oFOA6gOrwdk8aG43c8qe+okApUl2JAAVcsx/tB4ah0BNAoVR0t1k
         svEaQwDEgfixpR+39GgHCxLc6dne2mn0yI9jZAHY=
Date:   Wed, 01 Jun 2022 14:28:02 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        kent.overstreet@gmail.com, hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch added to mm-unstable branch
Message-Id: <20220601212803.276E5C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shrinkers: add scan interface for shrinker debugfs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch

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
Subject: mm: shrinkers: add scan interface for shrinker debugfs
Date: Tue, 31 May 2022 20:22:27 -0700

Add a scan interface which allows to trigger scanning of a particular
shrinker and specify memcg and numa node.  It's useful for testing,
debugging and profiling of a specific scan_objects() callback.  Unlike
alternatives (creating a real memory pressure and dropping caches via
/proc/sys/vm/drop_caches) this interface allows to interact with only one
shrinker at once.  Also, if a shrinker is misreporting the number of
objects (as some do), it doesn't affect scanning.

Link: https://lkml.kernel.org/r/20220601032227.4076670-7-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/shrinker_debugfs.rst |   39 +++++-
 mm/shrinker_debug.c                               |   74 ++++++++++++
 2 files changed, 109 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/shrinker_debugfs.rst~mm-shrinkers-add-scan-interface-for-shrinker-debugfs
+++ a/Documentation/admin-guide/mm/shrinker_debugfs.rst
@@ -5,14 +5,16 @@ Shrinker Debugfs Interface
 ==========================
 
 Shrinker debugfs interface provides a visibility into the kernel memory
-shrinkers subsystem and allows to get information about individual shrinkers.
+shrinkers subsystem and allows to get information about individual shrinkers
+and interact with them.
 
 For each shrinker registered in the system a directory in **<debugfs>/shrinker/**
 is created. The directory's name is composed from the shrinker's name and an
 unique id: e.g. *kfree_rcu-0* or *sb-xfs:vda1-36*.
 
-Each shrinker directory contains the **count** file, which allows to trigger
-the *count_objects()* callback for each memcg and numa node (if applicable).
+Each shrinker directory contains **count** and **scan** files, which allow to
+trigger *count_objects()* and *scan_objects()* callbacks for each memcg and
+numa node (if applicable).
 
 Usage:
 ------
@@ -43,7 +45,7 @@ Usage:
 
     $ cd sb-btrfs\:vda2-24/
     $ ls
-    count
+    count            scan
 
 3. *Count objects*
 
@@ -102,3 +104,32 @@ Usage:
     2877 84 0
     293 1 0
     735 8 0
+
+4. *Scan objects*
+
+  The expected input format::
+
+    <cgroup inode id> <numa id> <number of objects to scan>
+
+  For a non-memcg-aware shrinker or on a system with no memory
+  cgrups **0** should be passed as cgroup id.
+  ::
+
+    $ cd /sys/kernel/debug/shrinker/
+    $ cd sb-btrfs\:vda2-24/
+
+    $ cat count | head -n 5
+    1 212 0
+    21 97 0
+    55 802 5
+    2367 2 0
+    225 13 0
+
+    $ echo "55 0 200" > scan
+
+    $ cat count | head -n 5
+    1 212 0
+    21 96 0
+    55 752 5
+    2367 2 0
+    225 13 0
--- a/mm/shrinker_debug.c~mm-shrinkers-add-scan-interface-for-shrinker-debugfs
+++ a/mm/shrinker_debug.c
@@ -99,6 +99,78 @@ static int shrinker_debugfs_count_show(s
 }
 DEFINE_SHOW_ATTRIBUTE(shrinker_debugfs_count);
 
+static int shrinker_debugfs_scan_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t shrinker_debugfs_scan_write(struct file *file,
+					   const char __user *buf,
+					   size_t size, loff_t *pos)
+{
+	struct shrinker *shrinker = file->private_data;
+	unsigned long nr_to_scan = 0, ino;
+	struct shrink_control sc = {
+		.gfp_mask = GFP_KERNEL,
+	};
+	struct mem_cgroup *memcg = NULL;
+	int nid;
+	char kbuf[72];
+	int read_len = size < (sizeof(kbuf) - 1) ? size : (sizeof(kbuf) - 1);
+	ssize_t ret;
+
+	if (copy_from_user(kbuf, buf, read_len))
+		return -EFAULT;
+	kbuf[read_len] = '\0';
+
+	if (sscanf(kbuf, "%lu %d %lu", &ino, &nid, &nr_to_scan) < 2)
+		return -EINVAL;
+
+	if (nid < 0 || nid >= nr_node_ids)
+		return -EINVAL;
+
+	if (nr_to_scan == 0)
+		return size;
+
+	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
+		memcg = mem_cgroup_get_from_ino(ino);
+		if (!memcg || IS_ERR(memcg))
+			return -ENOENT;
+
+		if (!mem_cgroup_online(memcg)) {
+			mem_cgroup_put(memcg);
+			return -ENOENT;
+		}
+	} else if (ino != 0) {
+		return -EINVAL;
+	}
+
+	ret = down_read_killable(&shrinker_rwsem);
+	if (ret) {
+		mem_cgroup_put(memcg);
+		return ret;
+	}
+
+	sc.nid = nid;
+	sc.memcg = memcg;
+	sc.nr_to_scan = nr_to_scan;
+	sc.nr_scanned = nr_to_scan;
+
+	shrinker->scan_objects(shrinker, &sc);
+
+	up_read(&shrinker_rwsem);
+	mem_cgroup_put(memcg);
+
+	return size;
+}
+
+static const struct file_operations shrinker_debugfs_scan_fops = {
+	.owner	 = THIS_MODULE,
+	.open	 = shrinker_debugfs_scan_open,
+	.write	 = shrinker_debugfs_scan_write,
+};
+
 int shrinker_debugfs_add(struct shrinker *shrinker)
 {
 	struct dentry *entry;
@@ -128,6 +200,8 @@ int shrinker_debugfs_add(struct shrinker
 
 	debugfs_create_file("count", 0220, entry, shrinker,
 			    &shrinker_debugfs_count_fops);
+	debugfs_create_file("scan", 0440, entry, shrinker,
+			    &shrinker_debugfs_scan_fops);
 	return 0;
 }
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch
mm-shrinkers-provide-shrinkers-with-names.patch
mm-docs-document-shrinker-debugfs.patch
tools-add-memcg_shrinkerpy.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch

