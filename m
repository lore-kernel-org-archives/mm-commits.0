From: akpm@linux-foundation.org
Subject: - likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch removed from -mm tree
Date: Mon, 27 Oct 2008 21:34:55 -0700
Message-ID: <200810280434.m9S4YtOL018511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbYJ1EfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 00:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     likely_prof: update to test_and_set_bit_lock / clear_bit_unlock
has been removed from the -mm tree.  Its filename was
     likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

This patch was dropped because it was folded into profile-likely-unlikely-macros.patch

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

profile-likely-unlikely-macros.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

