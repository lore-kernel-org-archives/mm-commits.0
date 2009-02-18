From: akpm@linux-foundation.org
Subject: + arkfb-fix-misplaced-parentheses.patch added to -mm tree
Date: Wed, 18 Feb 2009 13:09:46 -0800
Message-ID: <200902182109.n1IL9kOq001176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbZBRVKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 16:10:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, santiago@crfreenet.org


The patch titled
     arkfb: fix misplaced parentheses
has been added to the -mm tree.  Its filename is
     arkfb-fix-misplaced-parentheses.patch

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
Subject: arkfb: fix misplaced parentheses
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/arkfb.c~arkfb-fix-misplaced-parentheses drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~arkfb-fix-misplaced-parentheses
+++ a/drivers/video/arkfb.c
@@ -470,7 +470,7 @@ static void ark_dac_read_regs(void *data
 
 	while (count != 0)
 	{
-		vga_wseq(NULL, 0x1C, regval | (code[0] & 4) ? 0x80 : 0);
+		vga_wseq(NULL, 0x1C, regval | (code[0] & 4 ? 0x80 : 0));
 		code[1] = vga_r(NULL, dac_regs[code[0] & 3]);
 		count--;
 		code += 2;
@@ -485,7 +485,7 @@ static void ark_dac_write_regs(void *dat
 
 	while (count != 0)
 	{
-		vga_wseq(NULL, 0x1C, regval | (code[0] & 4) ? 0x80 : 0);
+		vga_wseq(NULL, 0x1C, regval | (code[0] & 4 ? 0x80 : 0));
 		vga_w(NULL, dac_regs[code[0] & 3], code[1]);
 		count--;
 		code += 2;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
ufs-sector_t-cannot-be-negative.patch

