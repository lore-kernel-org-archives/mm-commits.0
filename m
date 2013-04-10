From: akpm@linux-foundation.org
Subject: + hugetlbfs-add-swap-entry-check-in-follow_hugetlb_page.patch added to -mm tree
Date: Wed, 10 Apr 2013 14:55:42 -0700
Message-ID: <20130410215543.05E7C31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42556 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab3DJVzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 17:55:44 -0400
Received: by mail-ob0-f202.google.com with SMTP id va7so231940obc.3
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 14:55:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, d.hatayama@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org


The patch titled
     Subject: hugetlbfs: add swap entry check in follow_hugetlb_page()
has been added to the -mm tree.  Its filename is
     hugetlbfs-add-swap-entry-check-in-follow_hugetlb_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hugetlbfs: add swap entry check in follow_hugetlb_page()

With applying the previous patch "hugetlbfs: stop setting VM_DONTDUMP in
initializing vma(VM_HUGETLB)" to reenable hugepage coredump, if a memory
error happens on a hugepage and the affected processes try to access the
error hugepage, we hit VM_BUG_ON(atomic_read(&page->_count) <= 0) in
get_page().

The reason for this bug is that coredump-related code doesn't recognise
"hugepage hwpoison entry" with which a pmd entry is replaced when a memory
error occurs on a hugepage.

In other words, physical address information is stored in different bit
layout between hugepage hwpoison entry and pmd entry, so
follow_hugetlb_page() which is called in get_dump_page() returns a wrong
page from a given address.

The expected behavior is like this:

  absent   is_swap_pte   FOLL_DUMP   Expected behavior
  -------------------------------------------------------------------
   true     false         false       hugetlb_fault
   false    true          false       hugetlb_fault
   false    false         false       return page
   true     false         true        skip page (to avoid allocation)
   false    true          true        hugetlb_fault
   false    false         true        return page

With this patch, we can call hugetlb_fault() and take proper actions (we
wait for migration entries, fail with VM_FAULT_HWPOISON_LARGE for
hwpoisoned entries,) and as the result we can dump all hugepages except
for hwpoisoned ones.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[2.6.34+?]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlbfs-add-swap-entry-check-in-follow_hugetlb_page mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-add-swap-entry-check-in-follow_hugetlb_page
+++ a/mm/hugetlb.c
@@ -2961,7 +2961,17 @@ long follow_hugetlb_page(struct mm_struc
 			break;
 		}
 
-		if (absent ||
+		/*
+		 * We need call hugetlb_fault for both hugepages under migration
+		 * (in which case hugetlb_fault waits for the migration,) and
+		 * hwpoisoned hugepages (in which case we need to prevent the
+		 * caller from accessing to them.) In order to do this, we use
+		 * here is_swap_pte instead of is_hugetlb_entry_migration and
+		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
+		 * both cases, and because we can't follow correct pages
+		 * directly from any kind of swap entries.
+		 */
+		if (absent || is_swap_pte(huge_ptep_get(pte)) ||
 		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hugetlbfs-stop-setting-vm_dontdump-in-initializing-vmavm_hugetlb.patch
fix-hugetlb-memory-check-in-vma_dump_size.patch
hugetlbfs-add-swap-entry-check-in-follow_hugetlb_page.patch
hwpoison-check-dirty-flag-to-match-against-clean-page.patch

