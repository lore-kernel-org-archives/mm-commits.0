Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA349C43334
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 21:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiFAV2G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 17:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiFAV2D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 17:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F48104CA4
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 14:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3FCE6132A
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 21:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4279EC385A5;
        Wed,  1 Jun 2022 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654118881;
        bh=ufIS5TphTnSYkElGjmACd0Io984oiYWFMnP+2CImBo0=;
        h=Date:To:From:Subject:From;
        b=LfiMIwKv7JtOOE7M46wIvfCJ/BXyBAEsIG260a/TG1VRyefqmatpwVr8j2fUhGxDp
         V1youDYTkGGMuk+X7BkBjBs5ADiodOSxDHFIx5COwkFfJjWU0akN1NHCOtpa0wMYdX
         sqb5SszM0RkKkElwFDDZmaC7anbmW4aYvf/bXt6M=
Date:   Wed, 01 Jun 2022 14:28:00 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        kent.overstreet@gmail.com, hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-add-memcg_shrinkerpy.patch added to mm-unstable branch
Message-Id: <20220601212801.4279EC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: add memcg_shrinker.py
has been added to the -mm mm-unstable branch.  Its filename is
     tools-add-memcg_shrinkerpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-add-memcg_shrinkerpy.patch

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

mm-memcontrol-introduce-mem_cgroup_ino-and-mem_cgroup_get_from_ino.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers.patch
mm-shrinkers-provide-shrinkers-with-names.patch
mm-docs-document-shrinker-debugfs.patch
tools-add-memcg_shrinkerpy.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs.patch

