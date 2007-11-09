From: akpm@linux-foundation.org
Subject: + sysfs-fix-off-by-one-error-in-fill_read_buffer.patch added to -mm tree
Date: Fri, 09 Nov 2007 15:40:18 -0800
Message-ID: <200711092340.lA9NeIMD005239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763673AbXKIXkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 18:40:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com


The patch titled
     sysfs: fix off-by-one error in fill_read_buffer()
has been added to the -mm tree.  Its filename is
     sysfs-fix-off-by-one-error-in-fill_read_buffer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysfs: fix off-by-one error in fill_read_buffer()
From: Miao Xie <miaox@cn.fujitsu.com>

I found that there is a off-by-one problem in the following code.

Version:	2.6.24-rc2
File:		fs/sysfs/file.c:118-122
Function:	fill_read_buffer
--------------------------------------------------------------------
	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);

	sysfs_put_active_two(attr_sd);

	BUG_ON(count > (ssize_t)PAGE_SIZE);
--------------------------------------------------------------------

Because according to the specification of the sysfs and the implement of
the show methods, the show methods return the number of bytes which would
be generated for the given input, excluding the trailing null.So if the
return value of the show methods equals PAGE_SIZE - 1, the buffer is full
in fact.  And if the return value equals PAGE_SIZE, the resulting string
was already truncated,or buffer overflow occurred.

This patch fixes an off-by-one error in fill_read_buffer.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sysfs/file.c~sysfs-fix-off-by-one-error-in-fill_read_buffer fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-fix-off-by-one-error-in-fill_read_buffer
+++ a/fs/sysfs/file.c
@@ -90,7 +90,7 @@ static int fill_read_buffer(struct dentr
 
 	sysfs_put_active_two(attr_sd);
 
-	BUG_ON(count > (ssize_t)PAGE_SIZE);
+	BUG_ON(count >= (ssize_t)PAGE_SIZE);
 	if (count >= 0) {
 		buffer->needs_read_fill = 0;
 		buffer->count = count;
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

sysfs-fix-off-by-one-error-in-fill_read_buffer.patch
