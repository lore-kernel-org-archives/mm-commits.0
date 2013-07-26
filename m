From: akpm@linux-foundation.org
Subject: + aoe-provide-file-operations-for-debugfs-files.patch added to
 -mm tree
Date: Fri, 26 Jul 2013 13:36:06 -0700
Message-ID: <51f2ddb6.2/EVUACLE6ZEuBbg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598Ab3GZUgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-provide-file-operations-for-debugfs-files.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:36:06 -0700


The patch titled
     Subject: aoe: provide file operations for debugfs files
has been added to the -mm tree.  Its filename is
     aoe-provide-file-operations-for-debugfs-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-provide-file-operations-for-debugfs-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-provide-file-operations-for-debugfs-files.patch

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
Subject: aoe: provide file operations for debugfs files

The place holder in the file contents is filled out in the following
patch.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoeblk.c~aoe-provide-file-operations-for-debugfs-files drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-provide-file-operations-for-debugfs-files
+++ a/drivers/block/aoe/aoeblk.c
@@ -110,6 +110,24 @@ static ssize_t aoedisk_show_payload(stru
 	return snprintf(page, PAGE_SIZE, "%lu\n", d->maxbcnt);
 }
 
+static int aoedisk_debugfs_show(struct seq_file *s, void *ignored)
+{
+	struct aoedev *d;
+	unsigned long flags;
+
+	d = s->private;
+	spin_lock_irqsave(&d->lock, flags);
+	seq_printf(s, "%s\n", d->gd->disk_name); /* place holder */
+	spin_unlock_irqrestore(&d->lock, flags);
+
+	return 0;
+}
+
+static int aoe_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, aoedisk_debugfs_show, inode->i_private);
+}
+
 static DEVICE_ATTR(state, S_IRUGO, aoedisk_show_state, NULL);
 static DEVICE_ATTR(mac, S_IRUGO, aoedisk_show_mac, NULL);
 static DEVICE_ATTR(netif, S_IRUGO, aoedisk_show_netif, NULL);
@@ -132,7 +150,12 @@ static const struct attribute_group attr
 	.attrs = aoe_attrs,
 };
 
-static const struct file_operations aoe_debugfs_fops;
+static const struct file_operations aoe_debugfs_fops = {
+	.open = aoe_debugfs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
 
 static void
 aoedisk_add_debugfs(struct aoedev *d)
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-create-and-destroy-debugfs-directory-for-aoe.patch
aoe-add-aoe-target-files-to-debugfs.patch
aoe-provide-file-operations-for-debugfs-files.patch
aoe-fill-in-per-aoe-target-information-for-debugfs-file.patch
aoe-update-copyright-date.patch
aoe-update-internal-version-number-to-85.patch

