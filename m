From: akpm@linux-foundation.org
Subject: + md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:23:42 -0800
Message-ID: <200803030823.m238NgZc006543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbYCCIYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:24:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: k-tanaka@ce.jp.nec.com, neilb@suse.de


The patch titled
     md: the md RAID10 resync thread could cause a md RAID10 array deadlock
has been added to the -mm tree.  Its filename is
     md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock.patch

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
Subject: md: the md RAID10 resync thread could cause a md RAID10 array deadlock
From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>

This message describes another issue about md RAID10 found by testing the
2.6.24 md RAID10 using new scsi fault injection framework.

Abstract:

When a scsi error results in disabling a disk during RAID10 recovery, the
resync threads of md RAID10 could stall.

This case, the raid array has already been broken and it may not matter.  But
I think stall is not preferable.  If it occurs, even shutdown or reboot will
fail because of resource busy.

The deadlock mechanism:

The r10bio_s structure has a "remaining" member to keep track of BIOs yet to
be handled when recovering.  The "remaining" counter is incremented when
building a BIO in sync_request() and is decremented when finish a BIO in
end_sync_write().

If building a BIO fails for some reasons in sync_request(), the "remaining"
should be decremented if it has already been incremented.  I found a case
where this decrement is forgotten.  This causes a md_do_sync() deadlock
because md_do_sync() waits for md_done_sync() called by end_sync_write(), but
end_sync_write() never calls md_done_sync() because of the "remaining" counter
mismatch.

For example, this problem would be reproduced in the following case:

Personalities : [raid10]
md0 : active raid10 sdf1[4] sde1[5](F) sdd1[2] sdc1[1] sdb1[6](F)
      3919616 blocks 64K chunks 2 near-copies [4/2] [_UU_]
      [>....................]  recovery =  2.2% (45376/1959808) finish=0.7min speed=45376K/sec

This case, sdf1 is recovering, sdb1 and sde1 are disabled.
An additional error with detaching sdd will cause a deadlock.

md0 : active raid10 sdf1[4] sde1[5](F) sdd1[6](F) sdc1[1] sdb1[7](F)
      3919616 blocks 64K chunks 2 near-copies [4/1] [_U__]
      [=>...................]  recovery =  5.0% (99520/1959808) finish=5.9min speed=5237K/sec

 2739 ?        S<     0:17 [md0_raid10]
28608 ?        D<     0:00 [md0_resync]
28629 pts/1    Ss     0:00 bash
28830 pts/1    R+     0:00 ps ax
31819 ?        D<     0:00 [kjournald]

The resync thread keeps working, but actually it is deadlocked.

Patch:
By this patch, the remaining counter will be decremented if needed.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid10.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/md/raid10.c~md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock
+++ a/drivers/md/raid10.c
@@ -1818,6 +1818,8 @@ static sector_t sync_request(mddev_t *md
 				if (j == conf->copies) {
 					/* Cannot recover, so abort the recovery */
 					put_buf(r10_bio);
+					if (rb2)
+						atomic_dec(&rb2->remaining);
 					r10_bio = rb2;
 					if (!test_and_set_bit(MD_RECOVERY_ERR, &mddev->recovery))
 						printk(KERN_INFO "raid10: %s: insufficient working devices for recovery.\n",
_

Patches currently in -mm which might be from k-tanaka@ce.jp.nec.com are

md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error.patch
md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync.patch
md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock.patch

