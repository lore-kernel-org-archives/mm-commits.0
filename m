From: akpm@linux-foundation.org
Subject: + ivtv-read-buffer-overflow.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:44:50 -0700
Message-ID: <200907232144.n6NLiov9021200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbZGWVpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:45:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, hverkuil@xs4all.nl, mchehab@infradead.org


The patch titled
     ivtv: read buffer overflow
has been added to the -mm tree.  Its filename is
     ivtv-read-buffer-overflow.patch

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
Subject: ivtv: read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

This mistakenly tests against sizeof(freqs) instead of the array size. 
Due to the mask the only illegal value possible was 3.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ivtv/ivtv-controls.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/ivtv/ivtv-controls.c~ivtv-read-buffer-overflow drivers/media/video/ivtv/ivtv-controls.c
--- a/drivers/media/video/ivtv/ivtv-controls.c~ivtv-read-buffer-overflow
+++ a/drivers/media/video/ivtv/ivtv-controls.c
@@ -17,6 +17,7 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/kernel.h>
 
 #include "ivtv-driver.h"
 #include "ivtv-cards.h"
@@ -281,7 +282,7 @@ int ivtv_s_ext_ctrls(struct file *file, 
 		idx = p.audio_properties & 0x03;
 		/* The audio clock of the digitizer must match the codec sample
 		   rate otherwise you get some very strange effects. */
-		if (idx < sizeof(freqs))
+		if (idx < ARRAY_SIZE(freqs))
 			ivtv_call_all(itv, audio, s_clock_freq, freqs[idx]);
 		return err;
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

