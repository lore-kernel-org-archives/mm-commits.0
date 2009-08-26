From: akpm@linux-foundation.org
Subject: - serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch removed from -mm tree
Date: Wed, 26 Aug 2009 13:24:04 -0700
Message-ID: <200908262024.n7QKO4Vl015636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbZHZUZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 16:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, alan@lxorguk.ukuu.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     serial: bfin_5xx: fix building as module when early printk is enabled
has been removed from the -mm tree.  Its filename was
     serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch

This patch was dropped because C code shouldn't set or unset Kconfig variables

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: bfin_5xx: fix building as module when early printk is enabled
From: Mike Frysinger <vapier@gentoo.org>

Since early printk only makes sense/works when the serial driver is built
into the kernel, disable the option for this driver when it is going to be
built as a module.  Otherwise we get build failures due to the ifdef
handling.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/serial/bfin_5xx.c~serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled
+++ a/drivers/serial/bfin_5xx.c
@@ -46,6 +46,10 @@
 # undef CONFIG_EARLY_PRINTK
 #endif
 
+#ifdef CONFIG_SERIAL_BFIN_MODULE
+# undef CONFIG_EARLY_PRINTK
+#endif
+
 /* UART name and device definitions */
 #define BFIN_SERIAL_NAME	"ttyBF"
 #define BFIN_SERIAL_MAJOR	204
_

Patches currently in -mm which might be from vapier@gentoo.org are

md-dm-log-fix-cn_ulog_callback-declaration.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
blackfin-fix-read-buffer-overflow.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch
rtc-bfin-do-not-share-rtc-irq.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch

