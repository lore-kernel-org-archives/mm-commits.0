From: akpm@linux-foundation.org
Subject: + partitions-efi-some-style-cleanups.patch added to -mm tree
Date: Tue, 10 Sep 2013 17:09:08 -0700
Message-ID: <522fb4a4.stViAewWNspoTUBp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3IKAJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com

Subject: + partitions-efi-some-style-cleanups.patch added to -mm tree
To: davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:09:08 -0700


The patch titled
     Subject: partitions/efi: some style cleanups
has been added to the -mm tree.  Its filename is
     partitions-efi-some-style-cleanups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-some-style-cleanups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-some-style-cleanups.patch

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
Subject: partitions/efi: some style cleanups

Trivial coding style cleanups - still plenty left.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Karel Zak <kzak@redhat.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-some-style-cleanups block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-some-style-cleanups
+++ a/block/partitions/efi.c
@@ -25,6 +25,9 @@
  * TODO:
  *
  * Changelog:
+ * Mon August 5th, 2013 Davidlohr Bueso <davidlohr@hp.com>
+ * - detect hybrid MBRs, tighter pMBR checking & cleanups.
+ *
  * Mon Nov 09 2004 Matt Domsch <Matt_Domsch@dell.com>
  * - test for valid PMBR and valid PGPT before ever reading
  *   AGPT, allow override with 'gpt' kernel command line option.
@@ -288,8 +291,7 @@ static gpt_entry *alloc_read_gpt_entries
 		return NULL;
 
 	if (read_lba(state, le64_to_cpu(gpt->partition_entry_lba),
-                     (u8 *) pte,
-		     count) < count) {
+                     (u8 *) pte, count) < count) {
 		kfree(pte);
                 pte=NULL;
 		return NULL;
@@ -613,8 +615,7 @@ static int find_valid_gpt(struct parsed_
 	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);
         if (good_pgpt)
-		good_agpt = is_gpt_valid(state,
-					 le64_to_cpu(pgpt->alternate_lba),
+		good_agpt = is_gpt_valid(state, le64_to_cpu(pgpt->alternate_lba),
 					 &agpt, &aptes);
         if (!good_agpt && force_gpt)
                 good_agpt = is_gpt_valid(state, lastlba, &agpt, &aptes);
@@ -632,9 +633,7 @@ static int find_valid_gpt(struct parsed_
                 kfree(agpt);
                 kfree(aptes);
                 if (!good_agpt) {
-                        printk(KERN_WARNING 
-			       "Alternate GPT is invalid, "
-                               "using primary GPT.\n");
+                        printk(KERN_WARNING "Alternate GPT is invalid, using primary GPT.\n");
                 }
                 return 1;
         }
@@ -643,8 +642,7 @@ static int find_valid_gpt(struct parsed_
                 *ptes = aptes;
                 kfree(pgpt);
                 kfree(pptes);
-                printk(KERN_WARNING 
-                       "Primary GPT is invalid, using alternate GPT.\n");
+                printk(KERN_WARNING "Primary GPT is invalid, using alternate GPT.\n");
                 return 1;
         }
 
@@ -706,8 +704,7 @@ int efi_partition(struct parsed_partitio
 		put_partition(state, i+1, start * ssz, size * ssz);
 
 		/* If this is a RAID volume, tell md */
-		if (!efi_guidcmp(ptes[i].partition_type_guid,
-				 PARTITION_LINUX_RAID_GUID))
+		if (!efi_guidcmp(ptes[i].partition_type_guid, PARTITION_LINUX_RAID_GUID))
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
 
 		info = &state->parts[i + 1].info;
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

