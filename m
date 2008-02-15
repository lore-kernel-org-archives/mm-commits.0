From: akpm@linux-foundation.org
Subject: - inotify-make-variables-static-in-inotify_userc.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:03 -0500
Message-ID: <200802150719.m1F7JP1o025705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762493AbYBOHT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:19:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     inotify: make variables static in inotify_user.c
has been removed from the -mm tree.  Its filename was
     inotify-make-variables-static-in-inotify_userc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inotify: make variables static in inotify_user.c
From: Harvey Harrison <harvey.harrison@gmail.com>

inotify_max_user_instances, inotify_max_user_watches,
inotify_max_queued_events can all be made static.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/inotify_user.c~inotify-make-variables-static-in-inotify_userc fs/inotify_user.c
--- a/fs/inotify_user.c~inotify-make-variables-static-in-inotify_userc
+++ a/fs/inotify_user.c
@@ -41,9 +41,9 @@ static struct kmem_cache *event_cachep _
 static struct vfsmount *inotify_mnt __read_mostly;
 
 /* these are configurable via /proc/sys/fs/inotify/ */
-int inotify_max_user_instances __read_mostly;
-int inotify_max_user_watches __read_mostly;
-int inotify_max_queued_events __read_mostly;
+static int inotify_max_user_instances __read_mostly;
+static int inotify_max_user_watches __read_mostly;
+static int inotify_max_queued_events __read_mostly;
 
 /*
  * Lock ordering:
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
