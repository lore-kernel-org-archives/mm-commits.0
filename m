From: akpm@linux-foundation.org
Subject: + partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check.patch added to -mm tree
Date: Thu, 13 Jan 2011 16:20:20 -0800
Message-ID: <201101140020.p0E0KKD2009829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137Ab1ANAVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 19:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dbrownell@users.sourceforge.net, gregkh@suse.de, sfr@canb.auug.org.au, w.sang@pengutronix.de


The patch titled
     partially revert "gpiolib: annotate gpio-intialization with __must_check"
has been added to the -mm tree.  Its filename is
     partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check.patch

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
Subject: partially revert "gpiolib: annotate gpio-intialization with __must_check"
From: Andrew Morton <akpm@linux-foundation.org>

Revert the __must_check aditions: we don't add __must_check until the
things which must be checked are actually checked.

Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <gregkh@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/gpio.h |   10 +++++-----
 include/linux/gpio.h       |    6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/asm-generic/gpio.h~partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check
+++ a/include/asm-generic/gpio.h
@@ -147,11 +147,11 @@ extern struct gpio_chip *gpiochip_find(v
 /* Always use the library code for GPIO management calls,
  * or when sleeping may be involved.
  */
-extern int __must_check gpio_request(unsigned gpio, const char *label);
+extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
-extern int __must_check gpio_direction_input(unsigned gpio);
-extern int __must_check gpio_direction_output(unsigned gpio, int value);
+extern int gpio_direction_input(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio, int value);
 
 extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
 
@@ -192,8 +192,8 @@ struct gpio {
 	const char	*label;
 };
 
-extern int __must_check gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
-extern int __must_check gpio_request_array(struct gpio *array, size_t num);
+extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+extern int gpio_request_array(struct gpio *array, size_t num);
 extern void gpio_free_array(struct gpio *array, size_t num);
 
 #ifdef CONFIG_GPIO_SYSFS
diff -puN include/linux/gpio.h~partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check include/linux/gpio.h
--- a/include/linux/gpio.h~partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check
+++ a/include/linux/gpio.h
@@ -30,7 +30,7 @@ static inline int gpio_is_valid(int numb
 	return 0;
 }
 
-static inline int __must_check gpio_request(unsigned gpio, const char *label)
+static inline int gpio_request(unsigned gpio, const char *label)
 {
 	return -ENOSYS;
 }
@@ -62,12 +62,12 @@ static inline void gpio_free_array(struc
 	WARN_ON(1);
 }
 
-static inline int __must_check gpio_direction_input(unsigned gpio)
+static inline int gpio_direction_input(unsigned gpio)
 {
 	return -ENOSYS;
 }
 
-static inline int __must_check gpio_direction_output(unsigned gpio, int value)
+static inline int gpio_direction_output(unsigned gpio, int value)
 {
 	return -ENOSYS;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call.patch
thp-pte-alloc-trans-splitting.patch
thp-kvm-mmu-transparent-hugepage-support.patch
thp-khugepaged-make-khugepaged-aware-of-madvise.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
mm-fix-migration-hangs-on-anon_vma-lock.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check.patch

