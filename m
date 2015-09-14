From: akpm@linux-foundation.org
Subject: + kasan-various-fixes-in-documentation.patch tentatively added to -mm tree
Date: Mon, 14 Sep 2015 14:46:26 -0700
Message-ID: <55f74032.1EBiOP/slnV2I1cz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbbINVq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: various fixes in documentation
has been added to the -mm tree.  Its filename is
     kasan-various-fixes-in-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-various-fixes-in-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-various-fixes-in-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: various fixes in documentation

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kasan.txt |   43 +++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff -puN Documentation/kasan.txt~kasan-various-fixes-in-documentation Documentation/kasan.txt
--- a/Documentation/kasan.txt~kasan-various-fixes-in-documentation
+++ a/Documentation/kasan.txt
@@ -1,32 +1,31 @@
-Kernel address sanitizer
-================
+KernelAddressSanitizer (KASAN)
+==============================
 
 0. Overview
 ===========
 
-Kernel Address sanitizer (KASan) is a dynamic memory error detector. It provides
+KernelAddressSANitizer (KASAN) is a dynamic memory error detector. It provides
 a fast and comprehensive solution for finding use-after-free and out-of-bounds
 bugs.
 
-KASan uses compile-time instrumentation for checking every memory access,
-therefore you will need a gcc version of 4.9.2 or later. KASan could detect out
-of bounds accesses to stack or global variables, but only if gcc 5.0 or later was
-used to built the kernel.
+KASAN uses compile-time instrumentation for checking every memory access,
+therefore you will need a GCC version 4.9.2 or later. GCC 5.0 or later is
+required for detection of out-of-bounds accesses to stack or global variables.
 
-Currently KASan is supported only for x86_64 architecture and requires that the
-kernel be built with the SLUB allocator.
+Currently KASAN is supported only for x86_64 architecture and requires the
+kernel to be built with the SLUB allocator.
 
 1. Usage
-=========
+========
 
 To enable KASAN configure kernel with:
 
 	  CONFIG_KASAN = y
 
-and choose between CONFIG_KASAN_OUTLINE and CONFIG_KASAN_INLINE. Outline/inline
-is compiler instrumentation types. The former produces smaller binary the
-latter is 1.1 - 2 times faster. Inline instrumentation requires a gcc version
-of 5.0 or later.
+and choose between CONFIG_KASAN_OUTLINE and CONFIG_KASAN_INLINE. Outline and
+inline are compiler instrumentation types. The former produces smaller binary
+the latter is 1.1 - 2 times faster. Inline instrumentation requires a GCC
+version 5.0 or later.
 
 Currently KASAN works only with the SLUB memory allocator.
 For better bug detection and nicer report, enable CONFIG_STACKTRACE and put
@@ -42,7 +41,7 @@ similar to the following to the respecti
                 KASAN_SANITIZE := n
 
 1.1 Error reports
-==========
+=================
 
 A typical out of bounds access report looks like this:
 
@@ -119,14 +118,16 @@ Memory state around the buggy address:
  ffff8800693bc800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================
 
-First sections describe slub object where bad access happened.
-See 'SLUB Debug output' section in Documentation/vm/slub.txt for details.
+The header of the report discribe what kind of bug happend and what kind of
+access caused it. It's followed by the description of the accessed slub object
+(see 'SLUB Debug output' section in Documentation/vm/slub.txt for details) and
+the description of the accessed memory page.
 
 In the last section the report shows memory state around the accessed address.
-Reading this part requires some more understanding of how KASAN works.
+Reading this part requires some understanding of how KASAN works.
 
-Each 8 bytes of memory are encoded in one shadow byte as accessible,
-partially accessible, freed or they can be part of a redzone.
+The state of each 8 aligned bytes of memory is encoded in one shadow byte.
+Those 8 bytes can be accessible, partially accessible, freed or be a redzone.
 We use the following encoding for each shadow byte: 0 means that all 8 bytes
 of the corresponding memory region are accessible; number N (1 <= N <= 7) means
 that the first N bytes are accessible, and other (8 - N) bytes are not;
@@ -139,7 +140,7 @@ the accessed address is partially access
 
 
 2. Implementation details
-========================
+=========================
 
 From a high level, our approach to memory error detection is similar to that
 of kmemcheck: use shadow memory to record whether each byte of memory is safe
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses.patch
kasan-update-reported-bug-types-for-kernel-memory-accesses.patch
kasan-accurately-determine-the-type-of-the-bad-access.patch
kasan-update-log-messages.patch
kasan-various-fixes-in-documentation.patch
kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch
kasan-update-reference-to-kasan-prototype-repo.patch

