From: akpm@linux-foundation.org
Subject: + edac-i5100-cleanup-fix.patch added to -mm tree
Date: Wed, 02 Jul 2008 10:09:47 -0700
Message-ID: <200807021709.m62H9ldN026993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbYGBRJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 13:09:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajones@riverbed.com, dougthompson@xmission.com


The patch titled
     drivers/edac: i5100 cleanup addendum
has been added to the -mm tree.  Its filename is
     edac-i5100-cleanup-fix.patch

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
Subject: drivers/edac: i5100 cleanup addendum
From: Arthur Jones <ajones@riverbed.com>

This follow-on cleanup patch fixes the following compiler warnings found
by Andrew Morton:

drivers/edac/i5100_edac.c:258: warning: function declaration isn't a prototype
drivers/edac/i5100_edac.c:263: warning: function declaration isn't a prototype
drivers/edac/i5100_edac.c: In function 'i5100_ctl_page_to_phys':
drivers/edac/i5100_edac.c:372: warning: left shift count >= width of type

The i5100_ctl_page_to_phys was not used, it will be
re-added when the controller -> cpu address space
translations work.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5100_edac.c |   39 ++----------------------------------
 1 file changed, 3 insertions(+), 36 deletions(-)

diff -puN drivers/edac/i5100_edac.c~edac-i5100-cleanup-fix drivers/edac/i5100_edac.c
--- a/drivers/edac/i5100_edac.c~edac-i5100-cleanup-fix
+++ a/drivers/edac/i5100_edac.c
@@ -254,12 +254,12 @@ static inline u32 i5100_recmema_dm_buf_i
 	return i5100_nrecmema_dm_buf_id(a);
 }
 
-static inline u32 i5100_recmemb_cas(a)
+static inline u32 i5100_recmemb_cas(u32 a)
 {
 	return i5100_nrecmemb_cas(a);
 }
 
-static inline u32 i5100_recmemb_ras(a)
+static inline u32 i5100_recmemb_ras(u32 a)
 {
 	return i5100_nrecmemb_ras(a);
 }
@@ -339,39 +339,6 @@ static int i5100_rank_to_slot(const stru
 	return -1;
 }
 
-/*
- * The processor bus memory addresses are broken into three
- * pieces, whereas the controller addresses are contiguous.
- *
- * here we map from the controller address space to the
- * processor address space:
- *
- *    Processor Address Space
- * +-----------------------------+
- * |                             |
- * |  "high" memory addresses    |
- * |                             |
- * +-----------------------------+ <- 4GB on the i5100
- * |                             |
- * |  other non-memory addresses |
- * |                             |
- * +-----------------------------+ <- top of low memory
- * |                             |
- * | "low" memory addresses      |
- * |                             |
- * +-----------------------------+
- */
-static unsigned long i5100_ctl_page_to_phys(struct mem_ctl_info *mci,
-					    unsigned long cntlr_addr)
-{
-	const struct i5100_priv *priv = mci->pvt_info;
-
-	if (cntlr_addr < priv->tolm)
-		return cntlr_addr;
-
-	return (1UL << 32) + (cntlr_addr - priv->tolm);
-}
-
 static const char *i5100_err_msg(unsigned err)
 {
 	static const char *merrs[] = {
@@ -912,7 +879,7 @@ static int __devinit i5100_init_one(stru
 	mci->mod_ver = "not versioned";
 	mci->ctl_name = "i5100";
 	mci->dev_name = pci_name(pdev);
-	mci->ctl_page_to_phys = i5100_ctl_page_to_phys;
+	mci->ctl_page_to_phys = NULL;
 
 	mci->edac_check = i5100_check_error;
 
_

Patches currently in -mm which might be from ajones@riverbed.com are

edac-i5100-new-intel-chipset-driver.patch
edac-i5100-fix-missing-bits.patch
edac-i5100-fix-enable-ecc-hardware.patch
edac-i5100-fix-unmask-ecc-bits.patch
edac-i5100-cleanup.patch
edac-i5100-cleanup-fix.patch
edac-core-fix-to-use-dynamic-kobject.patch
edac-core-fix-workq-timer.patch
edac-core-fix-redundant-sysfs-controls-to-parameters.patch
edac-core-fix-static-to-dynamic-kset.patch
edac-core-fix-added-newline-to-sysfs-dimm-labels.patch

