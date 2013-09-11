From: akpm@linux-foundation.org
Subject: +
 partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1.patch
 added to -mm tree
Date: Tue, 10 Sep 2013 17:09:03 -0700
Message-ID: <522fb49f.jesXqdBckem/+M2f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3IKAJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com

Subject: + partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1.patch added to -mm tree
To: davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:09:03 -0700


The patch titled
     Subject: partitions/efi: do not require gpt partition to begin at sector 1
has been added to the -mm tree.  Its filename is
     partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1.patch

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
Subject: partitions/efi: do not require gpt partition to begin at sector 1

When detecting a valid protective MBR, the Linux kernel isn't picky about
the partition (1-4) the 0xEE is at, but, unlike other operating systems,
it does require it to begin at the second sector (sector 1).  This check,
apart from it not being enforced by UEFI, and causing Linux to potentially
fail to detect any *valid* partitions on the disk, can present problems
when dealing with hybrid MBRs[1].

For compatibility reasons, if the first partition is hybridized, the 0xEE
partition must be small enough to ensure that it only protects the GPT
data structures - as opposed to the the whole disk in a protective MBR. 
This problem is very well described by Rod Smith[1]: where MBR-only
partitioning programs (such as older versions of fdisk) can see some of
the disk space as unallocated, thus loosing the purpose of the 0xEE
partition's protection of GPT data structures.

By dropping this check, this patch enables Linux to be more flexible when
probing for GPT disklabels.

[1] http://www.rodsbooks.com/gdisk/hybrid.html#reactions

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Karel Zak <kzak@redhat.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1 block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-do-not-require-gpt-partition-to-begin-at-sector-1
+++ a/block/partitions/efi.c
@@ -158,12 +158,9 @@ static inline int pmbr_part_valid(gpt_mb
         if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)
                 goto invalid;
 
-        if (le32_to_cpu(part->start_sector) != 1UL)
-                goto invalid;
-
-        return 1;
+	return 1;
 invalid:
-        return 0;
+	return 0;
 }
 
 /**
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

