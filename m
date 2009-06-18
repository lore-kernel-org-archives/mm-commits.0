From: akpm@linux-foundation.org
Subject: [merged] cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:45:17 -0700
Message-ID: <200906182245.n5IMjH7H004296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758271AbZFRW6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: forbid noprefix if mounting more than just cpuset subsystem
has been removed from the -mm tree.  Its filename was
     cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: forbid noprefix if mounting more than just cpuset subsystem
From: Li Zefan <lizf@cn.fujitsu.com>

The 'noprefix' option was introduced for backwards-compatibility of
cpuset, but actually it can be used when mounting other subsystems.

This results in possibility of name collision, and now the collision can
really happen, because we have 'stat' file in both memory and cpuacct
subsystem:

	# mount -t cgroup -o noprefix,memory,cpuacct xxx /mnt

Cgroup will happily mount the 2 subsystems, but only 'stat' file of memory
subsys can be seen.

We don't want users to use nopreifx, and also want to avoid name
collision, so we change to allow noprefix only if mounting just the cpuset
subsystem.

[akpm@linux-foundation.org: fix shift for cpuset_subsys_id >= 32]
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN kernel/cgroup.c~cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem
+++ a/kernel/cgroup.c
@@ -843,6 +843,11 @@ static int parse_cgroupfs_options(char *
 				     struct cgroup_sb_opts *opts)
 {
 	char *token, *o = data ?: "all";
+	unsigned long mask = (unsigned long)-1;
+
+#ifdef CONFIG_CPUSETS
+	mask = ~(1UL << cpuset_subsys_id);
+#endif
 
 	opts->subsys_bits = 0;
 	opts->flags = 0;
@@ -887,6 +892,15 @@ static int parse_cgroupfs_options(char *
 		}
 	}
 
+	/*
+	 * Option noprefix was introduced just for backward compatibility
+	 * with the old cpuset, so we allow noprefix only if mounting just
+	 * the cpuset subsystem.
+	 */
+	if (test_bit(ROOT_NOPREFIX, &opts->flags) &&
+	    (opts->subsys_bits & mask))
+		return -EINVAL;
+
 	/* We can't have an empty hierarchy */
 	if (!opts->subsys_bits)
 		return -EINVAL;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch

