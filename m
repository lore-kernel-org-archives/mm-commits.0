From: akpm@linux-foundation.org
Subject: [wrecked] dvb-negative-internal-sub_range-wont-get-noticed.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:44:44 -0700
Message-ID: <200903182244.n2IMiia9019632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756131AbZCRWrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:47:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     dvb: negative internal->sub_range won't get noticed
has been removed from the -mm tree.  Its filename was
     dvb-negative-internal-sub_range-wont-get-noticed.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dvb: negative internal->sub_range won't get noticed
From: Roel Kluin <roel.kluin@gmail.com>

internal->sub_range is unsigned, a negative won't get noticed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/stb0899_algo.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/media/dvb/frontends/stb0899_algo.c~dvb-negative-internal-sub_range-wont-get-noticed drivers/media/dvb/frontends/stb0899_algo.c
--- a/drivers/media/dvb/frontends/stb0899_algo.c~dvb-negative-internal-sub_range-wont-get-noticed
+++ a/drivers/media/dvb/frontends/stb0899_algo.c
@@ -467,13 +467,14 @@ static void next_sub_range(struct stb089
 
 	if (internal->sub_dir > 0) {
 		old_sub_range = internal->sub_range;
-		internal->sub_range = MIN((internal->srch_range / 2) -
+		if (internal->tuner_offst + internal->sub_range / 2 >=
+				internal->srch_range / 2)
+			internal->sub_range = 0;
+		else
+			internal->sub_range = min((internal->srch_range / 2) -
 					  (internal->tuner_offst + internal->sub_range / 2),
 					   internal->sub_range);
 
-		if (internal->sub_range < 0)
-			internal->sub_range = 0;
-
 		internal->tuner_offst += (old_sub_range + internal->sub_range) / 2;
 	}
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
jffs2_acl_count-tests-0-on-unsigned.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
hugetlb-chg-cannot-become-less-than-0.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
rtc-test-before-subtraction-on-unsigned.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch

