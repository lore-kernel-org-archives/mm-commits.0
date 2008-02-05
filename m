From: akpm@linux-foundation.org
Subject: - check-advice-of-fadvice64_64-even-if-get_xip_page-is-given.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:24 -0800
Message-ID: <200802052232.m15MW5oM012284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762641AbYBEWm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamato@redhat.com, cotte@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     check ADVICE of fadvise64_64 even if get_xip_page is given
has been removed from the -mm tree.  Its filename was
     check-advice-of-fadvice64_64-even-if-get_xip_page-is-given.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: check ADVICE of fadvise64_64 even if get_xip_page is given
From: Masatake YAMATO <yamato@redhat.com>

I've written some test programs in ltp project.  During writing I met an
problem which I cannot solve in user land.  So I wrote a patch for linux
kernel.  Please, include this patch if acceptable.

The test program tests the 4th parameter of fadvise64_64:

    long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice);

My test case calls fadvise64_64 with invalid advice value and checks errno is
set to EINVAL.  About the advice parameter man page says:

    ...
    Permissible values for advice include:

	   POSIX_FADV_NORMAL
                  ...
	   POSIX_FADV_SEQUENTIAL
                  ...
	   POSIX_FADV_RANDOM
		  ...
	   POSIX_FADV_NOREUSE
                  ...
	   POSIX_FADV_WILLNEED
                  ...
	   POSIX_FADV_DONTNEED
		  ...
    ERRORS
           ...
	   EINVAL An invalid value was specified for advice.

However, I got a bug report that the system call invocations
in my test case returned 0 unexpectedly.

I've inspected the kernel code:

    asmlinkage long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
    {
	    struct file *file = fget(fd);
	    struct address_space *mapping;
	    struct backing_dev_info *bdi;
	    loff_t endbyte;			/* inclusive */
	    pgoff_t start_index;
	    pgoff_t end_index;
	    unsigned long nrpages;
	    int ret = 0;

	    if (!file)
		    return -EBADF;

	    if (S_ISFIFO(file->f_path.dentry->d_inode->i_mode)) {
		    ret = -ESPIPE;
		    goto out;
	    }

	    mapping = file->f_mapping;
	    if (!mapping || len < 0) {
		    ret = -EINVAL;
		    goto out;
	    }

	    if (mapping->a_ops->get_xip_page)
		    /* no bad return value, but ignore advice */
		    goto out;
    ...
    out:
	    fput(file);
	    return ret;
    }

I found the advice parameter is just ignored in the case
mapping->a_ops->get_xip_page is given. This behavior is different from
what is written on the man page. Is this o.k.?

get_xip_page is given if CONFIG_EXT2_FS_XIP is true.
Anyway I cannot find the easy way to detect get_xip_page
field is given or CONFIG_EXT2_FS_XIP is true from the
user space.

I propose the following patch which checks the advice parameter
even if get_xip_page is given.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/fadvise.c~check-advice-of-fadvice64_64-even-if-get_xip_page-is-given mm/fadvise.c
--- a/mm/fadvise.c~check-advice-of-fadvice64_64-even-if-get_xip_page-is-given
+++ a/mm/fadvise.c
@@ -49,9 +49,21 @@ asmlinkage long sys_fadvise64_64(int fd,
 		goto out;
 	}
 
-	if (mapping->a_ops->get_xip_page)
-		/* no bad return value, but ignore advice */
+	if (mapping->a_ops->get_xip_page) {
+		switch (advice) {
+		case POSIX_FADV_NORMAL:
+		case POSIX_FADV_RANDOM:
+		case POSIX_FADV_SEQUENTIAL:
+		case POSIX_FADV_WILLNEED:
+		case POSIX_FADV_NOREUSE:
+		case POSIX_FADV_DONTNEED:
+			/* no bad return value, but ignore advice */
+			break;
+		default:
+			ret = -EINVAL;
+		}
 		goto out;
+	}
 
 	/* Careful about overflows. Len == 0 means "as much as possible" */
 	endbyte = offset + len;
_

Patches currently in -mm which might be from yamato@redhat.com are

origin.patch
