From: akpm@linux-foundation.org
Subject: + cgroups-dont-change-release_agent-when-remount-failed.patch added to -mm tree
Date: Wed, 04 Mar 2009 13:32:01 -0800
Message-ID: <200903042132.n24LW24x004928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714AbZCDVcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:32:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cgroups: don't change release_agent when remount failed
has been added to the -mm tree.  Its filename is
     cgroups-dont-change-release_agent-when-remount-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: don't change release_agent when remount failed
From: Li Zefan <lizf@cn.fujitsu.com>

Remount can fail in either case:
  - wrong mount options is specified, or option 'noprefix' is changed.
  - a to-be-added subsys is already mounted/active.

When using remount to change 'release_agent', for the above former failure
case, remount will return errno with release_agent unchanged, but for the
latter case, remount will return EBUSY with relase_agent changed, which is
unexpected I think:

 # mount -t cgroup -o cpu xxx /cgrp1
 # mount -t cgroup -o cpuset,release_agent=agent1 yyy /cgrp2
 # cat /cgrp2/release_agent
 agent1
 # mount -t cgroup -o remount,cpuset,noprefix,release_agent=agent2 yyy /cgrp2
 mount: /cgrp2 not mounted already, or bad option
 # cat /cgrp2/release_agent
 agent1     <-- ok
 # mount -t cgroup -o remount,cpu,cpuset,release_agent=agent2 yyy /cgrp2
 mount: /cgrp2 is busy
 # cat /cgrp2/release_agent
 agent2     <-- unexpected!

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-dont-change-release_agent-when-remount-failed kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-dont-change-release_agent-when-remount-failed
+++ a/kernel/cgroup.c
@@ -915,10 +915,11 @@ static int cgroup_remount(struct super_b
 	}
 
 	ret = rebind_subsystems(root, opts.subsys_bits);
+	if (ret)
+		goto out_unlock;
 
 	/* (re)populate subsystem files */
-	if (!ret)
-		cgroup_populate_dir(cgrp);
+	cgroup_populate_dir(cgrp);
 
 	if (opts.release_agent)
 		strcpy(root->release_agent_path, opts.release_agent);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
cgroups-show-correct-file-mode-fix.patch
cgroups-dont-change-release_agent-when-remount-failed.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch
cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch

