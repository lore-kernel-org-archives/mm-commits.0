From: akpm@linux-foundation.org
Subject: + stmp3xxx-deallocation-with-negative-index-of-descriptors.patch added to -mm tree
Date: Mon, 20 Jul 2009 23:17:28 -0700
Message-ID: <200907210617.n6L6HSP6022684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbZGUGRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 02:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dpervushin@embeddedalley.com, rmk@arm.linux.org.uk


The patch titled
     STMP3xxx: deallocation with negative index of descriptors[]
has been added to the -mm tree.  Its filename is
     stmp3xxx-deallocation-with-negative-index-of-descriptors.patch

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
Subject: STMP3xxx: deallocation with negative index of descriptors[]
From: Roel Kluin <roel.kluin@gmail.com>

The last deallocation is invalid. In the last iteration, i is -1.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: dmitry pervushin <dpervushin@embeddedalley.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-stmp3xxx/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-stmp3xxx/dma.c~stmp3xxx-deallocation-with-negative-index-of-descriptors arch/arm/plat-stmp3xxx/dma.c
--- a/arch/arm/plat-stmp3xxx/dma.c~stmp3xxx-deallocation-with-negative-index-of-descriptors
+++ a/arch/arm/plat-stmp3xxx/dma.c
@@ -264,7 +264,7 @@ int stmp3xxx_dma_make_chain(int ch, stru
 					stmp3xxx_dma_free_command(ch,
 								  &descriptors
 								  [i]);
-				} while (i-- >= 0);
+				} while (i-- > 0);
 			}
 			return err;
 		}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch

