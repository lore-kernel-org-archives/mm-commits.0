From: akpm@osdl.org
Subject: + remove-useless-find_first_bit-macro-from-cardbusc.patch added to -mm tree
Date: Tue, 09 Jan 2007 12:52:29 -0800
Message-ID: <200701092052.l09KqTOu014947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43139 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbXAIUwl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:52:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, linux@dominikbrodowski.net


The patch titled
     Remove useless FIND_FIRST_BIT() macro from cardbus.c
has been added to the -mm tree.  Its filename is
     remove-useless-find_first_bit-macro-from-cardbusc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove useless FIND_FIRST_BIT() macro from cardbus.c
From: "Robert P. J. Day" <rpjday@mindspring.com>

Delete the definition of the unused FIND_FIRST_BIT() macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pcmcia/cardbus.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/pcmcia/cardbus.c~remove-useless-find_first_bit-macro-from-cardbusc drivers/pcmcia/cardbus.c
--- a/drivers/pcmcia/cardbus.c~remove-useless-find_first_bit-macro-from-cardbusc
+++ a/drivers/pcmcia/cardbus.c
@@ -40,8 +40,6 @@
 
 /*====================================================================*/
 
-#define FIND_FIRST_BIT(n)	((n) - ((n) & ((n)-1)))
-
 /* Offsets in the Expansion ROM Image Header */
 #define ROM_SIGNATURE		0x0000	/* 2 bytes */
 #define ROM_DATA_PTR		0x0018	/* 2 bytes */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
