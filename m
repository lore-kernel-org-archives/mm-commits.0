From: akpm@linux-foundation.org
Subject: + osst-wrong-index-used-in-inner-loop.patch added to -mm tree
Date: Fri, 08 Apr 2011 12:33:03 -0700
Message-ID: <201104081933.p38JX3Y0025219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab1DHTdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2011 15:33:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, osst@riede.org


The patch titled
     osst: wrong index used in inner loop
has been added to the -mm tree.  Its filename is
     osst-wrong-index-used-in-inner-loop.patch

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
Subject: osst: wrong index used in inner loop
From: Roel Kluin <roel.kluin@gmail.com>

Index i was already used in the outer loop.  Fixes a potentially-infinite
loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Willem Riede <osst@riede.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osst.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/osst.c~osst-wrong-index-used-in-inner-loop drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~osst-wrong-index-used-in-inner-loop
+++ a/drivers/scsi/osst.c
@@ -4702,8 +4702,9 @@ static int __os_scsi_tape_open(struct in
 				STp->partition = STp->new_partition = 0;
 				if (STp->can_partitions)
 					STp->nbr_partitions = 1;  /* This guess will be updated later if necessary */
-				for (i=0; i < ST_NBR_PARTITIONS; i++) {
-					STps = &(STp->ps[i]);
+				int j;
+				for (j=0; j < ST_NBR_PARTITIONS; j++) {
+					STps = &(STp->ps[j]);
 					STps->rw = ST_IDLE;
 					STps->eof = ST_NOEOF;
 					STps->at_sm = 0;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

btrfs-dont-dereference-extent_mapping-if-null.patch
osst-wrong-index-used-in-inner-loop.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

