From: akpm@linux-foundation.org
Subject: [merged]
 slub-use-bool-function-return-values-of-true-false-not-1-0.patch removed
 from -mm tree
Date: Wed, 15 Apr 2015 12:09:02 -0700
Message-ID: <552eb74e.H6LKiB+E2cBiOlYA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbbDOTJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: use bool function return values of true/false not 1/0
has been removed from the -mm tree.  Its filename was
     slub-use-bool-function-return-values-of-true-false-not-1-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: slub: use bool function return values of true/false not 1/0

Use the normal return values for bool functions

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/slub.c~slub-use-bool-function-return-values-of-true-false-not-1-0 mm/slub.c
--- a/mm/slub.c~slub-use-bool-function-return-values-of-true-false-not-1-0
+++ a/mm/slub.c
@@ -374,7 +374,7 @@ static inline bool __cmpxchg_double_slab
 		if (cmpxchg_double(&page->freelist, &page->counters,
 				   freelist_old, counters_old,
 				   freelist_new, counters_new))
-			return 1;
+			return true;
 	} else
 #endif
 	{
@@ -384,7 +384,7 @@ static inline bool __cmpxchg_double_slab
 			page->freelist = freelist_new;
 			set_page_slub_counters(page, counters_new);
 			slab_unlock(page);
-			return 1;
+			return true;
 		}
 		slab_unlock(page);
 	}
@@ -396,7 +396,7 @@ static inline bool __cmpxchg_double_slab
 	pr_info("%s %s: cmpxchg double redo ", n, s->name);
 #endif
 
-	return 0;
+	return false;
 }
 
 static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
@@ -410,7 +410,7 @@ static inline bool cmpxchg_double_slab(s
 		if (cmpxchg_double(&page->freelist, &page->counters,
 				   freelist_old, counters_old,
 				   freelist_new, counters_new))
-			return 1;
+			return true;
 	} else
 #endif
 	{
@@ -424,7 +424,7 @@ static inline bool cmpxchg_double_slab(s
 			set_page_slub_counters(page, counters_new);
 			slab_unlock(page);
 			local_irq_restore(flags);
-			return 1;
+			return true;
 		}
 		slab_unlock(page);
 		local_irq_restore(flags);
@@ -437,7 +437,7 @@ static inline bool cmpxchg_double_slab(s
 	pr_info("%s %s: cmpxchg double redo ", n, s->name);
 #endif
 
-	return 0;
+	return false;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
maintainers-use-tabs-consistently.patch
maintainers-credits-remove-stefano-brivio-from-b43.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

