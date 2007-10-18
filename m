From: akpm@linux-foundation.org
Subject: - md-expose-the-degraded-status-of-an-assembled-array-through-sysfs.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:01 -0700
Message-ID: <200710180703.l9I731OY031325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762021AbXJRHQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iusty@k1024.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: expose the degraded status of an assembled array through sysfs
has been removed from the -mm tree.  Its filename was
     md-expose-the-degraded-status-of-an-assembled-array-through-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: expose the degraded status of an assembled array through sysfs
From: Iustin Pop <iusty@k1024.org>

The 'degraded' attribute is useful to quickly determine if the array is
degraded, instead of parsing 'mdadm -D' output or relying on the other
techniques (number of working devices against number of defined devices,
etc.).  The md code already keeps track of this attribute, so it's useful to
export it.

Signed-off-by: Iustin Pop <iusty@k1024.org>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/md/md.c~md-expose-the-degraded-status-of-an-assembled-array-through-sysfs drivers/md/md.c
--- a/drivers/md/md.c~md-expose-the-degraded-status-of-an-assembled-array-through-sysfs
+++ a/drivers/md/md.c
@@ -2833,6 +2833,12 @@ sync_max_store(mddev_t *mddev, const cha
 static struct md_sysfs_entry md_sync_max =
 __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
 
+static ssize_t
+degraded_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%d\n", mddev->degraded);
+}
+static struct md_sysfs_entry md_degraded = __ATTR_RO(degraded);
 
 static ssize_t
 sync_speed_show(mddev_t *mddev, char *page)
@@ -2976,6 +2982,7 @@ static struct attribute *md_redundancy_a
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
 	&md_bitmap.attr,
+	&md_degraded.attr,
 	NULL,
 };
 static struct attribute_group md_redundancy_group = {
_

Patches currently in -mm which might be from iusty@k1024.org are

origin.patch
