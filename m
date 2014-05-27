From: akpm@linux-foundation.org
Subject: [merged]
 mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct.patch removed
 from -mm tree
Date: Tue, 27 May 2014 13:22:15 -0700
Message-ID: <5384f3f7.D5qWdw44exmFvkiM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaE0UWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 16:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jmoyer@redhat.com, axboe@fb.com

Subject: [merged] mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct.patch removed from -mm tree
To: axboe@fb.com,jmoyer@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 13:22:15 -0700


The patch titled
     Subject: mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT
has been removed from the -mm tree.  Its filename was
     mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jens Axboe <axboe@fb.com>
Subject: mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT

In some testing I ran today (some fio jobs that spread over two nodes), we
end up spending 40% of the time in filemap_check_errors().  That smells
fishy.  Looking further, this is basically what happens:

blkdev_aio_read()
    generic_file_aio_read()
        filemap_write_and_wait_range()
            if (!mapping->nr_pages)
                filemap_check_errors()

and filemap_check_errors() always attempts two test_and_clear_bit() on the
mapping flags, thus dirtying it for every single invocation.  The patch
below tests each of these bits before clearing them, avoiding this issue. 
In my test case (4-socket box), performance went from 1.7M IOPS to 4.0M
IOPS.

Signed-off-by: Jens Axboe <axboe@fb.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct mm/filemap.c
--- a/mm/filemap.c~mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct
+++ a/mm/filemap.c
@@ -257,9 +257,11 @@ static int filemap_check_errors(struct a
 {
 	int ret = 0;
 	/* Check for outstanding write errors */
-	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
+	if (test_bit(AS_ENOSPC, &mapping->flags) &&
+	    test_and_clear_bit(AS_ENOSPC, &mapping->flags))
 		ret = -ENOSPC;
-	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+	if (test_bit(AS_EIO, &mapping->flags) &&
+	    test_and_clear_bit(AS_EIO, &mapping->flags))
 		ret = -EIO;
 	return ret;
 }
_

Patches currently in -mm which might be from axboe@fb.com are

linux-next.patch

