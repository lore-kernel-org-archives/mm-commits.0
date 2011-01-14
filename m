From: akpm@linux-foundation.org
Subject: [merged] partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:52 -0800
Message-ID: <201101142252.p0EMqgDJ005647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775Ab1ANWxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbrownell@users.sourceforge.net, gregkh@suse.de, sfr@canb.auug.org.au, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     partially revert "gpiolib: annotate gpio-intialization with __must_check"
has been removed from the -mm tree.  Its filename was
     partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
drivers-nfc-pn544c-fix-min_t-warnings.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

