From: akpm@linux-foundation.org
Subject: [merged]
 mm-fadvise-avoid-fadvise-for-fs-without-backing-device.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:40:10 -0700
Message-ID: <20170911194010.4jORfNOcC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49322 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdIKTkL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@suse.de, mm-commits@vger.kernel.org, shakeelb@google.com, vbabka@suse.cz


The patch titled
     Subject: mm: fadvise: avoid fadvise for fs without backing device
has been removed from the -mm tree.  Its filename was
     mm-fadvise-avoid-fadvise-for-fs-without-backing-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: fadvise: avoid fadvise for fs without backing device

The fadvise() manpage is silent on fadvise()'s effect on memory-based
filesystems (shmem, hugetlbfs & ramfs) and pseudo file systems (procfs,
sysfs, kernfs).  The current implementaion of fadvise is mostly a noop
for such filesystems except for FADV_DONTNEED which will trigger
expensive remote LRU cache draining.  This patch makes the noop of
fadvise() on such file systems very explicit.

However this change has two side effects for ramfs and one for tmpfs. 
First fadvise(FADV_DONTNEED) could remove the unmapped clean zero'ed
pages of ramfs (allocated through read, readahead & read fault) and
tmpfs (allocated through read fault).  Also fadvise(FADV_WILLNEED)
could create such clean zero'ed pages for ramfs.  This change removes
those possibilities.

One of our generic libraries does fadvise(FADV_DONTNEED).  Recently we
observed high latency in fadvise() and noticed that the users have
started using tmpfs files and the latency was due to expensive remote
LRU cache draining.  For normal tmpfs files (have data written on
them), fadvise(FADV_DONTNEED) will always trigger the unneeded remote
cache draining.

Link: http://lkml.kernel.org/r/20170818011023.181465-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/fadvise.c~mm-fadvise-avoid-fadvise-for-fs-without-backing-device mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-avoid-fadvise-for-fs-without-backing-device
+++ a/mm/fadvise.c
@@ -52,7 +52,9 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 		goto out;
 	}
 
-	if (IS_DAX(inode)) {
+	bdi = inode_to_bdi(mapping->host);
+
+	if (IS_DAX(inode) || (bdi == &noop_backing_dev_info)) {
 		switch (advice) {
 		case POSIX_FADV_NORMAL:
 		case POSIX_FADV_RANDOM:
@@ -75,8 +77,6 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 	else
 		endbyte--;		/* inclusive */
 
-	bdi = inode_to_bdi(mapping->host);
