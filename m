From: akpm@linux-foundation.org
Subject: [merged] nilfs2-potential-integer-overflow-in-nilfs_ioctl_clean_segments.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:04:37 -0800
Message-ID: <20111228220438.185905C0076@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:56781 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1L1WEk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:04:40 -0500
Received: by faar15 with SMTP id r15so405347faa.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2011 14:04:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haogangchen@gmail.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: potential integer overflow in nilfs_ioctl_clean_segments()
has been removed from the -mm tree.  Its filename was
     nilfs2-potential-integer-overflow-in-nilfs_ioctl_clean_segments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Haogang Chen <haogangchen@gmail.com>
Subject: nilfs2: potential integer overflow in nilfs_ioctl_clean_segments()

There is a potential integer overflow in nilfs_ioctl_clean_segments(). 
When a large argv[n].v_nmembs is passed from the userspace, the subsequent
call to vmalloc() will allocate a buffer smaller than expected, which
leads to out-of-bound access in nilfs_ioctl_move_blocks() and
lfs_clean_segments().

The following check does not prevent the overflow because nsegs is also
controlled by the userspace and could be very large.

		if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment)
			goto out_free;

This patch clamps argv[n].v_nmembs to UINT_MAX / argv[n].v_size, and
returns -EINVAL when overflow.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/nilfs2/ioctl.c~nilfs2-potential-integer-overflow-in-nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-potential-integer-overflow-in-nilfs_ioctl_clean_segments
+++ a/fs/nilfs2/ioctl.c
@@ -625,6 +625,9 @@ static int nilfs_ioctl_clean_segments(st
 		if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment)
 			goto out_free;
 
+		if (argv[n].v_nmembs >= UINT_MAX / argv[n].v_size)
+			goto out_free;
+
 		len = argv[n].v_size * argv[n].v_nmembs;
 		base = (void __user *)(unsigned long)argv[n].v_base;
 		if (len == 0) {
_

Patches currently in -mm which might be from haogangchen@gmail.com are

linux-next.patch

