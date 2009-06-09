From: akpm@linux-foundation.org
Subject: [merged] lguest-fix-array-indexing-check.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:33 -0700
Message-ID: <200906091812.n59ICXwv018803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758141AbZFISMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: fix array indexing check
has been removed from the -mm tree.  Its filename was
     lguest-fix-array-indexing-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lguest: fix array indexing check
From: Roel Kluin <roel.kluin@gmail.com>

The check for an overindexing of cpu->arch.gdt[] has an off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/segments.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/lguest/segments.c~lguest-fix-array-indexing-check drivers/lguest/segments.c
--- a/drivers/lguest/segments.c~lguest-fix-array-indexing-check
+++ a/drivers/lguest/segments.c
@@ -150,7 +150,7 @@ void load_guest_gdt_entry(struct lg_cpu 
 {
 	/* We assume the Guest has the same number of GDT entries as the
 	 * Host, otherwise we'd have to dynamically allocate the Guest GDT. */
-	if (num > ARRAY_SIZE(cpu->arch.gdt))
+	if (num >= ARRAY_SIZE(cpu->arch.gdt))
 		kill_guest(cpu, "too many gdt entries %i", num);
 
 	/* Set it up, then fix it. */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
tvp514x-try_count-off-by-one.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
atl1c-wake_mcast-tested-twice-not-wake_ucast.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-fix-off-by-one-errors.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

