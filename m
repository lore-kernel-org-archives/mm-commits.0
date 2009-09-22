From: akpm@linux-foundation.org
Subject: [merged] documentation-memorytxt-remove-some-very-outdated-recommendations.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:04 -0700
Message-ID: <200909222038.n8MKc4Ab000690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbZIVUie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/memory.txt: remove some very outdated recommendations
has been removed from the -mm tree.  Its filename was
     documentation-memorytxt-remove-some-very-outdated-recommendations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
-
-	* Try passing the "no-hlt" option to disable the potentially
-          buggy HLT instruction in your CPU.
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
kbuild-fix-ld-option-makefile-macro-to-really-work.patch
kbuild-echo-the-record_mcount-command.patch
kbuild-fail-build-if-recordmcountpl-fails.patch
kbuild-set-fconserve-stack-option-for-gcc-45.patch
vfs-optimization-for-touch_atime.patch
vfs-optimize-touch_time-too.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
kmap_typesh-rename-d-macro.patch
video-console-use-div_round_up.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch

