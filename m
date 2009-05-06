From: akpm@linux-foundation.org
Subject: [folded] inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive-fix.patch removed from -mm tree
Date: Wed, 06 May 2009 16:00:46 -0700
Message-ID: <200905062300.n46N0k99031001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbZEFXFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 19:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, a.p.zijlstra@chello.nl, clameter@sgi.com, fengguang.wu@intel.com, mpm@selenic.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     make inotify event handles use GFP_NOFS
has been removed from the -mm tree.  Its filename was
     inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive-fix.patch

This patch was dropped because it was folded into inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make inotify event handles use GFP_NOFS
From: Eric Paris <eparis@redhat.com>

I think this is a bandaide to shut up lockdep.  I could either figure out
lockdep classes and figure out how to reclassify inotify locks since I
believe Nick is correct when he says inotify watches pin the inode in core
so memory pressure can't evict it.  I don't want to do that as I think the
real fix is my next generation fsnotify which does zero allocations under
locks and so everything can be GFP_KERNEL.  I'm posting this as it is
clearly safe and should fix the issue.

http://marc.info/?l=linux-kernel&m=123617147432377&w=2

includes a lockdep warning that shows while we are reclaiming FS memory
and inode may get evicted which generates an IN_IGNORED message.  Half
of that code path already used GFP_NOFS but a second allocation to store
the filename was using GFP_KERNEL.  As a precaution I also moved the
audit handle_event code path to use GFP_NOFS.

This is much the same as the precaution in f04b30de3c82528 which did
something similar.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditfilter.c~inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive-fix kernel/auditfilter.c
--- a/kernel/auditfilter.c~inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive-fix
+++ a/kernel/auditfilter.c
@@ -1028,7 +1028,7 @@ static void audit_update_watch(struct au
 
 		if (audit_enabled) {
 			struct audit_buffer *ab;
-			ab = audit_log_start(NULL, GFP_KERNEL,
+			ab = audit_log_start(NULL, GFP_NOFS,
 				AUDIT_CONFIG_CHANGE);
 			audit_log_format(ab, "auid=%u ses=%u",
 				audit_get_loginuid(current),
@@ -1067,7 +1067,7 @@ static void audit_remove_parent_watches(
 			e = container_of(r, struct audit_entry, rule);
 			if (audit_enabled) {
 				struct audit_buffer *ab;
-				ab = audit_log_start(NULL, GFP_KERNEL,
+				ab = audit_log_start(NULL, GFP_NOFS,
 					AUDIT_CONFIG_CHANGE);
 				audit_log_format(ab, "auid=%u ses=%u",
 					audit_get_loginuid(current),
_

Patches currently in -mm which might be from eparis@redhat.com are

inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive.patch
inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive-fix.patch
linux-next.patch
fsnotify-unified-filesystem-notification-backend.patch
fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes.patch
fsnotify-parent-event-notification.patch
dnotify-reimplement-dnotify-using-fsnotify.patch
fsnotify-generic-notification-queue-and-waitq.patch
fsnotify-include-pathnames-with-entries-when-possible.patch
fsnotify-add-correlations-between-events.patch
fsnotify-allow-groups-to-add-private-data-to-events.patch
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch

