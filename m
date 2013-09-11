From: akpm@linux-foundation.org
Subject: + partitions-efi-compare-first-and-last-usable-lbas.patch added
 to -mm tree
Date: Tue, 10 Sep 2013 17:09:06 -0700
Message-ID: <522fb4a2.7tGAkdTO98sIeqi/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3IKAJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com

Subject: + partitions-efi-compare-first-and-last-usable-lbas.patch added to -mm tree
To: davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:09:06 -0700


The patch titled
     Subject: partitions/efi: compare first and last usable LBAs
has been added to the -mm tree.  Its filename is
     partitions-efi-compare-first-and-last-usable-lbas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-compare-first-and-last-usable-lbas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-compare-first-and-last-usable-lbas.patch

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
Subject: partitions/efi: compare first and last usable LBAs

When verifying GPT header integrity, make sure that first usable LBA is
smaller than last usable LBA.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Karel Zak <kzak@redhat.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN block/partitions/efi.c~partitions-efi-compare-first-and-last-usable-lbas block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-compare-first-and-last-usable-lbas
+++ a/block/partitions/efi.c
@@ -409,7 +409,12 @@ static int is_gpt_valid(struct parsed_pa
 			 (unsigned long long)lastlba);
 		goto fail;
 	}
-
+	if (le64_to_cpu((*gpt)->last_usable_lba) < le64_to_cpu((*gpt)->first_usable_lba)) {
+		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
+			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba));
+		goto fail;
+	}
 	/* Check that sizeof_partition_entry has the correct value */
 	if (le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
 		pr_debug("GUID Partitition Entry Size check failed.\n");
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

