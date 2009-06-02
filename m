From: akpm@linux-foundation.org
Subject: + cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch added to -mm tree
Date: Mon, 01 Jun 2009 23:54:54 -0700
Message-ID: <200906020654.n526ssMn013684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758301AbZFBGzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 02:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix-2
has been added to the -mm tree.  Its filename is
     cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch

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
linux-next.patch
mm-add-swap-cache-interface-for-swap-reference.patch
mm-modify-swap_map-and-add-swap_has_cache-flag.patch
mm-reuse-unused-swap-entry-if-necessary.patch
hexdump-remove-the-trailing-space.patch
cgroups-make-messages-more-readable.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch
memcg-fix-swap-accounting.patch

