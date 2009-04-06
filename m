From: akpm@linux-foundation.org
Subject: [merged] hppfs-hppfs_read_file-may-return-error.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:53 -0700
Message-ID: <200904061933.n36JXrrB011285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbZDFTfL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hppfs: hppfs_read_file() may return -ERROR
has been removed from the -mm tree.  Its filename was
     hppfs-hppfs_read_file-may-return-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hppfs: hppfs_read_file() may return -ERROR
From: Roel Kluin <roel.kluin@gmail.com>

hppfs_read_file() may return (ssize_t) -ENOMEM, or -EFAULT.  When stored
in size_t 'count', these errors will not be noticed, a large value will be
added to *ppos.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hppfs/hppfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/hppfs/hppfs.c~hppfs-hppfs_read_file-may-return-error fs/hppfs/hppfs.c
--- a/fs/hppfs/hppfs.c~hppfs-hppfs_read_file-may-return-error
+++ a/fs/hppfs/hppfs.c
@@ -280,7 +280,12 @@ static ssize_t hppfs_read(struct file *f
 			       "errno = %d\n", err);
 			return err;
 		}
-		count = hppfs_read_file(hppfs->host_fd, buf, count);
+		err = hppfs_read_file(hppfs->host_fd, buf, count);
+		if (err < 0) {
+			printk(KERN_ERR "hppfs_read: read failed: %d\n", err);
+			return err;
+		}
+		count = err;
 		if (count > 0)
 			*ppos += count;
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
spi-limit-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch

