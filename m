From: akpm@linux-foundation.org
Subject: + mtd-chips-cfi-remove-unneeded-null-checks.patch added to -mm tree
Date: Fri, 22 Jan 2010 14:03:16 -0800
Message-ID: <201001222203.o0MM3Hgf031285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485Ab0AVWDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 17:03:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, dwmw2@infradead.org


The patch titled
     mtd: chips/cfi, remove unneeded NULL checks
has been added to the -mm tree.  Its filename is
     mtd-chips-cfi-remove-unneeded-null-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
gpu-drm-i915-fix-potential-null-dereference.patch
infiniband-use-rlimit-helpers.patch
mtd-chips-cfi-remove-unneeded-null-checks.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch
char-synclink-remove-unnecessary-checks.patch

