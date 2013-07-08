From: akpm@linux-foundation.org
Subject: [merged]
 drivers-cdrom-cdromc-use-kzalloc-for-failing-hardware.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:23:43 -0700
Message-ID: <51db11bf.eZVq8F7Zw7YJCsrE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3GHTXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, axboe@kernel.dk, jonathan.salwan@gmail.com

Subject: [merged] drivers-cdrom-cdromc-use-kzalloc-for-failing-hardware.patch removed from -mm tree
To: jonathan.salwan@gmail.com,axboe@kernel.dk,dan.carpenter@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:43 -0700


The patch titled
     Subject: drivers/cdrom/cdrom.c: use kzalloc() for failing hardware
has been removed from the -mm tree.  Its filename was
     drivers-cdrom-cdromc-use-kzalloc-for-failing-hardware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jonathan Salwan <jonathan.salwan@gmail.com>
Subject: drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

In drivers/cdrom/cdrom.c mmc_ioctl_cdrom_read_data() allocates a memory
area with kmalloc in line 2885.

2885         cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
2886         if (cgc->buffer == NULL)
2887                 return -ENOMEM;

In line 2908 we can find the copy_to_user function:

2908         if (!ret && copy_to_user(arg, cgc->buffer, blocksize))

The cgc->buffer is never cleaned and initialized before this function.  If
ret = 0 with the previous basic block, it's possible to display some
memory bytes in kernel space from userspace.

When we read a block from the disk it normally fills the ->buffer but if
the drive is malfunctioning there is a chance that it would only be
partially filled.  The result is an leak information to userspace.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cdrom/cdrom.c~drivers-cdrom-cdromc-use-kzalloc-for-failing-hardware drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~drivers-cdrom-cdromc-use-kzalloc-for-failing-hardware
+++ a/drivers/cdrom/cdrom.c
@@ -2882,7 +2882,7 @@ static noinline int mmc_ioctl_cdrom_read
 	if (lba < 0)
 		return -EINVAL;
 
-	cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
+	cgc->buffer = kzalloc(blocksize, GFP_KERNEL);
 	if (cgc->buffer == NULL)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from jonathan.salwan@gmail.com are

origin.patch

