From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcg-avoid-page-count-check-for-zone-device-fix.patch removed from -mm
 tree
Date: Tue, 03 Oct 2017 16:09:08 -0700
Message-ID: <59d41894.oTlVwmdXjBw1dIRi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58244 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdJCXJJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jglisse@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: nano-optimize VM_BUG_ON in uncharge_page
has been removed from the -mm tree.  Its filename was
     mm-memcg-avoid-page-count-check-for-zone-device-fix.patch

This patch was dropped because it was folded into mm-memcg-avoid-page-count-check-for-zone-device.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg: nano-optimize VM_BUG_ON in uncharge_page

Even though VM_BUG* is usually not compiled in there are systems which
enable CONFIG_DEBUG_VM by default.  VM_BUG_ON_PAGE in uncharge_page is not
very optimal for the normal case.  All pages should have counter==0 so
that is the first thing to check.  is_zone_device_page is nicely noop if
ZONE_DEVICE is not compiled in and finally HW poison pages should be least
probable.  So reorder the check to bail out as early as possible on normal
case.

Link: http://lkml.kernel.org/r/20170918063141.6coovns7cb45bfly@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-avoid-page-count-check-for-zone-device-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-avoid-page-count-check-for-zone-device-fix
+++ a/mm/memcontrol.c
@@ -5658,8 +5658,8 @@ static void uncharge_batch(const struct
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 {
 	VM_BUG_ON_PAGE(PageLRU(page), page);
-	VM_BUG_ON_PAGE(!PageHWPoison(page) && !is_zone_device_page(page) &&
-			page_count(page), page);
+	VM_BUG_ON_PAGE(page_count(page) && !is_zone_device_page(page) &&
+			!PageHWPoison(page) , page);
 
 	if (!page->mem_cgroup)
 		return;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom_reaper-skip-mm-structs-with-mmu-notifiers.patch
mm-memcg-remove-hotplug-locking-from-try_charge.patch
mm-memcg-avoid-page-count-check-for-zone-device.patch
mm-memory_hotplug-add-scheduling-point-to-__add_pages.patch
mm-page_alloc-add-scheduling-point-to-memmap_init_zone.patch
memremap-add-scheduling-point-to-devm_memremap_pages.patch
mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-do-not-fail-offlining-too-early.patch
mm-memory_hotplug-remove-timeout-from-__offline_memory.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch

