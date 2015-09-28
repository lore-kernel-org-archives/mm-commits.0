From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-hugetlb-putback-destination-hugepage-to-active-list.patch
 removed from -mm tree
Date: Mon, 28 Sep 2015 11:15:59 -0700
Message-ID: <560983df.kFN8W49VhXVjDlh/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, hughd@google.com, mhocko@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: hugetlb: putback destination hugepage to active list
has been removed from the -mm tree.  Its filename was
     mm-migrate-hugetlb-putback-destination-hugepage-to-active-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: migrate: hugetlb: putback destination hugepage to active list

Since commit bcc54222309c ("mm: hugetlb: introduce page_huge_active") each
hugetlb page maintains its active flag to avoid a race condition betwe= en
multiple calls of isolate_huge_page(), but current kernel doesn't set the
f= lag on a hugepage allocated by migration because the proper putback
routine isn= 't called.  This means that users could still encounter the
race referred to by bcc54222309c in this special case, so this patch fixes
it.

Fixes: bcc54222309c ("mm: hugetlb: introduce page_huge_active")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>  [4.1.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-hugetlb-putback-destination-hugepage-to-active-list mm/migrate.c
--- a/mm/migrate.c~mm-migrate-hugetlb-putback-destination-hugepage-to-active-list
+++ a/mm/migrate.c
@@ -1075,7 +1075,7 @@ out:
 	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
 		put_new_page(new_hpage, private);
 	else
-		put_page(new_hpage);
+		putback_active_hugepage(new_hpage);
 
 	if (result) {
 		if (rc)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
mm-hwpoison-ratelimit-messages-from-unpoison_memory.patch

