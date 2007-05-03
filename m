From: akpm@linux-foundation.org
Subject: + use-simple_read_from_buffer-in-fs.patch added to -mm tree
Date: Thu, 03 May 2007 13:50:30 -0700
Message-ID: <200705032050.l43KoUXU019208@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031305AbXECUw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 16:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, gregkh@suse.de, joel.becker@oracle.com


The patch titled
     use simple_read_from_buffer() in fs/
has been added to the -mm tree.  Its filename is
     use-simple_read_from_buffer-in-fs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use simple_read_from_buffer() in fs/
From: Akinobu Mita <akinobu.mita@gmail.com>

Cleanup using simple_read_from_buffer() in binfmt_misc, configfs, and sysfs.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c   |   13 +------------
 fs/configfs/file.c |   33 ++-------------------------------
 fs/sysfs/file.c    |   33 ++-------------------------------
 3 files changed, 5 insertions(+), 74 deletions(-)

diff -puN fs/binfmt_misc.c~use-simple_read_from_buffer-in-fs fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~use-simple_read_from_buffer-in-fs
+++ a/fs/binfmt_misc.c
@@ -675,19 +675,8 @@ static ssize_t
 bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	char *s = enabled ? "enabled" : "disabled";
-	int len = strlen(s);
-	loff_t pos = *ppos;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= len)
-		return 0;
-	if (len < pos + nbytes)
-		nbytes = len - pos;
-	if (copy_to_user(buf, s + pos, nbytes))
-		return -EFAULT;
-	*ppos = pos + nbytes;
-	return nbytes;
+	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
 
 static ssize_t bm_status_write(struct file * file, const char __user * buffer,
diff -puN fs/configfs/file.c~use-simple_read_from_buffer-in-fs fs/configfs/file.c
--- a/fs/configfs/file.c~use-simple_read_from_buffer-in-fs
+++ a/fs/configfs/file.c
@@ -77,36 +77,6 @@ static int fill_read_buffer(struct dentr
 	return ret;
 }
 
-
-/**
- *	flush_read_buffer - push buffer to userspace.
- *	@buffer:	data buffer for file.
- *	@userbuf:	user-passed buffer.
- *	@count:		number of bytes requested.
- *	@ppos:		file position.
- *
- *	Copy the buffer we filled in fill_read_buffer() to userspace.
- *	This is done at the reader's leisure, copying and advancing
- *	the amount they specify each time.
- *	This may be called continuously until the buffer is empty.
- */
-static int flush_read_buffer(struct configfs_buffer * buffer, char __user * buf,
-			     size_t count, loff_t * ppos)
-{
-	int error;
-
-	if (*ppos > buffer->count)
-		return 0;
-
-	if (count > (buffer->count - *ppos))
-		count = buffer->count - *ppos;
-
-	error = copy_to_user(buf,buffer->page + *ppos,count);
-	if (!error)
-		*ppos += count;
-	return error ? -EFAULT : count;
-}
-
 /**
  *	configfs_read_file - read an attribute.
  *	@file:	file pointer.
@@ -139,7 +109,8 @@ configfs_read_file(struct file *file, ch
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
 		 __FUNCTION__, count, *ppos, buffer->page);
-	retval = flush_read_buffer(buffer,buf,count,ppos);
+	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
+					 buffer->count);
 out:
 	up(&buffer->sem);
 	return retval;
diff -puN fs/sysfs/file.c~use-simple_read_from_buffer-in-fs fs/sysfs/file.c
--- a/fs/sysfs/file.c~use-simple_read_from_buffer-in-fs
+++ a/fs/sysfs/file.c
@@ -104,36 +104,6 @@ static int fill_read_buffer(struct dentr
 	return ret;
 }
 
-
-/**
- *	flush_read_buffer - push buffer to userspace.
- *	@buffer:	data buffer for file.
- *	@buf:		user-passed buffer.
- *	@count:		number of bytes requested.
- *	@ppos:		file position.
- *
- *	Copy the buffer we filled in fill_read_buffer() to userspace.
- *	This is done at the reader's leisure, copying and advancing 
- *	the amount they specify each time.
- *	This may be called continuously until the buffer is empty.
- */
-static int flush_read_buffer(struct sysfs_buffer * buffer, char __user * buf,
-			     size_t count, loff_t * ppos)
-{
-	int error;
-
-	if (*ppos > buffer->count)
-		return 0;
-
-	if (count > (buffer->count - *ppos))
-		count = buffer->count - *ppos;
-
-	error = copy_to_user(buf,buffer->page + *ppos,count);
-	if (!error)
-		*ppos += count;
-	return error ? -EFAULT : count;
-}
-
 /**
  *	sysfs_read_file - read an attribute. 
  *	@file:	file pointer.
@@ -167,7 +137,8 @@ sysfs_read_file(struct file *file, char 
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
 		 __FUNCTION__, count, *ppos, buffer->page);
-	retval = flush_read_buffer(buffer,buf,count,ppos);
+	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
+					 buffer->count);
 out:
 	up(&buffer->sem);
 	return retval;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
slob-handle-slab_panic-flag.patch
fault-injection-fix-failslab-with-config_numa.patch
hugetlbfs-add-null-check-in-hugetlb_zero_setup.patch
slob-fix-page-order-calculation-on-not-4kb-page.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
fault-injection-enable-stacktrace-with-dwarf2-unwinder.patch
use-slab_panic-flag-cleanup.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
procfs-use-simple_read_from_buffer.patch
cm4000_cs-fix-error-paths.patch
cm4000_cs-use-bitrev.patch
use-simple_read_from_buffer-in-fs.patch
use-simple_read_from_buffer-in-kernel.patch
sunrpc-fix-error-path-in-module_init.patch
