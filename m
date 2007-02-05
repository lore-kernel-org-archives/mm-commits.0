From: akpm@linux-foundation.org
Subject: + arch-avr32-use-array_size-macro-when-appropriate.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:09:23 -0800
Message-ID: <200702052209.l15M9Nc0000376@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35932 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964852AbXBEWJ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:09:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, hskinnemoen@atmel.com


The patch titled
     AVR32: Use ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     arch-avr32-use-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AVR32: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/avr32/kernel/setup.c~arch-avr32-use-array_size-macro-when-appropriate arch/avr32/kernel/setup.c
--- a/arch/avr32/kernel/setup.c~arch-avr32-use-array_size-macro-when-appropriate
+++ a/arch/avr32/kernel/setup.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/root_dev.h>
 #include <linux/cpu.h>
+#include <linux/kernel.h>
 
 #include <asm/sections.h>
 #include <asm/processor.h>
@@ -174,8 +175,7 @@ static int __init parse_tag_mem_range(st
 	 * Copy the data so the bootmem init code doesn't need to care
 	 * about it.
 	 */
-	if (mem_range_next_free >=
-	    (sizeof(mem_range_cache) / sizeof(mem_range_cache[0])))
+	if (mem_range_next_free >= ARRAY_SIZE(mem_range_cache))
 		panic("Physical memory map too complex!\n");
 
 	new = &mem_range_cache[mem_range_next_free++];
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
