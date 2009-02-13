From: akpm@linux-foundation.org
Subject: + frv-duplicate-output_buffer-of-e03.patch added to -mm tree
Date: Fri, 13 Feb 2009 15:01:48 -0800
Message-ID: <200902132301.n1DN1mPU001171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755004AbZBMXCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 18:02:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dhowells@redhat.com, jason.wessel@windriver.com


The patch titled
     frv: duplicate output_buffer of E03
has been added to the -mm tree.  Its filename is
     frv-duplicate-output_buffer-of-e03.patch

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
Subject: frv: duplicate output_buffer of E03
From: Roel Kluin <roel.kluin@gmail.com>

In the case of an error, output_buffer gets an E0X value.  E03 was set in
two.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/gdb-stub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/frv/kernel/gdb-stub.c~frv-duplicate-output_buffer-of-e03 arch/frv/kernel/gdb-stub.c
--- a/arch/frv/kernel/gdb-stub.c~frv-duplicate-output_buffer-of-e03
+++ a/arch/frv/kernel/gdb-stub.c
@@ -1880,7 +1880,7 @@ void gdbstub(int sigval)
 			}
 
 			if (temp >= 5) {
-				gdbstub_strcpy(output_buffer,"E03");
+				gdbstub_strcpy(output_buffer,"E02");
 				break;
 			}
 
@@ -1908,7 +1908,7 @@ void gdbstub(int sigval)
 			}
 
 			if (temp >= 5) {
-				gdbstub_strcpy(output_buffer,"E03");
+				gdbstub_strcpy(output_buffer,"E02");
 				break;
 			}
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
v4l-dvb-calibration-still-successful-at-10.patch
leds-fix-confusion.patch
pci-hotplug-shpchp-busnr-reaches-end-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
paride-pgc-xs-confusion.patch
m68k-amiflop-ptr-incremented-past-0x4489.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
ufs-sector_t-cannot-be-negative.patch

