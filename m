From: akpm@linux-foundation.org
Subject: + mm-memcg-avoid-page-count-check-for-zone-device.patch added to
 -mm tree
Date: Thu, 14 Sep 2017 12:54:16 -0700
Message-ID: <59bade68.cCjiykG5IZBY77Uc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38862 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdINTyR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2017 15:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: avoid page count check for zone device
has been added to the -mm tree.  Its filename is
     mm-memcg-avoid-page-count-check-for-zone-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-avoid-page-count-check-for-zone-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-avoid-page-count-check-for-zone-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/memcg: avoid page count check for zone device

Fix for 4.14, zone device page always have an elevated refcount of one and
thus page count sanity check in uncharge_page() is inappropriate for them.

Link: http://lkml.kernel.org/r/20170914190011.5217-1-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Reported-by: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
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
+	VM_BUG_ON_PAGE(!PageHWPoison(page) && !is_zone_device_page(page) &&
+			page_count(page), page);
 
 	if (!page->mem_cgroup)
 		return;
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memcg-avoid-page-count-check-for-zone-device.patch

