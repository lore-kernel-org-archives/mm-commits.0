From: akpm@linux-foundation.org
Subject: [folded-merged]
 wireless-hostap-proc-print-properly-escaped-ssid-fix.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:42:42 -0700
Message-ID: <543c5562.Q+JJl4+pF428OV/E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaJMWmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, fengguang.wu@intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wireless-hostap-proc-print-properly-escaped-ssid-fix
has been removed from the -mm tree.  Its filename was
     wireless-hostap-proc-print-properly-escaped-ssid-fix.patch

This patch was dropped because it was folded into wireless-hostap-proc-print-properly-escaped-ssid.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: wireless-hostap-proc-print-properly-escaped-ssid-fix

drivers/net/wireless/hostap/hostap_proc.c: In function 'prism2_bss_list_proc_show':
drivers/net/wireless/hostap/hostap_proc.c:184: warning: field width should have type 'int', but argument 3 has type 'size_t'

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/hostap/hostap_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/hostap/hostap_proc.c~wireless-hostap-proc-print-properly-escaped-ssid-fix drivers/net/wireless/hostap/hostap_proc.c
--- a/drivers/net/wireless/hostap/hostap_proc.c~wireless-hostap-proc-print-properly-escaped-ssid-fix
+++ a/drivers/net/wireless/hostap/hostap_proc.c
@@ -181,7 +181,7 @@ static int prism2_bss_list_proc_show(str
 		   bss->bssid, bss->last_update,
 		   bss->count, bss->capab_info);
 
-	seq_printf(m, "%*pE", bss->ssid_len, bss->ssid);
+	seq_printf(m, "%*pE", (int)bss->ssid_len, bss->ssid);
 
 	seq_putc(m, '\t');
 	seq_printf(m, "%*phN", (int)bss->ssid_len, bss->ssid);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-max77686-use-ffs-to-calculate-tm_wday.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
x86-optimize-resource-lookups-for-ioremap.patch
init-resolve-shadow-warnings.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch

