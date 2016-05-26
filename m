From: akpm@linux-foundation.org
Subject: + mm-cma-silence-warnings-due-to-max-usage.patch added to -mm
 tree
Date: Thu, 26 May 2016 14:10:56 -0700
Message-ID: <57476660.2e6kxNQNzstNQEse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbcEZVK5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 17:10:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: silence warnings due to max() usage
has been added to the -mm tree.  Its filename is
     mm-cma-silence-warnings-due-to-max-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-silence-warnings-due-to-max-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-silence-warnings-due-to-max-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm/cma: silence warnings due to max() usage

pageblock_order can be (at least) an unsigned int or an unsigned long
depending on the kernel config and architecture, so use max_t(unsigned
long, ...) when comparing it.

fixes these warnings:

In file included from include/asm-generic/bug.h:13:0,
                 from arch/powerpc/include/asm/bug.h:127,
                 from include/linux/bug.h:4,
                 from include/linux/mmdebug.h:4,
                 from include/linux/mm.h:8,
                 from include/linux/memblock.h:18,
                 from mm/cma.c:28:
mm/cma.c: In function 'cma_init_reserved_mem':
include/linux/kernel.h:748:17: warning: comparison of distinct pointer types lacks a cast
  (void) (&_max1 == &_max2);                   ^
mm/cma.c:186:27: note: in expansion of macro 'max'
  alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
                           ^
mm/cma.c: In function 'cma_declare_contiguous':
include/linux/kernel.h:748:17: warning: comparison of distinct pointer types lacks a cast
  (void) (&_max1 == &_max2);                   ^
include/linux/kernel.h:747:9: note: in definition of macro 'max'
  typeof(y) _max2 = (y);            ^
mm/cma.c:270:29: note: in expansion of macro 'max'
   (phys_addr_t)PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order));
                             ^
include/linux/kernel.h:748:17: warning: comparison of distinct pointer types lacks a cast
  (void) (&_max1 == &_max2);                   ^
include/linux/kernel.h:747:21: note: in definition of macro 'max'
  typeof(y) _max2 = (y);                        ^
mm/cma.c:270:29: note: in expansion of macro 'max'
   (phys_addr_t)PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order));
                             ^

Link: http://lkml.kernel.org/r/20160526150748.5be38a4f@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 1 file changed, 2 insertions(+), 2 deletions(-)

These warnings have been irking me for some time now ... applies to
Linus' tree and linux-next (and so to the mmotm tree).

index ea506eb18cd6..fa823dc2ff15 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/cma.c~mm-cma-silence-warnings-due-to-max-usage mm/cma.c
--- a/mm/cma.c~mm-cma-silence-warnings-due-to-max-usage
+++ a/mm/cma.c
@@ -183,7 +183,7 @@ int __init cma_init_reserved_mem(phys_ad
 		return -EINVAL;
 
 	/* ensure minimal alignment required by mm core */
-	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+	alignment = PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order);
 
 	/* alignment should be aligned with order_per_bit */
 	if (!IS_ALIGNED(alignment >> PAGE_SHIFT, 1 << order_per_bit))
@@ -267,7 +267,7 @@ int __init cma_declare_contiguous(phys_a
 	 * you couldn't get a contiguous memory, which is not what we want.
 	 */
 	alignment = max(alignment,
-		(phys_addr_t)PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order));
+		(phys_addr_t)PAGE_SIZE << max_t(unsigned long, MAX_ORDER - 1, pageblock_order));
 	base = ALIGN(base, alignment);
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-cma-silence-warnings-due-to-max-usage.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch

