From: akpm@linux-foundation.org
Subject: + nilfs2-potential-integer-overflow-in-nilfs_ioctl_clean_segments.patch added to -mm tree
Date: Tue, 13 Dec 2011 12:27:56 -0800
Message-ID: <201112132027.pBDKRvjh026371@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49828 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1LMU2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Dec 2011 15:28:00 -0500
Received: by eaad1 with SMTP id d1so2699eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Dec 2011 12:27:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haogangchen@gmail.com, konishi.ryusuke@lab.ntt.co.jp


The patch titled
     Subject: nilfs2: potential integer overflow in nilfs_ioctl_clean_segments()
has been added to the -mm tree.  Its filename is
     nilfs2-potential-integer-overflow-in-nilfs_ioctl_clean_segments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: nilfs2: potential integer overflow in nilfs_ioctl_clean_segments()

Patches currently in -mm which might be from haogangchen@gmail.com are

linux-next.patch
nilfs2-potential-integer-overflow-in-nilfs_ioctl_clean_segments.patch

