From: akpm@linux-foundation.org
Subject: + fix-alpha-isa-support.patch added to -mm tree
Date: Wed, 27 Jun 2007 15:34:57 -0700
Message-ID: <200706272234.l5RMYwUa008510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbXF0WfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 18:35:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     fix alpha ISA support
has been added to the -mm tree.  Its filename is
     fix-alpha-isa-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix alpha ISA support
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

isa_bus_to_virt() is still needed in a few places (lance.c, at least).  When
we switch the kernel to using -Werror-implicit-function-declaration, the lack
of isa_bus_to_virt() breaks alpha allmodconfig builds.

Add isa_bus_to_virt() and deprecate the ezisting ISA APIs, though it might be
better to define these functions as BUG(), since virt_to_bus/bus_to_virt just
do wrong things on a number of machines.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/io.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/asm-alpha/io.h~fix-alpha-isa-support include/asm-alpha/io.h
--- a/include/asm-alpha/io.h~fix-alpha-isa-support
+++ a/include/asm-alpha/io.h
@@ -102,12 +102,12 @@ static inline void * phys_to_virt(unsign
  *
  * Note that this only works for a limited range of kernel addresses,
  * and very well may not span all memory.  Consider this interface 
- * deprecated in favour of the mapping functions in <asm/pci.h>.
+ * deprecated in favour of the DMA-mapping API.
  */
 extern unsigned long __direct_map_base;
 extern unsigned long __direct_map_size;
 
-static inline unsigned long virt_to_bus(void *address)
+static inline unsigned long __deprecated virt_to_bus(void *address)
 {
 	unsigned long phys = virt_to_phys(address);
 	unsigned long bus = phys + __direct_map_base;
@@ -115,7 +115,7 @@ static inline unsigned long virt_to_bus(
 }
 #define isa_virt_to_bus virt_to_bus
 
-static inline void *bus_to_virt(unsigned long address)
+static inline void * __deprecated bus_to_virt(unsigned long address)
 {
 	void *virt;
 
@@ -126,6 +126,7 @@ static inline void *bus_to_virt(unsigned
 	virt = phys_to_virt(address);
 	return (long)address <= 0 ? NULL : virt;
 }
+#define isa_bus_to_virt bus_to_virt
 
 /*
  * There are different chipsets to interface the Alpha CPUs to the world.
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

alpha-fix-trivial-section-mismatch-warnings.patch
fix-alpha-isa-support.patch
make-sure-nobodys-leaking-resources.patch
