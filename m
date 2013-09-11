From: akpm@linux-foundation.org
Subject: + partitions-efi-detect-hybrid-mbrs.patch added to -mm tree
Date: Tue, 10 Sep 2013 17:09:04 -0700
Message-ID: <522fb4a0.EU9bx8LSNNpK9Nsb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3IKAJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, kzak@redhat.com, davidlohr@hp.com

Subject: + partitions-efi-detect-hybrid-mbrs.patch added to -mm tree
To: davidlohr@hp.com,kzak@redhat.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:09:04 -0700


The patch titled
     Subject: partitions/efi: detect hybrid MBRs
has been added to the -mm tree.  Its filename is
     partitions-efi-detect-hybrid-mbrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-detect-hybrid-mbrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-detect-hybrid-mbrs.patch

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
Subject: partitions/efi: detect hybrid MBRs

One of the biggest problems with GPT is compatibility with older, non-GPT
systems.  The problem is addressed by creating hybrid mbrs, an extension,
or variant, of the traditional protective mbr.  This contains, apart from
the 0xEE partition, up three additional primary partitions that point to
the same space marked by up to three GPT partitions.  The result is that
legacy OSs can see the three required MBR partitions and at the same time
ignore the GPT-aware partitions that protect the GPT structures.

While hybrid MBRs are hacks, workarounds and simply not part of the GPT
standard, they do exist and we have no way around them.  For instance, by
default, OSX creates a hybrid scheme when using multi-OS booting.

In order for Linux to properly discover protective MBRs, it must be made
aware of devices that have hybrid MBRs.  No functionality is changed by
this patch, just a debug message informing the user of the MBR scheme that
is being used.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Karel Zak <kzak@redhat.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   72 +++++++++++++++++++++++++++------------
 block/partitions/efi.h |    3 +
 2 files changed, 54 insertions(+), 21 deletions(-)

diff -puN block/partitions/efi.c~partitions-efi-detect-hybrid-mbrs block/partitions/efi.c
--- a/block/partitions/efi.c~partitions-efi-detect-hybrid-mbrs
+++ a/block/partitions/efi.c
@@ -158,7 +158,7 @@ static inline int pmbr_part_valid(gpt_mb
         if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)
                 goto invalid;
 
-	return 1;
+	return GPT_MBR_PROTECTIVE;
 invalid:
 	return 0;
 }
@@ -167,21 +167,47 @@ invalid:
  * is_pmbr_valid(): test Protective MBR for validity
  * @mbr: pointer to a legacy mbr structure
  *
- * Description: Returns 1 if PMBR is valid, 0 otherwise.
- * Validity depends on two things:
+ * Description: Checks for a valid protective or hybrid
+ * master boot record (MBR). The validity of a pMBR depends
+ * on all of the following properties:
  *  1) MSDOS signature is in the last two bytes of the MBR
  *  2) One partition of type 0xEE is found
+ *
+ * In addition, a hybrid MBR will have up to three additional
+ * primary partitions, which point to the same space that's
+ * marked out by up to three GPT partitions.
+ *
+ * Returns 0 upon invalid MBR, or GPT_MBR_PROTECTIVE or
+ * GPT_MBR_HYBRID depending on the device layout.
  */
-static int
-is_pmbr_valid(legacy_mbr *mbr)
+static int is_pmbr_valid(legacy_mbr *mbr)
 {
-	int i;
+	int i, ret = 0; /* invalid by default */
+
 	if (!mbr || le16_to_cpu(mbr->signature) != MSDOS_MBR_SIGNATURE)
-                return 0;
+		goto done;
+
+	for (i = 0; i < 4; i++) {
+		ret = pmbr_part_valid(&mbr->partition_record[i]);
+		if (ret == GPT_MBR_PROTECTIVE) {
+			/*
+			 * Ok, we at least know that there's a protective MBR,
+			 * now check if there are other partition types for
+			 * hybrid MBR.
+			 */
+			goto check_hybrid;
+		}
+	}
+
+	if (ret != GPT_MBR_PROTECTIVE)
+		goto done;
+check_hybrid:
 	for (i = 0; i < 4; i++)
-		if (pmbr_part_valid(&mbr->partition_record[i]))
-                        return 1;
-	return 0;
+		if ((mbr->partition_record[i].os_type != EFI_PMBR_OSTYPE_EFI_GPT) &&
+		    (mbr->partition_record[i].os_type != 0x00))
+			ret = GPT_MBR_HYBRID;
+done:
+	return ret;
 }
 
 /**
@@ -548,17 +574,21 @@ static int find_valid_gpt(struct parsed_
 
 	lastlba = last_lba(state->bdev);
         if (!force_gpt) {
-                /* This will be added to the EFI Spec. per Intel after v1.02. */
-                legacymbr = kzalloc(sizeof (*legacymbr), GFP_KERNEL);
-                if (legacymbr) {
-                        read_lba(state, 0, (u8 *) legacymbr,
-				 sizeof (*legacymbr));
-                        good_pmbr = is_pmbr_valid(legacymbr);
-                        kfree(legacymbr);
-                }
-                if (!good_pmbr)
-                        goto fail;
-        }
+		/* This will be added to the EFI Spec. per Intel after v1.02. */
+		legacymbr = kzalloc(sizeof (*legacymbr), GFP_KERNEL);
+		if (!legacymbr)
+			goto fail;
+
+		read_lba(state, 0, (u8 *) legacymbr, sizeof (*legacymbr));
+		good_pmbr = is_pmbr_valid(legacymbr);
+		kfree(legacymbr);
+
+		if (!good_pmbr)
+			goto fail;
+
+		pr_debug("Device has a %s MBR\n",
+			 good_pmbr == GPT_MBR_PROTECTIVE ? "protective" : "hybrid");
+	}
 
 	good_pgpt = is_gpt_valid(state, GPT_PRIMARY_PARTITION_TABLE_LBA,
 				 &pgpt, &pptes);
diff -puN block/partitions/efi.h~partitions-efi-detect-hybrid-mbrs block/partitions/efi.h
--- a/block/partitions/efi.h~partitions-efi-detect-hybrid-mbrs
+++ a/block/partitions/efi.h
@@ -37,6 +37,9 @@
 #define EFI_PMBR_OSTYPE_EFI 0xEF
 #define EFI_PMBR_OSTYPE_EFI_GPT 0xEE
 
+#define GPT_MBR_PROTECTIVE  1
+#define GPT_MBR_HYBRID      2
+
 #define GPT_HEADER_SIGNATURE 0x5452415020494645ULL
 #define GPT_HEADER_REVISION_V1 0x00010000
 #define GPT_PRIMARY_PARTITION_TABLE_LBA 1
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

