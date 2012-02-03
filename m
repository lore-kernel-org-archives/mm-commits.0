From: akpm@linux-foundation.org
Subject: + nilfs2-avoid-overflowing-segment-numbers-in-nilfs_ioctl_clean_segments.patch added to -mm tree
Date: Fri, 03 Feb 2012 12:08:20 -0800
Message-ID: <20120203200820.95A22A00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42119 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab2BCUIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2012 15:08:22 -0500
Received: by eekb15 with SMTP id b15so124358eek.1
        for <mm-commits@vger.kernel.org>; Fri, 03 Feb 2012 12:08:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xi.wang@gmail.com, haogangchen@gmail.com, konishi.ryusuke@lab.ntt.co.jp


The patch titled
     Subject: nilfs2: avoid overflowing segment numbers in nilfs_ioctl_clean_segments()
has been added to the -mm tree.  Its filename is
     nilfs2-avoid-overflowing-segment-numbers-in-nilfs_ioctl_clean_segments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: nilfs2: avoid overflowing segment numbers in nilfs_ioctl_clean_segments()

nsegs is read from userspace.  Limit its value and avoid overflowing nsegs
* sizeof(__u64) in the subsequent call to memdup_user().

This patch complements 481fe17e973fb9 ("nilfs2: potential integer overflow
in nilfs_ioctl_clean_segments()").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Haogang Chen <haogangchen@gmail.com>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
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
Subject: Subject: nilfs2: avoid overflowing segment numbers in nilfs_ioctl_clean_segments()

Patches currently in -mm which might be from xi.wang@gmail.com are

origin.patch
linux-next.patch
nilfs2-avoid-overflowing-segment-numbers-in-nilfs_ioctl_clean_segments.patch

