From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-avoid-page-count-check-for-zone-device.patch removed from -mm tree
Date: Wed, 04 Oct 2017 12:40:31 -0700
Message-ID: <20171004194031.YIN63Tuj2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbdJDTkc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebaskakov@nvidia.com, hannes@cmpxchg.org, jglisse@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, vdavydov.dev@gmail.com


The patch titled
     Subject: mm/memcg: avoid page count check for zone device
has been removed from the -mm tree.  Its filename was
     mm-memcg-avoid-page-count-check-for-zone-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/memcg: avoid page count check for zone device

Fix for 4.14, zone device page always have an elevated refcount of one and
thus page count sanity check in uncharge_page() is inappropriate for them.

[mhocko@suse.com: nano-optimize VM_BUG_ON in uncharge_page]
Link: http://lkml.kernel.org/r/20170914190011.5217-1-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-avoid-page-count-check-for-zone-device mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-avoid-page-count-check-for-zone-device
+++ a/mm/memcontrol.c
@@ -5658,7 +5658,8 @@ static void uncharge_batch(const struct
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 {
 	VM_BUG_ON_PAGE(PageLRU(page), page);
-	VM_BUG_ON_PAGE(!PageHWPoison(page) && page_count(page), page);
+	VM_BUG_ON_PAGE(page_count(page) && !is_zone_device_page(page) &&
+			!PageHWPoison(page) , page);
 
 	if (!page->mem_cgroup)
 		return;
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-mmu_notifier-avoid-double-notification-when-it-is-useless.patch

