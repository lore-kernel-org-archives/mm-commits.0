From: akpm@linux-foundation.org
Subject: [folded] cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:46:54 -0700
Message-ID: <200906172246.n5HMksFN007182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342AbZFQWrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix-2
has been removed from the -mm tree.  Its filename was
     cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch

This patch was dropped because it was folded into cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix-2
From: Li Zefan <lizf@cn.fujitsu.com>

Explain more on the noprefix option.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2 kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2
+++ a/kernel/cgroup.c
@@ -891,7 +891,11 @@ static int parse_cgroupfs_options(char *
 		}
 	}
 
-	/* We allow noprefix only if mounting just the cpuset subsystem */
+	/*
+	 * Option noprefix was introduced just for backward compatibility
+	 * with the old cpuset, so we allow noprefix only if mounting just
+	 * the cpuset subsystem.
+	 */
 	if (test_bit(ROOT_NOPREFIX, &opts->flags) &&
 	    (opts->subsys_bits & mask))
 		return -EINVAL;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cgroups-make-messages-more-readable.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch
memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch
memcg-add-interface-to-reset-limits.patch

