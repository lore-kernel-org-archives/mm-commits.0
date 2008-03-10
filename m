From: akpm@linux-foundation.org
Subject: + drivers-fix-dma_get_required_mask.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:34:07 -0700
Message-ID: <200803102034.m2AKY7UF004212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966AbYCJUe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, greg@kroah.com, stable@kernel.org


The patch titled
     drivers: fix dma_get_required_mask
has been added to the -mm tree.  Its filename is
     drivers-fix-dma_get_required_mask.patch

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
Subject: drivers: fix dma_get_required_mask
From: James Bottomley <James.Bottomley@HansenPartnership.com>

There's a bug in the current implementation of dma_get_required_mask() where
it ands the returned mask with the current device mask.  This rather defeats
the purpose if you're using the call to determine what your mask should be
(since you will at that time have the default DMA_32BIT_MASK).  This bug
results in any driver that uses this function *always* getting a 32 bit mask,
which is wrong.

Fix by removing the and with dev->dma_mask.

This is a pretty nasty bug which can cause mysterious slow downs and panics on
>4GB machines (we've just had one on an aic79xx production system).

It probably also needs to be backported as far as it will go.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/platform.c~drivers-fix-dma_get_required_mask drivers/base/platform.c
--- a/drivers/base/platform.c~drivers-fix-dma_get_required_mask
+++ a/drivers/base/platform.c
@@ -648,7 +648,7 @@ u64 dma_get_required_mask(struct device 
 		high_totalram += high_totalram - 1;
 		mask = (((u64)high_totalram) << 32) + 0xffffffff;
 	}
-	return mask & *dev->dma_mask;
+	return mask;
 }
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 #endif
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are

git-parisc.patch
git-scsi-misc.patch
git-scsi-rc-fixes.patch
scsi-le_add_cpu-conversion.patch
arcmsr-modify-the-type-of-element-of-messageunit_b.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-stc-make-class-attributes-static.patch
scsi-osstc-make-class-attributes-static.patch
scsi-chc-fix-shadowed-variable-warnings.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch
drivers-fix-dma_get_required_mask.patch
remove-duplicated-unlikely-in-is_err.patch

