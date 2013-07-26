From: akpm@linux-foundation.org
Subject: + aoe-add-aoe-target-files-to-debugfs.patch added to -mm tree
Date: Fri, 26 Jul 2013 13:36:05 -0700
Message-ID: <51f2ddb5.WNdBSl0dL0o9Tz4f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab3GZUgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-add-aoe-target-files-to-debugfs.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:36:05 -0700


The patch titled
     Subject: aoe: add AoE-target files to debugfs
has been added to the -mm tree.  Its filename is
     aoe-add-aoe-target-files-to-debugfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-add-aoe-target-files-to-debugfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-add-aoe-target-files-to-debugfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: add AoE-target files to debugfs

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 ++
 drivers/block/aoe/aoeblk.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/block/aoe/aoedev.c |    1 +
 3 files changed, 38 insertions(+)

diff -puN drivers/block/aoe/aoe.h~aoe-add-aoe-target-files-to-debugfs drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-add-aoe-target-files-to-debugfs
+++ a/drivers/block/aoe/aoe.h
@@ -169,6 +169,7 @@ struct aoedev {
 	ulong ref;
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
+	struct dentry *debugfs;
 	struct request_queue *blkq;
 	struct hd_geometry geo;
 	sector_t ssize;
@@ -206,6 +207,7 @@ struct ktstate {
 int aoeblk_init(void);
 void aoeblk_exit(void);
 void aoeblk_gdalloc(void *);
+void aoedisk_rm_debugfs(struct aoedev *d);
 void aoedisk_rm_sysfs(struct aoedev *d);
 
 int aoechr_init(void);
diff -puN drivers/block/aoe/aoeblk.c~aoe-add-aoe-target-files-to-debugfs drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-add-aoe-target-files-to-debugfs
+++ a/drivers/block/aoe/aoeblk.c
@@ -132,6 +132,40 @@ static const struct attribute_group attr
 	.attrs = aoe_attrs,
 };
 
+static const struct file_operations aoe_debugfs_fops;
+
+static void
+aoedisk_add_debugfs(struct aoedev *d)
+{
+	struct dentry *entry;
+	char *p;
+
+	if (aoe_debugfs_dir == NULL)
+		return;
+	p = strchr(d->gd->disk_name, '/');
+	if (p == NULL)
+		p = d->gd->disk_name;
+	else
+		p++;
+	BUG_ON(*p == '\0');
+	entry = debugfs_create_file(p, 0444, aoe_debugfs_dir, d,
+				    &aoe_debugfs_fops);
+	if (IS_ERR_OR_NULL(entry)) {
+		pr_info("aoe: cannot create debugfs file for %s\n",
+			d->gd->disk_name);
+		return;
+	}
+	BUG_ON(d->debugfs);
+	d->debugfs = entry;
+}
+void
+aoedisk_rm_debugfs(struct aoedev *d)
+{
+	BUG_ON(d->debugfs == NULL);
+	debugfs_remove(d->debugfs);
+	d->debugfs = NULL;
+}
+
 static int
 aoedisk_add_sysfs(struct aoedev *d)
 {
@@ -332,6 +366,7 @@ aoeblk_gdalloc(void *vp)
 
 	add_disk(gd);
 	aoedisk_add_sysfs(d);
+	aoedisk_add_debugfs(d);
 
 	spin_lock_irqsave(&d->lock, flags);
 	WARN_ON(!(d->flags & DEVFL_GD_NOW));
diff -puN drivers/block/aoe/aoedev.c~aoe-add-aoe-target-files-to-debugfs drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-add-aoe-target-files-to-debugfs
+++ a/drivers/block/aoe/aoedev.c
@@ -278,6 +278,7 @@ freedev(struct aoedev *d)
 
 	del_timer_sync(&d->timer);
 	if (d->gd) {
+		aoedisk_rm_debugfs(d);
 		aoedisk_rm_sysfs(d);
 		del_gendisk(d->gd);
 		put_disk(d->gd);
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-create-and-destroy-debugfs-directory-for-aoe.patch
aoe-add-aoe-target-files-to-debugfs.patch
aoe-provide-file-operations-for-debugfs-files.patch
aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch
aoe-update-copyright-date.patch
aoe-update-internal-version-number-to-85.patch

