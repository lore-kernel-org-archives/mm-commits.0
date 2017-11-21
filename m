From: akpm@linux-foundation.org
Subject: + mm-migrate-fix-an-incorrect-call-of-prep_transhuge_page.patch
 added to -mm tree
Date: Tue, 21 Nov 2017 14:14:04 -0800
Message-ID: <5a14a52c.bQE4EmNxiFoIFxoH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751359AbdKUWOG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 17:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zi.yan@cs.rutgers.edu, ar@linux.vnet.ibm.com, jglisse@redhat.com, mhocko@kernel.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix an incorrect call of prep_transhuge_page()
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-an-incorrect-call-of-prep_transhuge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-an-incorrect-call-of-prep_transhuge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-an-incorrect-call-of-prep_transhuge_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <zi.yan@cs.rutgers.edu>
Subject: mm: migrate: fix an incorrect call of prep_transhuge_page()

In https://lkml.org/lkml/2017/11/20/411, Andrea reported that during
memory hotplug/hot remove prep_transhuge_page() is called incorrectly on
non-THP pages for migration, when THP is on but THP migration is not
enabled.  This leads to a bad state of target pages for migration.

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

Patches currently in -mm which might be from zi.yan@cs.rutgers.edu are

mm-migrate-fix-an-incorrect-call-of-prep_transhuge_page.patch

