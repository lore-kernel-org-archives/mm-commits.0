From: akpm@linux-foundation.org
Subject: [merged] mm-thp-fix-mlock-statistics.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:15:02 -0700
Message-ID: <20121009181503.5E32620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35223 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2JISPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:15:06 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so363410eek.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:15:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: fix mlock statistics
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-mlock-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: fix mlock statistics

NR_MLOCK is only accounted in single page units: there's no logic to
handle transparent hugepages.  This patch checks the appropriate number of
pages to adjust the statistics by so that the correct amount of memory is
reflected.

Currently:

		$ grep Mlocked /proc/meminfo
		Mlocked:           19636 kB

	#define MAP_SIZE	(4 << 30)	/* 4GB */

	void *ptr = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
			 MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
	mlock(ptr, MAP_SIZE);

		$ grep Mlocked /proc/meminfo
		Mlocked:           29844 kB

	munlock(ptr, MAP_SIZE);

		$ grep Mlocked /proc/meminfo
		Mlocked:           19636 kB

And with this patch:

		$ grep Mlock /proc/meminfo
		Mlocked:           19636 kB

	mlock(ptr, MAP_SIZE);

		$ grep Mlock /proc/meminfo
		Mlocked:         4213664 kB

	munlock(ptr, MAP_SIZE);

		$ grep Mlock /proc/meminfo
		Mlocked:           19636 kB

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Hugh Dickens <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 ++-
 mm/mlock.c    |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/internal.h~mm-thp-fix-mlock-statistics mm/internal.h
--- a/mm/internal.h~mm-thp-fix-mlock-statistics
+++ a/mm/internal.h
@@ -180,7 +180,8 @@ static inline int mlocked_vma_newpage(st
 		return 0;
 
 	if (!TestSetPageMlocked(page)) {
-		inc_zone_page_state(page, NR_MLOCK);
+		mod_zone_page_state(page_zone(page), NR_MLOCK,
+				    hpage_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 	}
 	return 1;
diff -puN mm/mlock.c~mm-thp-fix-mlock-statistics mm/mlock.c
--- a/mm/mlock.c~mm-thp-fix-mlock-statistics
+++ a/mm/mlock.c
@@ -56,7 +56,8 @@ void clear_page_mlock(struct page *page)
 	if (!TestClearPageMlocked(page))
 		return;
 
-	dec_zone_page_state(page, NR_MLOCK);
+	mod_zone_page_state(page_zone(page), NR_MLOCK,
+			    -hpage_nr_pages(page));
 	count_vm_event(UNEVICTABLE_PGCLEARED);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
@@ -78,7 +79,8 @@ void mlock_vma_page(struct page *page)
 	BUG_ON(!PageLocked(page));
 
 	if (!TestSetPageMlocked(page)) {
-		inc_zone_page_state(page, NR_MLOCK);
+		mod_zone_page_state(page_zone(page), NR_MLOCK,
+				    hpage_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
@@ -105,7 +107,8 @@ void munlock_vma_page(struct page *page)
 	BUG_ON(!PageLocked(page));
 
 	if (TestClearPageMlocked(page)) {
-		dec_zone_page_state(page, NR_MLOCK);
+		mod_zone_page_state(page_zone(page), NR_MLOCK,
+				    -hpage_nr_pages(page));
 		if (!isolate_lru_page(page)) {
 			int ret = SWAP_AGAIN;
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

