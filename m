From: akpm@linux-foundation.org
Subject: + partitions-efi-check-pmbr-records-starting-lba.patch added to
 -mm tree
Date: Tue, 10 Sep 2013 17:09:02 -0700
Message-ID: <522fb49e.XBK3UopNeXiSWEsK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3IKAJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com

Subject: + partitions-efi-check-pmbr-records-starting-lba.patch added to -mm tree
To: davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:09:02 -0700


The patch titled
     Subject: partitions/efi: check pmbr record's starting lba
has been added to the -mm tree.  Its filename is
     partitions-efi-check-pmbr-records-starting-lba.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-check-pmbr-records-starting-lba.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-check-pmbr-records-starting-lba.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: partitions/efi: check pmbr record's starting lba

Per the UEFI Specs 2.4, June 2013, the starting lba of the partition that
has the EFI GPT (0xEE) must be set to 0x00000001 - this is obviously the
LBA of the GPT Partition Header.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Karel Zak <kzak@redhat.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-check-pmbr-records-starting-lba block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-check-pmbr-records-starting-lba
+++ a/block/partitions/efi.c
@@ -151,9 +151,18 @@ static u64 last_lba(struct block_device
 
 static inline int pmbr_part_valid(gpt_mbr_record *part)
 {
-        if (part->os_type == EFI_PMBR_OSTYPE_EFI_GPT &&
-            le32_to_cpu(part->start_sector) == 1UL)
-                return 1;
+        if (part->os_type != EFI_PMBR_OSTYPE_EFI_GPT)
+                goto invalid;
+
+        /* set to 0x00000001 (i.e., the LBA of the GPT Partition Header) */
+        if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)
+                goto invalid;
+
+        if (le32_to_cpu(part->start_sector) != 1UL)
+                goto invalid;
+
+        return 1;
+invalid:
         return 0;
 }
 
_

Patches currently in -mm which might be from davidlohr@hp.com are

hugepage-mention-libhugetlbfs-in-doc.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
partitions-efi-use-lba-aware-partition-records.patch
partitions-efi-use-lba-aware-partition-records-fix.patch
partitions-efi-check-pmbr-records-starting-lba.patch
partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1.patch
partitions-efi-detect-hybrid-mbrs.patch
partitions-efi-account-for-pmbr-size-in-lba.patch
partitions-efi-compare-first-and-last-usable-lbas.patch
partitions-efi-delete-annoying-emacs-style-comments.patch
partitions-efi-some-style-cleanups.patch

