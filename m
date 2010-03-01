From: akpm@linux-foundation.org
Subject: [merged] mtd-chips-cfi-remove-unneeded-null-checks.patch removed from -mm tree
Date: Mon, 01 Mar 2010 11:46:47 -0800
Message-ID: <201003011946.o21Jklpm028698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293Ab0CATr2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 14:47:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: chips/cfi, remove unneeded NULL checks
has been removed from the -mm tree.  Its filename was
     mtd-chips-cfi-remove-unneeded-null-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: chips/cfi, remove unneeded NULL checks
From: Jiri Slaby <jslaby@suse.cz>

In cfi_intelext_setup and cfi_amdstd_setup, mtd is never NULL.  Remove
unnecessary checks.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |    6 ++----
 drivers/mtd/chips/cfi_cmdset_0002.c |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~mtd-chips-cfi-remove-unneeded-null-checks drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~mtd-chips-cfi-remove-unneeded-null-checks
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -615,10 +615,8 @@ static struct mtd_info *cfi_intelext_set
 	return mtd;
 
  setup_err:
-	if(mtd) {
-		kfree(mtd->eraseregions);
-		kfree(mtd);
-	}
+	kfree(mtd->eraseregions);
+	kfree(mtd);
 	kfree(cfi->cmdset_priv);
 	return NULL;
 }
diff -puN drivers/mtd/chips/cfi_cmdset_0002.c~mtd-chips-cfi-remove-unneeded-null-checks drivers/mtd/chips/cfi_cmdset_0002.c
--- a/drivers/mtd/chips/cfi_cmdset_0002.c~mtd-chips-cfi-remove-unneeded-null-checks
+++ a/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -494,10 +494,8 @@ static struct mtd_info *cfi_amdstd_setup
 	return mtd;
 
  setup_err:
-	if(mtd) {
-		kfree(mtd->eraseregions);
-		kfree(mtd);
-	}
+	kfree(mtd->eraseregions);
+	kfree(mtd);
 	kfree(cfi->cmdset_priv);
 	kfree(cfi->cfiq);
 	return NULL;
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
mm-use-rlimit-helpers.patch
bootmem-avoid-dma32-zone-by-default.patch
fs-use-rlimit-helpers.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
kernel-core-use-helpers-for-rlimits-fix.patch
ipc-use-rlimit-helpers.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

