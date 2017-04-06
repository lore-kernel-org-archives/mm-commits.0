From: akpm@linux-foundation.org
Subject: + mm-hmm-devmem-device-memory-hotplug-using-zone_device-fix.patch added to -mm tree
Date: Thu, 06 Apr 2017 14:31:51 -0700
Message-ID: <58e6b3c7.LHz7FBHOo4g7WT6c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752117AbdDFVbw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 17:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hmm-devmem-device-memory-hotplug-using-zone_device-fix
has been added to the -mm tree.  Its filename is
     mm-hmm-devmem-device-memory-hotplug-using-zone_device-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-devmem-device-memory-hotplug-using-zone_device-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-devmem-device-memory-hotplug-using-zone_device-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerome Glisse <jglisse@redhat.com>
Subject: mm-hmm-devmem-device-memory-hotplug-using-zone_device-fix

So during rebase on lastest mmotm one if branch logic got inversed.
Attached is a fixup patch.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hmm.c~mm-hmm-devmem-device-memory-hotplug-using-zone_device-fix mm/hmm.c
--- a/mm/hmm.c~mm-hmm-devmem-device-memory-hotplug-using-zone_device-fix
+++ a/mm/hmm.c
@@ -897,7 +897,7 @@ static int hmm_devmem_pages_create(struc
 	ret = arch_add_memory(nid, align_start, align_size,
 			      devmem->pagemap.type);
 	mem_hotplug_done();
-	if (!ret)
+	if (ret)
 		goto error_add_memory;
 
 	for (pfn = devmem->pfn_first; pfn < devmem->pfn_last; pfn++) {
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memory-hotplug-add-memory-type-parameter-to-arch_add-remove_memory.patch
mm-put_page-move-zone_device-page-reference-decrement-v2.patch
mm-unaddressable-memory-new-type-of-zone_device-for-unaddressable-memory.patch
mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-fix.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch
hmm-heterogeneous-memory-management-documentation.patch

