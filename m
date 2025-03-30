Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365CF1DE2C2
	for <mm-commits@vger.kernel.org>; Sun, 30 Mar 2025 21:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743369971; cv=none; b=aDcbr97RFgp86QElVUpMWfy6cpblguqTl9QgkysiuuTG2RZfnaNk+Xl5qmgc0dGuWC+4Vh0fTjv7SBzAGJpv22IaqQHYNar6KIJtW2tyDs1NAwsBBJK0DjWVSe/yDqhqwqx49aYcuvZpnjryI8Ka2FR1EefrBOR+VX3j1fWvlZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743369971; c=relaxed/simple;
	bh=crXVUeDOXz5eeNDjl/xeG6vN0TZzWY/DFE88MVIoums=;
	h=Date:To:From:Subject:Message-Id; b=JGXObBZ2JxCSe1jfkdH2DQT1XNzicGiSSqMujRGuFA5Uw/sJvUPnIPLZU00bLlbQW0A3w3DrJrRa6TouVFaSq9i7AEzdcE9HmXWwBVCX8jSENtfVbCCK4LG7esKVltyYMXWVOJACBTDVEb0BI4Ax4u+G7LRkLRZLvlvQc976Mms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lkAvgiTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lkAvgiTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CD5C4CEDD;
	Sun, 30 Mar 2025 21:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743369970;
	bh=crXVUeDOXz5eeNDjl/xeG6vN0TZzWY/DFE88MVIoums=;
	h=Date:To:From:Subject:From;
	b=lkAvgiTtdWEW894arHMh7UshFJLIQ6RoKkg18bnK71aFZ8o333jK8KkPyfktDwJSx
	 JQ9URV7f/D7xIZ8i2tx0HCNp7o/cccni4RauH8kbgoLnwVt/hW/STvHIKk+n7dZh4S
	 eMSZXvizEMB3bsqKprDqlsKJUCIdNDOIRRRwvMx4=
Date: Sun, 30 Mar 2025 14:26:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,thomas.lendacky@amd.com,sraithal@amd.com,rppt@kernel.org,rick.p.edgecombe@intel.com,mgorman@techsingularity.net,david@redhat.com,ashish.kalra@amd.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20250330212610.79CD5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix deadlock on cpu_hotplug_lock in __accept_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/page_alloc: fix deadlock on cpu_hotplug_lock in __accept_page()
Date: Sat, 29 Mar 2025 19:10:29 +0200

When the last page in the zone is accepted, __accept_page() calls
static_branch_dec().  This function takes cpu_hotplug_lock, which can lead
to a deadlock if the allocation occurs during CPU bringup path as
_cpu_up() also takes the lock.

To prevent this deadlock, defer static_branch_dec() to a workqueue.

Call static_branch_dec() only when the workqueue is not yet initialized. 
Workqueues are initialized before CPU bring up, so this will not conflict
with the first scenario.

Link: https://lkml.kernel.org/r/20250329171030.3942298-1-kirill.shutemov@linux.intel.com
Fixes: 55ad43e8ba0f ("mm: add a helper to accept page")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Srikanth Aithal <sraithal@amd.com>
Tested-by: Srikanth Aithal <sraithal@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 mm/internal.h          |    1 +
 mm/mm_init.c           |    1 +
 mm/page_alloc.c        |   28 ++++++++++++++++++++++++++--
 4 files changed, 31 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page
+++ a/include/linux/mmzone.h
@@ -964,6 +964,9 @@ struct zone {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	/* Pages to be accepted. All pages on the list are MAX_PAGE_ORDER */
 	struct list_head	unaccepted_pages;
+
+	/* To be called once the last page in the zone is accepted */
+	struct work_struct	unaccepted_cleanup;
 #endif
 
 	/* zone flags, see below */
--- a/mm/internal.h~mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page
+++ a/mm/internal.h
@@ -1517,6 +1517,7 @@ unsigned long move_page_tables(struct vm
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 void accept_page(struct page *page);
+void unaccepted_cleanup_work(struct work_struct *work);
 #else /* CONFIG_UNACCEPTED_MEMORY */
 static inline void accept_page(struct page *page)
 {
--- a/mm/mm_init.c~mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page
+++ a/mm/mm_init.c
@@ -1404,6 +1404,7 @@ static void __meminit zone_init_free_lis
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	INIT_LIST_HEAD(&zone->unaccepted_pages);
+	INIT_WORK(&zone->unaccepted_cleanup, unaccepted_cleanup_work);
 #endif
 }
 
--- a/mm/page_alloc.c~mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page
+++ a/mm/page_alloc.c
@@ -6930,6 +6930,11 @@ static DEFINE_STATIC_KEY_FALSE(zones_wit
 
 static bool lazy_accept = true;
 
+void unaccepted_cleanup_work(struct work_struct *work)
+{
+	static_branch_dec(&zones_with_unaccepted_pages);
+}
+
 static int __init accept_memory_parse(char *p)
 {
 	if (!strcmp(p, "lazy")) {
@@ -6968,8 +6973,27 @@ static void __accept_page(struct zone *z
 
 	__free_pages_ok(page, MAX_PAGE_ORDER, FPI_TO_TAIL);
 
-	if (last)
-		static_branch_dec(&zones_with_unaccepted_pages);
+	if (last) {
+		/*
+		 * There are two corner cases:
+		 *
+		 * - If allocation occurs during the CPU bring up,
+		 *   static_branch_dec() cannot be used directly as
+		 *   it causes a deadlock on cpu_hotplug_lock.
+		 *
+		 *   Instead, use schedule_work() to prevent deadlock.
+		 *
+		 * - If allocation occurs before workqueues are initialized,
+		 *   static_branch_dec() should be called directly.
+		 *
+		 *   Workqueues are initialized before CPU bring up, so this
+		 *   will not conflict with the first scenario.
+		 */
+		if (system_wq)
+			schedule_work(&zone->unaccepted_cleanup);
+		else
+			unaccepted_cleanup_work(&zone->unaccepted_cleanup);
+	}
 }
 
 void accept_page(struct page *page)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page.patch

