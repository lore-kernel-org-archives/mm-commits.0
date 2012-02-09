From: akpm@linux-foundation.org
Subject: [merged] nilfs2-avoid-overflowing-segment-numbers-in-nilfs_ioctl_clean_segments.patch removed from -mm tree
Date: Thu, 09 Feb 2012 12:21:09 -0800
Message-ID: <20120209202109.AC729A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:56359 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab2BIUVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 15:21:10 -0500
Received: by ggnp1 with SMTP id p1so223263ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 12:21:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xi.wang@gmail.com, haogangchen@gmail.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: avoid overflowing segment numbers in nilfs_ioctl_clean_segments()
has been removed from the -mm tree.  Its filename was
     nilfs2-avoid-overflowing-segment-numbers-in-nilfs_ioctl_clean_segments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: nilfs2: avoid overflowing segment numbers in nilfs_ioctl_clean_segments()

nsegs is read from userspace.  Limit its value and avoid overflowing nsegs
* sizeof(__u64) in the subsequent call to memdup_user().

This patch complements 481fe17e973fb9 ("nilfs2: potential integer overflow
in nilfs_ioctl_clean_segments()").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Haogang Chen <haogangchen@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/nilfs2/ioctl.c~nilfs2-avoid-overflowing-segment-numbers-in-nilfs_ioctl_clean_segments fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-avoid-overflowing-segment-numbers-in-nilfs_ioctl_clean_segments
+++ a/fs/nilfs2/ioctl.c
@@ -603,6 +603,8 @@ static int nilfs_ioctl_clean_segments(st
 	nsegs = argv[4].v_nmembs;
 	if (argv[4].v_size != argsz[4])
 		goto out;
+	if (nsegs > UINT_MAX / sizeof(__u64))
+		goto out;
 
 	/*
 	 * argv[4] points to segment numbers this ioctl cleans.  We
_

Patches currently in -mm which might be from xi.wang@gmail.com are

origin.patch
linux-next.patch

