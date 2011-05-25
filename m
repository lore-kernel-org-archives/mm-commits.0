From: akpm@linux-foundation.org
Subject: [merged] osst-wrong-index-used-in-inner-loop.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:54 -0700
Message-ID: <201105252031.p4PKVH8A015051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304Ab1EYUs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:48:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, osst@riede.org, mm-commits@vger.kernel.org


The patch titled
     osst: wrong index used in inner loop
has been removed from the -mm tree.  Its filename was
     osst-wrong-index-used-in-inner-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: osst: wrong index used in inner loop
From: Roel Kluin <roel.kluin@gmail.com>

Index i was already used in the outer loop.  Fixes a potentially-infinite
loop.

[akpm@linux-foundation.org: coding-style fixes]
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
+				for (j = 0; j < ST_NBR_PARTITIONS; j++) {
+					STps = &(STp->ps[j]);
 					STps->rw = ST_IDLE;
 					STps->eof = ST_NOEOF;
 					STps->at_sm = 0;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

