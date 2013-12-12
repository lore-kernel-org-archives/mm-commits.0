From: akpm@linux-foundation.org
Subject: [merged] m68k-atari-hide-rtc_port-macro-from-rtc-cmos.patch
 removed from -mm tree
Date: Wed, 11 Dec 2013 16:56:19 -0800
Message-ID: <52a909b3.oLPNCQB6fhmwpeMx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LLA4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 19:56:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: [merged] m68k-atari-hide-rtc_port-macro-from-rtc-cmos.patch removed from -mm tree
To: geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 16:56:19 -0800


The patch titled
     Subject: m68k/atari: hide RTC_PORT() macro from rtc-cmos
has been removed from the -mm tree.  Its filename was
     m68k-atari-hide-rtc_port-macro-from-rtc-cmos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m68k/atari: hide RTC_PORT() macro from rtc-cmos

Rename RTC_PORT() to ATARI_RTC_PORT(), as the rtc-cmos RTC driver uses the
presence of this macro to enable support for the second NVRAM bank, which
Atari doesn't have ("Unable to handle kernel access at virtual address
00ff8965").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/mc146818rtc.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/m68k/include/asm/mc146818rtc.h~m68k-atari-hide-rtc_port-macro-from-rtc-cmos arch/m68k/include/asm/mc146818rtc.h
--- a/arch/m68k/include/asm/mc146818rtc.h~m68k-atari-hide-rtc_port-macro-from-rtc-cmos
+++ a/arch/m68k/include/asm/mc146818rtc.h
@@ -10,16 +10,16 @@
 
 #include <asm/atarihw.h>
 
-#define RTC_PORT(x)	(TT_RTC_BAS + 2*(x))
+#define ATARI_RTC_PORT(x)	(TT_RTC_BAS + 2*(x))
 #define RTC_ALWAYS_BCD	0
 
 #define CMOS_READ(addr) ({ \
-atari_outb_p((addr),RTC_PORT(0)); \
-atari_inb_p(RTC_PORT(1)); \
+atari_outb_p((addr), ATARI_RTC_PORT(0)); \
+atari_inb_p(ATARI_RTC_PORT(1)); \
 })
 #define CMOS_WRITE(val, addr) ({ \
-atari_outb_p((addr),RTC_PORT(0)); \
-atari_outb_p((val),RTC_PORT(1)); \
+atari_outb_p((addr), ATARI_RTC_PORT(0)); \
+atari_outb_p((val), ATARI_RTC_PORT(1)); \
 })
 #endif /* CONFIG_ATARI */
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch
rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
rtc-s5m-enable-irq-wake-during-suspend.patch
mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch
inith-add-missing-initcall-variants.patch
futex-switch-to-user_ds-for-futex-test.patch
sh-always-link-in-helper-functions-extracted-from-libgcc.patch
drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

