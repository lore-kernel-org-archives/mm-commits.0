From: akpm@linux-foundation.org
Subject: + documentation-memorytxt-remove-some-very-outdated-recommendations.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:24:04 -0700
Message-ID: <200907132124.n6DLO49w000413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185AbZGMVYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com


The patch titled
     Documentation/memory.txt: remove some very outdated recommendations
has been added to the -mm tree.  Its filename is
     documentation-memorytxt-remove-some-very-outdated-recommendations.patch

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
Subject: Documentation/memory.txt: remove some very outdated recommendations
From: Andi Kleen <andi@firstfloor.org>

Remove some very outdated recommendations in Documentation/memory.txt

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory.txt |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff -puN Documentation/memory.txt~documentation-memorytxt-remove-some-very-outdated-recommendations Documentation/memory.txt
--- a/Documentation/memory.txt~documentation-memorytxt-remove-some-very-outdated-recommendations
+++ a/Documentation/memory.txt
@@ -1,18 +1,7 @@
 There are several classic problems related to memory on Linux
 systems.
 
-	1) There are some buggy motherboards which cannot properly 
-	   deal with the memory above 16MB.  Consider exchanging
-	   your motherboard.
-
-	2) You cannot do DMA on the ISA bus to addresses above
-	   16M.  Most device drivers under Linux allow the use
-           of bounce buffers which work around this problem.  Drivers
-	   that don't use bounce buffers will be unstable with
-	   more than 16M installed.  Drivers that use bounce buffers
-	   will be OK, but may have slightly higher overhead.
-	
-	3) There are some motherboards that will not cache above
+	1) There are some motherboards that will not cache above
 	   a certain quantity of memory.  If you have one of these
 	   motherboards, your system will be SLOWER, not faster
 	   as you add more memory.  Consider exchanging your 
@@ -24,7 +13,7 @@ It can also tell Linux to use less memor
 If you use "mem=" on a machine with PCI, consider using "memmap=" to avoid
 physical address space collisions.
 
-See the documentation of your boot loader (LILO, loadlin, etc.) about
+See the documentation of your boot loader (LILO, grub, loadlin, etc.) about
 how to pass options to the kernel.
 
 There are other memory problems which Linux cannot deal with.  Random
@@ -42,19 +31,3 @@ Try:
 	  with the vendor. Consider testing it with memtest86 yourself.
 	
 	* Exchanging your CPU, cache, or motherboard for one that works.
-
-	* Disabling the cache from the BIOS.
-
-	* Try passing the "mem=4M" option to the kernel to limit
-	  Linux to using a very small amount of memory. Use "memmap="-option
-	  together with "mem=" on systems with PCI to avoid physical address
-	  space collisions.
-
-
-Other tricks:
-
-	* Try passing the "no-387" option to the kernel to ignore
-	  a buggy FPU.
