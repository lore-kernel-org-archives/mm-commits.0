From: akpm@linux-foundation.org
Subject: + sysfs-disallow-truncation-of-files.patch added to -mm tree
Date: Tue, 29 Apr 2008 17:11:39 -0700
Message-ID: <200804300011.m3U0Bebk017321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755616AbYD3ALn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 20:11:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com


The patch titled
     sysfs: disallow truncation of files
has been added to the -mm tree.  Its filename is
     sysfs-disallow-truncation-of-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: disallow truncation of files
From: Ben Hutchings <bhutchings@solarflare.com>

sysfs allows attribute files to be truncated, e.g.  using ftruncate(), with
the expected effect on their inode.  For most attributes, this doesn't change
the "real" size of the file i.e.  how much can be read from it.  However, the
parameter validation for reading and writing binary attribute files is based
on the inode size and not the size specified in the file's bin_attribute, so
it can be broken by this.  For example, if we try using dd to write to such a
file:

# pwd
/sys/bus/pci/devices/0000:08:00.0
# ls -l config
-rw-r--r--  1 root root 4096 Feb  1 17:35 config
# dd if=/dev/zero of=config bs=4 count=1
1+0 records in
1+0 records out
# ls -l config
-rw-r--r--  1 root root 0 Feb  1 17:50 config
# dd if=/dev/zero of=config bs=4 count=1 seek=128
dd: writing `config': No space left on device
1+0 records in
0+0 records out

Also, after truncation to 0, parameter validation for read and write is
disabled.  Most bin_attribute read and write methods also validate the size
and offset, but for some this will allow out-of-range access.  This may be a
security issue, though access to such files is often limited to root.  In any
case, the validation should remain for safety's sake!)

This was previously reported in Bugzilla as bug 9867.

sysfs should ignore size changes or else refuse them (by returning -EINVAL). 
This patch makes it ignore them.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/sysfs/inode.c~sysfs-disallow-truncation-of-files fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~sysfs-disallow-truncation-of-files
+++ a/fs/sysfs/inode.c
@@ -59,6 +59,8 @@ int sysfs_setattr(struct dentry * dentry
 	if (error)
 		return error;
 
+	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
+
 	error = inode_setattr(inode, iattr);
 	if (error)
 		return error;
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

origin.patch
sysfs-disallow-truncation-of-files.patch

