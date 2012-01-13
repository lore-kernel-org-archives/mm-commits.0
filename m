From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-remove-unneeded-checks-from-newpage_charge.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:49 -0800
Message-ID: <20120113203350.21C5020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37836 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab2AMUdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:52 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25396eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: remove unneeded checks from newpage_charge()
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-unneeded-checks-from-newpage_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: remove unneeded checks from newpage_charge()

All callsites pass in freshly allocated pages and a valid mm.  As a
result, all checks pertaining to the page's mapcount, page->mapping or the
fallback to init_mm are unneeded.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-unneeded-checks-from-newpage_charge mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-unneeded-checks-from-newpage_charge
+++ a/mm/memcontrol.c
@@ -2748,19 +2748,11 @@ int mem_cgroup_newpage_charge(struct pag
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	/*
-	 * If already mapped, we don't have to account.
-	 * If page cache, page->mapping has address_space.
-	 * But page->mapping may have out-of-use anon_vma pointer,
-	 * detecit it by PageAnon() check. newly-mapped-anon's page->mapping
-	 * is NULL.
-  	 */
-	if (page_mapped(page) || (page->mapping && !PageAnon(page)))
-		return 0;
-	if (unlikely(!mm))
-		mm = &init_mm;
+	VM_BUG_ON(page_mapped(page));
+	VM_BUG_ON(page->mapping && !PageAnon(page));
+	VM_BUG_ON(!mm);
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_MAPPED);
+					MEM_CGROUP_CHARGE_TYPE_MAPPED);
 }
 
 static void
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

