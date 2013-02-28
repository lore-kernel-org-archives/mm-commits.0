From: akpm@linux-foundation.org
Subject: [merged] idr-fix-a-subtle-bug-in-idr_get_next.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:25 -0800
Message-ID: <20130228201225.DC4EE31C0A0__1511.3586247482$1362082387$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:42742 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab3B1UM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:27 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so244921qea.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, kamezawa.hiroyu@jp.fujitsu.com, stable@vger.kernel.org, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: fix a subtle bug in idr_get_next()
has been removed from the -mm tree.  Its filename was
     idr-fix-a-subtle-bug-in-idr_get_next.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: fix a subtle bug in idr_get_next()

The iteration logic of idr_get_next() is borrowed mostly verbatim from
idr_for_each().  It walks down the tree looking for the slot matching
the current ID.  If the matching slot is not found, the ID is
incremented by the distance of single slot at the given level and
repeats.

The implementation assumes that during the whole iteration id is
aligned to the layer boundaries of the level closest to the leaf,
which is true for all iterations starting from zero or an existing
element and thus is fine for idr_for_each().

However, idr_get_next() may be given any point and if the starting id
hits in the middle of a non-existent layer, increment to the next
layer will end up skipping the same offset into it.  For example, an
IDR with IDs filled between [64, 127] would look like the following.

          [  0  64 ... ]
       /----/   |
       |        |
      NULL    [ 64 ... 127 ]

If idr_get_next() is called with 63 as the starting point, it will try
to follow down the pointer from 0.  As it is NULL, it will then try to
proceed to the next slot in the same level by adding the slot distance
at that level which is 64 - making the next try 127.  It goes around
the loop and finds and returns 127 skipping [64, 126].

Note that this bug also triggers in idr_for_each_entry() loop which
deletes during iteration as deletions can make layers go away leaving
the iteration with unaligned ID into missing layers.

Fix it by ensuring proceeding to the next slot doesn't carry over the
unaligned offset - ie. use round_up(id + 1, slot_distance) instead of
id += slot_distance.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Teigland <teigland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN lib/idr.c~idr-fix-a-subtle-bug-in-idr_get_next lib/idr.c
--- a/lib/idr.c~idr-fix-a-subtle-bug-in-idr_get_next
+++ a/lib/idr.c
@@ -625,7 +625,14 @@ void *idr_get_next(struct idr *idp, int 
 			return p;
 		}
 
-		id += 1 << n;
+		/*
+		 * Proceed to the next layer at the current level.  Unlike
+		 * idr_for_each(), @id isn't guaranteed to be aligned to
+		 * layer boundary at this point and adding 1 << n may
+		 * incorrectly skip IDs.  Make sure we jump to the
+		 * beginning of the next layer using round_up().
+		 */
+		id = round_up(id + 1, 1 << n);
 		while (n < fls(id)) {
 			n += IDR_BITS;
 			p = *--paa;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

