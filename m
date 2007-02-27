From: akpm@linux-foundation.org
Subject: + fix-section-mismatch-warning-in-lib-swiotlbc.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:58:20 -0800
Message-ID: <200702272058.l1RKwOP3028378@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXB0U6d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, ak@suse.de, tony.luck@intel.com


The patch titled
     fix section mismatch warning in lib/swiotlb.c
has been added to the -mm tree.  Its filename is
     fix-section-mismatch-warning-in-lib-swiotlbc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix section mismatch warning in lib/swiotlb.c
From: Sam Ravnborg <sam@ravnborg.org>

kbuild spits outs following warning on a
defconfig x86_64 build:
WARNING: swiotlb.o - Section mismatch: reference to .init.text:swiotlb_init from __ksymtab between '__ksymtab_swiotlb_init' (at offset 0xa0) and '__ksymtab_swiotlb_free_coherent'

This warning happens because the function swiotlb_init is marked __init and
EXPORT_SYMBOL().  A 'git grep swiotlb_init' showed no users in drivers/ so
remove the EXPORT_SYMBOL.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/swiotlb.c~fix-section-mismatch-warning-in-lib-swiotlbc lib/swiotlb.c
--- a/lib/swiotlb.c~fix-section-mismatch-warning-in-lib-swiotlbc
+++ a/lib/swiotlb.c
@@ -894,7 +894,6 @@ swiotlb_dma_supported(struct device *hwd
 	return __swiotlb_dma_supported(hwdev, mask);
 }
 
-EXPORT_SYMBOL(swiotlb_init);
 EXPORT_SYMBOL(swiotlb_map_single);
 EXPORT_SYMBOL(swiotlb_unmap_single);
 EXPORT_SYMBOL(swiotlb_map_sg);
_

Patches currently in -mm which might be from sam@ravnborg.org are

fix-section-mismatch-warning-in-lockdep.patch
kbuild-override-build-timestamp.patch
kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
allow-kernel-to-build-on-cygwin.patch
git-lxdialog.patch
git-parisc.patch
x86_64-fix-section-mismatch-warnings.patch
fix-section-mismatch-warning-in-lib-swiotlbc.patch
