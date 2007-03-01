From: akpm@linux-foundation.org
Subject: + make-xfs-workqueues-nonfreezable.patch added to -mm tree
Date: Thu, 01 Mar 2007 00:04:27 -0800
Message-ID: <200703010804.l2184RfV008154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33335 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865AbXCAIEw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 03:04:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, dgc@sgi.com, pavel@ucw.cz


The patch titled
     Make XFS workqueues nonfreezable
has been added to the -mm tree.  Its filename is
     make-xfs-workqueues-nonfreezable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make XFS workqueues nonfreezable
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Since freezable workqueues are broken in 2.6.21-rc
(cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
it's better to change the only user of them, which is XFS, to use "normal"
nonfreezable workqueues.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_buf.c~make-xfs-workqueues-nonfreezable fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~make-xfs-workqueues-nonfreezable
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -1826,11 +1826,11 @@ xfs_buf_init(void)
 	if (!xfs_buf_zone)
 		goto out_free_trace_buf;
 
-	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
+	xfslogd_workqueue = create_workqueue("xfslogd");
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
+	xfsdatad_workqueue = create_workqueue("xfsdatad");
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

make-xfs-workqueues-nonfreezable.patch
fix-refrigerator-vs-thaw_process-race.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
shrink_slab-handle-bad-shrinkers.patch
