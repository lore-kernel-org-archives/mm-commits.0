From: akpm@google.com
Subject: [merged] blk-cgroup-be-able-to-remove-the-record-of-unplugged-device.patch removed from -mm tree
Date: Thu, 22 Sep 2011 14:00:10 -0700
Message-ID: <201109222100.p8ML0A7G026119@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:35024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1IVVBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaowanlong@cn.fujitsu.com, axboe@kernel.dk, lizf@cn.fujitsu.com, paul@paulmenage.org, stable@kernel.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: blk-cgroup: be able to remove the record of unplugged device
has been removed from the -mm tree.  Its filename was
     blk-cgroup-be-able-to-remove-the-record-of-unplugged-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: blk-cgroup: be able to remove the record of unplugged device

The bug is we're not able to remove the device from blkio cgroup's
per-device control files if it gets unplugged.

To reproduce the bug:

  # mount -t cgroup -o blkio xxx /cgroup
  # cd /cgroup
  # echo "8:0 1000" > blkio.throttle.read_bps_device
  # unplug the device
  # cat blkio.throttle.read_bps_device
  8:0	1000
  # echo "8:0 0" > blkio.throttle.read_bps_device
  -bash: echo: write error: No such device

After patching, the device removal will succeed.

Thanks for the comments of Paul, Zefan, and Vivek.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-cgroup.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff -puN block/blk-cgroup.c~blk-cgroup-be-able-to-remove-the-record-of-unplugged-device block/blk-cgroup.c
--- a/block/blk-cgroup.c~blk-cgroup-be-able-to-remove-the-record-of-unplugged-device
+++ a/block/blk-cgroup.c
@@ -785,10 +785,10 @@ static int blkio_policy_parse_and_set(ch
 {
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	int ret;
-	unsigned long major, minor, temp;
+	unsigned long major, minor;
 	int i = 0;
 	dev_t dev;
-	u64 bps, iops;
+	u64 temp;
 
 	memset(s, 0, sizeof(s));
 
@@ -826,20 +826,23 @@ static int blkio_policy_parse_and_set(ch
 
 	dev = MKDEV(major, minor);
 
-	ret = blkio_check_dev_num(dev);
+	ret = strict_strtoull(s[1], 10, &temp);
 	if (ret)
-		return ret;
+		return -EINVAL;
 
-	newpn->dev = dev;
+	/* For rule removal, do not check for device presence. */
+	if (temp) {
+		ret = blkio_check_dev_num(dev);
+		if (ret)
+			return ret;
+	}
 
-	if (s[1] == NULL)
-		return -EINVAL;
+	newpn->dev = dev;
 
 	switch (plid) {
 	case BLKIO_POLICY_PROP:
-		ret = strict_strtoul(s[1], 10, &temp);
-		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
-			temp > BLKIO_WEIGHT_MAX)
+		if ((temp < BLKIO_WEIGHT_MIN && temp > 0) ||
+		     temp > BLKIO_WEIGHT_MAX)
 			return -EINVAL;
 
 		newpn->plid = plid;
@@ -850,26 +853,18 @@ static int blkio_policy_parse_and_set(ch
 		switch(fileid) {
 		case BLKIO_THROTL_read_bps_device:
 		case BLKIO_THROTL_write_bps_device:
-			ret = strict_strtoull(s[1], 10, &bps);
-			if (ret)
-				return -EINVAL;
-
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.bps = bps;
+			newpn->val.bps = temp;
 			break;
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
-			ret = strict_strtoull(s[1], 10, &iops);
-			if (ret)
-				return -EINVAL;
