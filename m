From: akpm@linux-foundation.org
Subject: + documentation-update-kmemleaktxt.patch added to -mm tree
Date: Tue, 18 Feb 2014 14:54:58 -0800
Message-ID: <5303e4c2.Q8i8cNNvYl/tWNBs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaBRWy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 17:54:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, udknight@gmail.com

Subject: + documentation-update-kmemleaktxt.patch added to -mm tree
To: udknight@gmail.com,catalin.marinas@arm.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 14:54:58 -0800


The patch titled
     Subject: Documentation/kmemleak.txt: updates
has been added to the -mm tree.  Its filename is
     documentation-update-kmemleaktxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-update-kmemleaktxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-update-kmemleaktxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: Documentation/kmemleak.txt: updates

Update Documentatin/kmemleak.txt to
reflect the following changes:

b69ec42b1b19 ("Kconfig: clean up the long arch list for the DEBUG_KMEMLEAK
config option") make we can't check supported architectures by read
Kconfig.debug.

85d3a316c71 ("kmemleak: use rbtree instead of prio tree") convert kmemleak
to use rbtree instead of prio tree.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kmemleak.txt |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN Documentation/kmemleak.txt~documentation-update-kmemleaktxt Documentation/kmemleak.txt
--- a/Documentation/kmemleak.txt~documentation-update-kmemleaktxt
+++ a/Documentation/kmemleak.txt
@@ -11,9 +11,7 @@ with the difference that the orphan obje
 reported via /sys/kernel/debug/kmemleak. A similar method is used by the
 Valgrind tool (memcheck --leak-check) to detect the memory leaks in
 user-space applications.
-
-Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug for supported
-architectures.
+Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze, ppc, mips, s390, metag and tile.
 
 Usage
 -----
@@ -68,7 +66,7 @@ Basic Algorithm
 
 The memory allocations via kmalloc, vmalloc, kmem_cache_alloc and
 friends are traced and the pointers, together with additional
-information like size and stack trace, are stored in a prio search tree.
+information like size and stack trace, are stored in a rbtree.
 The corresponding freeing function calls are tracked and the pointers
 removed from the kmemleak data structures.
 
@@ -84,7 +82,7 @@ The scanning algorithm steps:
   1. mark all objects as white (remaining white objects will later be
      considered orphan)
   2. scan the memory starting with the data section and stacks, checking
-     the values against the addresses stored in the prio search tree. If
+     the values against the addresses stored in the rbtree. If
      a pointer to a white object is found, the object is added to the
      gray list
   3. scan the gray objects for matching addresses (some white objects
_

Patches currently in -mm which might be from udknight@gmail.com are

documentation-update-kmemleaktxt.patch

