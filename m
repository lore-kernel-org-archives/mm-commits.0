From: akpm@linux-foundation.org
Subject: + asm-generic-atomich-add-atomic_set_mask-helper.patch added to -mm tree
Date: Tue, 21 Jun 2011 16:06:01 -0700
Message-ID: <201106212306.p5LN61jv030232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757015Ab1FUXGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 19:06:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, arnd@arndb.de, asharma@fb.com


The patch titled
     asm-generic/atomic.h: add atomic_set_mask() helper
has been added to the -mm tree.  Its filename is
     asm-generic-atomich-add-atomic_set_mask-helper.patch

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
Subject: asm-generic/atomic.h: add atomic_set_mask() helper
From: Mike Frysinger <vapier@gentoo.org>

Since arches are expected to implement this guy, add a common version for
people the same way as atomic_clear_mask is handled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/asm-generic/atomic.h~asm-generic-atomich-add-atomic_set_mask-helper include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~asm-generic-atomich-add-atomic_set_mask-helper
+++ a/include/asm-generic/atomic.h
@@ -157,6 +157,22 @@ static inline void atomic_clear_mask(uns
 	raw_local_irq_restore(flags);
 }
 
+/**
+ * atomic_set_mask - Atomically set bits in atomic variable
+ * @mask: Mask of the bits to be set
+ * @v: pointer of type atomic_t
+ *
+ * Atomically sets the bits set in @mask in @v
+ */
+static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
+{
+	unsigned long flags;
+
+	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
+	v->counter |= mask;
+	raw_local_irq_restore(flags);
+}
+
 /* Assume that atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()	barrier()
 #define smp_mb__after_atomic_dec()	barrier()
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

