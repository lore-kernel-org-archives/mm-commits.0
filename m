From: akpm@linux-foundation.org
Subject: [patch 22/28] mm: migrate: fix an incorrect call of
 prep_transhuge_page()
Date: Wed, 29 Nov 2017 16:11:12 -0800
Message-ID: <5a1f4ca0.NpCyQY0OBbM1XmTS%akpm__45159.7933927134$1512000679$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752959AbdK3ALN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:11:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zi.yan@cs.rutgers.edu, ar@linux.vnet.ibm.com, jglisse@redhat.com, mhocko@kernel.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org

From: Zi Yan <zi.yan@cs.rutgers.edu>
Subject: mm: migrate: fix an incorrect call of prep_transhuge_page()

In https://lkml.org/lkml/2017/11/20/411, Andrea reported that during
memory hotplug/hot remove prep_transhuge_page() is called incorrectly on
non-THP pages for migration, when THP is on but THP migration is not
enabled.  This leads to a bad state of target pages for migration.

By inspecting the code, if called on a non-THP, prep_transhuge_page() will

1) change the value of the mapping of (page + 2), since it is used
   for THP deferred list;

2) change the lru value of (page + 1), since it is used for THP's
   dtor.

Both can lead to data corruption of these two pages.

Andrea said:

: Pragmatically and from the point of view of the memory_hotplug subsys, the
: effect is a kernel crash when pages are being migrated during a memory hot
: remove offline and migration target pages are found in a bad state.

This patch fixes it by only calling prep_transhuge_page() when we are
certain that the target page is THP.

Link: http://lkml.kernel.org/r/20171121021855.50525-1-zi.yan@sent.com
Fixes: 8135d8926c08 ("mm: memory_hotplug: memory hotremove supports thp migration")
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Reported-by: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: <stable@vger.kernel.org>	[4.14]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/migrate.h~mm-migrate-fix-an-incorrect-call-of-prep_transhuge_page include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-fix-an-incorrect-call-of-prep_transhuge_page
+++ a/include/linux/migrate.h
@@ -54,7 +54,7 @@ static inline struct page *new_page_node
 	new_page = __alloc_pages_nodemask(gfp_mask, order,
 				preferred_nid, nodemask);
 
-	if (new_page && PageTransHuge(page))
+	if (new_page && PageTransHuge(new_page))
 		prep_transhuge_page(new_page);
 
 	return new_page;
_
