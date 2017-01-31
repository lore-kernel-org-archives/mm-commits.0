From: akpm@linux-foundation.org
Subject: [folded-merged]
 hwpoison-soft-offlining-for-non-lru-movable-page-fix.patch removed from -mm tree
Date: Tue, 31 Jan 2017 14:42:05 -0800
Message-ID: <589112bd.gHrSegMkm3ae0PLf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45526 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdAaWnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 17:43:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, xieyisheng1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: add isolate_movable_page() stub implementation
has been removed from the -mm tree.  Its filename was
     hwpoison-soft-offlining-for-non-lru-movable-page-fix.patch

This patch was dropped because it was folded into hwpoison-soft-offlining-for-non-lru-movable-page.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: migrate: add isolate_movable_page() stub implementation

Without CONFIG_MIGRATION, we get a build failure when trying to
call isolate_movable_page():

mm/memory-failure.c: In function '__soft_offline_page':
mm/memory-failure.c:1656:10: error: implicit declaration of function 'isolate_movable_page';did you mean 'isolate_huge_page'? [-Werror=implicit-function-declaration]

This adds one more static inline helper function in the header
declaring it. This returns false to indicate that the
page was not isolated.

Fixes: mmotm ("HWPOISON: soft offlining for non-lru movable pages")
Fixes: bda807d44454 ("mm: migrate: support non-lru movable page migration")
Link: http://lkml.kernel.org/r/20170125222752.1314498-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/migrate.h~hwpoison-soft-offlining-for-non-lru-movable-page-fix include/linux/migrate.h
--- a/include/linux/migrate.h~hwpoison-soft-offlining-for-non-lru-movable-page-fix
+++ a/include/linux/migrate.h
@@ -57,6 +57,9 @@ static inline int migrate_pages(struct l
 		int reason)
 	{ return -ENOSYS; }
 
+static inline bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+	{ return false; }
+
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
 
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-track-active-portions-of-a-section-at-boot-fix-fix.patch
mm-support-section-unaligned-zone_device-memory-ranges-fix.patch
mm-fs-reduce-fault-page_mkwrite-and-pfn_mkwrite-to-take-only-vmf-fix.patch
hwpoison-soft-offlining-for-non-lru-movable-page.patch
lib-add-config_test_sort-to-enable-self-test-of-sort-fix.patch

