From: akpm@linux-foundation.org
Subject: + memcg-fix-section-mismatch.patch added to -mm tree
Date: Wed, 14 Jan 2009 13:58:41 -0800
Message-ID: <200901142158.n0ELwfVY009905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbZANV7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 16:59:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, rakib.mullick@gmail.com


The patch titled
     memcg: fix section mismatch
has been added to the -mm tree.  Its filename is
     memcg-fix-section-mismatch.patch

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
Subject: memcg: fix section mismatch
From: Li Zefan <lizf@cn.fujitsu.com>

At system boot when creating the top cgroup, mem_cgroup_create() calls
enable_swap_cgroup() which is marked as __init, so mark
mem_cgroup_create() as __ref to avoid false section mismatch warning.

Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by; KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-section-mismatch mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-section-mismatch
+++ a/mm/memcontrol.c
@@ -2202,7 +2202,7 @@ static void __init enable_swap_cgroup(vo
 }
 #endif
 
-static struct cgroup_subsys_state *
+static struct cgroup_subsys_state * __ref
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct mem_cgroup *mem, *parent;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cgroups-clean-up-kconfig.patch
cgroups-consolidate-cgroup-documents.patch
idr-fix-wrong-kernel-doc.patch
memcg-fix-mem_cgroup_get_reclaim_stat_from_page.patch
memcg-fix-error-path-of-mem_cgroup_move_parent.patch
memcg-fix-hierarchical-reclaim.patch
memcg-make-oom-less-frequently.patch
memcg-fix-section-mismatch.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch

