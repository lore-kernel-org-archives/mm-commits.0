From: akpm@linux-foundation.org
Subject: + drivers-acpi-apei-ghesc-fix-32-bit-build.patch added to -mm tree
Date: Tue, 02 Aug 2011 16:08:43 -0700
Message-ID: <201108022347.p72Nl7cj022021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703Ab1HBXrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2011 19:47:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com, lenb@kernel.org, ying.huang@intel.com


The patch titled
     drivers/acpi/apei/ghes.c: fix 32-bit build
has been added to the -mm tree.  Its filename is
     drivers-acpi-apei-ghesc-fix-32-bit-build.patch

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
Subject: drivers/acpi/apei/ghes.c: fix 32-bit build
From: Andrew Morton <akpm@linux-foundation.org>

linux-next i386 allmodconfig:

drivers/built-in.o: In function `ghes_estatus_cache_add':
ghes.c:(.text+0xa6d27): undefined reference to `__udivdi3'

Remaining bugs are:

drivers/acpi/apei/ghes.c: In function 'ghes_estatus_cached':
drivers/acpi/apei/ghes.c:542: warning: integer overflow in expression
drivers/acpi/apei/ghes.c: In function 'ghes_estatus_cache_add':
drivers/acpi/apei/ghes.c:619: warning: integer overflow in expression

Cc: Len Brown <lenb@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/apei/ghes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/apei/ghes.c~drivers-acpi-apei-ghesc-fix-32-bit-build drivers/acpi/apei/ghes.c
--- a/drivers/acpi/apei/ghes.c~drivers-acpi-apei-ghesc-fix-32-bit-build
+++ a/drivers/acpi/apei/ghes.c
@@ -622,7 +622,8 @@ static void ghes_estatus_cache_add(
 			break;
 		}
 		count = atomic_read(&cache->count);
-		period = duration / (count + 1);
+		period = duration;
+		do_div(period, count + 1);
 		if (period > max_period) {
 			max_period = period;
 			slot = i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-x86-platform-mrst-pmuc-needs-moduleh.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
hpet-factor-timer-allocate-from-open.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
pps-new-client-driver-using-gpio-fix.patch
drivers-acpi-apei-ghesc-fix-32-bit-build.patch

