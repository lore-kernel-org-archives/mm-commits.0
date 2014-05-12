From: akpm@linux-foundation.org
Subject: +
 mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct.patch added to
 -mm tree
Date: Mon, 12 May 2014 16:07:02 -0700
Message-ID: <53715416.mIcTMnXzzvVkAnAm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaELXHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 19:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jmoyer@redhat.com, axboe@fb.com

Subject: + mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct.patch added to -mm tree
To: axboe@fb.com,jmoyer@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 16:07:02 -0700


The patch titled
     Subject: mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT
has been added to the -mm tree.  Its filename is
     mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Al Viro <viro@zeniv.linux.org.uk
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

mm-filemapc-avoid-always-dirtying-mapping-flags-on-o_direct.patch
linux-next.patch

