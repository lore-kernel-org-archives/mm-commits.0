From: akpm@linux-foundation.org
Subject: + md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch added to -mm tree
Date: Mon, 31 Mar 2008 16:36:32 -0700
Message-ID: <200803312336.m2VNaW8V031689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbYCaXh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 19:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, neilb@suse.de


The patch titled
     md: raid5.c convert simple_strtoul to strict_strtoul
has been added to the -mm tree.  Its filename is
     md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -4034,15 +4034,13 @@ static ssize_t
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
@@ -4080,17 +4078,15 @@ static ssize_t
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

git-arm.patch
git-async-tx.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
md-introduce-get_priority_stripe-to-improve-raid456-write-performance.patch
md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch

