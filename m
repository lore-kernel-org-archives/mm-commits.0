From: akpm@linux-foundation.org
Subject: + fs-add-missing-compat_ptr-handling-for-fs_ioc_resvsp-ioctl.patch added to -mm tree
Date: Tue, 10 Nov 2009 11:57:42 -0800
Message-ID: <200911101957.nAAJvgWe021744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757908AbZKJT6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 14:58:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, arndbergmann@googlemail.com, davem@davemloft.net, hch@lst.de, me@ankitjain.org, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl
has been added to the -mm tree.  Its filename is
     fs-add-missing-compat_ptr-handling-for-fs_ioc_resvsp-ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl
From: Heiko Carstens <heiko.carstens@de.ibm.com>

For FS_IOC_RESVSP and FS_IOC_RESVSP64 compat_sys_ioctl() uses its
arg argument as a pointer to userspace. However it is missing a
a call to compat_ptr() which will do a proper pointer conversion.

This was introduced with 3e63cbb1 "fs: Add new pre-allocation ioctls
to vfs for compatibility with legacy xfs ioctls".

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ankit Jain <me@ankitjain.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Arnd Bergmann <arndbergmann@googlemail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: <stable@kernel.org>		[2.6.31.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/compat_ioctl.c~fs-add-missing-compat_ptr-handling-for-fs_ioc_resvsp-ioctl fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~fs-add-missing-compat_ptr-handling-for-fs_ioc_resvsp-ioctl
+++ a/fs/compat_ioctl.c
@@ -1800,7 +1800,7 @@ struct space_resv_32 {
 /* just account for different alignment */
 static int compat_ioctl_preallocate(struct file *file, unsigned long arg)
 {
-	struct space_resv_32	__user *p32 = (void __user *)arg;
+	struct space_resv_32	__user *p32 = compat_ptr(arg);
 	struct space_resv	__user *p = compat_alloc_user_space(sizeof(*p));
 
 	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
@@ -2802,7 +2802,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 #else
 	case FS_IOC_RESVSP:
 	case FS_IOC_RESVSP64:
-		error = ioctl_preallocate(filp, (void __user *)arg);
+		error = ioctl_preallocate(filp, compat_ptr(arg));
 		goto out_fput;
 #endif
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

fs-add-missing-compat_ptr-handling-for-fs_ioc_resvsp-ioctl.patch
linux-next.patch

