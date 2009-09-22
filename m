From: akpm@linux-foundation.org
Subject: [folded] build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:38:30 -0700
Message-ID: <200909222138.n8MLcVYc023300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbZIVVit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, JBeulich@novell.com, andi@firstfloor.org, catalin.marinas@arm.com, davem@davemloft.net, jbeulich@novell.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix
has been removed from the -mm tree.  Its filename was
     build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch

This patch was dropped because it was folded into build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix
From: Andrew Morton <akpm@linux-foundation.org>

/usr/src/devel/arch/sparc/include/asm/vio.h: In function `vio_dring_avail':
/usr/src/devel/arch/sparc/include/asm/vio.h:261: error: bit-field `<anonymous>' width not an integer constant


Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Jan Beulich" <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/vio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/vio.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix arch/sparc/include/asm/vio.h
--- a/arch/sparc/include/asm/vio.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix
+++ a/arch/sparc/include/asm/vio.h
@@ -258,7 +258,7 @@ static inline void *vio_dring_entry(stru
 static inline u32 vio_dring_avail(struct vio_dring_state *dr,
 				  unsigned int ring_size)
 {
-	BUILD_BUG_ON(!is_power_of_2(ring_size));
+	MAYBE_BUILD_BUG_ON(!is_power_of_2(ring_size));
 
 	return (dr->pending -
 		((dr->prod - dr->cons) & (ring_size - 1)));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch

