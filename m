From: akpm@linux-foundation.org
Subject: + idr-fix-a-subtle-bug-in-idr_get_next.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:36:30 -0800
Message-ID: <20130206223631.4CB725A42B7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:41139 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BFWgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:36:32 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so209773vea.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:36:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, kamezawa.hiroyu@jp.fujitsu.com, stable@vger.kernel.org, teigland@redhat.com


The patch titled
     Subject: idr: fix a subtle bug in idr_get_next()
has been added to the -mm tree.  Its filename is
     idr-fix-a-subtle-bug-in-idr_get_next.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-fix-a-subtle-bug-in-idr_get_next.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-mlx4-convert-to-idr_alloc.patch
ib-ocrdma-convert-to-idr_alloc.patch
ib-qib-convert-to-idr_alloc.patch
dm-convert-to-idr_alloc.patch
memstick-convert-to-idr_alloc.patch
mfd-convert-to-idr_alloc.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
mmc-convert-to-idr_alloc.patch
mtd-convert-to-idr_alloc.patch
macvtap-convert-to-idr_alloc.patch
ppp-convert-to-idr_alloc.patch
power-convert-to-idr_alloc.patch
pps-convert-to-idr_alloc.patch
remoteproc-convert-to-idr_alloc.patch
rpmsg-convert-to-idr_alloc.patch
scsi-bfa-convert-to-idr_alloc.patch
scsi-convert-to-idr_alloc.patch
target-iscsi-convert-to-idr_alloc.patch
scsi-lpfc-convert-to-idr_alloc.patch
thermal-convert-to-idr_alloc.patch
uio-convert-to-idr_alloc.patch
vfio-convert-to-idr_alloc.patch
dlm-convert-to-idr_alloc.patch
inotify-convert-to-idr_alloc.patch
ocfs2-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch

