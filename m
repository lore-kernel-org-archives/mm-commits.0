From: akpm@linux-foundation.org
Subject: [folded-merged]
 vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch removed from -mm tree
Date: Fri, 06 Jun 2014 14:09:43 -0700
Message-ID: <53922e17.OUPfFFP1TrERlGFc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbaFFVJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:09:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com

Subject: [folded-merged] vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch removed from -mm tree
To: hughd@google.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:09:43 -0700


The patch titled
     Subject:  vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o om-control-fix.patch
has been removed from the -mm tree.  Its filename was
     vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch

This patch was dropped because it was folded into vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject:  vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o om-control-fix.patch

mem_cgroup_swappiness() oopses immediately when booted with
cgroup_disable=memory.  Fix that in the obvious inelegant way for now -
though I hope we are moving towards a world in which almost all of the
mem_cgroup_disabled() tests will vanish, with a root_mem_cgroup which can
handle the basics even when disabled.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch
+++ a/mm/memcontrol.c
@@ -1550,7 +1550,7 @@ static unsigned long mem_cgroup_margin(s
 int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	/* root ? */
-	if (!css_parent(&memcg->css))
+	if (mem_cgroup_disabled() || !css_parent(&memcg->css))
 		return vm_swappiness;
 
 	return memcg->swappiness;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

