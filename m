From: akpm@linux-foundation.org
Subject: + mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
 added to -mm tree
Date: Thu, 16 Mar 2017 13:51:35 -0700
Message-ID: <58cafad7.Oig4VoilH85bkoUI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753253AbdCPVR0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/put_page: move ref decrement to put_zone_device_page()
has been added to the -mm tree.  Its filename is
     mm-put_page-move-ref-decrement-to-put_zone_device_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-put_page-move-ref-decrement-to-put_zone_device_page.patch

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
Subject: mm/put_page: move ref decrement to put_zone_device_page()

This does not affect non ZONE_DEVICE page.  In order to allow ZONE_DEVICE
page to be tracked we need to detect when refcount of a ZONE_DEVICE page
reach 1 (not 0 as non ZONE_DEVICE page).

This patch just move put_page_testzero() from put_page() to
put_zone_device_page() and only for ZONE_DEVICE.  It does not add any
overhead compare to existing code.

Link: http://lkml.kernel.org/r/1489680335-6594-3-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 +++++---
 kernel/memremap.c  |    2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-put_page-move-ref-decrement-to-put_zone_device_page include/linux/mm.h
--- a/include/linux/mm.h~mm-put_page-move-ref-decrement-to-put_zone_device_page
+++ a/include/linux/mm.h
@@ -795,11 +795,13 @@ static inline void put_page(struct page
 {
 	page = compound_head(page);
 
+	if (unlikely(is_zone_device_page(page))) {
+		put_zone_device_page(page);
+		return;
+	}
+
 	if (put_page_testzero(page))
 		__put_page(page);
-
-	if (unlikely(is_zone_device_page(page)))
-		put_zone_device_page(page);
 }
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
diff -puN kernel/memremap.c~mm-put_page-move-ref-decrement-to-put_zone_device_page kernel/memremap.c
--- a/kernel/memremap.c~mm-put_page-move-ref-decrement-to-put_zone_device_page
+++ a/kernel/memremap.c
@@ -190,6 +190,8 @@ EXPORT_SYMBOL(get_zone_device_page);
 
 void put_zone_device_page(struct page *page)
 {
+	page_ref_dec(page);
+
 	put_dev_pagemap(page->pgmap);
 }
 EXPORT_SYMBOL(put_zone_device_page);
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch
mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch
mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch

