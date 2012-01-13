From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-remove-unneeded-checks-from-uncharge_page.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:53 -0800
Message-ID: <20120113203353.AF0991E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:57077 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:54 -0500
Received: by yhjj52 with SMTP id j52so101969yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: remove unneeded checks from uncharge_page()
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-unneeded-checks-from-uncharge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: remove unneeded checks from uncharge_page()

mem_cgroup_uncharge_page() is only called on either freshly allocated
pages without page->mapping or on rmapped PageAnon() pages.  There is no
need to check for a page->mapping that is not an anon_vma.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-unneeded-checks-from-uncharge_page mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-unneeded-checks-from-uncharge_page
+++ a/mm/memcontrol.c
@@ -3061,8 +3061,7 @@ void mem_cgroup_uncharge_page(struct pag
 	/* early check. */
 	if (page_mapped(page))
 		return;
-	if (page->mapping && !PageAnon(page))
-		return;
+	VM_BUG_ON(page->mapping && !PageAnon(page));
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_MAPPED);
 }
 
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

