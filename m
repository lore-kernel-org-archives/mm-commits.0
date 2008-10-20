From: akpm@linux-foundation.org
Subject: + intel-agp-avoid-oops-for-g33-on-1mb-stolen-case.patch added to -mm tree
Date: Mon, 20 Oct 2008 14:19:04 -0700
Message-ID: <200810202119.m9KLJ451018804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYJTVTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 17:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bphilips@suse.de, airlied@linux.ie


The patch titled
     intel-agp: avoid oops for G33 on 1MB stolen case
has been added to the -mm tree.  Its filename is
     intel-agp-avoid-oops-for-g33-on-1mb-stolen-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-agp: avoid oops for G33 on 1MB stolen case
From: Brandon Philips <bphilips@suse.de>

This is similar to f443675affe3f16dd428e46f0f7fd3f4d703eeab which was
reverted because it broke older X.org driver. This patch only fixes
the 1MB stolen case since it causes an oops.

Xorg will not work without the accompanying patch[1] but avoiding an
oops and making it possible to work with patched xorg driver is
reasonable.

[1] http://ifup.org/~philips/review/xf86-video-intel-G33-1mb.patch

Explanation of the oops:

> static void intel_i830_init_gtt_entries(void)
...
>         } else if (IS_G33) {
>         /* G33's GTT size defined in gmch_ctrl */
>                 switch (gmch_ctrl & G33_PGETBL_SIZE_MASK) {
>                 case G33_PGETBL_SIZE_1M:
>                         size = 1024;
>                         break;
...
>                 size += 4;

size = 1028

Then since we have the BIOS setting 1MB for the device in the GMCH
control we get to here:

>         } else {
>                 switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
>                 case I855_GMCH_GMS_STOLEN_1M:
>                         gtt_entries = MB(1) - KB(size);
>                         break;

MB(1) = 1 * 1024 * 1024
KB(1028) = 1028 * 1024

MB(1) - KB(1028) = -4096

>         gtt_entries /= KB(4);
>         intel_private.gtt_entries = gtt_entries;

We end up with -1 in gtt_entries.

This leads to intel_i915_configure reading/writing to areas outside of
mapped memory and the oops.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=391261

Signed-off-by: Brandon Philips <bphilips@suse.de>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/char/agp/intel-agp.c~intel-agp-avoid-oops-for-g33-on-1mb-stolen-case drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel-agp-avoid-oops-for-g33-on-1mb-stolen-case
+++ a/drivers/char/agp/intel-agp.c
@@ -561,6 +561,14 @@ static void intel_i830_init_gtt_entries(
 	} else {
 		switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
 		case I855_GMCH_GMS_STOLEN_1M:
+			if (IS_G33) {
+				size = 0;
+				printk(KERN_WARNING PFX
+				       "Warning: G33 chipset with 1MB"
+					" allocated. Older X.org Intel drivers"
+					" will not work.\n");
+				WARN_ON(1);
+			}
 			gtt_entries = MB(1) - KB(size);
 			break;
 		case I855_GMCH_GMS_STOLEN_4M:
_

Patches currently in -mm which might be from bphilips@suse.de are

origin.patch
intel-agp-avoid-oops-for-g33-on-1mb-stolen-case.patch

