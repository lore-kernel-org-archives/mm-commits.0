Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE07C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiGDBKL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiGDBJt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698656305
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14B65B80BEB
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C230AC341C7;
        Mon,  4 Jul 2022 01:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896985;
        bh=XvLxCcphg7Y0ma/rnwd36G3fHRtThSYNWzRMtvwvR0U=;
        h=Date:To:From:Subject:From;
        b=FluUmZ0gV9dMSSSKZZPFqA048bfdBWoi2byKx82w23Cy2zhGbqOa+e8p1oR0Z8yGH
         ZK1gXFyBJ8pjtvmDQ7FZRXR2ce5anBo8Q/ateHNpBVcrSiN2/TUoglkokcBQG9j0DR
         +T9fqY8t/DBvP87NEV1oGpFVmZwSTyZqHDbwTXwQ=
Date:   Sun, 03 Jul 2022 18:09:45 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        kent.overstreet@gmail.com, hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-add-memcg_shrinkerpy.patch removed from -mm tree
Message-Id: <20220704010945.C230AC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools: add memcg_shrinker.py
has been removed from the -mm tree.  Its filename was
     tools-add-memcg_shrinkerpy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: tools: add memcg_shrinker.py
Date: Tue, 31 May 2022 20:22:26 -0700

Add a simple tool which prints a sorted list of shrinker lists in the
following format: (number of objects, shrinker name, cgroup).

Example:
  $ ./memcg_shrinker.py -n 10
  2090     sb-sysfs-26          /sys/fs/cgroup/system.slice
  1809     sb-sysfs-26          /sys/fs/cgroup/system.slice/systemd-udevd.service
  1044     sb-btrfs:vda2-24     /sys/fs/cgroup/system.slice/system-dbus\x2d:1.3\...
  861      sb-btrfs:vda2-24     /sys/fs/cgroup/system.slice/system-dbus\x2d:1.3\...
  804      sb-btrfs:vda2-24     /sys/fs/cgroup/system.slice
  643      sb-btrfs:vda2-24     /sys/fs/cgroup/system.slice/firewalld.service
  616      sb-cgroup2-30        /sys/fs/cgroup/init.scope
  275      sb-sysfs-26          /
  238      sb-proc-25           /sys/fs/cgroup/system.slice/systemd-journald.service
  225      sb-proc-25           /sys/fs/cgroup/system.slice/abrtd.service

Link: https://lkml.kernel.org/r/20220601032227.4076670-6-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/cgroup/memcg_shrinker.py |   71 +++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

--- /dev/null
+++ a/tools/cgroup/memcg_shrinker.py
@@ -0,0 +1,71 @@
+#!/usr/bin/env python3
+#
+# Copyright (C) 2022 Roman Gushchin <roman.gushchin@linux.dev>
+# Copyright (C) 2022 Meta
+
+import os
+import argparse
+import sys
+
+
+def scan_cgroups(cgroup_root):
+    cgroups = {}
+
+    for root, subdirs, _ in os.walk(cgroup_root):
+        for cgroup in subdirs:
+            path = os.path.join(root, cgroup)
+            ino = os.stat(path).st_ino
+            cgroups[ino] = path
+
+    # (memcg ino, path)
+    return cgroups
+
+
+def scan_shrinkers(shrinker_debugfs):
+    shrinkers = []
+
+    for root, subdirs, _ in os.walk(shrinker_debugfs):
+        for shrinker in subdirs:
+            count_path = os.path.join(root, shrinker, "count")
+            with open(count_path) as f:
+                for line in f.readlines():
+                    items = line.split(' ')
+                    ino = int(items[0])
+                    # (count, shrinker, memcg ino)
+                    shrinkers.append((int(items[1]), shrinker, ino))
+    return shrinkers
+
+
+def main():
+    parser = argparse.ArgumentParser(description='Display biggest shrinkers')
+    parser.add_argument('-n', '--lines', type=int, help='Number of lines to print')
+
+    args = parser.parse_args()
+
+    cgroups = scan_cgroups("/sys/fs/cgroup/")
+    shrinkers = scan_shrinkers("/sys/kernel/debug/shrinker/")
+    shrinkers = sorted(shrinkers, reverse = True, key = lambda x: x[0])
+
+    n = 0
+    for s in shrinkers:
+        count, name, ino = (s[0], s[1], s[2])
+        if count == 0:
+            break
+
+        if ino == 0 or ino == 1:
+            cg = "/"
+        else:
+            try:
+                cg = cgroups[ino]
+            except KeyError:
+                cg = "unknown (%d)" % ino
+
+        print("%-8s %-20s %s" % (count, name, cg))
+
+        n += 1
+        if args.lines and n >= args.lines:
+            break
+
+
+if __name__ == '__main__':
+    main()
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch
mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch

