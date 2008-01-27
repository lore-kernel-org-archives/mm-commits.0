From: akpm@linux-foundation.org
Subject: + page-migraton-handle-orphaned-pages.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:12:11 -0800
Message-ID: <200801270512.m0R5C8pX030909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbYA0FMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, clameter@sgi.com, npiggin@suse.de


The patch titled
     page migraton: handle orphaned pages
has been added to the -mm tree.  Its filename is
     page-migraton-handle-orphaned-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page migraton: handle orphaned pages
From: Shaohua Li <shaohua.li@intel.com>

Orphaned page might have fs-private metadata, the page is truncated.  As
the page hasn't mapping, page migration refuse to migrate the page.  It
appears the page is only freed in page reclaim and if zone watermark is
low, the page is never freed, as a result migration always fail.  I thought
we could free the metadata so such page can be freed in migration and make
migration more reliable.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c  |   16 +++++++++++++---
 mm/truncate.c |    2 +-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff -puN mm/migrate.c~page-migraton-handle-orphaned-pages mm/migrate.c
--- a/mm/migrate.c~page-migraton-handle-orphaned-pages
+++ a/mm/migrate.c
@@ -640,15 +640,25 @@ static int unmap_and_move(new_page_t get
 		rcu_read_lock();
 		rcu_locked = 1;
 	}
+
 	/*
-	 * This is a corner case handling.
-	 * When a new swap-cache is read into, it is linked to LRU
+	 * There are corner cases handling.
+	 * 1. When a new swap-cache is read into, it is linked to LRU
 	 * and treated as swapcache but has no rmap yet.
 	 * Calling try_to_unmap() against a page->mapping==NULL page is
 	 * BUG. So handle it here.
+	 * 2. Orphaned page (see truncate_complete_page) might have
+	 * fs-private metadata, the page is truncated. The page can be picked
+	 * up due to memory offlineing. Everywhere else except page reclaim,
+	 * the page is invisible to the vm, so the page can't be migrated. Try
+	 * to free metadata, so the page can be freed.
 	 */
-	if (!page->mapping)
+	if (!page->mapping) {
+		if (!PageAnon(page) && PagePrivate(page))
+			try_to_release_page(page, GFP_KERNEL);
 		goto rcu_unlock;
+	}
+
 	/* Establish migration ptes or remove ptes */
 	try_to_unmap(page, 1);
 
diff -puN mm/truncate.c~page-migraton-handle-orphaned-pages mm/truncate.c
--- a/mm/truncate.c~page-migraton-handle-orphaned-pages
+++ a/mm/truncate.c
@@ -84,7 +84,7 @@ EXPORT_SYMBOL(cancel_dirty_page);
 
 /*
  * If truncate cannot remove the fs-private metadata from the page, the page
- * becomes anonymous.  It will be left on the LRU and may even be mapped into
+ * becomes orphaned.  It will be left on the LRU and may even be mapped into
  * user pagetables if we're racing with filemap_fault().
  *
  * We need to bale out if page->mapping is no longer equal to the original
_

Patches currently in -mm which might be from shaohua.li@intel.com are

git-acpi.patch
acpi-ignore-acpi-video-devices-that-arent-present-in-hardware.patch
acpi-ignore-acpi-video-devices-that-arent-present-in-hardware-checkpatch-fixes.patch
ia64-fix-the-order-of-atomic-operations-in-restore_previous_kprobes.patch
git-kvm.patch
git-libata-all.patch
page-migraton-handle-orphaned-pages.patch
page-migraton-handle-orphaned-pages-fix.patch
