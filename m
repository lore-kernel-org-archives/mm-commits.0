From: akpm@linux-foundation.org
Subject: + partitions-add-aix-lvm-partition-support-files-v2.patch added
 to -mm tree
Date: Mon, 20 May 2013 16:53:17 -0700
Message-ID: <519ab76d.LyM3TfJusQa+dC8C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab3ETXxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 19:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kzak@redhat.com, axboe@kernel.dk, phdm@macqel.be

Subject: + partitions-add-aix-lvm-partition-support-files-v2.patch added to -mm tree
To: phdm@macqel.be,axboe@kernel.dk,kzak@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 16:53:17 -0700


The patch titled
     Subject: partitions-add-aix-lvm-partition-support-files-v2
has been added to the -mm tree.  Its filename is
     partitions-add-aix-lvm-partition-support-files-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Philippe De Muyter <phdm@macqel.be>
Subject: partitions-add-aix-lvm-partition-support-files-v2

Fix a problem in the discovering of small (1 pp) partitions in presence of
discontiguous partitions.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/aix.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN block/partitions/aix.c~partitions-add-aix-lvm-partition-support-files-v2 block/partitions/aix.c
--- a/block/partitions/aix.c~partitions-add-aix-lvm-partition-support-files-v2
+++ a/block/partitions/aix.c
@@ -257,12 +257,13 @@ int aix_partition(struct parsed_partitio
 				continue;
 			}
 			lvip[lv_ix].pps_found += 1;
-			if (lp_ix != next_lp_ix)
-				continue;
-			if (lp_ix == 1)
+			if (lp_ix == 1) {
 				cur_lv_ix = lv_ix;
-			else if (lv_ix != cur_lv_ix)
 				next_lp_ix = 1;
+			} else if (lv_ix != cur_lv_ix || lp_ix != next_lp_ix) {
+				next_lp_ix = 1;
+				continue;
+			}
 			if (lp_ix == lvip[lv_ix].pps_per_lv) {
 				char tmp[70];
 
_

Patches currently in -mm which might be from phdm@macqel.be are

partitions-msdosc-end-of-line-whitespace-and-semicolon-cleanup.patch
partitions-add-aix-lvm-partition-support-files.patch
partitions-add-aix-lvm-partition-support-files-v2.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-compile-aixc-if-configured.patch
partitions-add-aix-lvm-partition-support-files-add-the-aix_partition-entry.patch
partitions-msdos-enumerate-also-aix-lvm-partitions.patch

