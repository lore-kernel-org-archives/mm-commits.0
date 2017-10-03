From: akpm@linux-foundation.org
Subject: [patch 14/51] mm/memcg: avoid page count check for zone device
Date: Tue, 03 Oct 2017 16:14:57 -0700
Message-ID: <59d419f1.ngn5z9piT2OnoMdc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58480 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jglisse@redhat.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov.dev@gmail.com

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
