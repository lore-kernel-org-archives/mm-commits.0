From: akpm@linux-foundation.org
Subject: + dm-raid1-bitops-bug.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:50 -0800
Message-ID: <200802230732.m1N7Wdmr018088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbYBWHyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, agk@redhat.com, jbrassow@redhat.com


The patch titled
     dm raid1: bitops bug
has been added to the -mm tree.  Its filename is
     dm-raid1-bitops-bug.patch

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
@@ -758,7 +758,8 @@ static void recovery_complete(int read_e
 {
 	struct region *reg = (struct region *)context;
 	struct mirror_set *ms = reg->rh->ms;
-	int m, bit = 0;
+	unsigned int mask = 1;
+	int m;
 
 	if (read_err) {
 		/* Read error means the failure of default mirror. */
@@ -776,10 +777,10 @@ static void recovery_complete(int read_e
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

git-s390.patch
s390-use-div_round_up.patch
dm-raid1-bitops-bug.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
