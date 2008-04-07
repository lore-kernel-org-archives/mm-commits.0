From: akpm@linux-foundation.org
Subject: + likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch added to -mm tree
Date: Mon, 07 Apr 2008 16:46:45 -0700
Message-ID: <200804072346.m37NkjxC031106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754111AbYDGXrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 19:47:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl


The patch titled
     likely_prof: update to test_and_set_bit_lock / clear_bit_unlock
has been added to the -mm tree.  Its filename is
     likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: likely_prof: update to test_and_set_bit_lock / clear_bit_unlock
From: Roel Kluin <12o3l@tiscali.nl>

Because the _lock routines are faster and provide a better example to follow.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/likely_prof.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/likely_prof.c~likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock lib/likely_prof.c
--- a/lib/likely_prof.c~likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock
+++ a/lib/likely_prof.c
@@ -36,7 +36,7 @@ int do_check_likely(struct likeliness *l
 		 * disable and it was a bit cleaner then using internal __raw
 		 * spinlock calls.
 		 */
-		if (!test_and_set_bit(0, &likely_lock)) {
+		if (!test_and_set_bit_lock(0, &likely_lock)) {
 			if (likeliness->label & LP_UNSEEN) {
 				likeliness->label &= (~LP_UNSEEN);
 				likeliness->next = likeliness_head;
@@ -44,8 +44,7 @@ int do_check_likely(struct likeliness *l
 				likeliness->caller = (unsigned long)
 						__builtin_return_address(0);
 			}
-			smp_mb__before_clear_bit();
-			clear_bit(0, &likely_lock);
+			clear_bit_unlock(0, &likely_lock);
 		}
 	}
 
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-powerpc.patch
git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-net.patch
git-scsi-misc.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
git-cryptodev.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

