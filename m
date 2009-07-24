From: akpm@linux-foundation.org
Subject: + sisfb-read-buffer-overflow.patch added to -mm tree
Date: Fri, 24 Jul 2009 16:56:06 -0700
Message-ID: <200907242356.n6ONu6je031955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbZGXX4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 19:56:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, thomas@winischhofer.net


The patch titled
     sisfb: read buffer overflow
has been added to the -mm tree.  Its filename is
     sisfb-read-buffer-overflow.patch

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
Subject: sisfb: read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

If called with mode_idx = 1, rate = 68, a read occurs from
sisfb_vrate[-1].refresh.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/sis/sis_main.c~sisfb-read-buffer-overflow drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~sisfb-read-buffer-overflow
+++ a/drivers/video/sis/sis_main.c
@@ -698,8 +698,8 @@ sisfb_search_refresh_rate(struct sis_vid
 						rate, sisfb_vrate[i].refresh);
 					ivideo->rate_idx = sisfb_vrate[i].idx;
 					ivideo->refresh_rate = sisfb_vrate[i].refresh;
-				} else if(((rate - sisfb_vrate[i-1].refresh) <= 2)
-						&& (sisfb_vrate[i].idx != 1)) {
+				} else if((sisfb_vrate[i].idx != 1) &&
+						((rate - sisfb_vrate[i-1].refresh) <= 2)) {
 					DPRINTK("sisfb: Adjusting rate from %d down to %d\n",
 						rate, sisfb_vrate[i-1].refresh);
 					ivideo->rate_idx = sisfb_vrate[i-1].idx;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-cell-replace-strncpy-by-strlcpy.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

