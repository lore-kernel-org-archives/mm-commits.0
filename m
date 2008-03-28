From: akpm@linux-foundation.org
Subject: - dm-raid1-bitops-bug.patch removed from -mm tree
Date: Fri, 28 Mar 2008 10:50:27 -0700
Message-ID: <200803281750.m2SHoRjm002379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754239AbYC1Rv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 13:51:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, agk@redhat.com, jbrassow@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm raid1: bitops bug
has been removed from the -mm tree.  Its filename was
     dm-raid1-bitops-bug.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm raid1: bitops bug
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Commit 8f0205b798f926e2745de5fdebf0a8605c621de6
"dm raid1: handle recovery failures" introduces a test_bit on an
integer. test_bit is only defined to do something useful on arrays
of long. Remove the test_bit code and use hand coded test bit
instead.

Cc: Jonathan Brassow <jbrassow@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-raid1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/md/dm-raid1.c~dm-raid1-bitops-bug drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-raid1-bitops-bug
+++ a/drivers/md/dm-raid1.c
@@ -756,7 +756,8 @@ static void recovery_complete(int read_e
 {
 	struct region *reg = (struct region *)context;
 	struct mirror_set *ms = reg->rh->ms;
-	int m, bit = 0;
+	unsigned int mask = 1;
+	int m;
 
 	if (read_err) {
 		/* Read error means the failure of default mirror. */
@@ -774,10 +775,10 @@ static void recovery_complete(int read_e
 		for (m = 0; m < ms->nr_mirrors; m++) {
 			if (&ms->mirror[m] == get_default_mirror(ms))
 				continue;
-			if (test_bit(bit, &write_err))
+			if (write_err & mask)
 				fail_mirror(ms->mirror + m,
 					    DM_RAID1_SYNC_ERROR);
-			bit++;
+			mask <<= 1;
 		}
 	}
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

dm-io-write-error-bits-form-long-not-int.patch
git-hrt.patch
git-kvm.patch
git-kvm-vs-git-s390.patch
git-s390.patch
git-s390-git-rejects.patch
s390-remove-redundant-display-of-free-swap-space-in-show_mem.patch
drivers-s390-replace-remaining-__function__-occurrences.patch
dm-raid1-bitops-bug.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch

