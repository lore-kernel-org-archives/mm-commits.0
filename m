From: akpm@linux-foundation.org
Subject: - md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:59 -0700
Message-ID: <200804282159.m3SLxxEd018631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965506AbYD1WAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: raid5.c convert simple_strtoul to strict_strtoul
has been removed from the -mm tree.  Its filename was
     md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: raid5.c convert simple_strtoul to strict_strtoul
From: Dan Williams <dan.j.williams@intel.com>

strict_strtoul handles the open-coded sanity checks in
raid5_store_stripe_cache_size and raid5_store_preread_threshold

Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/md/raid5.c~md-raid5c-convert-simple_strtoul-to-strict_strtoul drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-raid5c-convert-simple_strtoul-to-strict_strtoul
+++ a/drivers/md/raid5.c
@@ -4041,15 +4041,13 @@ static ssize_t
 raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	char *end;
-	int new;
+	unsigned long new;
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (!conf)
 		return -ENODEV;
 
-	new = simple_strtoul(page, &end, 10);
-	if (!*page || (*end && *end != '\n') )
+	if (strict_strtoul(page, 10, &new))
 		return -EINVAL;
 	if (new <= 16 || new > 32768)
 		return -EINVAL;
@@ -4087,17 +4085,15 @@ static ssize_t
 raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	char *end;
-	int new;
+	unsigned long new;
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (!conf)
 		return -ENODEV;
 
-	new = simple_strtoul(page, &end, 10);
-	if (!*page || (*end && *end != '\n'))
+	if (strict_strtoul(page, 10, &new))
 		return -EINVAL;
-	if (new > conf->max_nr_stripes || new < 0)
+	if (new > conf->max_nr_stripes)
 		return -EINVAL;
 	conf->bypass_threshold = new;
 	return len;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

