From: akpm@linux-foundation.org
Subject: [merged] nilfs2-clamp-ns_r_segments_percentage-to.patch removed from -mm tree
Date: Mon, 19 Mar 2012 13:29:55 -0700
Message-ID: <20120319202955.5B5A0A02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:47871 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031296Ab2CSU34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Mar 2012 16:29:56 -0400
Received: by yhgm50 with SMTP id m50so1074346yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Mar 2012 13:29:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haogangchen@gmail.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: clamp ns_r_segments_percentage to [1, 99]
has been removed from the -mm tree.  Its filename was
     nilfs2-clamp-ns_r_segments_percentage-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Haogang Chen <haogangchen@gmail.com>
Subject: nilfs2: clamp ns_r_segments_percentage to [1, 99]

ns_r_segments_percentage is read from the disk.  Bogus or malicious value
could cause integer overflow and malfunction due to meaningless disk usage
calculation.  This patch reports error when mounting such bogus volumes.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/nilfs2/the_nilfs.c~nilfs2-clamp-ns_r_segments_percentage-to fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-clamp-ns_r_segments_percentage-to
+++ a/fs/nilfs2/the_nilfs.c
@@ -409,6 +409,12 @@ static int nilfs_store_disk_layout(struc
 	nilfs->ns_first_data_block = le64_to_cpu(sbp->s_first_data_block);
 	nilfs->ns_r_segments_percentage =
 		le32_to_cpu(sbp->s_r_segments_percentage);
+	if (nilfs->ns_r_segments_percentage < 1 ||
+	    nilfs->ns_r_segments_percentage > 99) {
+		printk(KERN_ERR "NILFS: invalid reserved segments percentage.\n");
+		return -EINVAL;
+	}
+
 	nilfs_set_nsegments(nilfs, le64_to_cpu(sbp->s_nsegments));
 	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
 	return 0;
_

Patches currently in -mm which might be from haogangchen@gmail.com are

origin.patch

