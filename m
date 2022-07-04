Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D08C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiGDBKJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGDBJs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B4362F3
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04B1CB80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDA3C341C6;
        Mon,  4 Jul 2022 01:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896984;
        bh=RwoIuJyH6Ua2iQ30UVGSRerR2mFVNO3MzQF/85eEMi8=;
        h=Date:To:From:Subject:From;
        b=rpdqJ7+ShLFjQr65jtvhWAGIsa9KYE7XMbD6Hb0UoIczxpDOFuV9PjtR9cHf6wmpe
         B1aJBF4OGsNZVvgat1Mj0SQ1CWIamXZxJlMWrFU+ApSTF6KnoURQXZ1PudyMGkF1J3
         Q3RhVvciiMCsYF34yv4uk2NWHJpmt+DPXIYdmeuA=
Date:   Sun, 03 Jul 2022 18:09:44 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        kent.overstreet@gmail.com, hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-docs-document-shrinker-debugfs.patch removed from -mm tree
Message-Id: <20220704010944.ACDA3C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: docs: document shrinker debugfs
has been removed from the -mm tree.  Its filename was
     mm-docs-document-shrinker-debugfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: docs: document shrinker debugfs
Date: Tue, 31 May 2022 20:22:25 -0700

Add a document describing the shrinker debugfs interface.

Link: https://lkml.kernel.org/r/20220601032227.4076670-5-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/index.rst            |    1 
 Documentation/admin-guide/mm/shrinker_debugfs.rst |  104 ++++++++++++
 2 files changed, 105 insertions(+)

--- a/Documentation/admin-guide/mm/index.rst~mm-docs-document-shrinker-debugfs
+++ a/Documentation/admin-guide/mm/index.rst
@@ -36,6 +36,7 @@ the Linux memory management.
    numa_memory_policy
    numaperf
    pagemap
+   shrinker_debugfs
    soft-dirty
    swap_numa
    transhuge
--- /dev/null
+++ a/Documentation/admin-guide/mm/shrinker_debugfs.rst
@@ -0,0 +1,104 @@
+.. _shrinker_debugfs:
+
+==========================
+Shrinker Debugfs Interface
+==========================
+
+Shrinker debugfs interface provides a visibility into the kernel memory
+shrinkers subsystem and allows to get information about individual shrinkers.
+
+For each shrinker registered in the system a directory in **<debugfs>/shrinker/**
+is created. The directory's name is composed from the shrinker's name and an
+unique id: e.g. *kfree_rcu-0* or *sb-xfs:vda1-36*.
+
+Each shrinker directory contains the **count** file, which allows to trigger
+the *count_objects()* callback for each memcg and numa node (if applicable).
+
+Usage:
+------
+
+1. *List registered shrinkers*
+
+  ::
+
+    $ cd /sys/kernel/debug/shrinker/
+    $ ls
+    dquota-cache-16     sb-devpts-28     sb-proc-47       sb-tmpfs-42
+    mm-shadow-18        sb-devtmpfs-5    sb-proc-48       sb-tmpfs-43
+    mm-zspool:zram0-34  sb-hugetlbfs-17  sb-pstore-31     sb-tmpfs-44
+    rcu-kfree-0         sb-hugetlbfs-33  sb-rootfs-2      sb-tmpfs-49
+    sb-aio-20           sb-iomem-12      sb-securityfs-6  sb-tracefs-13
+    sb-anon_inodefs-15  sb-mqueue-21     sb-selinuxfs-22  sb-xfs:vda1-36
+    sb-bdev-3           sb-nsfs-4        sb-sockfs-8      sb-zsmalloc-19
+    sb-bpf-32           sb-pipefs-14     sb-sysfs-26      thp-deferred_split-10
+    sb-btrfs:vda2-24    sb-proc-25       sb-tmpfs-1       thp-zero-9
+    sb-cgroup2-30       sb-proc-39       sb-tmpfs-27      xfs-buf:vda1-37
+    sb-configfs-23      sb-proc-41       sb-tmpfs-29      xfs-inodegc:vda1-38
+    sb-dax-11           sb-proc-45       sb-tmpfs-35
+    sb-debugfs-7        sb-proc-46       sb-tmpfs-40
+
+2. *Get information about a specific shrinker*
+
+  ::
+
+    $ cd sb-btrfs\:vda2-24/
+    $ ls
+    count
+
+3. *Count objects*
+
+  Each line in the output has the following format::
+
+    <cgroup inode id> <nr of objects on node 0> <nr of objects on node 1> ...
+    <cgroup inode id> <nr of objects on node 0> <nr of objects on node 1> ...
+    ...
+
+  If there are no objects on all numa nodes, a line is omitted. If there
+  are no objects at all, the output might be empty.
+
+  If the shrinker is not memcg-aware or CONFIG_MEMCG is off, 0 is printed
+  as cgroup inode id. If the shrinker is not numa-aware, 0's are printed
+  for all nodes except the first one.
+  ::
+
+    $ cat count
+    1 224 2
+    21 98 0
+    55 818 10
+    2367 2 0
+    2401 30 0
+    225 13 0
+    599 35 0
+    939 124 0
+    1041 3 0
+    1075 1 0
+    1109 1 0
+    1279 60 0
+    1313 7 0
+    1347 39 0
+    1381 3 0
+    1449 14 0
+    1483 63 0
+    1517 53 0
+    1551 6 0
+    1585 1 0
+    1619 6 0
+    1653 40 0
+    1687 11 0
+    1721 8 0
+    1755 4 0
+    1789 52 0
+    1823 888 0
+    1857 1 0
+    1925 2 0
+    1959 32 0
+    2027 22 0
+    2061 9 0
+    2469 799 0
+    2537 861 0
+    2639 1 0
+    2707 70 0
+    2775 4 0
+    2877 84 0
+    293 1 0
+    735 8 0
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

tools-add-memcg_shrinkerpy.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch
mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch

