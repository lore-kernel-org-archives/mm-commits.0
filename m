From: akpm@osdl.org
Subject: - use-freezeable-workqueues-in-xfs.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:02 -0800
Message-ID: <200612072300.kB7N02RE029604@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51180 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163598AbWLGXAO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, dgc@sgi.com, nigel@suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Use freezeable workqueues in XFS
has been removed from the -mm tree.  Its filename was
     use-freezeable-workqueues-in-xfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use freezeable workqueues in XFS
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Make the workqueues used by XFS freezeable, so their worker threads don't
submit any I/O after the suspend image has been created.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@suspend2.net>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_buf.c~use-freezeable-workqueues-in-xfs fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~use-freezeable-workqueues-in-xfs
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -1827,11 +1827,11 @@ xfs_buf_init(void)
 	if (!xfs_buf_zone)
 		goto out_free_trace_buf;
 
-	xfslogd_workqueue = create_workqueue("xfslogd");
+	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-	xfsdatad_workqueue = create_workqueue("xfsdatad");
+	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

