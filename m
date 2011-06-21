From: akpm@linux-foundation.org
Subject: + asm-generic-atomich-fix-type-used-in-atomic_clear_mask.patch added to -mm tree
Date: Tue, 21 Jun 2011 16:05:59 -0700
Message-ID: <201106212305.p5LN5xbO030222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757015Ab1FUXGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 19:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, arnd@arndb.de, asharma@fb.com


The patch titled
     asm-generic/atomic.h: fix type used in atomic_clear_mask
has been added to the -mm tree.  Its filename is
     asm-generic-atomich-fix-type-used-in-atomic_clear_mask.patch

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
Subject: asm-generic/atomic.h: fix type used in atomic_clear_mask
From: Mike Frysinger <vapier@gentoo.org>

The atomic helpers are supposed to take an atomic_t pointer, not a random
unsigned long pointer.  So convert atomic_clear_mask over.

While we're here, also add some nice documentation to the func.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/atomic.h~asm-generic-atomich-fix-type-used-in-atomic_clear_mask include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~asm-generic-atomich-fix-type-used-in-atomic_clear_mask
+++ a/include/asm-generic/atomic.h
@@ -140,13 +140,20 @@ static inline int __atomic_add_unless(at
   return c;
 }
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+/**
+ * atomic_clear_mask - Atomically clear bits in atomic variable
+ * @mask: Mask of the bits to be cleared
+ * @v: pointer of type atomic_t
+ *
+ * Atomically clears the bits set in @mask from @v
+ */
+static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
 {
 	unsigned long flags;
 
 	mask = ~mask;
 	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
-	*addr &= mask;
+	v->counter &= mask;
 	raw_local_irq_restore(flags);
 }
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch
asm-generic-systemh-drop-useless-__kernel__.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch
asm-generic-atomich-simplify-inc-dec-test-helpers.patch
asm-generic-atomich-fix-type-used-in-atomic_clear_mask.patch
asm-generic-atomich-add-atomic_set_mask-helper.patch
asm-generic-atomich-allow-smp-peeps-to-leverage-this.patch
blackfin-smp-punt-unused-atomic_test_mask-helper.patch
blackfin-smp-convert-to-common-asm-generic-atomich.patch

