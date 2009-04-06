From: akpm@linux-foundation.org
Subject: [merged] cgroups-dont-change-release_agent-when-remount-failed.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:19 -0700
Message-ID: <200904061934.n36JYJ6i011571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756719AbZDFTgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: don't change release_agent when remount failed
has been removed from the -mm tree.  Its filename was
     cgroups-dont-change-release_agent-when-remount-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch

