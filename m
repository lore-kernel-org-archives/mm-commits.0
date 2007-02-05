From: akpm@linux-foundation.org
Subject: + arch-arm-use-array_size-macro-when-appropriate.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:09:37 -0800
Message-ID: <200702052209.l15M9bo3000403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35968 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964923AbXBEWJo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, rmk@arm.linux.org.uk


The patch titled
     ARM: Use ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     arch-arm-use-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ARM: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/ecard.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/kernel/ecard.c~arch-arm-use-array_size-macro-when-appropriate arch/arm/kernel/ecard.c
--- a/arch/arm/kernel/ecard.c~arch-arm-use-array_size-macro-when-appropriate
+++ a/arch/arm/kernel/ecard.c
@@ -1009,7 +1009,7 @@ ecard_probe(int slot, card_type_t type)
 		ec->fiqmask = 4;
 	}
 
-	for (i = 0; i < sizeof(blacklist) / sizeof(*blacklist); i++)
+	for (i = 0; i < ARRAY_SIZE(blacklist); i++)
 		if (blacklist[i].manufacturer == ec->cid.manufacturer &&
 		    blacklist[i].product == ec->cid.product) {
 			ec->card_desc = blacklist[i].type;
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
isdn-capi-use-array_size-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
arch-mips-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-arm-use-array_size-macro-when-appropriate.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
