From: akpm@linux-foundation.org
Subject: + nilfs2-clamp-ns_r_segments_percentage-to.patch added to -mm tree
Date: Fri, 16 Mar 2012 14:28:20 -0700
Message-ID: <20120316212821.538E3A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:57769 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031321Ab2CPV2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 17:28:22 -0400
Received: by vcbfk26 with SMTP id fk26so745960vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 14:28:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haogangchen@gmail.com, konishi.ryusuke@lab.ntt.co.jp


The patch titled
     Subject: nilfs2: clamp ns_r_segments_percentage to [1, 99]
has been added to the -mm tree.  Its filename is
     nilfs2-clamp-ns_r_segments_percentage-to.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: nilfs2: clamp ns_r_segments_percentage to [1, 99]

Patches currently in -mm which might be from haogangchen@gmail.com are

nilfs2-clamp-ns_r_segments_percentage-to.patch

