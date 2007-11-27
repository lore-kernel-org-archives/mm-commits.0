From: akpm@linux-foundation.org
Subject: - sysfs-fix-off-by-one-error-in-fill_read_buffer.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:24 -0800
Message-ID: <200711272033.lARKXOOr028976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755642AbXK0Udg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, greg@kroah.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: fix off-by-one error in fill_read_buffer() (update)
has been removed from the -mm tree.  Its filename was
     sysfs-fix-off-by-one-error-in-fill_read_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: fix off-by-one error in fill_read_buffer() (update)
From: Miao Xie <miaox@cn.fujitsu.com>

Add a comment requested by Tejun.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/file.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/sysfs/file.c~sysfs-fix-off-by-one-error-in-fill_read_buffer fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-fix-off-by-one-error-in-fill_read_buffer
+++ a/fs/sysfs/file.c
@@ -90,6 +90,10 @@ static int fill_read_buffer(struct dentr
 
 	sysfs_put_active_two(attr_sd);
 
+	/*
+	 * The code works fine with PAGE_SIZE return but it's likely to
+	 * indicate truncated result or overflow in normal use cases.
+	 */
 	BUG_ON(count >= (ssize_t)PAGE_SIZE);
 	if (count >= 0) {
 		buffer->needs_read_fill = 0;
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
